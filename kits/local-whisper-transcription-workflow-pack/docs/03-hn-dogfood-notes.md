# Indie / HN dogfood notes

Use this when you show the workflow publicly (Show HN, personal blog, launch thread).

## Honest framing

- “Local Whisper inbox→markdown on my Mac — no paid STT meter”
- Link the pack SKU pay page if people ask how to buy the scripts/docs
- Say which stack you actually run (whisper.cpp vs pip)

## Do / don’t

**Do**

- Show real latency on *your* machine for a 5‑minute clip
- Note model size (`base.en` vs `small`)
- Mention consent when demos involve other people’s voices

**Don’t**

- Claim WER championships without your own eval set
- Imply cloud API parity
- Paste other people’s private audio into public threads

## Dogfood checklist

- [ ] `doctor.sh` clean on the demo machine  
- [ ] One sample clip transcribed end-to-end  
- [ ] README quick start matches what you just ran  
- [ ] Pay link works: `pay-btc.html?sku=local-whisper-transcription-workflow-pack`
