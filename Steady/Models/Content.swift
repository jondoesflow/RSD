import Foundation

/// All of the app's built-in guidance. Drawn from ThinkADHD, ADDitude
/// (Dr William Dodson), Simply Psychology, Gottman time-out guidance and the
/// ADHD Chatter podcast — see RESEARCH.md for the full source list.
enum Content {

    // MARK: Right now

    static func guide(for phase: Phase) -> PhaseGuide {
        switch phase {
        case .wobble:
            return PhaseGuide(
                phase: .wobble,
                youMightSee: [
                    "A sudden change in face or voice after something small — a comment, a look, a late reply.",
                    "Over-apologising, or asking “Are you annoyed with me?”",
                    "Going quiet, short answers, or suddenly very busy.",
                    "Defensiveness over something you thought was neutral.",
                    "Rushing to fix, explain or justify."
                ],
                insideJon: [
                    "{J}'s brain has read rejection or criticism into something — even if none was meant.",
                    "The feeling arrives fast and much bigger than the moment. It isn't a choice.",
                    "{J} may already be telling themselves a story: “I've messed up. They're fed up with me.”",
                    "There's still a window here where a calm, warm word can stop it growing."
                ],
                doThis: [
                    "Slow down your own voice and body. Your calm is contagious.",
                    "Name it gently and without blame: “That seemed to land hard.”",
                    "Reassure the relationship, separately from the issue: “We're fine. I love you.”",
                    "Be specific and concrete — vague is where RSD fills in the blanks.",
                    "Offer a choice: talk now, or a breather first?"
                ],
                avoid: [
                    "“You're overreacting” or “It's not a big deal.”",
                    "Debating whether the feeling is fair or logical right now.",
                    "Sarcasm, teasing, or a sigh and an eye-roll — they read as contempt.",
                    "Going silent without explanation."
                ],
                say: [
                    "“I'm not upset with you. I just meant the bins need doing.”",
                    "“That came out wrong — what I meant was…”",
                    "“You're not in trouble. We're on the same team.”",
                    "“Do you want to talk, or would a few minutes help?”",
                    "“I noticed you looked at me — was there anything behind that look?”"
                ]
            )
        case .storm:
            return PhaseGuide(
                phase: .storm,
                youMightSee: [
                    "Tears, despair, or “I'm useless / I ruin everything.”",
                    "A flash of anger that seems out of proportion.",
                    "Shutting down completely — leaving the room, staring, numb.",
                    "All-or-nothing words: always, never, everyone."
                ],
                insideJon: [
                    "This is the “difficult to bear” part of dysphoria. It can feel physical, like being winded.",
                    "Logic can't get in right now — the emotional brain is running the show.",
                    "Anger, if it shows up, is usually armour over shame and hurt.",
                    "Afterwards {J} may feel embarrassed about how big it got. That's part of the cycle."
                ],
                doThis: [
                    "Prioritise safety and calm over solving anything.",
                    "Fewer words. Short, warm, steady sentences.",
                    "Respect the pause word if it's used — and agree when to come back.",
                    "Try QTIP — Quit Taking It Personally. The intensity is about the hurt, not about you.",
                    "Offer physical comfort only if it's wanted. Ask first.",
                    "Look after yourself too: you can step away if you're being spoken to unkindly."
                ],
                avoid: [
                    "Trying to reason, correct facts or win the point.",
                    "Matching the volume or intensity.",
                    "Bringing up past episodes or other grievances.",
                    "Following {J} from room to room if they need space.",
                    "Making big decisions or threats in the heat of it — on either side."
                ],
                say: [
                    "“I can see this really hurts. I'm not going anywhere.”",
                    "“This is the RSD wave. It will pass. I'll be right here.”",
                    "“Let's take twenty minutes. I'll come and find you.”",
                    "“I want to hear you, and I need us both calmer first.”"
                ]
            )
        case .after:
            return PhaseGuide(
                phase: .after,
                youMightSee: [
                    "Tiredness, a ‘hangover’ feeling, or embarrassment.",
                    "Lots of apologising — or avoiding the subject altogether.",
                    "Testing the water: checking whether you're still upset."
                ],
                insideJon: [
                    "Recovery can take hours, sometimes into the next day — the feeling outlasts the event.",
                    "{J} may be scared that this has damaged how you see them.",
                    "This is the best time to learn from it together — once both of you feel safe."
                ],
                doThis: [
                    "Reconnect first, review later. A hug, a cuppa, a normal moment.",
                    "When you're both ready, get curious, not critical: “What did it feel like?”",
                    "Share your side using ‘I’ statements.",
                    "Agree one small thing to try next time.",
                    "Log it in Moments — patterns are easier to see over time."
                ],
                avoid: [
                    "A post-mortem straight away while it's still raw.",
                    "Keeping score or saving it up for later.",
                    "Making {J} grovel. One sincere repair is enough."
                ],
                say: [
                    "“Can we talk about earlier? I want to understand how it felt for you.”",
                    "“I know the rejection feeling wasn't accurate, but I get how real it was.”",
                    "“What would have helped in that moment?”",
                    "“We're okay. We handled that together.”"
                ]
            )
        }
    }

