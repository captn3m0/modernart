include "gameplay.mzn";
enum Players;
enum Artists;
enum Rounds;

Players = {Nemo,Jana};
Artists = {Krypto,KarlGitter,ChristinP,Yoko,LiteMetal};
Rounds = {Round1};

% Number of cards per round per player per artist
array[Rounds,Players,Artists] of var int: visible_count_per_round_per_artist_per_player;

% First player every Round
array[Rounds] of var Players: first_player;

% Closing player every Round
array[Rounds] of var Players: last_player;

% Total points that an artist has in a given round
array[Rounds,Artists] of var int: total_score_per_round_per_artist;

% Whether you played a double this round
array[Rounds,Players,Artists] of var bool: double_played;

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