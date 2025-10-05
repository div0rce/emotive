//
//  OnboardingView.swift
//  Emotive
//

import SwiftUI

struct OnboardingView: View {
    // Shared preference key used in EmotiveApp
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 0)

            // Headline
            Text("Welcome to Emotive")
                .font(.largeTitle).fontWeight(.bold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            // Subtitle
            Text("Track your moods, visualize trends, and stay mindful.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer(minLength: 0)

            // Primary CTA
            Button {
                // Flip the flag; app root will switch to RootTabView automatically
                withAnimation(.easeInOut) {
                    hasSeenOnboarding = true
                }
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.tint, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.white)
            }
            .accessibilityLabel("Get Started with Emotive")

            // (Optional) Secondary action
            // Button("Learn More") { /* show a sheet later */ }

        }
        .padding(24)
    }
}

#Preview {
    // No Core Data needed in this view; preview is simple
    OnboardingView()
}
