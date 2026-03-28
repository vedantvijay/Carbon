//
//  ProductLookupView.swift
//  carbon
//
//  Created by Vedant Vijay on 16/02/26.
//

import SwiftUI

struct ProductLookupView: View {
    @Binding var selectedTab: Tab
    @Binding var showAddEmission: Bool
    @ObservedObject var emissionStore: EmissionStore
    @Environment(\.useNativeTabBar) private var useNativeTabBar
    
    @State private var searchQuery: String = ""
    @State private var selectedProduct: ScannedProduct? = nil
    
    private let accentGreen = AppColors.accent
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Product Lookup")
                                .font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                            Text("Search products to check carbon impact")
                                .font(.system(size: 16)).foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 20).padding(.horizontal)
                        
                        if let product = selectedProduct {
                            // Show result
                            ScanResultView(
                                product: product,
                                onLogEmission: { logProduct(product) },
                                onScanAgain: { withAnimation { selectedProduct = nil } }
                            )
                            .padding(.horizontal)
                        } else {
                            // Search bar
                            searchBar
                            
                            // Results or browse
                            if searchQuery.isEmpty {
                                browseSection
                            } else {
                                searchResults
                            }
                        }
                        
                        if !useNativeTabBar {
                            Spacer().frame(height: 100)
                        }
                    }
                }
                
                if !useNativeTabBar {
                    CustomTabBar(selectedTab: $selectedTab, onAddTapped: { showAddEmission = true })
                }
            }
            .ignoresSafeArea(edges: useNativeTabBar ? [] : .bottom)
            
            GeometryReader { proxy in
                GradientBlurOverlay(direction: .top)
                    .frame(height: proxy.safeAreaInsets.top)
                    .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundColor(.white.opacity(0.4))
            TextField("Search products…", text: $searchQuery)
                .foregroundColor(.white)
                .autocorrectionDisabled()
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.1)))
        .padding(.horizontal)
    }
    
    // MARK: - Browse
    
    private var browseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Info card
            GlassmorphicCard(cornerRadius: 24) {
                VStack(spacing: 20) {
                    ZStack {
                        Circle().fill(accentGreen.opacity(0.15)).frame(width: 80, height: 80)
                        Image(systemName: "leaf.circle")
                            .font(.system(size: 40, weight: .light)).foregroundColor(accentGreen)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Explore Carbon Footprints")
                            .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                        Text("Search our database to discover the carbon\nimpact of everyday products")
                            .font(.system(size: 14)).foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center).padding(.horizontal, 20)
                    }
                }
                .padding(24).frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            // Popular products
            Text("Popular Products")
                .font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                .padding(.horizontal)
            
            let popular = Array(ProductDatabase.allProducts.prefix(6))
            ForEach(popular) { product in
                Button(action: { withAnimation { selectedProduct = product } }) {
                    ProductListRow(product: product)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }
            
            // Tips card
            GlassmorphicCard(cornerRadius: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill").foregroundColor(.yellow).font(.system(size: 16))
                        Text("Did You Know?").font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                    }
                    TipRow(text: "A single beef burger produces ~3.5 kg of CO₂")
                    TipRow(text: "Flying 1,000 km emits about 150 kg of CO₂ per person")
                    TipRow(text: "Switching to plant milk saves ~0.6 kg CO₂ per litre")
                }
                .padding(20).frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Search Results
    
    private var searchResults: some View {
        VStack(spacing: 10) {
            let results = ProductDatabase.search(query: searchQuery)
            if results.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32)).foregroundColor(.white.opacity(0.3))
                    Text("No products found")
                        .font(.system(size: 16, weight: .medium)).foregroundColor(.white.opacity(0.5))
                    Text("Try a different search term")
                        .font(.system(size: 13)).foregroundColor(.white.opacity(0.35))
                }
                .padding(.top, 40).frame(maxWidth: .infinity)
            } else {
                ForEach(results) { product in
                    Button(action: { withAnimation { selectedProduct = product } }) {
                        ProductListRow(product: product)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func logProduct(_ product: ScannedProduct) {
        emissionStore.add(entry: EmissionEntry(
            category: product.category, subcategoryName: product.name, subcategoryEmoji: product.emoji,
            value: 1.0, unit: product.unit, calculatedKg: product.carbonKg, date: Date(),
            notes: "Product: \(product.name)"
        ))
        withAnimation { selectedProduct = nil }
    }
}
