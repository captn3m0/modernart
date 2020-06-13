include "gameplay.mzn";
enum Players;
enum Artists;
enum Rounds;

Players = {Nemo, Jana, Adam};

% The order here is opposite of what you'd usually use while playing the game
% because this results in LiteMetal getting a higher numeric value and that makes
% sorting much easier

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

% Total number of a cards of an artist that were PLAYED this round
array[Rounds, Artists] of var int: CardsForArtist;

% Number of Turns played by the closing player this round
array[Rounds] of var int: NominalTurnCount;

% constraint award_bonus_per_round_per_artist[Round1,Krypto] = true;
% constraint award_bonus_per_round_per_artist[Round1,Yoko] = true;
% constraint award_bonus_per_round_per_artist[Round1,ChristinP] = true;

solve maximize Score[Nemo];