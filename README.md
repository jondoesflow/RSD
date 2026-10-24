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

## Getting it onto your iPhone

You'll need a Mac with **Xcode 16 or later**. A free Apple ID is enough to install on your own phone.

1. Clone this repo and open `Steady.xcodeproj`.
2. Select the **Steady** target, open **Signing & Capabilities**, and choose your Team (your Apple ID). If Xcode complains about the bundle identifier, change `com.jonrussell.steady` to something unique.
3. Plug in Katie's iPhone, select it as the run destination, and press **Run** (⌘R).
4. On the iPhone, go to **Settings → General → VPN & Device Management** and trust your developer certificate.

With a free Apple ID, the app has to be re-installed every 7 days. A paid Apple Developer account removes that limit and also lets you use TestFlight, so Katie can install updates without a cable.

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
