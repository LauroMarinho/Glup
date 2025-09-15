//
//  GoalView.swift
//  Glup Watch App
//
//  Created by Lauro Marinho on 10/09/25.
//

import SwiftUI

struct GoalView: View {
    // Persistência simples no relógio
    @AppStorage("dailyGoalML") private var savedGoal: Int = 200
    @State private var goal: Double = 200

    private let minGoal: Double = 200
    private let maxGoal: Double = 8000
    private let step: Double = 200

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // Topo: título à esquerda e valor à direita
                HStack(alignment: .firstTextBaseline) {
                    Text("META")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.appBlue)
                    Spacer()
                    Text("\(Int(goal))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                // Anel de progresso com texto central
                ZStack {
                    RingBackground()
                    RingProgress(progress: goal / maxGoal)
                    VStack(spacing: 2) {
                        Text("Meta\ndiária")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                        Text("\(Int(goal)) ml")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
                .frame(width: 120, height: 120)
                .padding(.top, 4)

                // Slider fino arrastável
                ZStack {
                    Slider(value: $goal, in: minGoal...maxGoal, step: step)
                        .tint(.appBlue)
                        .padding(.horizontal, 16)
                }
                .frame(height: 44)

                // Botão de salvar
                Button("Salvar") {
                    savedGoal = Int(goal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.appBlue)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.vertical, 8)
                .padding(.bottom, 10)
            }
            .padding(.horizontal)
        }
        .onAppear { goal = Double(savedGoal) }
    }
}

// MARK: - Componentes do anel
private struct RingBackground: View {
    var body: some View {
        Circle()
            .trim(from: 0.08, to: 0.92)
            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
            .foregroundColor(Color.appBlue.opacity(0.25))
            .rotationEffect(.degrees(90))
    }
}

private struct RingProgress: View {
    let progress: Double // 0..1
    var body: some View {
        Circle()
            .trim(from: 0.08 + 0.84 * (1 - progress), to: 0.92)
            .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
            .foregroundStyle(AngularGradient(gradient: Gradient(colors: [Color.appBlue.opacity(0.7), Color.appBlue]), center: .center))
            .rotationEffect(.degrees(90))
            .animation(Animation.easeInOut(duration: 0.25), value: progress)
    }
}

#Preview {
    GoalView()
}
