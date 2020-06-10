include "modernart-game.mzn";
enum Players;
enum Artists;
enum Rounds;

Players = { Nemo, Jana };
Artists = {Krypto,KarlGitter,ChristinP,Yoko,LiteMetal};
Rounds = {Round1};

% Number of cards per round per player per artist
array[Rounds,Players,Artists] of var int: visible_count_per_round_per_artist_per_player;
% How much score was made by each artist in each round by just RANKING
array[Rounds,Artists] of var int: ranking_score_per_artist_per_round;
% Winning artists for each round
array[Rounds,1..3] of var Artists: top_3_artists_per_round;

% Total number of a cards of an artist that were PLAYED this round
array[Rounds, Artists] of var int: cards_per_artist_per_round;

% constraint forall(a,b in Artists, r in Rounds) (


% );

% solve maximize visible_count_per_round_per_artist_per_player[LiteMetal, Nemo, Round1] +
%    visible_count_per_round_per_artist_per_player[Krypto, Nemo, Round1] + 
%    visible_count_per_round_per_artist_per_player[Yoko, Nemo, Round1] + 
%    visible_count_per_round_per_artist_per_player[ChristinP, Nemo, Round1];