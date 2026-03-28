//
//  JournalModel.swift
//  carbon
//
//  Created by Vedant Vijay on 12/02/26.
//

import Foundation

struct GratitudeEntry: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var impact: Double
    var description: String
    var emoji: String
    
    // Static formatters to avoid memory/CPU overhead on each evaluation
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var formattedDate: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            return Self.dateFormatter.string(from: date)
        }
    }
}

class GratitudeStore: ObservableObject {
    @Published var entries: [GratitudeEntry] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func add(entry: GratitudeEntry) {
        entries.insert(entry, at: 0)
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "GratitudeEntries")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "GratitudeEntries"),
           let decoded = try? JSONDecoder().decode([GratitudeEntry].self, from: data) {
            entries = decoded
        } else {
            // Default mock data to show journey initially
            entries = [
                GratitudeEntry(date: Date(), impact: 3.2, description: "Chose to bike instead of driving today. Fresh air and exercise!", emoji: "🚴"),
                GratitudeEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, impact: 2.1, description: "Went to the farmer's market and got locally sourced food.", emoji: "🥬")
            ]
        }
    }
    
    var totalEntries: Int {
        entries.count
    }
    
    var totalImpactSaved: Double {
        entries.reduce(0) { $0 + $1.impact }
    }
}
