# abletop/guide GitHub repo

## 25-7-01tag v0.7.0
- Table schema:
  - Slots area
    1. Frontline 4 slots
    2. Backline 4 slots
  - Player hand area
  - Deck area
  ...
  - Graveyard area
  - Action interface
    - Buttons block
    - Information/Log area
- Game sequence
  - Initial draw 4 cards
  - 2 coins for each player
  - Each turn adds 1 more coin (Cards with cost 5 played on turn 2-5)
  ...
  - Turn sequence:
      0. Turn starts with \[2\]Coins.
      1. Player can draw \[1\]C or play a card \[value\]C from the hand.
         - Drawn card are tapped: can not attack, can block/contr-attack. 
      2. Repeat 1.
      3. Attack with the cards not tapped.
      4. End turn.
         - Untap all cards.
