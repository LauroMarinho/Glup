//
//  RemindersView.swift
//  Glup Watch App
//
//  Created by Lauro Marinho on 10/09/25.
//


import SwiftUI

extension Color {
    static let appBlue = Color.blue // azul padrão do app
}

struct BlueToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button {
                configuration.isOn.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(configuration.isOn ? Color.appBlue : Color.gray.opacity(0.4))
                    .frame(width: 51, height: 31)
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 27, height: 27)
                            .offset(x: configuration.isOn ? 10 : -10)
                            .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

struct StyleSelector: View {
    @Binding var selection: Int
    private let items: [(title: String, system: String, tag: Int)] = [
        ("Som", "speaker.wave.2.fill", 0),
        ("Vibração", "iphone.radiowaves.left.and.right", 1),
        ("Silencioso", "speaker.slash.fill", 2)
    ]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.tag) { item in
                let isSelected = selection == item.tag
                Button {
                    selection = item.tag
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: item.system)
                            .imageScale(.medium)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .fill(isSelected ? Color.appBlue : Color.appBlue.opacity(0.12))
                    )
                    .foregroundColor(isSelected ? .white : .appBlue)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct RemindersView: View {
    @AppStorage("reminderEnabled") private var enabled = true
    @AppStorage("reminderStyle") private var style = 1 // 0 som, 1 vibração, 2 silencioso
    @AppStorage("reminderEveryMinutes") private var every = 60 // 0 = janela personalizada
    @AppStorage("windowStartHour") private var startH = 8
    @AppStorage("windowEndHour") private var endH = 22
    
    var body: some View {
        Form {
            Section {
                Toggle("Ativar lembretes", isOn: $enabled)
                    .toggleStyle(BlueToggleStyle())
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notificação")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    StyleSelector(selection: $style)
                }
                
                Picker("Frequência", selection: $every) {
                    Text("A cada 1h").tag(60)
                    Text("A cada 2h").tag(120)
                    Text("Janela personalizada").tag(0)
                }
                
                if every == 0 {
                    Stepper(value: $startH, in: 0...23) {
                        Text("Início: \(startH)h")
                            .font(.system(size: 17))
                    }
                    .controlSize(.mini)

                    Stepper(value: $endH, in: 0...23) {
                        Text("Fim: \(endH)h")
                            .font(.system(size: 17))
                    }
                    .controlSize(.mini)
                }
                
                Button("Salvar e programar") {
                    // aqui chamaria ReminderScheduler para agendar as notificações
                    WKInterfaceDevice.current().play(.success)
                }
                .buttonStyle(.borderedProminent)
                .tint(.appBlue)
                .listRowBackground(Color.clear)
                
            } header: {
                Text("Lembretes")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.appBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}


#Preview {
    RemindersView()
}
