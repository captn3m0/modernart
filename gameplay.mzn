include "alldifferent.mzn";
include "globals.mzn";
include "awards.mzn";
include "ranking.mzn";
include "scoring.mzn";
include "sanity.mzn";
include "artists.mzn";
include "dealing.mzn";
% Ignoring these for now
% include "double.mzn";
% include "drawone.mzn";
% include "hidden.mzn";
% include "simultaneous.mzn";

/*
 This file includes the core gameplay rules
 ie, how many cards are getting played each round
 who plays the closing card etc.
 */

% Calculate total cards of an artist played per round
constraint forall (a in Artists, r in Rounds) (
  CardsForArtist[r, a] = sum(p in Players) (visible_count_per_round_per_artist_per_player[r,p,a])
);

% Max number of visible cards can be 6 for any artist per player
var 5..6: MaxVisibleCards;
constraint MaxVisibleCards = if card(Players)>2 then 6 else 5 endif;

% Maximum MaxVisibleCards of the artist with maximum cards
constraint forall(r in Rounds) (max(row(CardsForArtist,r)) = MaxVisibleCards);

% second highest value should not be the max
constraint forall(r in Rounds) (sort(row(CardsForArtist, r))[4] != MaxVisibleCards);

% Temporary variable to see how many cards you've played TOTAL per round
array[Rounds,Players] of var int: TotalCardsPlayed;
constraint forall(r in Rounds, p in Players) (
% TODO: Change this to played cards from VISIBLE (hidden)
  TotalCardsPlayed[r,p] = sum(a in Artists) (visible_count_per_round_per_artist_per_player[r,p,a])
);

% Calculate maximum cards any player can play in first round
array[Rounds,Players] of var int: StartingCardsInHand;
% Round 1 Starting Hand is 13 cards
constraint forall(p in Players) (StartingCardsInHand[Round1,p] = CardsDealtPerRound[Round1]);
constraint forall(p in Players) ( 
  StartingCardsInHand[Round2,p] = StartingCardsInHand[Round1,p] - TotalCardsPlayed[Round1,p]  + CardsDealtPerRound[Round2]
);
constraint forall(p in Players) ( 
  StartingCardsInHand[Round3,p] = StartingCardsInHand[Round2,p] - TotalCardsPlayed[Round2,p]  + CardsDealtPerRound[Round3]
);
constraint forall(p in Players) ( 
  StartingCardsInHand[Round4,p] = StartingCardsInHand[Round3,p] - TotalCardsPlayed[Round3,p]  + CardsDealtPerRound[Round4]
);

constraint forall(r in Rounds, p in Players) (
  StartingCardsInHand[r,p] >= TotalCardsPlayed[r,p]
);

% TODO: Move to simultanouse
% The last player must have played atleast one card of the top artist
constraint forall(r in Rounds) (
  visible_count_per_round_per_artist_per_player[r,last_player[r],sorted_artists_per_round[r,1]] >=1
);

% TURN ORDER STUFF
constraint forall(r in Rounds) (
  NominalTurnCount[r] = TotalCardsPlayed[r, last_player[r]]
);

%All players who played nominal turns
var set of Players: Pn1;
var set of Players: Pn2;
var set of Players: Pn3;
var set of Players: Pn4;
%All players who played sub-nominal turns
var set of Players: Px1;
var set of Players: Px2;
var set of Players: Px3;
var set of Players: Px4;

constraint Pn1 = if (first_player[Round1] < last_player[Round1]) then
     first_player[Round1]..last_player[Round1]
   else    
     set_diff(Players,first_player[Round1]..last_player[Round1])
   endif;


constraint Pn2 = if (first_player[Round2] < last_player[Round2]) then
     first_player[Round2]..last_player[Round2]
   else    
     set_diff(Players,first_player[Round2]..last_player[Round2])
   endif;


constraint Pn3 = if (first_player[Round3] < last_player[Round3]) then
     first_player[Round3]..last_player[Round3]
   else    
     set_diff(Players,first_player[Round3]..last_player[Round3])
   endif;


constraint Pn4 = if (first_player[Round4] < last_player[Round4]) then
     first_player[Round4]..last_player[Round4]
   else    
     set_diff(Players,first_player[Round4]..last_player[Round4])
   endif;
   
constraint Px1 = set_diff(Players,Pn1);
constraint Px2 = set_diff(Players,Pn2);
constraint Px3 = set_diff(Players,Pn3);
constraint Px4 = set_diff(Players,Pn4);

constraint forall(p in Players) (p in Pn1 -> TotalCardsPlayed[Round1, p] = NominalTurnCount[Round1]);
constraint forall(p in Players) (p in Pn2 -> TotalCardsPlayed[Round2, p] = NominalTurnCount[Round2]);
constraint forall(p in Players) (p in Pn3 -> TotalCardsPlayed[Round3, p] = NominalTurnCount[Round3]);
constraint forall(p in Players) (p in Pn3 -> TotalCardsPlayed[Round4, p] = NominalTurnCount[Round4]);

constraint forall(p in Players) (p in Px1 -> TotalCardsPlayed[Round1, p] = NominalTurnCount[Round1] - 1);
constraint forall(p in Players) (p in Px2 -> TotalCardsPlayed[Round2, p] = NominalTurnCount[Round2] - 1);
constraint forall(p in Players) (p in Px3 -> TotalCardsPlayed[Round3, p] = NominalTurnCount[Round3] - 1);
constraint forall(p in Players) (p in Px3 -> TotalCardsPlayed[Round4, p] = NominalTurnCount[Round4] - 1);

% Total Playable Cards for any round are set equal to the Starting Hand
% TODO: Move this to `drawone`
array[Rounds,Players] of var int: PlayableCards;
constraint forall(p in Players, r in Rounds) (
  PlayableCards[r,p] = StartingCardsInHand[r,p]
);