    // MARK: Learn

    static let topics: [LearnTopic] = [
        LearnTopic(
            id: "what",
            title: "What is RSD?",
            symbol: "questionmark.circle",
            summary: "Intense emotional pain triggered by real or perceived rejection, criticism or falling short.",
            sections: [
                LearnSection(heading: "In a sentence",
                             body: "Rejection Sensitivity Dysphoria (RSD) is an intense, sudden emotional reaction to feeling rejected, criticised, excluded or judged — or to believing you've let people down. It's not an official diagnosis, but it is very commonly experienced by people with ADHD."),
                LearnSection(heading: "The name",
                             body: "“Dysphoria” comes from Greek and means “difficult to bear”. That's the key: it isn't ordinary hurt feelings. The pain is far bigger than the moment that sparked it."),
                LearnSection(heading: "Perceived is enough",
                             body: "The rejection doesn't have to be real. A neutral comment, a short text or a tired face can be enough. {J}'s brain fills in the gap with the worst version, very fast."),
                LearnSection(heading: "It's not a reflection of worth",
                             body: "RSD is part of how an ADHD brain processes emotional triggers. It doesn't mean {J} is weak, dramatic or fragile — and it doesn't mean you did something wrong.")
            ],
            source: "ThinkADHD · ADDitude (Dr William Dodson)"
        ),
        LearnTopic(
            id: "why",
            title: "Why is it so intense?",
            symbol: "bolt.heart",
            summary: "ADHD affects how emotions are regulated — the volume knob is turned up, and the brakes are weaker.",
            sections: [
                LearnSection(heading: "Emotional regulation",
                             body: "ADHD isn't just attention. It also affects the brain's ability to put the brakes on a strong emotion. Feelings arrive faster, hit harder and take longer to settle."),
                LearnSection(heading: "Mixed (combined) type",
                             body: "{J} has mixed-type ADHD — both inattentive and hyperactive-impulsive traits. The impulsive side can mean a reaction comes out before there's time to think; the inattentive side can mean missing cues, then feeling ashamed about it."),
                LearnSection(heading: "A lifetime of feedback",
                             body: "Many ADHD adults grew up hearing far more correction than praise — “try harder”, “you're so careless”. Over time the brain becomes primed to expect criticism and to react to the first hint of it."),
                LearnSection(heading: "Zero to a hundred",
                             body: "Dodson describes the shift as abrupt: from apparently fine to overwhelmed in moments. It can be hard for {J} to notice it starting — which is why this app tries to help you both spot the early signs.")
            ],
            source: "ThinkADHD · ADDitude"
        ),
        LearnTopic(
            id: "faces",
            title: "The two faces of RSD",
            symbol: "theatermasks",
            summary: "The pain can turn inwards (shame, sadness) or outwards (anger). Both come from the same hurt.",
            sections: [
                LearnSection(heading: "Turned inwards",
                             body: "Sudden low mood, tears, “I'm useless”, wanting to disappear. It can look like depression arriving out of nowhere — and leaving almost as quickly."),
                LearnSection(heading: "Turned outwards",
                             body: "A sudden flash of anger or defensiveness aimed at the person or situation that seemed to cause the pain. It's armour. Underneath is usually shame or fear."),
                LearnSection(heading: "Shutdown",
                             body: "Some people freeze: go quiet, numb, or leave the room. It can look like not caring. It's usually the opposite — caring so much it's overwhelming."),
                LearnSection(heading: "What this means for you",
                             body: "Try to respond to the hurt underneath rather than the surface behaviour. That doesn't mean accepting being treated badly — you can hold a boundary and still be kind.")
            ],
            source: "ADDitude (Dr William Dodson)"
        ),
        LearnTopic(
            id: "masks",
            title: "The everyday disguises",
            symbol: "eyeglasses",
            summary: "People-pleasing, perfectionism and avoidance are often RSD working quietly in the background.",
            sections: [
                LearnSection(heading: "People-pleasing",
                             body: "Saying yes to everything, constantly reading your mood, agreeing to avoid conflict. It's a way of never giving anyone a reason to reject you."),
                LearnSection(heading: "Perfectionism & over-working",
                             body: "If it's perfect, nobody can criticise it. This can drive great work — and burnout."),
                LearnSection(heading: "Avoidance",
                             body: "Not starting the task, not asking for feedback, not raising the difficult thing. If you don't try, you can't be rejected."),
                LearnSection(heading: "Why it matters at home",
                             body: "If {J} seems to avoid a conversation or agrees too quickly, it may be fear rather than not caring. A gentle “It's safe to disagree with me” can open the door.")
            ],
            source: "ADDitude · ADHD Chatter (Dr Jo Perkins & Dr Mark Rackley)"
        ),
        LearnTopic(
            id: "relationships",
            title: "RSD in our relationship",
            symbol: "heart.circle",
            summary: "The closer someone is, the more their reaction matters — so partners often feel RSD the most.",
            sections: [
                LearnSection(heading: "Why you get the brunt",
                             body: "Your opinion matters most to {J}, so a small sign of disapproval from you carries more weight than from anyone else. That's a sign of how much you matter, not a sign that you're doing it wrong."),
                LearnSection(heading: "The eggshells trap",
                             body: "It's easy to start censoring yourself to avoid triggering a reaction. That isn't healthy for either of you. The goal isn't never saying difficult things — it's saying them in a way RSD can hear, and both of you owning your part."),
                LearnSection(heading: "Shared ownership",
                             body: "{J} is responsible for learning to notice and manage RSD. You're not responsible for preventing it. What helps most is a shared plan — signals, pause words, ways to repair — agreed when you're both calm."),
                LearnSection(heading: "Time-outs work",
                             body: "Relationship researchers (Gottman) recommend a time-out system when either person is flooded: pause for at least 20 minutes, do something soothing, then come back. The coming back is the important bit.")
            ],
            source: "ThinkADHD · Simply Psychology · Gottman Institute"
        ),
        LearnTopic(
            id: "help",
            title: "What actually helps",
            symbol: "cross.case",
            summary: "Self-awareness, self-compassion, support from people who get it, and sometimes professional help.",
            sections: [
                LearnSection(heading: "Naming it",
                             body: "Simply recognising “this is RSD” separates the feeling from the facts. It's one of the most powerful tools — and something you can gently help with, if {J} has agreed you can."),
                LearnSection(heading: "Reframing",
                             body: "Swapping “I'm not good enough because they criticised me” for “That feedback stings, but it doesn't define me.” This takes practice, ideally when calm."),
                LearnSection(heading: "CBT & coaching",
                             body: "Cognitive-behavioural therapy can help challenge the thought patterns that fuel RSD. ADHD coaches and support groups help too — feeling less alone matters."),
                LearnSection(heading: "Medication",
                             body: "Some clinicians report that certain medications ease RSD for some people. This is a conversation for {J}'s GP or ADHD specialist — not something to change without advice."),
                LearnSection(heading: "Basics",
                             body: "Sleep, food, exercise and stress all change how big a reaction gets. A tired, hungry {J} at the end of a hard day is far more likely to be knocked over by a small comment.")
            ],
            source: "ThinkADHD · ADDitude"
        ),
        LearnTopic(
            id: "myths",
            title: "Myths & truths",
            symbol: "checkmark.seal",
            summary: "Clearing up a few common misunderstandings.",
            sections: [
                LearnSection(heading: "“They're just too sensitive.”",
                             body: "RSD is a recognised pattern linked to how ADHD brains regulate emotion. It's not a character flaw or a lack of resilience."),
                LearnSection(heading: "“If I'm careful enough it won't happen.”",
                             body: "You can reduce triggers, but you can't remove them. It isn't your job to. Your job is to be a kind, honest partner — not a bomb disposal expert."),
                LearnSection(heading: "“The anger means they don't love me.”",
                             body: "The anger is usually protecting a deep hurt. That doesn't make hurtful words okay — but it does mean they're rarely about you."),
                LearnSection(heading: "“It's every hurt feeling.”",
                             body: "Not every upset is RSD. Sometimes {J} is upset about something real, and that deserves to be heard on its own terms. Some ADHD voices talk about “rejection attunement” — being finely tuned to real signals too.")
            ],
            source: "ADDitude · ADHD Wise podcast"
        ),
        LearnTopic(
            id: "feels",
            title: "What it actually feels like",
            symbol: "waveform.path.ecg",
            summary: "Adults with ADHD describe RSD as physical — like being winded — and it often hits the body before the mind catches up.",
            sections: [
                LearnSection(heading: "Like a punch",
                             body: "When ADDitude asked readers what RSD feels like, many described it physically: the air leaving their lungs, the heart dropping into the stomach, nausea, a tight chest or throat, then exhaustion afterwards."),
                LearnSection(heading: "Silence can hurt most",
                             body: "One reader described a partner's silence and blank expression as feeling “like knives”. If you go quiet because you're tired or thinking, saying so out loud can save {J} a lot of pain."),
                LearnSection(heading: "Fast anger",
                             body: "Others described frustration turning into “white hot rage” in seconds. It's the hurt coming out sideways — and it usually burns out just as fast."),
                LearnSection(heading: "Being small again",
                             body: "Some said every rejection feels like the very first one they had as a child. That's why a minor moment can bring a reaction that seems to belong to a much bigger event."),
                LearnSection(heading: "Why this helps you",
                             body: "Knowing it's this physical makes it easier not to take it personally. In the moment {J} may genuinely be in pain, not choosing to be difficult.")
            ],
            source: "ADDitude · “How Does RSD Really, Actually Feel?” (readers' experiences)"
        ),
        LearnTopic(
            id: "couples",
            title: "Tools for couples",
            symbol: "person.2.wave.2",
            summary: "Simple, practical tools from psychologist Dr Sharon Saline for couples living with RSD.",
            sections: [
                LearnSection(heading: "QTIP: Quit Taking It Personally",
                             body: "Before reacting, ask: is this bad mood really about me? Very often it isn't. This works both ways — for {K} and for {J}."),
                LearnSection(heading: "The Takeback of the Day",
                             body: "Either of you can say: “I said something I regret. I'd like it to be my takeback.” The other takes a breath and lets it go, without holding on to resentment."),
                LearnSection(heading: "Benefit of the doubt",
                             body: "Assume good intent. Swap accusations for “I wonder…” or “It hurt me when…”."),
                LearnSection(heading: "STEPS to cool down",
                             body: "Self-control: notice early body signs — a faster heartbeat, a louder voice — and act early.\nTime apart: agree a break signal (your pause word) and how breaks work.\nEvenness: once calm, ask what upset you and what you'd do differently.\nPractise reflective listening (below).\nStrategise: small goals, like a monthly date night or a daily thank-you."),
                LearnSection(heading: "Reflective listening",
                             body: "Pick a talker and a listener. The talker speaks without interruption for a few minutes. The listener repeats back what they heard and asks, “Did I get that right?” Then swap."),
                LearnSection(heading: "Questions to ask each other",
                             body: "“How should I say things so they're easier for you to hear?”\n“How can I help you slow down when feelings get big?”\n“I noticed you looked at me — was there anything behind that look?”\nIf this feels too hard to start alone, an ADHD-informed couples therapist can help.")
            ],
            source: "ADDitude · Dr Sharon Saline, “Stop Walking On (or Throwing Down) Eggshells”"
        ),
        LearnTopic(
            id: "spiral",
            title: "Slowing the spiral",
            symbol: "tornado",
            summary: "Strategies for {J} to catch an RSD spiral early and come back from it faster.",
            sections: [
                LearnSection(heading: "Be a STAR",
                             body: "Stop, Think, Act, Recover. A pause in a tense moment gives time to read the situation accurately instead of jumping to the worst conclusion."),
                LearnSection(heading: "Know your triggers",
                             body: "Think back to a recent time you felt bad about yourself: what happened, what you felt, and what story you told yourself. Spotting the pattern lets you step in earlier. (The Moments log in the Us tab helps with this.)"),
                LearnSection(heading: "Talk to yourself like a friend",
                             body: "A mistake doesn't make you a bad person. Notice the effort you made, what went well, and what you'd do differently next time. It feels awkward at first and calming with practice."),
                LearnSection(heading: "Distraction and humour",
                             body: "Break the shame loop with movement (a quick walk, jumping jacks), a small task, or something that makes you laugh. It's not dodging responsibility — it's getting out of a distorted story first."),
                LearnSection(heading: "Build the evidence",
                             body: "Write down times you kept going despite fear, and a list of your strengths — RSD makes these memories fade. A daily “happy and a crappy” (a few good and not-so-good things) keeps the balance honest."),
                LearnSection(heading: "What doesn't work",
                             body: "Pushing feelings down or avoiding every chance of criticism. Rejection is part of life, and avoidance tends to make RSD stronger over time.")
            ],
            source: "ADDitude · Dr Sharon Saline; Kate Funk, LMFT"
        )
    ]

