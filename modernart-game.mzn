include "alldifferent.mzn";
include "globals.mzn";

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

% Score sanity per round
constraint forall (a in Artists, r in Rounds) (
  ranking_score_per_artist_per_round[r,a] >=0
);

% Calculate total cards of an artist played per round
constraint forall (a in Artists, r in Rounds) (
  cards_per_artist_per_round[r, a] = sum(p in Players) (visible_count_per_round_per_artist_per_player[r,p,a])
);

constraint forall (a in Artists, r in Rounds) (
  cards_per_artist_per_round[r,a]>=0
);


% Decide the top 3 artists by picikng the cards per artist for that round, and sorting them, then slice to get top 3
constraint forall(r in Rounds)(row(top_3_artists_per_round,r)= reverse(arg_sort(row(cards_per_artist_per_round, Round1)))[1..3]);

% Top three artists get ranking score in each round as 3,2,1
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(top_3_artists_per_round,r)[1]] = 3);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(top_3_artists_per_round,r)[2]] = 2);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(top_3_artists_per_round,r)[3]] = 1);

% Max number of visible cards can be 6
constraint forall(r in Rounds, p in Players, a in Artists) (visible_count_per_round_per_artist_per_player[r,p,a] <=6);
constraint forall(r in Rounds, p in Players, a in Artists) (visible_count_per_round_per_artist_per_player[r,p,a] >=0);

% TODO: This is actual not VISIBLE, but TOTAL cards LIMIT
% You can max play 13 cards in Round 1
constraint forall(p in Players) (sum(a in Artists) (visible_count_per_round_per_artist_per_player[Round1,p,a]) <=13);

% array[1..5] of var Artists: artists_sorted_by_count_round1;
% constraint alldifferent(artists_sorted_by_count_round1);
% constraint artists_sorted_by_count_round1 = reverse(arg_sort(row(cards_per_artist_per_round, Round1)));

% output [show_int(reverse(arg_sort(row(cards_per_artist_per_round, Round1))))];