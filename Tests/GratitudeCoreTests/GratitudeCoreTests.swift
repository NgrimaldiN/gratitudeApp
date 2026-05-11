import Foundation
import Testing
@testable import GratitudeCore

@Suite("Course practice catalog")
struct CoursePracticeCatalogTests {
    @Test("wheel includes the main practices from the course emails")
    func wheelIncludesCoursePractices() {
        let titles = Set(PracticeCatalog.all.map(\.title))

        #expect(PracticeCatalog.all.count >= 12)
        #expect(titles.contains("Five-Minute Gratitude Writing"))
        #expect(titles.contains("Loving-Kindness Meditation"))
        #expect(titles.contains("Heart Coherence Breathing"))
        #expect(titles.contains("Rumi Guest House Reflection"))
    }

    @Test("daily spin is stable for the same date and spin seed")
    func dailySpinIsStable() throws {
        let date = try #require(Calendar.gregorian.date(from: DateComponents(year: 2026, month: 5, day: 7)))

        let first = try #require(DailyWheel.pickPractice(for: date, spinSeed: 42, practices: PracticeCatalog.all))
        let second = try #require(DailyWheel.pickPractice(for: date, spinSeed: 42, practices: PracticeCatalog.all))

        #expect(first == second)
    }
}

@Suite("Mindfulness progress")
struct MindfulnessProgressTests {
    @Test("completion stats award streaks, XP, levels, and badges")
    func completionStats() throws {
        let calendar = Calendar.gregorian
        let gratitude = try #require(PracticeCatalog.practice(id: "gratitude-writing"))
        let lovingKindness = try #require(PracticeCatalog.practice(id: "loving-kindness"))
        let heart = try #require(PracticeCatalog.practice(id: "heart-coherence"))

        let logs = [
            DailyLog.completed(
                date: try #require(calendar.date(from: DateComponents(year: 2026, month: 5, day: 5))),
                practice: gratitude,
                minutes: 5,
                note: "Wrote down small things from today."
            ),
            DailyLog.completed(
                date: try #require(calendar.date(from: DateComponents(year: 2026, month: 5, day: 6))),
                practice: lovingKindness,
                minutes: 12,
                note: "Tried the phrases with a friend in mind."
            ),
            DailyLog.completed(
                date: try #require(calendar.date(from: DateComponents(year: 2026, month: 5, day: 7))),
                practice: heart,
                minutes: 10,
                note: "Breathing felt smoother after a few minutes."
            ),
        ]

        let stats = MindfulnessProgress.stats(from: logs, asOf: logs[2].date, calendar: calendar)

        #expect(stats.completedDays == 3)
        #expect(stats.currentStreak == 3)
        #expect(stats.xp == 132)
        #expect(stats.level == 2)
        #expect(stats.badges.contains(.firstPractice))
        #expect(stats.badges.contains(.threeDaySpark))
        #expect(stats.badges.contains(.gratitudeWriter))
        #expect(stats.badges.contains(.heartSteady))
    }

    @Test("date keys use local calendar days")
    func dateKeysUseCalendarDays() throws {
        let date = try #require(Calendar.gregorian.date(from: DateComponents(year: 2026, month: 4, day: 23)))

        #expect(DailyWheel.dateKey(for: date, calendar: .gregorian) == "2026-04-23")
    }
}

@Suite("Demo timeline")
struct DemoTimelineTests {
    @Test("sample timeline is clearly marked and covers about 90 percent of April 26 through May 20")
    func sampleTimelineCoverage() throws {
        let calendar = Calendar.gregorian
        let logs = SampleTimeline.springPresentationLogs(calendar: calendar)

        let start = try #require(calendar.date(from: DateComponents(year: 2026, month: 4, day: 26)))
        let end = try #require(calendar.date(from: DateComponents(year: 2026, month: 5, day: 20)))
        let completedDayKeys = Set(logs.map { DailyWheel.dateKey(for: $0.date, calendar: calendar) })
        let practiceIDs = Set(logs.map(\.practiceID))

        #expect(logs.count == 23)
        #expect(logs.allSatisfy { $0.isCompleted })
        #expect(logs.allSatisfy { $0.source == .sample })
        #expect(logs.allSatisfy { $0.note.contains("[Sample]") })
        #expect(logs.allSatisfy { $0.date >= start && $0.date <= end })
        #expect(practiceIDs.count >= 10)
        #expect(completedDayKeys.contains("2026-04-26"))
        #expect(completedDayKeys.contains("2026-05-20"))
        #expect(!completedDayKeys.contains("2026-05-01"))
        #expect(!completedDayKeys.contains("2026-05-09"))
    }
}

private extension Calendar {
    static var gregorian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }
}