    static let voiceCards: [VoiceCard] = [
        VoiceCard(text: "When I go quiet, I'm not punishing you. I'm trying not to say something I'll regret."),
        VoiceCard(text: "I often don't know what I'm feeling until it's already huge. Help me name it, gently."),
        VoiceCard(text: "A small comment can feel like proof I've let you down. I know that's not logical. It still hurts."),
        VoiceCard(text: "When I over-apologise, I'm asking: are we still okay?"),
        VoiceCard(text: "My anger is usually shame wearing armour. Please don't take it as the real me."),
        VoiceCard(text: "I don't need you to fix it. I need to know you're still on my side."),
        VoiceCard(text: "If I need space, I will come back. Please trust that."),
        VoiceCard(text: "It's not your job to stop this happening. Thank you for learning about it anyway."),
        VoiceCard(text: "Afterwards I often feel embarrassed. A normal hug and a cup of tea helps more than a big talk.")
    ]

    // MARK: Translator

    static let situations: [Situation] = [
        Situation(
            id: "text",
            title: "A slow or short text reply",
            symbol: "message",
            youMeant: "I was busy. “ok” meant ok.",
            rsdHears: "They're annoyed with me. I've done something wrong. They're pulling away.",
            tryInstead: "“Busy right now — all good, will reply properly later ❤️”",
            why: "Ambiguity is where RSD fills in the worst story. A tiny bit of warmth removes the gap."
        ),
        Situation(
            id: "talk",
            title: "“We need to talk.”",
            symbol: "bubble.left.and.exclamationmark.bubble.right",
            youMeant: "There's something practical I'd like us to sort out.",
            rsdHears: "Something terrible is coming. I'm in trouble. This could be the end.",
            tryInstead: "“Nothing bad — can we chat tonight about the holiday budget?”",
            why: "Waiting with an unknown is torture for an RSD brain. Give the topic and the reassurance up front."
        ),
        Situation(
            id: "chore",
            title: "Pointing out a forgotten job",
            symbol: "checklist",
            youMeant: "The bins still need doing.",
            rsdHears: "I'm useless. I always let them down. They're sick of me.",
            tryInstead: "“Could you do the bins before bed? Thanks, love.”",
            why: "Ask for the next action rather than naming the failure. Leave out ‘again’, ‘always’ and ‘never’."
        ),
        Situation(
            id: "feedback",
            title: "Feedback on something they made or did",
            symbol: "pencil.and.scribble",
            youMeant: "It's good — one small tweak would make it better.",
            rsdHears: "It's not good enough. I'm not good enough.",
            tryInstead: "“I really like this. One idea, if you want it: …”",
            why: "Lead with what's genuinely good, make the suggestion optional, and keep it about the thing, not the person."
        ),
        Situation(
            id: "tired",
            title: "You're tired or in a mood",
            symbol: "battery.25",
            youMeant: "Nothing — I've had a rubbish day.",
            rsdHears: "It's me. They're upset with me and won't say.",
            tryInstead: "“I'm grumpy about work, not you. I just need a quiet half hour.”",
            why: "RSD assumes it's about them. Saying who or what it's about saves a spiral."
        ),
        Situation(
            id: "plans",
            title: "Changing or cancelling plans",
            symbol: "calendar.badge.minus",
            youMeant: "I'm too tired for the pub tonight.",
            rsdHears: "They don't want to spend time with me.",
            tryInstead: "“I'm wiped — can we do a sofa night instead? I still want time with you.”",
            why: "Separate ‘no to the plan’ from ‘yes to you’."
        ),
        Situation(
            id: "tease",
            title: "Teasing or banter",
            symbol: "face.smiling",
            youMeant: "Just a joke!",
            rsdHears: "That's what they really think of me.",
            tryInstead: "Keep teasing for moments when {J} is clearly in a good place, and steer clear of known sore spots.",
            why: "On a good day banter is fun. On a fragile day, a joke can land as the truth."
        ),
        Situation(
            id: "space",
            title: "Needing some space yourself",
            symbol: "figure.walk",
            youMeant: "I need an hour to myself to recharge.",
            rsdHears: "They want to get away from me.",
            tryInstead: "“I need an hour to recharge — nothing's wrong. Film together after?”",
            why: "Give the reason, the duration and the reconnection. Then it's a plan, not a rejection."
        ),
        Situation(
            id: "others",
            title: "In front of friends or family",
            symbol: "person.3",
            youMeant: "A quick correction of a story detail.",
            rsdHears: "I've been humiliated in front of everyone.",
            tryInstead: "Let small things go in public. If it matters, mention it privately later.",
            why: "Public correction multiplies the sting. Private is kinder for almost everyone."
        )
    ]

