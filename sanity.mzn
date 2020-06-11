% Sanity check
constraint forall (a in Artists, r in Rounds) (
  CardsForArtist[r,a]>=0
);
% So they don't go negative
constraint forall (a in Artists, r in Rounds, p in Players) (
  visible_count_per_round_per_artist_per_player[r,p, a]>=0
);

% Score sanity per round
constraint forall (a in Artists, r in Rounds) (
  ranking_score_per_artist_per_round[r,a] >=0
);

% No game can have less than 1 Nominal Turn (Number of turns played by the Closing Player)
constraint forall(r in Rounds) (NominalTurnCount[r] >=1);

constraint forall(r in Rounds, p in Players) (
  StartingCardsInHand[r,p] >=0
);

% Round 1 Player 1
constraint first_player[Round1] = Nemo;

% Visible Cards per round per player for every artist > 0
constraint forall(a in Artists) (
  sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,a])>=0
);

% This is a  2-5 player game
constraint assert(card(Players) <=5, "Max Players is 5");
constraint assert(card(Players) >=1, "MinPlayers is 2");