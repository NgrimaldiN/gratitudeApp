import Foundation

public enum PracticeCategory: String, CaseIterable, Codable, Equatable, Sendable {
    case body
    case reflection
    case emotion
    case awareness
    case thoughts
    case healthyHabits
    case tenderness
    case empowerment

    public var label: String {
        switch self {
        case .body:
            "Body"
        case .reflection:
            "Reflection"
        case .emotion:
            "Emotion"
        case .awareness:
            "Awareness"
        case .thoughts:
            "Thoughts"
        case .healthyHabits:
            "Healthy Habits"
        case .tenderness:
            "Tenderness"
        case .empowerment:
            "Empowerment"
        }
    }
}

public struct Practice: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let category: PracticeCategory
    public let durationMinutes: Int
    public let courseMoment: String
    public let prompt: String
    public let steps: [String]

    public init(
        id: String,
        title: String,
        category: PracticeCategory,
        durationMinutes: Int,
        courseMoment: String,
        prompt: String,
        steps: [String]
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.durationMinutes = durationMinutes
        self.courseMoment = courseMoment
        self.prompt = prompt
        self.steps = steps
    }
}

public enum PracticeCatalog {
    public static let all: [Practice] = [
        Practice(
            id: "breath-focus",
            title: "Breath Focus Meditation",
            category: .awareness,
            durationMinutes: 10,
            courseMoment: "Class 3: meditation focused on the breath",
            prompt: "What changed when you placed attention on the breath?",
            steps: [
                "Sit comfortably and soften your shoulders.",
                "Follow the inhale and exhale without trying to improve them.",
                "When your mind wanders, notice it and return to breathing.",
            ]
        ),
        Practice(
            id: "body-scan",
            title: "Slow Body Movement Scan",
            category: .body,
            durationMinutes: 10,
            courseMoment: "April 9: physical mindfulness and slow body movements",
            prompt: "Which part of your body felt most awake afterward?",
            steps: [
                "Move your neck, shoulders, hands, and feet slowly.",
                "Track each sensation as if you were listening with your body.",
                "End by standing still for three breaths.",
            ]
        ),
        Practice(
            id: "mindful-walk",
            title: "Mindful Walk",
            category: .healthyHabits,
            durationMinutes: 15,
            courseMoment: "April 9: mindful walk using the senses",
            prompt: "What did you notice outside that you usually miss?",
            steps: [
                "Walk without music or texting.",
                "Name five things you see, four sounds, and three physical sensations.",
                "Slow down for the final minute.",
            ]
        ),
        Practice(
            id: "gratitude-writing",
            title: "Five-Minute Gratitude Writing",
            category: .tenderness,
            durationMinutes: 5,
            courseMoment: "March 26 and April 2: gratitude writing",
            prompt: "What are you grateful for today, even if it is very small?",
            steps: [
                "Set a five minute timer.",
                "Write anything you are grateful for without editing.",
                "Underline one sentence that surprised you.",
            ]
        ),
        Practice(
            id: "loving-kindness",
            title: "Loving-Kindness Meditation",
            category: .tenderness,
            durationMinutes: 12,
            courseMoment: "April 2: loving kindness meditation",
            prompt: "Who was easy to include, and who was harder?",
            steps: [
                "Begin with yourself: may I be safe, steady, and kind.",
                "Offer the same wish to a friend.",
                "Offer it to someone neutral, then to someone difficult.",
            ]
        ),
        Practice(
            id: "heart-coherence",
            title: "Heart Coherence Breathing",
            category: .emotion,
            durationMinutes: 10,
            courseMoment: "April 23: heart coherence meditation",
            prompt: "Did your body feel different after breathing evenly?",
            steps: [
                "Place a hand near your heart.",
                "Breathe in for five counts and out for five counts.",
                "Picture one person, place, or moment that feels warm.",
            ]
        ),
        Practice(
            id: "emotion-naming",
            title: "Emotion Naming Check-In",
            category: .emotion,
            durationMinutes: 8,
            courseMoment: "February 12 and April 17: pleasant, neutral, and less pleasant emotions",
            prompt: "Which feeling word fits best, and where did you feel it?",
            steps: [
                "Choose one current feeling word.",
                "Notice whether it is pleasant, neutral, or less pleasant.",
                "Write what the feeling seems to need.",
            ]
        ),
        Practice(
            id: "thought-reflection",
            title: "Thoughts on Paper",
            category: .thoughts,
            durationMinutes: 10,
            courseMoment: "February 5: Reflect, thoughts, and the feelings that arise",
            prompt: "Which thought kept returning, and what feeling came with it?",
            steps: [
                "Write the thoughts that appear for ten minutes.",
                "Circle one repeated thought.",
                "Add one sentence that names the feeling under it.",
            ]
        ),
        Practice(
            id: "stress-sort",
            title: "Stress Sort",
            category: .reflection,
            durationMinutes: 12,
            courseMoment: "March 12: acute and chronic stressors",
            prompt: "Which stressor is changeable today, even by one percent?",
            steps: [
                "List three stressors in your life right now.",
                "Mark each one acute, chronic, internal, or external.",
                "Choose one tiny helpful action.",
            ]
        ),
        Practice(
            id: "rumi-guest-house",
            title: "Rumi Guest House Reflection",
            category: .reflection,
            durationMinutes: 10,
            courseMoment: "May 7: The Guest House by Rumi",
            prompt: "What visitor arrived today, and how could you treat it honorably?",
            steps: [
                "Name the strongest emotion or thought visiting today.",
                "Imagine greeting it at the door.",
                "Write what it might be trying to show you.",
            ]
        ),
        Practice(
            id: "gratitude-collage",
            title: "Gratitude Collage Snapshot",
            category: .empowerment,
            durationMinutes: 15,
            courseMoment: "May 7: gratitude collages",
            prompt: "What image, color, or object captured gratitude today?",
            steps: [
                "Take or choose three photos that represent gratitude.",
                "Arrange them in your notes or camera roll.",
                "Add a one sentence caption.",
            ]
        ),
        Practice(
            id: "silent-sitting",
            title: "Five-Minute Silent Sitting",
            category: .awareness,
            durationMinutes: 5,
            courseMoment: "March 26 and February 5: silent meditation",
            prompt: "What did silence reveal once you stopped filling it?",
            steps: [
                "Set a five minute timer.",
                "Sit without music, reading, or checking your phone.",
                "Record the first three things you noticed.",
            ]
        ),
        Practice(
            id: "senses-scan",
            title: "Directed Senses Scan",
            category: .awareness,
            durationMinutes: 8,
            courseMoment: "January 26: noticing how noticing changes with directed senses",
            prompt: "Which sense changed the mood of the moment?",
            steps: [
                "Spend one minute each on sight, sound, touch, smell, and taste.",
                "Let the sense lead instead of searching for something special.",
                "Write the most vivid detail.",
            ]
        ),
        Practice(
            id: "future-self-letter",
            title: "Future Self Letter",
            category: .empowerment,
            durationMinutes: 15,
            courseMoment: "April 2: letter to yourself for the last day of class",
            prompt: "What would you like your May 21 self to remember?",
            steps: [
                "Start with: I want you to know...",
                "Write kindly about what is hard right now.",
                "End with one wish for your future self.",
            ]
        ),
    ]

