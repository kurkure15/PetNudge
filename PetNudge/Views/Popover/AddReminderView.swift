import SwiftUI

struct AddReminderView: View {
    @EnvironmentObject var viewModel: PetNudgeViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedCategory: ReminderCategory = .hydration
    @State private var customTitle: String = ""
    @State private var intervalMinutes: Int = 30

    var body: some View {
        VStack(spacing: 20) {
            Text("New Reminder")
                .font(.headline)
                .padding(.top, 16)

            Picker("Type", selection: $selectedCategory) {
                ForEach(ReminderCategory.allCases) { category in
                    HStack {
                        Text(category.emoji)
                        Text(category.displayName)
                    }
                    .tag(category)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedCategory) { _, newValue in
                intervalMinutes = newValue.defaultIntervalMinutes
            }

            if selectedCategory == .custom {
                TextField("Reminder title", text: $customTitle)
                    .textFieldStyle(.roundedBorder)
            }

            Stepper("Every \(intervalMinutes) minutes",
                    value: $intervalMinutes,
                    in: 5...480,
                    step: 5)

            Spacer()

            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Add") {
                    let reminder = Reminder(
                        category: selectedCategory,
                        customTitle: selectedCategory == .custom ? customTitle : nil,
                        intervalMinutes: intervalMinutes
                    )
                    viewModel.addReminder(reminder)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(selectedCategory == .custom && customTitle.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 300, height: 280)
    }
}
