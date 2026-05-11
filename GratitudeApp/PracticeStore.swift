import Foundation

final class PracticeStore: ObservableObject {
    @Published private(set) var logs: [DailyLog] = []
    @Published private(set) var todaysPractice: Practice?
    @Published var wheelRotation = 0.0

    private let logsKey = "breathe.quest.logs.v1"
    private let sampleSeedKey = "breathe.quest.sample.seeded.v1"
    private let calendar: Calendar
    private let defaults: UserDefaults

    init(calendar: Calendar = .current, defaults: UserDefaults = .standard) {
        self.calendar = calendar
        self.defaults = defaults
        load()
        seedSampleTimelineIfNeeded()
        restoreToday()
    }

    var todayLog: DailyLog? {
        log(for: Date())
    }

    var todayCompleted: Bool {
        todayLog?.isCompleted == true
    }

    var stats: ProgressStats {
        MindfulnessProgress.stats(from: logs, asOf: Date(), calendar: calendar)
    }

    var recentCompletedLogs: [DailyLog] {
        logs
            .filter(\.isCompleted)
            .sorted { $0.date > $1.date }
    }

    var progressDays: [ProgressDay] {
        ProgressTimeline.days(endingAt: Date(), count: 30, logs: logs, calendar: calendar)
    }

    var hasSampleData: Bool {
        logs.contains { $0.source == .sample }
    }

    func spinToday() {
        if let existingLog = todayLog, let practice = PracticeCatalog.practice(id: existingLog.practiceID) {
            todaysPractice = practice
            rotateWheel(to: practice)
            return
        }

        let seed = Int(Date().timeIntervalSince1970.rounded()) % 10_000
        guard let practice = DailyWheel.pickPractice(for: Date(), spinSeed: seed, practices: PracticeCatalog.all, calendar: calendar) else {
            return
        }

        todaysPractice = practice
        upsert(DailyLog.pending(date: Date(), practice: practice, calendar: calendar))
        rotateWheel(to: practice)
    }

    func completeToday(minutes: Int, note: String) {
        let practice = todaysPractice ?? PracticeCatalog.practice(id: todayLog?.practiceID ?? "") ?? PracticeCatalog.all[0]
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let completed = DailyLog.completed(
            date: Date(),
            practice: practice,
            minutes: max(1, minutes),
            note: trimmedNote,
            calendar: calendar
        )
        todaysPractice = practice
        upsert(completed)
    }

    func practice(for log: DailyLog) -> Practice? {
        PracticeCatalog.practice(id: log.practiceID)
    }

    func isCompleted(on date: Date) -> Bool {
        log(for: date)?.isCompleted == true
    }

    func reportText() -> String {
        let stats = stats
        let lines = recentCompletedLogs.reversed().map { log -> String in
            let practice = PracticeCatalog.practice(id: log.practiceID)
            let title = practice?.title ?? log.practiceID
            let day = log.date.formatted(.dateTime.month(.abbreviated).day().year())
            let source = log.source == .sample ? " [SAMPLE]" : ""
            let note = log.note.isEmpty ? "No note." : log.note
            return "\(day): \(title), \(log.minutes) min\(source). \(note)"
        }
        let sampleNotice = hasSampleData ? "\nSample data notice: these entries are for app demonstration only, not a real submitted journal.\n" : ""

        return """
        BREATHE Quest Mindfulness Report
        \(sampleNotice)

        Completed days: \(stats.completedDays)
        Current streak: \(stats.currentStreak)
        Mindful minutes: \(stats.totalMinutes)
        Level: \(stats.level)

        Daily record:
        \(lines.joined(separator: "\n"))

        Reflection prompts:
        1. What did I notice during or just afterward?
        2. Did I notice a cumulative effect?
        3. What changed in mood, energy, sleep, or appetite?
        4. What benefits did this practice bring?
        5. Will I continue this or another mindfulness practice?
        """
    }

    func clearSampleData() {
        logs.removeAll { $0.source == .sample }
        defaults.set(true, forKey: sampleSeedKey)
        save()
        restoreToday()
    }

    private func restoreToday() {
        guard let log = todayLog else {
            todaysPractice = nil
            return
        }
        todaysPractice = PracticeCatalog.practice(id: log.practiceID)
    }

    private func rotateWheel(to practice: Practice) {
        guard let index = PracticeCatalog.all.firstIndex(of: practice) else {
            wheelRotation += 720
            return
        }

        let slice = 360.0 / Double(PracticeCatalog.all.count)
        let target = 360.0 - (Double(index) * slice + slice / 2.0)
        let current = wheelRotation.truncatingRemainder(dividingBy: 360)
        wheelRotation += 1_080 + target - current
    }

    private func log(for date: Date) -> DailyLog? {
        let key = DailyWheel.dateKey(for: date, calendar: calendar)
        return logs.first { DailyWheel.dateKey(for: $0.date, calendar: calendar) == key }
    }

    private func upsert(_ log: DailyLog) {
        let key = DailyWheel.dateKey(for: log.date, calendar: calendar)
        if let index = logs.firstIndex(where: { DailyWheel.dateKey(for: $0.date, calendar: calendar) == key }) {
            logs[index] = log
        } else {
            logs.append(log)
        }
        logs.sort { $0.date < $1.date }
        save()
    }

    private func seedSampleTimelineIfNeeded() {
        guard !defaults.bool(forKey: sampleSeedKey), !hasSampleData else {
            return
        }

        for sampleLog in SampleTimeline.springPresentationLogs(calendar: calendar) {
            let key = DailyWheel.dateKey(for: sampleLog.date, calendar: calendar)
            let existing = logs.first { DailyWheel.dateKey(for: $0.date, calendar: calendar) == key }
            if existing?.source == .user {
                continue
            }
            upsert(sampleLog)
        }

        defaults.set(true, forKey: sampleSeedKey)
    }

    private func load() {
        guard let data = defaults.data(forKey: logsKey) else {
            logs = []
            return
        }

        do {
            logs = try JSONDecoder().decode([DailyLog].self, from: data)
        } catch {
            logs = []
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(logs) else {
            return
        }
        defaults.set(data, forKey: logsKey)
    }
}
