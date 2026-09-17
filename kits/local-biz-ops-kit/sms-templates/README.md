# SMS / text templates

Replace `{{tokens}}` before sending. Use only with existing customers or people who asked to be contacted. **No blast lists.**

| Token | Example |
|-------|---------|
| `{{customer_name}}` | Sam |
| `{{business_name}}` | Valley Lock & Key |
| `{{appointment_time}}` | Thu 4:30pm |
| `{{address_or_area}}` | Oak St / your place |
| `{{tech_name}}` | Mike |
| `{{google_review_url}}` | https://g.page/r/YOUR_PLACE/review |
| `{{phone}}` | (555) 555-0100 |
| `{{job_type}}` | rekey |

Send from your usual business number or SMS app. Automating via Twilio is optional and documented in `docs/install.md` — not required for v0.1.0.
