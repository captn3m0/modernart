include "gameplay.mzn";
enum Players;
enum Artists;
enum Rounds;

Players = {Nemo,Jana, Adam};
Artists = {Krypto,KarlGitter,ChristinP,Yoko,LiteMetal};
Rounds = {Round1, Round2, Round3, Round4};

% Number of cards per round per player per artist
array[Rounds,Players,Artists] of var int: visible_count_per_round_per_artist_per_player;

% First player every Round
array[Rounds] of var Players: first_player;

% Closing player every Round
array[Rounds] of var Players: last_player;

% Total points that an artist has in a given round
array[Rounds,Artists] of var int: total_score_per_round_per_artist;

% Score a player gets in each given round
array[Rounds,Players] of var int: RoundScore;

% Final score of a player
array[Players] of var int: Score;

% Total number of a cards of an artist that were PLAYED this round
array[Rounds, Artists] of var int: CardsForArtist;

% Number of Turns played by the closing player this round
array[Rounds] of var int: NominalTurnCount;

solve maximize Score[Nemo];