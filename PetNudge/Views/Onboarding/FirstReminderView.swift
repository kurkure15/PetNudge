import SwiftUI

struct FirstReminderView: View {
    let character: PetCharacter
    let onReminderCreated: (Reminder) -> Void
    let onClose: () -> Void

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
    @FocusState private var isTaskFieldFocused: Bool

    // Default task text per character (from Figma)
    private var defaultTaskText: String {
        switch character {
        case .dog:      return "Drink Water"
        case .cat:      return "Water my Plants"
        case .redPanda: return "Feed my Cat"
        }
    }

    // Default day text per character (from Figma)
    private var defaultDayText: String {
        switch character {
        case .dog:      return "Today"
        case .cat:      return "Today"
        case .redPanda: return "Tomorrow"
        }
    }

    // Default time per character (from Figma)
    private var defaultTimeText: String {
        switch character {
        case .dog:      return "10:00 AM"
        case .cat:      return "06:00 PM"
        case .redPanda: return "11:30 AM"
        }
    }

    // Hint text per character (from Figma)
    private var hintText: String {
        switch character {
        case .dog:
            return "Add what you want to me remind you\nabout in the white text."
        case .cat:
            return "You can ask me to remind you before\n5, 10, or 15 minutes too."
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

            ZStack(alignment: .topLeading) {
                // MARK: - Close button (top-left, 48x48 at 24,24)
                Button(action: onClose) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
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
                VStack(alignment: .leading, spacing: 8) {
                    // "Hey [Name]," — SF Pro, weight 860 (heavy), 20pt
                    Text("Hey \(character.displayName),")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)

                    // "Remind me to [Task]"
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Remind me to")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)

                            // Editable task text — SF Pro, weight 1000 (black), 24pt, accent color
                            TextField("", text: $taskText)
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(accentColor)
                                .focused($isTaskFieldFocused)
                                .textFieldStyle(.plain)
                        }

                        // "[Day] at [Time]"
                        HStack(alignment: .center, spacing: 8) {
                            Button(action: { showDatePicker = true }) {
                                Text(dayString)
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(accentColor)
                            }
                            .buttonStyle(.plain)

                            Text("at")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)

                            Button(action: { showTimePicker = true }) {
                                Text(timeString)
                                    .font(.system(size: 24, weight: .black))
                                    .foregroundColor(accentColor)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(width: 285, alignment: .leading)
                .position(x: 600, y: 303)

                // MARK: - Hint with character thumbnail (bottom-right)
                HStack(alignment: .center, spacing: 8) {
                    // Character thumbnail (~38x37)
                    Image(character.circleImageName)
                        .resizable()
                        .interpolation(.high)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 38, height: 37)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    // Hint text — SF Pro Rounded, 700 weight (bold), 10pt, accent color
                    Text(hintText)
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(accentColor)
                }
                .position(x: hintXPosition, y: 592)
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
            if taskText.isEmpty {
                taskText = defaultTaskText
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $selectedDate,
                isPresented: $showDatePicker
            )
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(
                selectedTime: $selectedTime,
                isPresented: $showTimePicker
            )
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
            formatter.dateFormat = "EEEE"
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
            intervalMinutes: nil,
            isEnabled: true
        )
        onReminderCreated(reminder)
    }
}

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Date")
                .font(.headline)
                .padding(.top)

            DatePicker(
                "Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()

            Button("Done") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Time Picker Sheet

struct TimePickerSheet: View {
    @Binding var selectedTime: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Time")
                .font(.headline)
                .padding(.top)

            DatePicker(
                "Time",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.graphical)
            .padding()

            Button("Done") {
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
        .frame(width: 300, height: 300)
    }
}

// MARK: - Triangle Shape for Speech Bubble

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