    // MARK: Feelings finder

    static let clues: [FeelingClue] = [
        FeelingClue(id: "hot", kind: .body, text: "Hot face or neck", flavours: [.shame, .anger]),
        FeelingClue(id: "chest", kind: .body, text: "Tight chest", flavours: [.anxious, .anger]),
        FeelingClue(id: "drop", kind: .body, text: "Stomach drop", flavours: [.shame, .anxious]),
        FeelingClue(id: "heavy", kind: .body, text: "Heavy, drained", flavours: [.shame, .shutdown]),
        FeelingClue(id: "numb", kind: .body, text: "Numb or blank", flavours: [.shutdown]),
        FeelingClue(id: "buzz", kind: .body, text: "Buzzing, restless", flavours: [.anxious, .anger]),
        FeelingClue(id: "tears", kind: .body, text: "Close to tears", flavours: [.shame]),
        FeelingClue(id: "jaw", kind: .body, text: "Clenched jaw or fists", flavours: [.anger]),
        FeelingClue(id: "winded", kind: .body, text: "Winded, like a punch", flavours: [.shame, .anger]),

        FeelingClue(id: "ruin", kind: .thought, text: "“I've ruined everything”", flavours: [.shame]),
        FeelingClue(id: "angry", kind: .thought, text: "“They're angry with me”", flavours: [.anxious]),
        FeelingClue(id: "burden", kind: .thought, text: "“I'm a burden”", flavours: [.shame]),
        FeelingClue(id: "unfair", kind: .thought, text: "“That's so unfair”", flavours: [.anger]),
        FeelingClue(id: "replay", kind: .thought, text: "Replaying what was said", flavours: [.anxious]),
        FeelingClue(id: "point", kind: .thought, text: "“What's the point?”", flavours: [.shutdown, .shame]),
        FeelingClue(id: "fix", kind: .thought, text: "“I have to fix this NOW”", flavours: [.anxious]),
        FeelingClue(id: "fog", kind: .thought, text: "Can't think straight", flavours: [.shutdown]),
        FeelingClue(id: "child", kind: .thought, text: "Feeling small, like a kid again", flavours: [.shame]),

        FeelingClue(id: "hide", kind: .urge, text: "Hide or leave the room", flavours: [.shutdown, .shame]),
        FeelingClue(id: "snap", kind: .urge, text: "Snap or argue back", flavours: [.anger]),
        FeelingClue(id: "sorry", kind: .urge, text: "Apologise over and over", flavours: [.anxious, .shame]),
        FeelingClue(id: "please", kind: .urge, text: "Do anything to make it okay", flavours: [.anxious]),
        FeelingClue(id: "scroll", kind: .urge, text: "Scroll / zone out", flavours: [.shutdown]),
        FeelingClue(id: "defend", kind: .urge, text: "Explain and justify", flavours: [.anger, .anxious])
    ]

