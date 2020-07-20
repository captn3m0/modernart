include "gameplay.mzn";
enum Players;
enum Artists;
enum Rounds;

Players = {Player1, Player2, Player3,Player4};

% The order here is opposite of what you'd usually use while playing the game
% because this results in LiteMetal getting a higher numeric value and that makes
% sorting much easier

Artists = {Krypto,KarlGitter,ChristinP,Yoko,LiteMetal};
Rounds = {Round1, Round2, Round3, Round4};

% Number of cards per round per player per artist
array[Rounds,Players,Artists] of var 0..15: visible_count_per_round_per_artist_per_player;

% First player every Round
array[Rounds] of var Players: first_player;

% Closing player every Round
array[Rounds] of var Players: last_player;

% Total points that an artist has in a given round
array[Rounds,Artists] of var 0..15: total_score_per_round_per_artist;

% Total number of a cards of an artist that were PLAYED this round
array[Rounds, Artists] of var 0..10: CardsForArtist;

% Number of Turns played by the closing player this round
array[Rounds] of var 0..10: NominalTurnCount;

% Symmetry Breaking

solve maximize Score[Player2];

output  outputJSON();