    public static func practice(id: String) -> Practice? {
        all.first { $0.id == id }
    }
}

public enum DailyWheel {
    public static func pickPractice(
        for date: Date,
        spinSeed: Int,
        practices: [Practice] = PracticeCatalog.all,
        calendar: Calendar = .current
    ) -> Practice? {
        guard !practices.isEmpty else {
            return nil
        }

        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = UInt64(components.year ?? 0)
        let month = UInt64(components.month ?? 0)
        let day = UInt64(components.day ?? 0)
        let dateNumber = year * 10_000 + month * 100 + day
        let seed = UInt64(truncatingIfNeeded: spinSeed)
        let mixed = dateNumber &* 1_103_515_245 &+ seed &* 12_345 &+ 97

        return practices[Int(mixed % UInt64(practices.count))]
    }

    public static func dateKey(for date: Date, calendar: Calendar = .current) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}

public enum LogSource: String, Codable, Equatable, Sendable {
    case user
    case sample
}

public struct DailyLog: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let date: Date
    public let practiceID: String
    public var isCompleted: Bool
    public var minutes: Int
    public var note: String
    public var completedAt: Date?
    public var source: LogSource

    public init(
        id: String,
        date: Date,
        practiceID: String,
        isCompleted: Bool,
        minutes: Int,
        note: String,
        completedAt: Date?,
        source: LogSource = .user
    ) {
        self.id = id
        self.date = date
        self.practiceID = practiceID
        self.isCompleted = isCompleted
        self.minutes = minutes
        self.note = note
        self.completedAt = completedAt
        self.source = source
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case practiceID
        case isCompleted
        case minutes
        case note
        case completedAt
        case source
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        practiceID = try container.decode(String.self, forKey: .practiceID)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        minutes = try container.decode(Int.self, forKey: .minutes)
        note = try container.decode(String.self, forKey: .note)
        completedAt = try container.decodeIfPresent(Date.self, forKey: .completedAt)
        source = try container.decodeIfPresent(LogSource.self, forKey: .source) ?? .user
    }

    public static func pending(date: Date, practice: Practice, calendar: Calendar = .current) -> DailyLog {
        DailyLog(
            id: "\(DailyWheel.dateKey(for: date, calendar: calendar))-\(practice.id)",
            date: date,
            practiceID: practice.id,
            isCompleted: false,
            minutes: practice.durationMinutes,
            note: "",
            completedAt: nil
        )
    }

    public static func completed(
        date: Date,
        practice: Practice,
        minutes: Int,
        note: String,
        calendar: Calendar = .current,
        source: LogSource = .user
    ) -> DailyLog {
        DailyLog(
            id: "\(DailyWheel.dateKey(for: date, calendar: calendar))-\(practice.id)",
            date: date,
            practiceID: practice.id,
            isCompleted: true,
            minutes: minutes,
            note: note,
            completedAt: date,
            source: source
        )
    }
}

