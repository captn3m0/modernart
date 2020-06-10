% DOUBLE CARDS
% - Double cards are counted as VISIBLE
% - Double cards CANNOT breach the 6 LIMIT
% Total number of DOUBLE CARDS for each artist = 1
% FOR EVERY ROUND+ARTIST combination, only 1 player should have played a double card
% TODO: Check if this is still correct after a second round

% Whether you played a double this round
array[Rounds,Players,Artists] of var bool: double_played;


constraint forall(a in Artists) (
  sum(p in Players, r in Rounds) (double_played[r,p,a])  = 1
);

% What is the extra cards you can possibly play
array[Rounds,Players,Artists] of var bool: bonus_due_to_double_cards;

constraint forall(a in Artists, r in Rounds, p in Players) (
  % If this player played more than 2 cards of this artist
  if visible_count_per_round_per_artist_per_player[r,p,a] >=2
  % And this artist is the winning artist this round
     /\ row(sorted_artists_per_round,r)[1] = a
  % And you closed this round
     /\ visible_count_per_round_per_artist_per_player[r,p,a] = max_visible_cards
  % and they are claiming their double now
     /\ double_played[r,p,a] then
    bonus_due_to_double_cards[r,p,a] = true
  else
    bonus_due_to_double_cards[r,p,a] = false
  endif
);

% array[Rounds,Players] of var int: negs_due_to_double_cards;