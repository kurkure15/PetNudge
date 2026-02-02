import SwiftUI

struct FirstReminderView: View {
    let character: PetCharacter
    let onReminderCreated: (Reminder) -> Void
    let onBack: () -> Void

    @State private var taskText: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 10
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()

    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var hasEdited = false
    @FocusState private var isTaskFieldFocused: Bool

    // Default task text per character (from Figma)
    private var defaultTaskText: String {
        switch character {
        case .dog:      return "Drink Water"
        case .cat:      return "Water my Plants"
        case .redPanda: return "Feed my Cat"
        }
    }

    // Hint text per character (from Figma)
    private var hintText: String {
        switch character {
        case .dog:
            return "Add what you want to me remind you\nabout in the white text"
        case .cat:
            return "You can ask me to remind you before\n5, 10, or 15 minutes too"
        case .redPanda:
            return "I can also remind you to take a nap\ntomorrow or on Wednesday"
        }
    }

    private var reminderDate: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute

        return calendar.date(from: combinedComponents) ?? Date()
    }

    private var accentColor: Color {
        Color(hex: character.accentHex)
    }

    var body: some View {
        ZStack {
            // Character-specific dark gradient background
            LinearGradient(
                colors: [
                    Color(hex: character.step1GradientTopHex),
                    Color(hex: "000000")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                isTaskFieldFocused = false
            }

            ZStack(alignment: .topLeading) {
                // MARK: - Back button (top-left, 48x48 at 24,24)
                Button(action: onBack) {
                    Image("ic_Back")
                        .resizable()
                        .interpolation(.high)
                        .frame(width: 48, height: 48)
                }
                .buttonStyle(.plain)
                .position(x: 24 + 24, y: 24 + 24)

                // MARK: - Settings button (top-right, 48x48 at 1128,24)
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                }
                .buttonStyle(.plain)
                .position(x: 1128 + 24, y: 24 + 24)

                // MARK: - Sentence builder (centered, width 285, at x:457.5 y:271)
                VStack(alignment: .leading, spacing: 12) {
                    // "Hey [Name]," — SF Pro, weight 860 (heavy), 20pt
                    Text("Hey \(character.displayName),")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)

                    // "Remind me to [Task]"
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Remind me to")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                                .fixedSize()

                            // Editable task text — SF Pro, weight 1000 (black), 24pt, accent color, single-line
                            ZStack(alignment: .leading) {
                                // TextField always in tree (preserves focus state).
                                // Hidden when unfocused so its scroll position doesn't bleed through.
                                TextField("", text: $taskText)
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(accentColor)
                                    .focused($isTaskFieldFocused)
                                    .textFieldStyle(.plain)
                                    .opacity(isTaskFieldFocused ? 1 : 0)
                                    .onChange(of: taskText) { _, _ in
                                        if !hasEdited { hasEdited = true }
                                    }

                                // Overlay when not focused: placeholder or display text (shows from start)
                                if !isTaskFieldFocused {
                                    Group {
                                        if taskText.isEmpty {
                                            Text(defaultTaskText)
                                                .underline(!hasEdited, color: accentColor)
                                        } else {
                                            Text(taskText)
                                                .truncationMode(.tail)
                                        }
                                    }
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(accentColor)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                    .onTapGesture { isTaskFieldFocused = true }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(Rectangle())
                        }

                        // "[Day] at [Time]"
                        HStack(alignment: .center, spacing: 8) {
                            Button(action: { showDatePicker.toggle() }) {
                                Text(dayString)
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(accentColor)
                                    .underline(!hasEdited, color: accentColor)
                                    .lineLimit(1)
                                    .fixedSize()
                            }
                            .buttonStyle(.plain)
                            .popover(isPresented: $showDatePicker) {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .padding()
                                    .onChange(of: selectedDate) { _, _ in
                                        if !hasEdited { hasEdited = true }
                                    }
                            }

                            Text("at")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)

                            Button(action: { showTimePicker.toggle() }) {
                                Text(timeString)
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(accentColor)
                                    .underline(!hasEdited, color: accentColor)
                            }
                            .buttonStyle(.plain)
                            .popover(isPresented: $showTimePicker) {
                                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.graphical)
                                    .labelsHidden()
                                    .padding()
                                    .onChange(of: selectedTime) { _, _ in
                                        if !hasEdited { hasEdited = true }
                                    }
                            }
                        }
                    }
                }
                .frame(width: 285, alignment: .leading)
                .clipped()
                .position(x: 600, y: 303)

                // MARK: - Hint with character thumbnail (shown when task is empty)
                if taskText.trimmingCharacters(in: .whitespaces).isEmpty {
                    HStack(alignment: .center, spacing: 8) {
                        // Character message thumbnail (~36x36)
                        Image(character.messageImageName)
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)

                        // Hint text — SF Pro Rounded, 700 weight (bold), 10pt, accent color
                        Text(hintText)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(accentColor)
                    }
                    .position(x: hintXPosition, y: 592)
                }

                // MARK: - Next button (bottom-right, appears when task has text)
                if !taskText.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button(action: createReminder) {
                        Image("ic_Next")
                            .resizable()
                            .interpolation(.high)
                            .frame(width: 48, height: 48)
                    }
                    .buttonStyle(.plain)
                    .position(x: 1112 + 24, y: 568 + 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.3), location: 0),
                            .init(color: .black.opacity(0.3), location: 0.17),
                            .init(color: .black.opacity(0.3), location: 0.80),
                            .init(color: .white.opacity(0.3), location: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .onAppear {
            // Set per-character default date
            if character == .redPanda {
                selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            }
            // Set per-character default time
            var timeComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            switch character {
            case .dog:
                timeComponents.hour = 10
                timeComponents.minute = 0
            case .cat:
                timeComponents.hour = 18
                timeComponents.minute = 0
            case .redPanda:
                timeComponents.hour = 11
                timeComponents.minute = 30
            }
            selectedTime = Calendar.current.date(from: timeComponents) ?? selectedTime
        }
    }

    // MARK: - Hint X position varies per character (from Figma)

    private var hintXPosition: CGFloat {
        switch character {
        case .dog:      return 1040
        case .cat:      return 1030
        case .redPanda: return 1050
        }
    }

    // MARK: - Date/Time formatting

    private var dayString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "Today"
        } else if calendar.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            return formatter.string(from: selectedDate)
        }
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: selectedTime)
    }

    // MARK: - Actions

    private func createReminder() {
        let reminder = Reminder(
            category: .custom,
            customTitle: taskText,
            intervalMinutes: 60,
            isEnabled: true,
            scheduledFireDate: reminderDate
        )
        onReminderCreated(reminder)
    }
}

