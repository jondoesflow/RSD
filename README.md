# Steady

**A pocket toolkit for understanding Rejection Sensitivity Dysphoria (RSD), and for getting through RSD moments together.**

Jon made Steady for his wife Katie. Jon has mixed-type ADHD and lives with RSD. Those moments are hard to explain from the inside, and it can be just as hard to recognise what's happening while it's happening. Steady puts the explanation, a plan you've agreed between you, and the right words on Katie's phone, where she can reach them in the moment.

The names are editable, so any couple can use it.

## What's inside

| Tab | What it does |
|---|---|
| **Right now** | Pick **Wobble**, **Storm** or **After the storm**. Each one shows what you might see, what's going on inside, what to do and avoid, and phrases you could say. It also holds the pause word, full-screen **signal cards** Jon can hold up when words won't come, a **breathe together** timer, and one-tap **check-in messages**. |
| **Understand** | Short explainers: what RSD is, why it's so intense, its two faces (inward and outward), the everyday disguises (people-pleasing, perfectionism, avoidance), RSD in relationships, what helps, and some myths. It also has "In Jon's words" cards, a **Feelings finder**, a repair guide, and a self-care section for Katie. |
| **Translate** | Everyday situations (a slow text reply, "we need to talk", a forgotten chore, feedback, cancelled plans, teasing). Each one shows *what you meant*, *what RSD might hear*, and *a way to say it instead*. |
| **Us** | Jon's own plan: triggers, early warning signs, what helps, what makes it worse, the pause word and time-out length, and a note to Katie. It also has a **Moments log** for spotting patterns over time. |
| **Listen & read** | ADHD Chatter episodes on RSD, other podcasts, Alex Partridge's book, the source articles, and UK support lines. |

### The Feelings finder
Jon often doesn't know what he's feeling until the feeling is already huge. The Feelings finder asks him to tap what he notices **in his body**, **in his head** and **what he wants to do**. It then suggests which flavour of RSD it might be (shame wave, anger flash, alarm bells or shutdown), says what might help, and writes a message he can send straight to Katie.

## Getting it onto Katie's iPhone (TestFlight, no Mac needed)

`.github/workflows/testflight.yml` archives the app, signs it and uploads it to TestFlight from a GitHub-hosted Mac. It's the same workflow Upside and Grade use.

**1. Register the app (one time)**
- At [developer.apple.com → Identifiers](https://developer.apple.com/account/resources/identifiers/list), add an App ID with the bundle ID `com.jondoesflow.steady`.
- In [App Store Connect → Apps](https://appstoreconnect.apple.com/apps), click **+ → New App**. Choose iOS, pick a name, select that bundle ID, and set the SKU to `steady`. App names must be unique across the whole App Store, so if "Steady" is taken use something like "Steady – RSD Toolkit". The name on the home screen stays "Steady".

**2. Add the four repository secrets (one time)**
In this repo, go to Settings → Secrets and variables → Actions. These are the same values as the other apps:
`APPLE_TEAM_ID`, `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_P8`. The workflow file explains each one.

**3. Upload a build**
Go to Actions → **TestFlight** → **Run workflow**. Pushing to the `testflight` branch or pushing a tag named `testflight-*` also works. Apple usually takes 5–30 minutes to process the build. Each run gets a new build number.

**4. Add Katie as a tester**
- **Internal tester (fastest, no review):** in App Store Connect → Users and Access, invite Katie with the *Customer Support* or *Developer* role. Once she accepts, open the app's TestFlight tab → Internal Testing, click **+** to create a group, and add her.
- **External tester (just her email):** TestFlight → External Testing, click **+** to create a group, then add her email. The first build needs a quick Beta App Review, which usually takes about a day.

Katie installs the **TestFlight** app from the App Store and accepts the email invite. Updates then arrive automatically each time you run the workflow.

### On a Mac instead

```bash
brew install xcodegen
xcodegen generate
open Steady.xcodeproj
```

Select your team under Signing & Capabilities and run it on a connected iPhone.

Requires iOS 17 or later. Everything is stored on the device. There are no accounts and nothing is sent anywhere.

## Making it yours

The most valuable part is the **Us** tab. Sit down together on a calm day and fill it in:

- Which situations tend to set it off?
- What does Katie notice first? What does Jon notice first?
- What actually helps, and what makes it worse?
- Pick a pause word you'd never say by accident.
- Write the note to Katie.

The pre-filled examples are just a starting point. Delete anything that doesn't fit.

All the built-in wording lives in `Steady/Models/Content.swift`, so it's easy to change. In that file, `{J}` and `{K}` are replaced with your names.

## Project layout

```
project.yml               XcodeGen spec (iOS 17+, bundle ID com.jondoesflow.steady)
.github/workflows/        build.yml (CI build), testflight.yml (upload to TestFlight)
Steady/
  SteadyApp.swift         app entry and tabs
  Models/
    Models.swift          data types
    Content.swift         all guidance text, situations, resources
    Store.swift           profile and moments log (saved on device)
  Views/                  one file per screen
RESEARCH.md               sources and notes
```

## Sources

See [RESEARCH.md](RESEARCH.md). The main sources are ThinkADHD, ADDitude (Dr William Dodson), Simply Psychology, the Gottman Institute and the ADHD Chatter podcast.

*Steady is for understanding and connection. It isn't medical advice. If RSD is having a big impact, talk to a GP or ADHD specialist. If things ever feel unsafe, call Samaritans on 116 123 or 999 in an emergency.*
