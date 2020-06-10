% This file deals with dealing of new cards every Round

% Usable variable from here is CardsDealtPerRound[Rounds]
array[Rounds] of var int: CardsDealtPerRound;

constraint CardsDealtPerRound[Round1] = 13;
constraint CardsDealtPerRound[Round2] = 
  if card(Players) < 4 then 
    6 
  else if card(Players) = 4 then 
    4
  else 
    2
  endif
endif;

constraint CardsDealtPerRound[Round3] = 
  if card(Players) < 4 then 
    6 
  else if card(Players) = 4 then 
    4
  else 
    2
  endif
endif;

constraint CardsDealtPerRound[Round4] = if card(Players) = 2 then 3 else 0 endif;