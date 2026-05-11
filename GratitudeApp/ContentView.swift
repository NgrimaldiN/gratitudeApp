import SwiftUI

struct ContentView: View {
    @StateObject private var store = PracticeStore()

    var body: some View {
        TabView {
            TodayView(store: store)
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            ProgressViewScreen(store: store)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }

            ReportView(store: store)
                .tabItem {
                    Label("Report", systemImage: "doc.text.fill")
                }
        }
        .tint(.coral)
        .toolbarBackground(Color.cream, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

private struct TodayView: View {
    @ObservedObject var store: PracticeStore
    @State private var note = ""
    @State private var minutes = 10

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        HeaderView(stats: store.stats)
                        if store.hasSampleData {
                            SampleDataNotice(clear: store.clearSampleData)
                        } else {
                            SampleDataPrompt(load: store.loadSampleData)
                        }
                        TodayChallengeCard(
                            store: store,
                            note: $note,
                            minutes: $minutes
                        )
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 18)
                    .padding(.bottom, 28)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 84)
                }
            }
            .onAppear {
                if let practice = store.todaysPractice {
                    minutes = practice.durationMinutes
                }
                if let log = store.todayLog {
                    note = log.note
                    minutes = log.minutes
                }
            }
            .onChange(of: store.todaysPractice?.id) { _, _ in
                guard let practice = store.todaysPractice else {
                    return
                }
                minutes = practice.durationMinutes
                note = store.todayLog?.note ?? ""
            }
        }
    }
}

private struct SampleDataNotice: View {
    let clear: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "testtube.2")
                .font(.headline.weight(.black))
                .foregroundStyle(Color.violet)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.violet.opacity(0.14)))

            VStack(alignment: .leading, spacing: 2) {
                Text("Sample data")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.ink)
                Text("Demo entries from Apr 26-May 20 are marked as sample.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.ink.opacity(0.62))
            }

            Spacer(minLength: 8)

            Button(action: clear) {
                Image(systemName: "xmark")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.ink.opacity(0.58))
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Clear sample data")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .shadow(color: .ink.opacity(0.06), radius: 14, y: 8)
        )
    }
}

private struct SampleDataPrompt: View {
    let load: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "tray.and.arrow.down.fill")
                .font(.headline.weight(.black))
                .foregroundStyle(Color.coral)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.coral.opacity(0.14)))

            VStack(alignment: .leading, spacing: 2) {
                Text("Sample history")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.ink)
                Text("Load the Apr 26-May 20 demo entries.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.ink.opacity(0.62))
            }

            Spacer(minLength: 8)

            Button(action: load) {
                Text("Load")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.coral))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Load sample history")
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .shadow(color: .ink.opacity(0.06), radius: 14, y: 8)
        )
    }
}

private struct HeaderView: View {
    let stats: ProgressStats

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(Date().formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.ink.opacity(0.62))

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BREATHE Quest")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(Color.ink)
                        .minimumScaleFactor(0.8)
                    Text("Spin a course practice. Log what changed.")
                        .font(.headline.weight(.medium))
                        .foregroundStyle(Color.ink.opacity(0.68))
                }
                Spacer(minLength: 12)
                LevelBadge(level: stats.level, xp: stats.xp)
            }

            HStack(spacing: 10) {
                StatPill(title: "Streak", value: "\(stats.currentStreak)d", symbol: "flame.fill", tint: .coral)
                StatPill(title: "Minutes", value: "\(stats.totalMinutes)", symbol: "timer", tint: .minty)
                StatPill(title: "Days", value: "\(stats.completedDays)/30", symbol: "checkmark.seal.fill", tint: .violet)
            }
        }
    }
}

private struct TodayChallengeCard: View {
    @ObservedObject var store: PracticeStore
    @Binding var note: String
    @Binding var minutes: Int

