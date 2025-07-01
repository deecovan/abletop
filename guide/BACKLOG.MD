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
  ...
  - Turn sequence:
      0. Turn starts with 2AP.
      1. Player can draw a card or play a card from the hand. -1AP.
         - Drawn card are tapped - can not attack, can contr-attack. 
      2. Repeat 1.
      3. Attack with the cards not tapped.
      4. End turn.
         - Untap all cards.