    // MARK: Signal cards

    static let signalCards: [SignalCard] = [
        SignalCard(id: "rsd", title: "RSD moment",
                   message: "I'm having an RSD moment. It's not your fault. I need a little time and I will come back.",
                   symbol: "cloud.bolt.rain", tint: "storm"),
        SignalCard(id: "pause", title: "Pause",
                   message: "I need 20 minutes to calm down. I'm not leaving the conversation — I'm looking after it.",
                   symbol: "pause.circle", tint: "wobble"),
        SignalCard(id: "hug", title: "Hug please",
                   message: "I can't find the words. A hug would help more than talking right now.",
                   symbol: "heart.fill", tint: "after"),
        SignalCard(id: "okay", title: "Are we okay?",
                   message: "My brain is telling me you're upset with me. Could you tell me if we're okay?",
                   symbol: "questionmark.bubble", tint: "accent"),
        SignalCard(id: "quiet", title: "Overwhelmed",
                   message: "I'm overwhelmed, not angry. I need quiet and low lights for a bit.",
                   symbol: "moon.zzz", tint: "shutdown")
    ]

    // MARK: Repair & self-care

    static let repairSteps: [Step] = [
        Step(title: "Wait until you're both calm",
             detail: "Give it time — sometimes until the next day. Talking while either of you is still flooded rarely goes well."),
        Step(title: "Reconnect before you review",
             detail: "A normal, warm moment first. It tells {J}'s nervous system: we're still safe."),
        Step(title: "Get curious",
             detail: "“What did it feel like for you?” “When did it start?” Use the Feelings finder together if words are hard."),
        Step(title: "Share your side without blame",
             detail: "“I felt worried when you went quiet.” ‘I’ statements are much easier for RSD to hear than ‘you’ statements."),
        Step(title: "Each own your part",
             detail: "{J} owns how the feeling came out. You can own anything you'd do differently. Nobody needs to grovel."),
        Step(title: "Agree one small change",
             detail: "A pause word, a clearer text, a check-in. Small and specific beats a big promise."),
        Step(title: "Use a takeback",
             detail: "Either of you can say, “I said something I regret — I'd like it to be my takeback.” The other lets it go. (From Dr Sharon Saline.)"),
        Step(title: "Close the loop",
             detail: "“We're okay. We got through that.” Then do something nice together.")
    ]

