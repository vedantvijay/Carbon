//
//  ProductDatabase.swift
//  carbon
//
//  Created by Vedant Vijay on 10/02/26.
//

import Foundation



struct ScannedProduct: Identifiable {
    let id = UUID()
    let barcode: String
    let name: String
    let brand: String
    let emoji: String
    let category: EmissionCategory
    let carbonKg: Double        // kg CO₂ per unit
    let unit: String            // "item", "bottle", "kg", etc.
    let tip: String             // eco-friendly alternative tip
    
    /// Formatted carbon value
    var formattedCarbon: String {
        if carbonKg < 1 {
            return String(format: "%.0f g", carbonKg * 1000)
        }
        return String(format: "%.1f kg", carbonKg)
    }
    
    /// Rating from 1-5 (1 = low carbon, 5 = very high)
    var impactRating: Int {
        switch carbonKg {
        case ..<0.5: return 1
        case 0.5..<2.0: return 2
        case 2.0..<5.0: return 3
        case 5.0..<10.0: return 4
        default: return 5
        }
    }
    
    var impactLabel: String {
        switch impactRating {
        case 1: return "Very Low"
        case 2: return "Low"
        case 3: return "Moderate"
        case 4: return "High"
        default: return "Very High"
        }
    }
    
    var impactColor: String {
        switch impactRating {
        case 1: return "green"
        case 2: return "mint"
        case 3: return "yellow"
        case 4: return "orange"
        default: return "red"
        }
    }
}

// MARK: - Product Database

struct ProductDatabase {
    
    /// Search products by name (for manual lookup)
    static func search(query: String) -> [ScannedProduct] {
        guard !query.isEmpty else { return Array(products.values).sorted { $0.name < $1.name } }
        let q = query.lowercased()
        return products.values
            .filter { $0.name.lowercased().contains(q) || $0.brand.lowercased().contains(q) }
            .sorted { $0.name < $1.name }
    }
    
    /// All products for browsing
    static var allProducts: [ScannedProduct] {
        Array(products.values).sorted { $0.name < $1.name }
    }
    
    // MARK: - Local Database
    // Common products with real-ish barcodes and carbon footprint data
    