    var body: some View {
        VStack(spacing: 18) {
            ZStack(alignment: .top) {
                WheelView(
                    practices: PracticeCatalog.all,
                    selectedPracticeID: store.todaysPractice?.id,
                    rotation: store.wheelRotation
                )
                .frame(width: 248, height: 248)
                .padding(.top, 8)

                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title2.weight(.black))
                    .foregroundStyle(Color.coral)
                    .shadow(color: .peach.opacity(0.65), radius: 8, y: 3)
                    .offset(y: -4)
            }
            .frame(maxWidth: .infinity)

            if let practice = store.todaysPractice {
                PracticeDetail(
                    practice: practice,
                    isCompleted: store.todayCompleted,
                    isSample: store.todayLog?.source == .sample,
                    note: $note,
                    minutes: $minutes,
                    complete: {
                        withAnimation(.snappy(duration: 0.35)) {
                            store.completeToday(minutes: minutes, note: note)
                        }
                    }
                )
            } else {
                VStack(spacing: 14) {
                    Button {
                        withAnimation(.interpolatingSpring(stiffness: 72, damping: 11)) {
                            store.spinToday()
                        }
                    } label: {
                        Label("Spin today's wheel", systemImage: "sparkles")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())

                }
                .padding(.horizontal, 6)
            }
        }
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.72))
                .shadow(color: .ink.opacity(0.08), radius: 22, y: 12)
        }
    }
}

private struct PracticeDetail: View {
    let practice: Practice
    let isCompleted: Bool
    let isSample: Bool
    @Binding var note: String
    @Binding var minutes: Int
    let complete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(practice.category.label, systemImage: practice.category.symbolName)
                    .font(.caption.weight(.black))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.coral)
                Spacer()
                if isSample {
                    Text("Sample")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.violet)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.violet.opacity(0.14)))
                }
                Text("\(practice.durationMinutes) min")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.56))
            }

            Text(practice.title)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(Color.ink)

            Text(practice.courseMoment)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.ink.opacity(0.62))

            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(practice.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.black))
                            .foregroundStyle(Color.white)
                            .frame(width: 22, height: 22)
                            .background(Circle().fill(stepColor(index)))
                        Text(step)
                            .font(.callout.weight(.medium))
                            .foregroundStyle(Color.ink.opacity(0.74))
                    }
                }
            }

            Text(practice.prompt)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.ink)
                .padding(.top, 4)

            Stepper(value: $minutes, in: 1...30) {
                Label("\(minutes) mindful minutes", systemImage: "timer")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(Color.ink)
            }

            TextEditor(text: $note)
                .frame(minHeight: 110)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.cream.opacity(0.72))
                )
                .overlay(alignment: .topLeading) {
                    if note.isEmpty {
                        Text("Notes for your final report...")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(Color.ink.opacity(0.38))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }
                }

            Button(action: complete) {
                Label(isCompleted ? "Update today's log" : "Mark complete", systemImage: isCompleted ? "checkmark.circle.fill" : "seal.fill")
                    .font(.headline.weight(.bold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    private func stepColor(_ index: Int) -> Color {
        [.coral, .minty, .violet][index % 3]
    }
}

private struct ProgressViewScreen: View {
    @ObservedObject var store: PracticeStore

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("Progress")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(Color.ink)

                        if store.hasSampleData {
                            SampleDataNotice(clear: store.clearSampleData)
                        } else {
                            SampleDataPrompt(load: store.loadSampleData)
                        }
                        ProgressPanel(stats: store.stats)
                        LastThirtyDaysGrid(store: store)
                        HistoryList(store: store)
                    }
                    .padding(18)
                    .padding(.bottom, 24)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 84)
                }
            }
        }
    }
}

private struct ProgressPanel: View {
    let stats: ProgressStats

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(stats.level)")
                        .font(.title.bold())
                        .foregroundStyle(Color.ink)
                    Text("\(stats.xp % 100) XP toward next level")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.ink.opacity(0.62))
                }
                Spacer()
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Color.violet)
            }

            SwiftUI.ProgressView(value: Double(stats.xp % 100), total: 100)
                .tint(.coral)

            HStack(spacing: 10) {
                StatPill(title: "Badges", value: "\(stats.badges.count)", symbol: "rosette", tint: .violet)
                StatPill(title: "Logged", value: "\(stats.completedDays)", symbol: "square.and.pencil", tint: .minty)
            }
        }
        .panelStyle()
    }
}