    static let selfCare: [Step] = [
        Step(title: "It's not your fault",
             detail: "You can't cause or prevent RSD on your own. You can only influence how you both respond to it."),
        Step(title: "Boundaries are allowed",
             detail: "Being understanding doesn't mean accepting being shouted at. “I want to help, and I won't be spoken to like that. I'll be back in 20 minutes.”"),
        Step(title: "QTIP: Quit Taking It Personally",
             detail: "When {J}'s mood shifts suddenly, ask yourself whether it's really about you. With RSD it usually isn't."),
        Step(title: "Your feelings matter too",
             detail: "Living alongside RSD can be tiring and confusing. It's okay to feel frustrated, sad or hurt yourself."),
        Step(title: "Don't walk on eggshells",
             detail: "Censoring yourself long-term builds resentment. Say what you need to — the Translator tab helps with how."),
        Step(title: "Get your own support",
             detail: "A friend, a partners' group, or ADHD-informed couples therapy. You don't have to carry this alone."),
        Step(title: "Refill your tank",
             detail: "You can't pour from an empty cup. Protect your own sleep, time and joy.")
    ]

    // MARK: Resources

    static let resources: [Resource] = [
        Resource(kind: .podcast, title: "ADHD Chatter",
                 by: "Alex Partridge",
                 detail: "Weekly UK interviews with ADHD experts. Try “The Science of Rejection Sensitive Dysphoria (+ how to hack it)” with Dr Jo Perkins & Dr Mark Rackley, and “How To Overcome Rejection Sensitivity Dysphoria” with Jessica Summers — which covers RSD in romantic relationships.",
                 url: "https://podcasts.apple.com/gb/podcast/adhd-chatter/id1677158558"),
        Resource(kind: .podcast, title: "The Science of RSD (+ how to hack it)",
                 by: "ADHD Chatter · Dec 2024",
                 detail: "Why RSD happens, people-pleasing as a way to avoid criticism, and how to stop ruminating.",
                 url: "https://podbay.fm/p/adhd-chatter/e/1735603233"),
        Resource(kind: .podcast, title: "How To Overcome RSD",
                 by: "ADHD Chatter · Dec 2025",
                 detail: "With RSD specialist Jessica Summers — includes RSD in romantic relationships and perfectionism.",
                 url: "https://podbay.fm/p/adhd-chatter/e/1766444400"),
        Resource(kind: .podcast, title: "ADHD and RSD: rejection sensitivity meets rejection attunement",
                 by: "ADHD Wise podcast · Episode 5",
                 detail: "A neuro-affirming take: not every hurt is RSD — sometimes it's being finely tuned to real signals.",
                 url: "https://adhdwisepodcast.buzzsprout.com/2604423/episodes/19088381-episode-5-adhd-and-rsd-when-rejection-sensitivity-meets-rejection-attunement"),
        Resource(kind: .book, title: "Why Does Everybody Hate Me?",
                 by: "Alex Partridge",
                 detail: "“Living and Loving with Rejection Sensitivity Dysphoria” — the ADHD Chatter host's book on RSD, relationships and rebuilding confidence. Also on audiobook.",
                 url: "https://www.hachette.co.uk/titles/alex-partridge/why-does-everybody-hate-me/9781399827843/"),
        Resource(kind: .article, title: "ADHD and Rejection (RSD)",
                 by: "ThinkADHD",
                 detail: "A clear, kind UK overview: what RSD is, its impact on relationships and work, CBT and coping strategies.",
                 url: "https://thinkadhd.co.uk/adhd-and/adhd-and-rejection-sensitivity-dysphoria-rsd/"),
        Resource(kind: .additude, title: "ADDitude",
                 by: "additudemag.com",
                 detail: "A leading ADHD magazine with a large library on RSD, emotions and relationships, written with ADHD specialists.",
                 url: "https://www.additudemag.com/"),
        Resource(kind: .additude, title: "How Does RSD Really, Actually Feel?",
                 by: "ADDitude readers",
                 detail: "Adults with ADHD describe RSD in their own words — a great one for partners to read.",
                 url: "https://www.additudemag.com/rsd-rejection-sensitive-dysphoria-experiences/"),
        Resource(kind: .additude, title: "Stop Walking On (or Throwing Down) Eggshells",
                 by: "Dr Sharon Saline",
                 detail: "Tools for couples: QTIP, the Takeback of the Day, STEPS and reflective listening.",
                 url: "https://www.additudemag.com/hurt-feelings-shame-spiral-how-to-stop-being-defensive/"),
        Resource(kind: .additude, title: "How to Deal with Rejection",
                 by: "Dr Sharon Saline",
                 detail: "Coping strategies including STAR, recalling times you persevered, and self-compassion.",
                 url: "https://www.additudemag.com/how-to-deal-with-rejection-rsd-adhd/"),
        Resource(kind: .additude, title: "Emotional Spirals of RSD",
                 by: "Kate Funk, LMFT",
                 detail: "Three steps to slow negative feelings: know your triggers, compassionate self-talk, distraction and humour.",
                 url: "https://www.additudemag.com/emotional-spiral-rsd-strategies/"),
        Resource(kind: .additude, title: "RSD Meaning & Impact in Relationships",
                 by: "ADDitude podcast 524 · Dr Sharon Saline",
                 detail: "Managing conflict, repair and blame in relationships touched by RSD.",
                 url: "https://www.additudemag.com/webinar/rsd-meaning-impact-relationships-adhd/"),
        Resource(kind: .additude, title: "Living with RSD: Alex Partridge",
                 by: "ADDitude",
                 detail: "The ADHD Chatter host on his own experience of rejection sensitivity.",
                 url: "https://www.additudemag.com/alex-partridge-rejection-sensitive-dysphoria/"),
        Resource(kind: .additude, title: "How ADHD Ignites Rejection Sensitive Dysphoria",
                 by: "Dr William Dodson",
                 detail: "The classic explainer: internalised vs externalised RSD, people-pleasing, avoidance and treatment options.",
                 url: "https://www.additudemag.com/rejection-sensitive-dysphoria-and-adhd/"),
        Resource(kind: .article, title: "Rejection Sensitivity in ADHD Relationships",
                 by: "Simply Psychology",
                 detail: "Practical relationship advice — what to say, what to avoid, and how to repair.",
                 url: "https://www.simplypsychology.org/rejection-sensitive-dysphoria-relationships.html"),
        Resource(kind: .support, title: "ADHD UK",
                 by: "UK charity",
                 detail: "Information, community and support for ADHD adults and their families.",
                 url: "https://adhduk.co.uk"),
        Resource(kind: .support, title: "Samaritans — call 116 123",
                 by: "Free, 24/7",
                 detail: "If RSD ever turns into thoughts of not wanting to be here, please reach out. You can call any time, day or night.",
                 url: "tel:116123"),
        Resource(kind: .support, title: "Shout — text SHOUT to 85258",
                 by: "Free, 24/7 text support",
                 detail: "For when talking out loud is too much.",
                 url: "sms:85258&body=SHOUT"),
        Resource(kind: .support, title: "NHS 111 — mental health option",
                 by: "England",
                 detail: "Call 111 and choose the mental health option for urgent support. In an emergency, call 999.",
                 url: "tel:111")
    ]

    // MARK: Check-in messages

    static let defaultCheckIns: [String] = [
        "Just thinking of you ❤️ No need to reply.",
        "We're okay. I love you. Take the time you need.",
        "Nothing's wrong — just wanted to say I'm proud of you today.",
        "I'm here whenever you're ready. Cuppa when you're back?"
    ]
}
