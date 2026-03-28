//
//  TipStore.swift
//  carbon
//
//  Created by Vedant Vijay on 11/02/26.
//

import SwiftUI

struct EcoTip: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let detail: String
    let impact: String
    let source: String
    let category: EmissionCategory
    let annualSavingsKg: Double
}

class TipStore: ObservableObject {
    let tips: [EcoTip] = [
        // Travel
        .init(emoji: "🚲", title: "Cycle Short Trips",
              detail: "Replace car trips under 5 km with cycling. Short trips account for over 50% of all car journeys but produce disproportionate emissions due to cold-start engine inefficiency.",
              impact: "Saves ~0.9 kg CO₂ per trip", source: "European Cyclists' Federation, 2021",
              category: .travel, annualSavingsKg: 600),
        .init(emoji: "🚆", title: "Train Over Plane",
              detail: "A train journey produces 80–90% less CO₂ per passenger-km than flying. For trips under 700 km, high-speed rail is often comparable in total travel time.",
              impact: "Saves ~0.2 kg CO₂ per km", source: "IEA Transport Report, 2023",
              category: .travel, annualSavingsKg: 1200),
        .init(emoji: "🚗", title: "Eco-Driving Techniques",
              detail: "Smooth acceleration, maintaining steady speed, and anticipating traffic flow can reduce fuel consumption by 15–20%. Keep tires properly inflated for another 3% savings.",
              impact: "Saves ~15% fuel per drive", source: "UNECE Eco-driving Guidelines, 2022",
              category: .travel, annualSavingsKg: 300),
        .init(emoji: "🏠", title: "Work From Home",
              detail: "Each day working from home eliminates an average 8.1 kg CO₂ commute. Even 2 days/week can reduce your annual transport footprint by 20%.",
              impact: "Saves ~8.1 kg CO₂ per day", source: "Nature Sustainability, 2022",
              category: .travel, annualSavingsKg: 840),
        .init(emoji: "🚌", title: "Use Public Transit",
              detail: "Buses emit 2.5x less CO₂ per passenger-km than private cars. A single full bus removes about 40 cars from the road.",
              impact: "Saves ~0.12 kg CO₂ per km", source: "UITP Global Report, 2023",
              category: .travel, annualSavingsKg: 500),
        
        // Food
        .init(emoji: "🥦", title: "One Plant-Based Day",
              detail: "Replacing meat with plant-based meals one day per week reduces food emissions by ~15%. Plant proteins require 6–36x less land and 2–11x less water.",
              impact: "Saves ~3.0 kg CO₂ per week", source: "Science, Poore & Nemecek, 2018",
              category: .food, annualSavingsKg: 156),
        .init(emoji: "🥩", title: "Swap Beef for Chicken",
              detail: "Beef produces 4x more greenhouse gases than chicken per kg. A simple protein swap can dramatically reduce your food footprint without going vegetarian.",
              impact: "Saves ~20 kg CO₂ per kg swapped", source: "Our World in Data, 2023",
              category: .food, annualSavingsKg: 520),
        .init(emoji: "🍳", title: "Reduce Food Waste",
              detail: "8–10% of global emissions come from food waste. Planning meals, using leftovers, and proper storage can cut household waste by up to 50%.",
              impact: "Saves ~1.8 kg CO₂ per week", source: "UNEP Food Waste Index, 2021",
              category: .food, annualSavingsKg: 94),
        .init(emoji: "🌾", title: "Buy Local & Seasonal",
              detail: "Seasonal produce travels shorter distances and needs less energy-intensive greenhouses. Local food cuts transport emissions by 5–17x.",
              impact: "Saves ~0.5 kg CO₂ per shop", source: "Nature Food, Leopold et al., 2022",
              category: .food, annualSavingsKg: 130),
        .init(emoji: "🥛", title: "Try Plant-Based Milk",
              detail: "Producing 1L of dairy milk generates 3x more CO₂ than oat milk and uses 10x more land. Switching your daily latte adds up over a year.",
              impact: "Saves ~0.6 kg CO₂ per litre", source: "Science, Poore & Nemecek, 2018",
              category: .food, annualSavingsKg: 110),
        
        // Energy
        .init(emoji: "💡", title: "Switch to LED Bulbs",
              detail: "LEDs use 75% less electricity than incandescent bulbs and last 25x longer. Replacing 10 bulbs saves about 400 kWh per year.",
              impact: "Saves ~168 kg CO₂ per year", source: "US DOE Energy Star, 2023",
              category: .energy, annualSavingsKg: 168),
        .init(emoji: "🌡️", title: "Lower Thermostat by 1°C",
              detail: "Reducing heating by just 1°C cuts energy use by 6–10%. Wearing a sweater at home is one of the simplest high-impact actions.",
              impact: "Saves ~300 kg CO₂ per year", source: "European Commission, JRC, 2022",
              category: .energy, annualSavingsKg: 300),
        .init(emoji: "🔌", title: "Unplug Standby Devices",
              detail: "Standby power accounts for 5–10% of household electricity. Smart power strips or unplugging chargers eliminates this waste.",
              impact: "Saves ~100 kg CO₂ per year", source: "IEA Standby Power Report, 2022",
              category: .energy, annualSavingsKg: 100),
        .init(emoji: "🧊", title: "Efficient Laundry",
              detail: "Washing at 30°C instead of 60°C uses 57% less energy. Air-drying saves another 2.4 kg CO₂ per load.",
              impact: "Saves ~2.4 kg CO₂ per load", source: "Energy Research & Social Science, 2021",
              category: .energy, annualSavingsKg: 250),
        .init(emoji: "☀️", title: "Use Natural Light",
              detail: "Opening blinds and positioning desks near windows can reduce artificial lighting needs by up to 50% during daytime.",
              impact: "Saves ~80 kg CO₂ per year", source: "Building & Environment Journal, 2022",
              category: .energy, annualSavingsKg: 80),
        
        // Shopping
        .init(emoji: "👕", title: "Buy Fewer, Better Clothes",
              detail: "Fashion produces 10% of global emissions. Buying 5 fewer items per year and choosing quality over quantity makes a big difference.",
              impact: "Saves ~50 kg CO₂ per item avoided", source: "UNEP Fashion Charter, 2023",
              category: .shopping, annualSavingsKg: 250),
        .init(emoji: "📱", title: "Extend Device Lifespan",
              detail: "Manufacturing a smartphone produces ~70 kg CO₂. Using it for 4 years instead of 2 halves the annualized carbon impact.",
              impact: "Saves ~35 kg CO₂ per year", source: "Greenpeace Electronics Report, 2022",
              category: .shopping, annualSavingsKg: 35),
        .init(emoji: "♻️", title: "Choose Refurbished",
              detail: "Refurbished electronics produce 70–80% less CO₂ than new. It also prevents e-waste — 50M tonnes generated globally each year.",
              impact: "Saves ~50 kg CO₂ per device", source: "Circular Economy Action Plan, EU, 2023",
              category: .shopping, annualSavingsKg: 50),
        .init(emoji: "🛍️", title: "Bring Reusable Bags",
              detail: "A single reusable bag replaces 500+ plastic bags over its lifetime.",
              impact: "Saves ~5 kg CO₂ per year", source: "UNEP Single-Use Plastics Report, 2021",
              category: .shopping, annualSavingsKg: 5),
        .init(emoji: "🔧", title: "Repair, Don't Replace",
              detail: "Repairing appliances avoids 50–80% of manufacturing emissions. The 'right to repair' movement is making this easier worldwide.",
              impact: "Saves ~100 kg CO₂ per appliance", source: "EEA Circular Economy Report, 2023",
              category: .shopping, annualSavingsKg: 100),
    ]
    
    func topCategory(for store: EmissionStore) -> EmissionCategory? {
        store.categoryBreakdown(since: 30)
            .max(by: { $0.total < $1.total })?
            .category
    }
    
    func personalizedTips(for store: EmissionStore) -> [EcoTip] {
        guard let top = topCategory(for: store) else {
            return Array(tips.sorted { $0.annualSavingsKg > $1.annualSavingsKg }.prefix(5))
        }
        return tips.filter { $0.category == top }
            .sorted { $0.annualSavingsKg > $1.annualSavingsKg }
    }
}
