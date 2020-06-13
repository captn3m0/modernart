array[Rounds,Players,Artists] of var bool: DrawOneCard;

% Total Playable Cards for any round are set equal to the Starting Hand
array[Rounds,Players] of var int: PlayableCards;

% Playable Cards in any round = Starting Cards + Draw One cards that give you an extra playable card
constraint forall(p in Players, r in Rounds) (
  PlayableCards[r,p] = StartingCardsInHand[r,p] + sum(a in Artists) (DrawOneCard[r,p,a])
);

% Every artist only has a single Draw One Card
constraint forall(a in Artists) (
  sum(p in Players, r in Rounds) (DrawOneCard[r,p,a])  = 1
);

% Isolated count for DrawOne, you can only play your draw one, if you've atleast played that artist this round
constraint forall(p in Players, r in Rounds, a in Artists) (
  visible_count_per_round_per_artist_per_player[r,p,a] >= DrawOneCard[r,p,a]
);