private struct LastThirtyDaysGrid: View {
    @ObservedObject var store: PracticeStore
    @State private var selectedDay: ProgressDay?
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 10)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("30-Day Path")
                    .font(.title3.bold())
                    .foregroundStyle(Color.ink)
                Spacer()
                Image(systemName: "hand.tap.fill")
                    .font(.callout.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.42))
            }

            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(store.progressDays) { day in
                    Button {
                        selectedDay = day
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(cellFill(for: day))
                                .frame(height: 28)
                                .overlay {
                                    if Calendar.current.isDateInToday(day.date) {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(Color.ink.opacity(0.58), lineWidth: 2)
                                    }
                                }

                            Text(day.date.formatted(.dateTime.day()))
                                .font(.caption2.weight(.black))
                                .foregroundStyle(day.isCompleted ? Color.white : Color.ink.opacity(0.56))
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(accessibilityLabel(for: day))
                }
            }
        }
        .panelStyle()
        .sheet(item: $selectedDay) { day in
            ProgressDayDetailSheet(day: day)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func cellFill(for day: ProgressDay) -> Color {
        if day.isCompleted {
            return .coral
        }
        if day.log != nil {
            return .sun.opacity(0.52)
        }
        return Color.white.opacity(0.72)
    }

    private func accessibilityLabel(for day: ProgressDay) -> String {
        let status = day.isCompleted ? "completed" : "not completed"
        return "\(day.date.formatted(.dateTime.month().day())), \(day.title), \(status)"
    }
}

private struct ProgressDayDetailSheet: View {
    let day: ProgressDay

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: dayIcon)
                            .font(.title2.weight(.black))
                            .foregroundStyle(Color.white)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(dayColor))

                        VStack(alignment: .leading, spacing: 5) {
                            Text(day.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.ink.opacity(0.58))
                            Text(day.title)
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundStyle(Color.ink)
                        }
                    }

                    HStack(spacing: 10) {
                        DetailPill(title: "Status", value: statusText, symbol: dayIcon, tint: dayColor)
                        DetailPill(title: "Minutes", value: minutesText, symbol: "timer", tint: .minty)
                    }

                    if day.source == .sample {
                        Label("Sample data", systemImage: "testtube.2")
                            .font(.caption.weight(.black))
                            .foregroundStyle(Color.violet)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Capsule().fill(Color.violet.opacity(0.14)))
                    }

                    if let practice = day.practice {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Practice")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(Color.ink)
                            Label(practice.category.label, systemImage: practice.category.symbolName)
                                .font(.callout.weight(.semibold))
                                .foregroundStyle(Color.coral)
                            Text(practice.courseMoment)
                                .font(.callout.weight(.medium))
                                .foregroundStyle(Color.ink.opacity(0.66))
                        }
                        .panelStyle()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color.ink)
                        Text(notesText)
                            .font(.body.weight(.medium))
                            .foregroundStyle(Color.ink.opacity(0.68))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .panelStyle()

                    if day.log == nil {
                        Text("No wheel spin or journal entry was recorded for this date.")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(Color.ink.opacity(0.56))
                    } else if !day.isCompleted {
                        Text("A practice was selected, but it was not marked complete.")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(Color.ink.opacity(0.56))
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
        }
    }

    private var dayColor: Color {
        if day.isCompleted {
            return .coral
        }
        if day.log != nil {
            return .sun
        }
        return .ink.opacity(0.38)
    }

    private var dayIcon: String {
        if day.isCompleted {
            return "checkmark.seal.fill"
        }
        if day.log != nil {
            return "circle.dashed"
        }
        return "minus"
    }

    private var statusText: String {
        if day.isCompleted {
            return "Completed"
        }
        if day.log != nil {
            return "Pending"
        }
        return "Empty"
    }

    private var minutesText: String {
        guard let minutes = day.minutes else {
            return "-"
        }
        return "\(minutes)"
    }

    private var notesText: String {
        day.note.isEmpty ? "No notes for this day." : day.note
    }
}

private struct DetailPill: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.headline.weight(.bold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.ink)
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.48))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.72))
        )
    }
}

private struct HistoryList: View {
    @ObservedObject var store: PracticeStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Journal")
                .font(.title3.bold())
                .foregroundStyle(Color.ink)

            if store.recentCompletedLogs.isEmpty {
                Text("Completed practices will collect here.")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Color.ink.opacity(0.62))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
            } else {
                ForEach(store.recentCompletedLogs.prefix(8)) { log in
                    HistoryRow(log: log, practice: store.practice(for: log))
                }
            }
        }
        .panelStyle()
    }
}

