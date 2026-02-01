import SwiftUI

struct FirstReminderView: View {
    let character: PetCharacter
    let onReminderCreated: (Reminder) -> Void
    let onClose: () -> Void
    
    @State private var taskText: String = "Drink Water"
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
    
    var body: some View {
        ZStack {
            // Character-specific dark gradient background
            characterGradient
                .ignoresSafeArea()
            
            VStack {
                // Top bar with buttons
                HStack {
                    // Green dot button (top-left)
                    Button(action: {
                        createReminder()
                    }) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                    }
                    .buttonStyle(.plain)
                    .help("Create reminder")
                    
                    Spacer()
                    
                    // Close (X) button (top-right)
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .help("Close")
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                Spacer()
                
                // Main reminder text
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hey \(character.displayName),")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        Text("Remind me to ")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // Editable task field
                        TextField("", text: $taskText)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .focused($isTaskFieldFocused)
                            .frame(minWidth: 200)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(height: 3)
                                    .offset(y: 4)
                            )
                    }
                    
                    HStack(spacing: 0) {
                        // Tappable day field
                        Button(action: {
                            showDatePicker = true
                        }) {
                            HStack(spacing: 4) {
                                Text(dayString)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(height: 3)
                                    .offset(y: 4)
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Text(" at ")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // Tappable time field
                        Button(action: {
                            showTimePicker = true
                        }) {
                            Text(timeString)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .overlay(
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(height: 3)
                                        .offset(y: 4)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Pet icon with speech bubble (bottom-right)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        // Speech bubble
                        Text("Add what you want me to remind you about in the white text.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.white)
                            )
                            .overlay(
                                // Speech bubble tail
                                Triangle()
                                    .fill(Color.white)
                                    .frame(width: 12, height: 12)
                                    .offset(x: -20, y: 20)
                            )
                        
                        // Pet icon
                        Image(nsImage: character.idleIcon)
                            .resizable()
                            .interpolation(.high)
                            .frame(width: 60, height: 60)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    // MARK: - Character-specific dark gradients
    
    private var characterGradient: LinearGradient {
        switch character {
        case .dog: // Blue
            return LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.1, blue: 0.25),  // Deep navy
                    Color(red: 0.1, green: 0.15, blue: 0.3)     // Darker blue
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .cat: // Budgie
            return LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.12, blue: 0.08),    // Dark brown
                    Color(red: 0.15, green: 0.1, blue: 0.05)      // Amber/black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .redPanda: // Pabu
            return LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.2, blue: 0.15),    // Dark green
                    Color(red: 0.08, green: 0.25, blue: 0.18)    // Darker green
                ],
                startPoint: .top,
                endPoint: .bottom
            )
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

