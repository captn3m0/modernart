include "modernart-game.mzn";
enum Players;
enum Artists;
enum Rounds;

Players = { Nemo, Jana, Adam};
Artists = {Krypto,KarlGitter,ChristinP,Yoko,LiteMetal};
Rounds = {Round1};

% Number of cards per round per player per artist
array[Rounds,Players,Artists] of var int: visible_count_per_round_per_artist_per_player;

% How much score was made by each artist in each round by just RANKING
array[Rounds,Artists] of var int: ranking_score_per_artist_per_round;
% Total points that an artist has in a given round
array[Rounds,Artists] of var int: total_score_per_round_per_artist;

% Whether an artist won an award in a given round
array[Rounds,Artists] of var bool: awards_per_round_per_artist;

% Winning artists for each round (just-by-ranking)
array[Rounds,1..card(Artists)] of var Artists: sorted_artists_per_round;

% Score a player gets in each given round
array[Rounds,Players] of var int: score_per_round_per_player;

% Final score of a player
array[Players] of var int: score_per_player;

% Total number of a cards of an artist that were PLAYED this round
array[Rounds, Artists] of var int: cards_per_artist_per_round;

% Dumb constraints to help maximize score
constraint score_per_round_per_player[Round1,Nemo] > score_per_round_per_player[Round1,Jana];
% constraint score_per_round_per_player[Round1,Jana] > 10;
% constraint score_per_round_per_player[Round1,Adam] > 5;
solve maximize sum(p in Players)(score_per_player[p]);