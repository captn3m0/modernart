% Constraints per artist
% TODO: This is also TOTAL card limit, not visible
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,LiteMetal]) <=17;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,Yoko]) <=18;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,ChristinP]) <=19;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,KarlGitter]) <=20;
constraint sum(p in Players, r in Rounds) (visible_count_per_round_per_artist_per_player[r,p,Krypto]) <=21;