private struct HistoryRow: View {
    let log: DailyLog
    let practice: Practice?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: practice?.category.symbolName ?? "leaf.fill")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.white)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.minty))

            VStack(alignment: .leading, spacing: 4) {
                Text(practice?.title ?? log.practiceID)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.ink)
                Text(log.date.formatted(.dateTime.month(.abbreviated).day())) + Text(" · \(log.minutes) min")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.ink.opacity(0.54))
                if log.source == .sample {
                    Text("Sample data")
                        .font(.caption2.weight(.black))
                        .foregroundStyle(Color.violet)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.violet.opacity(0.14)))
                }
                if !log.note.isEmpty {
                    Text(log.note)
                        .font(.callout)
                        .foregroundStyle(Color.ink.opacity(0.68))
                        .lineLimit(2)
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

private struct ReportView: View {
    @ObservedObject var store: PracticeStore

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Report Kit")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(Color.ink)

                        if store.hasSampleData {
                            SampleDataNotice(clear: store.clearSampleData)
                        } else {
                            SampleDataPrompt(load: store.loadSampleData)
                        }
                        VStack(alignment: .leading, spacing: 14) {
                            Text("May 21 checklist")
                                .font(.title2.bold())
                                .foregroundStyle(Color.ink)
                            ReportLine(text: "What you did each day and how long")
                            ReportLine(text: "What you noticed during or afterward")
                            ReportLine(text: "Cumulative effect over 30 days")
                            ReportLine(text: "Changes to mood, energy, sleep, appetite")
                            ReportLine(text: "Benefits and whether you will continue")
                        }
                        .panelStyle()

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Draft Notes")
                                .font(.title2.bold())
                                .foregroundStyle(Color.ink)
                            Text(store.reportText())
                                .font(.callout.monospaced())
                                .foregroundStyle(Color.ink.opacity(0.72))
                                .textSelection(.enabled)

                            ShareLink(item: store.reportText()) {
                                Label("Share report text", systemImage: "square.and.arrow.up")
                                    .font(.headline.weight(.bold))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .panelStyle()
                    }
                    .padding(18)
                    .padding(.bottom, 24)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 84)
                }
            }
        }
    }
}

private struct ReportLine: View {
    let text: String

    var body: some View {
        Label(text, systemImage: "checkmark.circle.fill")
            .font(.callout.weight(.semibold))
            .foregroundStyle(Color.ink.opacity(0.72))
    }
}

private struct WheelView: View {
    let practices: [Practice]
    let selectedPracticeID: String?
    let rotation: Double

    private let colors: [Color] = [.coral, .sun, .minty, .violet, .rose, .sky]

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)

            ZStack {
                ForEach(Array(practices.enumerated()), id: \.element.id) { index, practice in
                    segment(for: practice, at: index)
                }

                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: side * 0.36, height: side * 0.36)
                    .shadow(color: .ink.opacity(0.12), radius: 18, y: 8)

                VStack(spacing: 4) {
                    Image(systemName: selectedPracticeID == nil ? "sparkles" : "checkmark.seal.fill")
                        .font(.title2.weight(.black))
                    Text(selectedPracticeID == nil ? "SPIN" : "TODAY")
                        .font(.caption.weight(.black))
                }
                .foregroundStyle(Color.ink)
            }
            .frame(width: side, height: side)
            .rotationEffect(.degrees(rotation))
            .animation(.interpolatingSpring(stiffness: 70, damping: 10), value: rotation)
            .overlay {
                Circle()
                    .stroke(.white.opacity(0.86), lineWidth: 8)
                    .shadow(color: .ink.opacity(0.14), radius: 18, y: 8)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func segment(for practice: Practice, at index: Int) -> some View {
        let slice = 360.0 / Double(practices.count)
        let shape = WheelSegmentShape(
            startDegrees: Double(index) * slice,
            endDegrees: Double(index + 1) * slice
        )

        return shape
            .fill(colors[index % colors.count])
            .overlay {
                shape.stroke(Color.white.opacity(0.56), lineWidth: 2)
            }
            .opacity(selectedPracticeID == nil || selectedPracticeID == practice.id ? 1 : 0.78)
    }
}

private struct WheelSegmentShape: Shape {
    let startDegrees: Double
    let endDegrees: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startDegrees - 90),
            endAngle: .degrees(endDegrees - 90),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

