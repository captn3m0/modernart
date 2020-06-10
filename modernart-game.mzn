include "alldifferent.mzn";
include "globals.mzn";
include "modernart-sanity.mzn";

% Constraints per artist
% TODO: This is also TOTAL card limit, not visible
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,LiteMetal]) <=17;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,Yoko]) <=18;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,ChristinP]) <=19;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,KarlGitter]) <=20;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,Krypto]) <=21;

constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,LiteMetal])>=0;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,Yoko]) >=0;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,ChristinP])>=0;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,KarlGitter])>=0;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,Krypto])>=0;

% Calculate total cards of an artist played per round
constraint forall (a in Artists, r in Rounds) (
  cards_per_artist_per_round[r, a] = sum(p in Players) (visible_count_per_round_per_artist_per_player[r,p,a])
);


% Calculate total score per player
constraint forall(r in Rounds, p in Players) (
  score_per_round_per_player[r,p] = sum(a in Artists) (visible_count_per_round_per_artist_per_player[r,p,a] * ranking_score_per_artist_per_round[r,a])
);
constraint forall(p in Players) (
  score_per_player[p] = sum(r in Rounds) (score_per_round_per_player[r,p])
);

% Max number of visible cards can be 6 for any artist per player
var 5..6: max_visible_cards;
constraint max_visible_cards = if card(Players)>2 then 6 else 5 endif;
% Maximum max_visible_cards of the artist with maximum cards
constraint forall(r in Rounds) (max(row(cards_per_artist_per_round,r)) = max_visible_cards);
% second highest value should not be the max
constraint forall(r in Rounds) (sort(row(cards_per_artist_per_round, r))[4] != max_visible_cards);

% Decide the top artists by picikng the cards per artist for that round, and sorting them
constraint forall(r in Rounds)(row(sorted_artists_per_round,r)= reverse(arg_sort(row(cards_per_artist_per_round, r))));

% Top three artists get ranking score in each round as 3,2,1 others get 0
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[1]] = 3);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[2]] = 2);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[3]] = 1);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[4]] = 0);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[5]] = 0);

% AWARDS
% Total number of awards for each artist = 1
constraint forall(a in Artists) ( sum(col(awards_per_round_per_artist,a)) = 1 );
% awards can only be given if an artist's card was played that turn
constraint forall(r in Rounds, a in Artists) (
  awards_per_round_per_artist[r,a] = 1 -> cards_per_artist_per_round[r,a] > 0
);

% DOUBLE CARDS
% - Double cards are counted as VISIBLE
% - Double cards CANNOT breach the 6 LIMIT
% Total number of DOUBLE CARDS for each artist = 1
% FOR EVERY ROUND+ARTIST combination, only 1 player should have played a double card
% TODO: Check if this is still correct after a second round
constraint forall(a in Artists) (
  sum(p in Players, r in Rounds) (double_played[r,p,a])  = 1
);

% Score = ranking_score + award_score if an award was given this round
constraint forall(r in Rounds, a in Artists) (
  total_score_per_round_per_artist[r,a] = 
    if awards_per_round_per_artist[r,a] then 
      ranking_score_per_artist_per_round[r,a] + 2 
    else 
      ranking_score_per_artist_per_round[r,a] 
    endif
);

array[Rounds,Players] of var int: max_cards_per_round_per_player;

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

% constraint forall(r in Rounds, p in Players) (
  
% );

% Calculate maximum cards any player can play in first round
constraint forall(p in Players) (
  max_cards_per_round_per_player[Round1,p] = 13
);

% TODO: This is actual not VISIBLE, but TOTAL cards LIMIT
% TODO: This does not consider any of the symbols
% IMPLIED RULE: You can max play 13 cards in Round 1
constraint forall(p in Players) (
  sum(a in Artists) (
    visible_count_per_round_per_artist_per_player[Round1,p,a]
  ) <= max_cards_per_round_per_player[Round1,p]
);