    private static let products: [String: ScannedProduct] = {
        let list: [ScannedProduct] = [
            // ---- BEVERAGES ----
            ScannedProduct(barcode: "5449000000996", name: "Coca-Cola (500ml)", brand: "Coca-Cola", emoji: "🥤", category: .food, carbonKg: 0.35, unit: "bottle", tip: "Try tap water with lemon — zero carbon!"),
            ScannedProduct(barcode: "5000112637922", name: "Pepsi (500ml)", brand: "PepsiCo", emoji: "🥤", category: .food, carbonKg: 0.33, unit: "bottle", tip: "Choose a reusable bottle to cut packaging waste"),
            ScannedProduct(barcode: "5060466510036", name: "Oat Milk (1L)", brand: "Oatly", emoji: "🥛", category: .food, carbonKg: 0.3, unit: "carton", tip: "Great choice! Oat milk is one of the lowest-carbon milks"),
            ScannedProduct(barcode: "7613036271851", name: "Nescafé Instant Coffee", brand: "Nestlé", emoji: "☕", category: .food, carbonKg: 0.28, unit: "cup", tip: "Use a reusable mug and avoid single-use pods"),
            ScannedProduct(barcode: "4902430793841", name: "Green Tea Pack", brand: "ITO EN", emoji: "🍵", category: .food, carbonKg: 0.05, unit: "cup", tip: "Excellent low-carbon choice!"),
            ScannedProduct(barcode: "0078000113464", name: "Orange Juice (1L)", brand: "Tropicana", emoji: "🍊", category: .food, carbonKg: 0.7, unit: "carton", tip: "Try eating whole oranges instead — less processing"),
            
            // ---- DAIRY & ALTERNATIVES ----
            ScannedProduct(barcode: "5000295142015", name: "Whole Milk (1L)", brand: "Dairy", emoji: "🥛", category: .food, carbonKg: 1.39, unit: "liter", tip: "Switch to oat or soy milk to cut carbon by 60%"),
            ScannedProduct(barcode: "4007993002581", name: "Greek Yogurt (500g)", brand: "FAGE", emoji: "🍨", category: .food, carbonKg: 1.65, unit: "tub", tip: "Try coconut or soy yogurt for a lower footprint"),
            ScannedProduct(barcode: "5021991941295", name: "Cheddar Cheese (200g)", brand: "Cathedral City", emoji: "🧀", category: .food, carbonKg: 2.72, unit: "block", tip: "Cheese is carbon-intensive — use it as a topping, not a main"),
            ScannedProduct(barcode: "8000500310427", name: "Nutella (400g)", brand: "Ferrero", emoji: "🍫", category: .food, carbonKg: 1.8, unit: "jar", tip: "Palm oil in Nutella drives deforestation — try a palm-free spread"),
            
            // ---- MEAT & PROTEIN ----
            ScannedProduct(barcode: "0000000040112", name: "Chicken Breast (500g)", brand: "Fresh", emoji: "🍗", category: .food, carbonKg: 3.15, unit: "pack", tip: "Chicken is one of the lower-impact meats — good choice"),
            ScannedProduct(barcode: "0000000040211", name: "Ground Beef (500g)", brand: "Fresh", emoji: "🥩", category: .food, carbonKg: 30.0, unit: "pack", tip: "Beef has the highest carbon cost — try a meatless day!"),
            ScannedProduct(barcode: "0000000040310", name: "Salmon Fillet (250g)", brand: "Fresh", emoji: "🐟", category: .food, carbonKg: 2.15, unit: "pack", tip: "Choose sustainably farmed or local catch when possible"),
            ScannedProduct(barcode: "0041220966295", name: "Beyond Burger (2-pack)", brand: "Beyond Meat", emoji: "🌱", category: .food, carbonKg: 1.7, unit: "pack", tip: "plant-based protein — up to 90% less carbon than beef!"),
            ScannedProduct(barcode: "0000000040518", name: "Eggs (12 pack)", brand: "Farm Fresh", emoji: "🥚", category: .food, carbonKg: 2.04, unit: "dozen", tip: "Free-range eggs have a similar footprint but better welfare"),
            
            // ---- SNACKS ----
            ScannedProduct(barcode: "5000159459228", name: "Cadbury Dairy Milk", brand: "Cadbury", emoji: "🍫", category: .food, carbonKg: 0.85, unit: "bar", tip: "Dark chocolate typically has a lower carbon footprint"),
            ScannedProduct(barcode: "5000159484282", name: "Oreo Cookies", brand: "Mondelēz", emoji: "🍪", category: .food, carbonKg: 0.6, unit: "pack", tip: "Bake at home to skip the packaging and transport emissions"),
            ScannedProduct(barcode: "0028400064057", name: "Lay's Potato Chips", brand: "Frito-Lay", emoji: "🥔", category: .food, carbonKg: 0.2, unit: "bag", tip: "Veggie chips from local producers are a greener snack"),
            
            // ---- HOUSEHOLD ----
            ScannedProduct(barcode: "5410041003109", name: "Laundry Detergent (1L)", brand: "Ecover", emoji: "🧴", category: .shopping, carbonKg: 0.7, unit: "bottle", tip: "Wash at 30°C to cut energy use by 40%"),
            ScannedProduct(barcode: "8001090443694", name: "Dish Soap (500ml)", brand: "Fairy", emoji: "🫧", category: .shopping, carbonKg: 0.5, unit: "bottle", tip: "Refill pouches use 70% less plastic than new bottles"),
            ScannedProduct(barcode: "7702018974306", name: "Disposable Razors (5pk)", brand: "Gillette", emoji: "🪒", category: .shopping, carbonKg: 0.35, unit: "pack", tip: "A safety razor eliminates disposable plastic waste entirely"),
            
            // ---- CLOTHING ----
            ScannedProduct(barcode: "0000000080112", name: "Cotton T-Shirt", brand: "Fast Fashion", emoji: "👕", category: .shopping, carbonKg: 8.0, unit: "item", tip: "One cotton tee uses 2,700L of water — buy secondhand!"),
            ScannedProduct(barcode: "0000000080211", name: "Denim Jeans", brand: "Various", emoji: "👖", category: .shopping, carbonKg: 33.4, unit: "item", tip: "Jeans are carbon-heavy — extend their life by washing less"),
            ScannedProduct(barcode: "0000000080310", name: "Polyester Jacket", brand: "Various", emoji: "🧥", category: .shopping, carbonKg: 18.0, unit: "item", tip: "Polyester is made from fossil fuels — look for recycled options"),
            
            // ---- ENERGY & ELECTRONICS ----
            ScannedProduct(barcode: "4549292157000", name: "AA Batteries (4pk)", brand: "Panasonic", emoji: "🔋", category: .energy, carbonKg: 0.58, unit: "pack", tip: "Rechargeable batteries save 30x the carbon over their life"),
            ScannedProduct(barcode: "0000000090112", name: "LED Light Bulb", brand: "Philips", emoji: "💡", category: .energy, carbonKg: 0.3, unit: "bulb", tip: "Great choice! LEDs use 85% less energy than incandescent"),
            ScannedProduct(barcode: "0000000090211", name: "USB-C Charger", brand: "Anker", emoji: "🔌", category: .energy, carbonKg: 1.2, unit: "item", tip: "One universal charger for all devices cuts e-waste"),
            
            // ---- TRANSPORT RELATED ----
            ScannedProduct(barcode: "0000000070112", name: "Gasoline (1 liter)", brand: "Fuel", emoji: "⛽", category: .travel, carbonKg: 2.31, unit: "liter", tip: "Each liter of petrol produces 2.31 kg CO₂ — try cycling!"),
            ScannedProduct(barcode: "0000000070211", name: "Diesel (1 liter)", brand: "Fuel", emoji: "⛽", category: .travel, carbonKg: 2.68, unit: "liter", tip: "Diesel emits more CO₂ per liter — consider an EV"),
        ]
        
        var dict: [String: ScannedProduct] = [:]
        for product in list {
            dict[product.barcode] = product
        }
        return dict
    }()
}
