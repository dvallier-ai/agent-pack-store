# Kill Rules — Park the System

A kill rule is a pre-committed pause. It is not a signal to reverse, double size, or recover losses.

## Park immediately when

- **Drawdown:** The account or paper equity reaches the written drawdown review stop.
- **Daily cap:** The hard daily loss cap is reached or its calculation is uncertain.
- **Weekly cap:** Planned or realized risk reaches the weekly ceiling.
- **Process break:** A stop was moved, size was changed, an order was entered without a thesis, or a required log is missing.
- **Data/execution fault:** Prices, feeds, clock, broker state, fills, or connectivity cannot be trusted.
- **Rule ambiguity:** The operator cannot explain which rule permits the next trade.
- **Revenge trading:** A loss, frustration, urgency, or desire to “make it back” is influencing the next action.
- **System drift:** Strategy code, parameters, data, or permissions changed without a logged review.

## Park procedure

1. Cancel unneeded open orders; do not add exposure.
2. Record the trigger, current state, and last valid journal entry.
3. Export screenshots/logs and label the environment **PAPER** or **LIVE** accurately.
4. Notify the reviewer or write a short incident note.
5. Wait for the scheduled review; do not restart from memory.

## Restart gate

Restart only after the trigger is understood, caps are intact, the journal is complete, and an independent review records a decision. If the trigger was emotional or a repeated process break, default to staying parked.

**No martingale:** No doubling, averaging down to recover, removing stops, or increasing risk after a loss.
