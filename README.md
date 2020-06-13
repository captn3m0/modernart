# modernart-solver

This is a [MiniZinc](https://www.minizinc.org/) based attempt to solve the [Modern Art: Masters Gallery](https://boardgamegeek.com/boardgame/40381/masters-gallery) game.

The current partial implementation (see below for missing rules) results in a highest possible score of 242. (`*` = Award given to artist).

|Player 1|Player 2|Player 3|A|B|C|D|E|
|--------|--------|--------|-|-|-|-|-|
|AA*     |AA      |AA      |5|0|0|1|2|
|AAAEE*  |BBCC*E  |D*EEEE  |7|0|0|4|7|
|AAAAAEEEE|ABBBDDDDE|BBCCCCCA|10|0|0|5|9|
|AAAAAAEEE|BBBBCCCDD|B*CCDDDEE|13|0|0|6|11|
|*242* = 10+35+86+111|*65* = 10+4+39+12|*87* = 10+32+5+40|

## Plan

- Implement all of the game ruleset in MiniZinc.
- Solve for the highest possible score.

## Implementation Notes

Instead of implementing a turn-by-turn solver (which would increase the complexity by too much?), I'm implementing a backwards-solver of sorts that:

1. Models each "round" per player instead of per-turn
2. Excludes any gameplays that are impossible to reach.

The idea is to calculate possible values for "counts-of-cards-per-artist-per-player-per-round", which is a list of 5 integers for every player in each round. And then add constraints on top to ensure that this possible selection was valid. This misses out on nuances for turn order, which might turn out to be relevant. But my gameplay intuition says that if I model the number of turns correctly, the other constraints should hopefully hinder any impossible gameplay. It is important to note that _the scoring system_ does not depend on the order in which you played the cards._ If the exhibit (count per artist per player for a given round) is legally possible - we don't really care about the turn order.

## List of high-level constraints

I'm using MiniZinc, which is a constraint programming language commonly used for optimization problems. By rewriting the rules for Modern Art as a set of constraints, we can model them in MiniZinc and then solve for various different problems (highest score, least score, highest score in a game without awards and so on). I've categorized the constraints and documented them so I know what all is done/pending:

### Card Count Constraints

- [x] Total number of cards of any artist are limited (17-21, depending on the artist)
- [x] Total number of starting cards of any player are limited (13 for first round, and additions are limited on the number of players)
- [x] Max number of "visible" cards in any round for any artist can be 6  (or 5 in case of 2 players)
- [x] Total number of played cards for a round < Total number of playable cards for this round

### Draw One Card

Similar to the `double_card` boolean table, we maintain a `draw_one` boolean lookup table. This goes to 1 if a draw one card is played by any player for a given artist.

`Starting Cards for a Round(r) = PlayableCards(r-1) - PlayedCards(r-1) + CardsDealt(r,PlayerCount)`

Starting cards are based on initial cards given to you, number of cards you played in previous rounds, and any additional cards you acquired via being dealt. CardsDealt is the lookup table I've given below. `PlayableCards(-1)`, and `PlayedCards(-1)` is set to 0.

`Playable Cards for a Round = Starting Cards for that round + 𝚺(a in Artists) ( 1 ⇔ draw_one(a) ∧ CardsPlayed(a) >=1 )`

Playable cards for any given round are starting cards + 1 card for every draw one card you played. Note that cards you draw are playable in the round you drew them.

### Gameplay Constraints

These are the toughest ones. We define the following notation (for any given round)

#### `P*`

First Player

#### `P'`

Closing Player

#### `A'`

Closing Artist (the one with 6|5 cards)

#### `Pn`

Players that fall between `P*` and `P'`. These are players that have not been skipped over.

#### `𝚻`

Number of "turns" that the closing player played.

#### `Px`

All players not in `Pn`. Turns have been skipped for these.

- [x] `Turns(Px) = 𝚻-1`, ie Px - get one fewer turn
- [x]  The number of cards you can play in a round = number of turns (ignoring symbols for now)
- [x] `P'` (closing player) must have played atleast one card of `A'`. (Ignoring symbols again for now).

### Second Card Face Up

We keep a variable called `double_played` denoting whether a "double" card was played by a player in a given round by a given player. Default constraints ensure that there is only one such card played across all rounds for each artist.

In order to accomodate this, we use the turn calculation from gameplay constraints. Constraints are:

`Cards(Px) = 𝚻-1 + 𝚺(a in Artists) ( 1 ⇔ double_played(a) ∧ CardsPlayed(a) >=2 )`

Total number of cards playable is same as their number of turns, but we add a +1 for every artist that had a double card played this turn, but with the condition that the minimum number of cards of that artist were 2.

### Scoring Constraints

For scoring the awards, we keep a boolean array denoting which round any artist was "awarded". Note that it does not matter which player does the awarding, as long as atleast one card of that artist was played.

We subdivide the score into the following sections:

#### Ranking Score

- [x] Top 3 artists in each round get 1-3 points per card played)

#### Awards Score

- [x] For any artist that got an award in Round(R), their cumulative score for this and all future rounds is increased by 2.

### Missing Constraints

- [x] Symbol (■) - Draw One Card
- [ ] Symbol (**=**) - Second card face up
- [ ] Symbol (≂) - Second card face down
- [ ] Symbol (✠) - Simultaneous play
- [ ] Since the model misses out on the turn-dynamics, and treats symbols as global counters (instead of being attached to specific cards), there are some additional constraints that will be required. Without these, I'm expecting to see the same card being used for multiple symbols. Some sort of **Symbol counter** per round that keeps track of total number of cards you've claimed for symbols would be a better approach.
- [ ] **Additional Card Play**. Every round, all players can opt to play one extra card per artist they've already played. Note that this rule is very ambigously worded in the rules. I'm planning to implement the "blessed" variant. See https://boardgamegeek.com/thread/473713/playing-additional-cards-during-scoring for more details.
- [ ] In case `DrawOne` card is the last card of a round, then `PlayableCards` for that round does not increase by 1, but only for the subsequent rounds. Since I'm maintaining awards as a boolean on the (Round,Artist) tuple, this becomes quite hard to model. Unless this gets violated in the winning entries, I don't plan to model this.

## TODO

Outside of constraints, I've to get to the following:

- [ ] Improve output formatting
- [ ] Get JSON output to render outside of the solver
- [x] Get Gecode and other solvers working

## Cards Dealt Table

Each player is dealt additional cards based on this table at the start of that round. This is implemented in `dealing.md`.

| # Players | 2  | 3  | 4  | 5  |
|-----------|----|----|----|----|
| Round 1   | 13 | 13 | 13 | 13 |
| Round 2   | 6  | 6  | 4  | 2  |
| Round 3   | 6  | 6  | 4  | 2  |
| Round 4   | 3  | 0  | 0  | 0  |