private struct BadgeStrip: View {
    let badges: [GameBadge]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Badges")
                .font(.title3.bold())
                .foregroundStyle(Color.ink)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    if badges.isEmpty {
                        BadgeChip(title: "First Practice", subtitle: "Waiting", symbol: "seal", tint: .ink.opacity(0.42))
                    } else {
                        ForEach(badges, id: \.self) { badge in
                            BadgeChip(title: badge.title, subtitle: badge.detail, symbol: badge.symbolName, tint: badge.tint)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
}

private struct BadgeChip: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol)
                .font(.title2.weight(.black))
                .foregroundStyle(tint)
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.ink)
            Text(subtitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.ink.opacity(0.56))
                .lineLimit(2)
        }
        .frame(width: 150, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.72))
        )
    }
}

private struct StatPill: View {
    let title: String
    let value: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.callout.weight(.bold))
                .foregroundStyle(tint)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color.ink)
                Text(title)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.48))
            }
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 10)
        .background(Capsule().fill(Color.white.opacity(0.66)))
    }
}

private struct LevelBadge: View {
    let level: Int
    let xp: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(level)")
                .font(.title.bold())
                .foregroundStyle(Color.white)
            Text("LVL")
                .font(.caption2.weight(.black))
                .foregroundStyle(Color.white.opacity(0.8))
        }
        .frame(width: 64, height: 64)
        .background(
            Circle()
                .fill(LinearGradient(colors: [.coral, .violet], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .shadow(color: .coral.opacity(0.32), radius: 16, y: 8)
        .accessibilityLabel("Level \(level), \(xp) XP")
    }
}

private struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [.cream, .peach.opacity(0.62), .sky.opacity(0.36)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(Color.sun.opacity(0.28))
                .frame(width: 180, height: 180)
                .blur(radius: 10)
                .offset(x: 54, y: -72)
        }
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 15)
            .foregroundStyle(Color.white)
            .background(
                Capsule()
                    .fill(LinearGradient(colors: [.coral, .rose], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .shadow(color: .coral.opacity(configuration.isPressed ? 0.16 : 0.32), radius: 14, y: 7)
    }
}

private extension View {
    func panelStyle() -> some View {
        padding(18)
            .background {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.72))
                    .shadow(color: .ink.opacity(0.08), radius: 20, y: 10)
            }
    }
}

private extension PracticeCategory {
    var symbolName: String {
        switch self {
        case .body:
            "figure.mind.and.body"
        case .reflection:
            "text.bubble.fill"
        case .emotion:
            "heart.fill"
        case .awareness:
            "eye.fill"
        case .thoughts:
            "cloud.fill"
        case .healthyHabits:
            "figure.walk"
        case .tenderness:
            "hands.sparkles.fill"
        case .empowerment:
            "star.circle.fill"
        }
    }
}

private extension GameBadge {
    var symbolName: String {
        switch self {
        case .firstPractice:
            "seal.fill"
        case .threeDaySpark:
            "flame.fill"
        case .sevenDayGlow:
            "sun.max.fill"
        case .gratitudeWriter:
            "pencil.and.scribble"
        case .heartSteady:
            "heart.circle.fill"
        case .varietyBloom:
            "camera.macro"
        case .reportReady:
            "doc.text.fill"
        }
    }

    var tint: Color {
        switch self {
        case .firstPractice:
            .coral
        case .threeDaySpark:
            .rose
        case .sevenDayGlow:
            .sun
        case .gratitudeWriter:
            .minty
        case .heartSteady:
            .coral
        case .varietyBloom:
            .violet
        case .reportReady:
            .sky
        }
    }
}

private extension Color {
    static let cream = Color(red: 0.99, green: 0.96, blue: 0.88)
    static let peach = Color(red: 1.00, green: 0.76, blue: 0.61)
    static let coral = Color(red: 0.95, green: 0.36, blue: 0.28)
    static let rose = Color(red: 0.90, green: 0.30, blue: 0.50)
    static let sun = Color(red: 0.98, green: 0.75, blue: 0.24)
    static let minty = Color(red: 0.20, green: 0.67, blue: 0.53)
    static let violet = Color(red: 0.45, green: 0.40, blue: 0.86)
    static let sky = Color(red: 0.36, green: 0.66, blue: 0.90)
    static let ink = Color(red: 0.13, green: 0.16, blue: 0.20)
}