public enum SampleTimeline {
    public static func springPresentationLogs(calendar: Calendar = .current) -> [DailyLog] {
        let entries: [(month: Int, day: Int, practiceID: String, minutes: Int, note: String)] = [
            (4, 26, "gratitude-writing", 6, "[Sample] Wrote about coffee, a quiet morning, and feeling less rushed."),
            (4, 27, "mindful-walk", 14, "[Sample] Walked without music and noticed wind, traffic, and tree shadows."),
            (4, 28, "breath-focus", 10, "[Sample] Breath felt uneven at first, then settled after a few minutes."),
            (4, 29, "loving-kindness", 12, "[Sample] Sending kind phrases to myself felt awkward but useful."),
            (4, 30, "thought-reflection", 10, "[Sample] Repeated school thoughts showed up; naming them made them less loud."),
            (5, 2, "heart-coherence", 10, "[Sample] Five-count breathing made my chest feel calmer before studying."),
            (5, 3, "body-scan", 11, "[Sample] Shoulders were tense; slow movement made that obvious."),
            (5, 4, "emotion-naming", 8, "[Sample] The best word was nervous, with some excitement underneath."),
            (5, 5, "stress-sort", 13, "[Sample] Split stressors into school, sleep, and family; picked one small action."),
            (5, 6, "silent-sitting", 5, "[Sample] Silence felt long, but I noticed fewer urges to grab my phone."),
            (5, 7, "rumi-guest-house", 10, "[Sample] The main visitor was impatience, and I tried not to push it away."),
            (5, 8, "gratitude-collage", 15, "[Sample] Chose photos of dinner, sunlight, and my desk after cleaning it."),
            (5, 10, "senses-scan", 8, "[Sample] Sound changed the mood most; small background noises became vivid."),
            (5, 11, "future-self-letter", 15, "[Sample] Wrote to May 21 me about keeping the practice simple."),
            (5, 12, "mindful-walk", 16, "[Sample] Walked slower and noticed how automatic my pace usually is."),
            (5, 13, "loving-kindness", 12, "[Sample] It was easier to include a friend than myself today."),
            (5, 14, "heart-coherence", 11, "[Sample] Breathing evenly helped before a conversation I was avoiding."),
            (5, 15, "gratitude-writing", 7, "[Sample] Listed tiny things; the strongest one was having enough time."),
            (5, 16, "stress-sort", 12, "[Sample] Most stress was internal pressure, so I wrote one realistic next step."),
            (5, 17, "breath-focus", 10, "[Sample] Mind wandered a lot, but returning to breath felt less frustrating."),
            (5, 18, "emotion-naming", 9, "[Sample] Felt tired and a little proud; both could exist at once."),
            (5, 19, "body-scan", 10, "[Sample] Slow neck and shoulder movement helped after sitting too long."),
            (5, 20, "rumi-guest-house", 12, "[Sample] Tried welcoming worry as information instead of a problem to erase."),
        ]

        return entries.compactMap { entry in
            guard
                let date = calendar.date(from: DateComponents(year: 2026, month: entry.month, day: entry.day)),
                let practice = PracticeCatalog.practice(id: entry.practiceID)
            else {
                return nil
            }

            return DailyLog.completed(
                date: date,
                practice: practice,
                minutes: entry.minutes,
                note: entry.note,
                calendar: calendar,
                source: .sample
            )
        }
    }
}

