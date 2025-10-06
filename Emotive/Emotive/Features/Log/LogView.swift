//
//  LogView.swift
//  Emotive
//

import SwiftUI
import CoreData

struct LogView: View {
    // MARK: - Dependencies
    @Environment(\.managedObjectContext) private var viewContext

    // MARK: - UI State
    @State private var selectedEmoji: String? = nil
    @State private var moodScore: Double = 3 // slider works with Double; we’ll cast on save
    @State private var note: String = ""
    @State private var showingToast = false

    // MARK: - Emoji Palette
    private let emojis = ["🤩","😄","🙂","😐","😞","😭","😠","😌"]

    // MARK: - Derived
    private var canSave: Bool { selectedEmoji != nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How are you feeling?")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 8)

                // Emoji Grid
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(emojis, id: \.self) { emoji in
                        Button {
                            selectEmoji(emoji)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke( (selectedEmoji == emoji) ? Color.accentColor : Color.secondary.opacity(0.2),
                                             lineWidth: (selectedEmoji == emoji) ? 2 : 1 )
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill( (selectedEmoji == emoji) ? Color.accentColor.opacity(0.12) : Color.secondary.opacity(0.06) )
                                    )
                                Text(emoji).font(.system(size: 28))
                            }
                            .frame(height: 56)
                        }
                        .accessibilityLabel("Mood \(emoji)")
                    }
                }

                // Slider 1–5 with labels
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Intensity")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(moodScore)) / 5")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                    }
                    Slider(value: $moodScore, in: 1...5, step: 1) {
                        Text("Mood Intensity")
                    } minimumValueLabel: {
                        Text("Low").font(.caption)
                    } maximumValueLabel: {
                        Text("High").font(.caption)
                    }
                    .onChange(of: moodScore) { _, newValue in
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        #if DEBUG
                        print("[DEBUG][Log] Slider changed →", Int(newValue))
                        #endif
                        lightHaptic()
                    }
                }

                // Multiline note
                VStack(alignment: .leading, spacing: 6) {
                    Text("Add a note (optional)")
                        .font(.headline)
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.secondary.opacity(0.06)))
                        TextEditor(text: $note)
                            .frame(minHeight: 120)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .onChange(of: note) { _, newValue in
                                #if DEBUG
                                print("[DEBUG][Log] Note length:", newValue.count)
                                #endif
                            }
                    }
                }

                // Save button
                Button(action: {
                    saveMood()
                }) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(canSave ? Color.accentColor : Color.gray.opacity(0.4))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(!canSave)
                .accessibilityLabel("Save mood entry")
                .padding(.top, 8)
            }
            .padding(16)
        }
        .overlay(alignment: .top) {
            if showingToast {
                ToastView(text: "Saved!")
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
            }
        }
        .animation(.easeInOut, value: showingToast)
        .navigationTitle("Log")
    }

    // MARK: - Actions

    private func selectEmoji(_ emoji: String) {
        selectedEmoji = emoji
        #if DEBUG
        print("[DEBUG][Log] Emoji selected:", emoji)
        #endif
        lightHaptic()
    }

    private func saveMood() {
        guard let emoji = selectedEmoji else { return }

        do {
            // If you used "Class Definition" codegen, this type exists at build time.
            let entry = MoodEntry(context: viewContext)
            entry.id = UUID()
            entry.createdAt = Date()
            entry.moodScore = Int16(moodScore)  // attribute name must match your model
            entry.emoji = emoji
            entry.note = note.isEmpty ? nil : note

            try viewContext.save()

            #if DEBUG
            print("[DEBUG][Log] Saved entry:", [
                "id": entry.id?.uuidString ?? "nil",
                "emoji": emoji,
                "score": Int(moodScore),
                "noteLen": note.count
            ])
            #endif

            // Reset form
            selectedEmoji = nil
            moodScore = 3
            note = ""
            successHaptic()
            showToastBriefly()
        } catch {
            #if DEBUG
            print("[DEBUG][Log][ERROR] Save failed:", error.localizedDescription)
            #endif
        }
    }

    // MARK: - Toast

    private func showToastBriefly() {
        showingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showingToast = false
        }
    }

    // MARK: - Haptics

    private func lightHaptic() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func successHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

// Simple inline toast view
private struct ToastView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline).bold()
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(.thinMaterial, in: Capsule())
            .shadow(radius: 2, y: 1)
    }
}

#Preview {
    // If you want a live Core Data preview, inject the preview context:
    // LogView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    LogView()
}