public enum GameBadge: String, CaseIterable, Codable, Equatable, Sendable {
    case firstPractice
    case threeDaySpark
    case sevenDayGlow
    case gratitudeWriter
    case heartSteady
    case varietyBloom
    case reportReady

    public var title: String {
        switch self {
        case .firstPractice:
            "First Practice"
        case .threeDaySpark:
            "3-Day Spark"
        case .sevenDayGlow:
            "7-Day Glow"
        case .gratitudeWriter:
            "Gratitude Writer"
        case .heartSteady:
            "Heart Steady"
        case .varietyBloom:
            "Variety Bloom"
        case .reportReady:
            "Report Ready"
        }
    }

    public var detail: String {
        switch self {
        case .firstPractice:
            "Complete your first daily challenge."
        case .threeDaySpark:
            "Practice three days in a row."
        case .sevenDayGlow:
            "Keep a full week streak alive."
        case .gratitudeWriter:
            "Complete a gratitude writing practice."
        case .heartSteady:
            "Try heart coherence breathing."
        case .varietyBloom:
            "Explore five course themes."
        case .reportReady:
            "Log the 30 days needed for the report."
        }
    }
}

public struct ProgressStats: Equatable, Sendable {
    public let completedDays: Int
    public let currentStreak: Int
    public let totalMinutes: Int
    public let xp: Int
    public let level: Int
    public let badges: [GameBadge]

    public init(
        completedDays: Int,
        currentStreak: Int,
        totalMinutes: Int,
        xp: Int,
        level: Int,
        badges: [GameBadge]
    ) {
        self.completedDays = completedDays
        self.currentStreak = currentStreak
        self.totalMinutes = totalMinutes
        self.xp = xp
        self.level = level
        self.badges = badges
    }
}

public struct ProgressDay: Identifiable, Equatable, Sendable {
    public let date: Date
    public let dateKey: String
    public let log: DailyLog?
    public let practice: Practice?

    public var id: String {
        dateKey
    }

    public var isCompleted: Bool {
        log?.isCompleted == true
    }

    public var title: String {
        practice?.title ?? "No practice logged"
    }

    public var minutes: Int? {
        log?.minutes
    }

    public var note: String {
        log?.note ?? ""
    }

    public var source: LogSource? {
        log?.source
    }

    public init(date: Date, dateKey: String, log: DailyLog?, practice: Practice?) {
        self.date = date
        self.dateKey = dateKey
        self.log = log
        self.practice = practice
    }
}

public enum ProgressTimeline {
    public static func days(
        endingAt endDate: Date,
        count: Int = 30,
        logs: [DailyLog],
        calendar: Calendar = .current
    ) -> [ProgressDay] {
        guard count > 0 else {
            return []
        }

        let logsByDay = Dictionary(grouping: logs) { log in
            DailyWheel.dateKey(for: log.date, calendar: calendar)
        }

        return (0..<count).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset - count + 1, to: endDate) else {
                return nil
            }

            let startOfDay = calendar.startOfDay(for: date)
            let key = DailyWheel.dateKey(for: startOfDay, calendar: calendar)
            let log = preferredLog(from: logsByDay[key] ?? [])
            let practice = log.flatMap { PracticeCatalog.practice(id: $0.practiceID) }

            return ProgressDay(
                date: startOfDay,
                dateKey: key,
                log: log,
                practice: practice
            )
        }
    }

    private static func preferredLog(from logs: [DailyLog]) -> DailyLog? {
        logs.sorted { lhs, rhs in
            if lhs.source != rhs.source {
                return lhs.source == .user
            }
            if lhs.isCompleted != rhs.isCompleted {
                return lhs.isCompleted && !rhs.isCompleted
            }
            return (lhs.completedAt ?? lhs.date) > (rhs.completedAt ?? rhs.date)
        }.first
    }
}

public enum MindfulnessProgress {
    public static func stats(
        from logs: [DailyLog],
        asOf date: Date = Date(),
        calendar: Calendar = .current
    ) -> ProgressStats {
        let completedLogs = logs.filter(\.isCompleted)
        let uniqueCompletedDays = Set(completedLogs.map { DailyWheel.dateKey(for: $0.date, calendar: calendar) })
        let totalMinutes = completedLogs.reduce(0) { $0 + max(0, $1.minutes) }
        let noteBonus = completedLogs.filter { !$0.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count * 5
        let xp = completedLogs.count * 30 + totalMinutes + noteBonus
        let streak = currentStreak(from: completedLogs, asOf: date, calendar: calendar)
        let level = max(1, xp / 100 + 1)
        let badges = earnedBadges(
            completedLogs: completedLogs,
            completedDays: uniqueCompletedDays.count,
            currentStreak: streak
        )

        return ProgressStats(
            completedDays: uniqueCompletedDays.count,
            currentStreak: streak,
            totalMinutes: totalMinutes,
            xp: xp,
            level: level,
            badges: badges
        )
    }

    private static func currentStreak(
        from completedLogs: [DailyLog],
        asOf date: Date,
        calendar: Calendar
    ) -> Int {
        let completedDays = Set(completedLogs.map { DailyWheel.dateKey(for: $0.date, calendar: calendar) })
        guard !completedDays.isEmpty else {
            return 0
        }

        let startOfAsOf = calendar.startOfDay(for: date)
        let latestCompletedDate = completedLogs
            .map { calendar.startOfDay(for: $0.date) }
            .filter { $0 <= startOfAsOf }
            .max() ?? startOfAsOf

        var cursor = latestCompletedDate
        var streak = 0

        while completedDays.contains(DailyWheel.dateKey(for: cursor, calendar: calendar)) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previous
        }

        return streak
    }

    private static func earnedBadges(
        completedLogs: [DailyLog],
        completedDays: Int,
        currentStreak: Int
    ) -> [GameBadge] {
        let practiceIDs = Set(completedLogs.map(\.practiceID))
        let categories = Set(completedLogs.compactMap { PracticeCatalog.practice(id: $0.practiceID)?.category })
        var badges: [GameBadge] = []

        if completedDays >= 1 {
            badges.append(.firstPractice)
        }
        if currentStreak >= 3 {
            badges.append(.threeDaySpark)
        }
        if currentStreak >= 7 {
            badges.append(.sevenDayGlow)
        }
        if practiceIDs.contains("gratitude-writing") {
            badges.append(.gratitudeWriter)
        }
        if practiceIDs.contains("heart-coherence") {
            badges.append(.heartSteady)
        }
        if categories.count >= 5 {
            badges.append(.varietyBloom)
        }
        if completedDays >= 30 {
            badges.append(.reportReady)
        }

        return badges
    }
}
