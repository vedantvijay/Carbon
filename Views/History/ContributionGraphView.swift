//
//  ContributionGraphView.swift
//  carbon
//
//  Created by Vedant Vijay on 14/02/26.
//

import SwiftUI

// MARK: - Contribution Graph View

struct ContributionGraphView: View {
    @ObservedObject var emissionStore: EmissionStore
    
    private let accentGreen = AppColors.accent
    private let cellSpacing: CGFloat = 3
    private let maxCellSize: CGFloat = 16
    
    private var grid: [(date: Date, count: Int)] {
        emissionStore.activityGrid(days: 91)
    }
    
    private var totalWeeks: Int {
        (grid.count + 6) / 7
    }
    
    private var maxCount: Int {
        max(grid.filter { $0.count > 0 }.map(\.count).max() ?? 1, 1)
    }
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                headerSection
                
                if emissionStore.totalActiveDays == 0 {
                    emptyState
                } else {
                    gridSection
                    legendRow
                }
                
                statsRow
            }
            .padding(20)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "square.grid.3x3.fill")
                        .foregroundColor(accentGreen)
                        .font(.system(size: 16))
                    Text("Consistency")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("\(emissionStore.totalActiveDays) active days • last 3 months")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 14))
                Text("\(emissionStore.currentStreak)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.orange.opacity(0.15)))
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 10) {
            Text("🌿")
                .font(.system(size: 36))
            Text("No activity yet")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            Text("Log your first emission to start\nbuilding your consistency graph")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
    
    // MARK: - Grid Section
    
    private var gridSection: some View {
        GeometryReader { geo in
            let dayLabelWidth: CGFloat = 28
            let labelPadding: CGFloat = 6
            let availableWidth = geo.size.width - dayLabelWidth - labelPadding
            let rawCellSize = (availableWidth - CGFloat(totalWeeks - 1) * cellSpacing) / CGFloat(totalWeeks)
            let cellSize = min(max(rawCellSize, 6), maxCellSize)
            let rowHeight = cellSize + cellSpacing
            
            VStack(alignment: .leading, spacing: 2) {
                // Month labels row
                monthLabelsRow(cellSize: cellSize, dayLabelWidth: dayLabelWidth + labelPadding)
                
                // Grid + day labels
                HStack(alignment: .top, spacing: 0) {
                    // Day labels (Sun–Sat, only show Mon/Wed/Fri)
                    dayLabelsColumn(rowHeight: rowHeight, width: dayLabelWidth, padding: labelPadding)
                    
                    // Grid cells
                    gridCells(cellSize: cellSize)
                }
            }
        }
        .frame(height: adaptiveGridHeight)
    }
    
    // MARK: - Month Labels
    
    private func monthLabelsRow(cellSize: CGFloat, dayLabelWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Color.clear.frame(width: dayLabelWidth, height: 14)
            
            HStack(spacing: cellSpacing) {
                ForEach(0..<totalWeeks, id: \.self) { week in
                    let index = week * 7
                    if index < grid.count {
                        let date = grid[index].date
                        let day = Calendar.current.component(.day, from: date)
                        
                        if day <= 7 {
                            Text(monthShortName(from: date))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(width: cellSize, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .allowsTightening(true)
                                .minimumScaleFactor(0.7)
                        } else {
                            Color.clear.frame(width: cellSize, height: 1)
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
    }
    
    // MARK: - Day Labels
    
    private func dayLabelsColumn(rowHeight: CGFloat, width: CGFloat, padding: CGFloat) -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(0..<7, id: \.self) { row in
                Group {
                    if row == 1 {
                        Text("Mon")
                    } else if row == 3 {
                        Text("Wed")
                    } else if row == 5 {
                        Text("Fri")
                    } else {
                        Text("")
                    }
                }
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.4))
                .frame(height: rowHeight)
            }
        }
        .frame(width: width)
        .padding(.trailing, padding)
    }
    
    // MARK: - Grid Cells
    
    private func gridCells(cellSize: CGFloat) -> some View {
        HStack(alignment: .top, spacing: cellSpacing) {
            ForEach(0..<totalWeeks, id: \.self) { week in
                VStack(spacing: cellSpacing) {
                    ForEach(0..<7, id: \.self) { day in
                        let index = week * 7 + day
                        if index < grid.count {
                            let entry = grid[index]
                            if entry.count == -1 {
                                // Padding cell
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color.clear)
                                    .frame(width: cellSize, height: cellSize)
                            } else {
                                let isToday = Calendar.current.isDateInToday(entry.date)
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(colorForCount(entry.count))
                                    .frame(width: cellSize, height: cellSize)
                                    .overlay(
                                        isToday ?
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                        : nil
                                    )
                            }
                        } else {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.clear)
                                .frame(width: cellSize, height: cellSize)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Legend
    
    private var legendRow: some View {
        HStack(spacing: 8) {
            Spacer()
            Text("Less")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
            ForEach(0..<5) { level in
                RoundedRectangle(cornerRadius: 2)
                    .fill(legendColor(for: level))
                    .frame(width: 11, height: 11)
            }
            Text("More")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
        }
    }
    
    // MARK: - Stats Row
    
    private var statsRow: some View {
        HStack(spacing: 0) {
            StatPill(
                icon: "flame.fill",
                iconColor: .orange,
                label: "Current",
                value: "\(emissionStore.currentStreak) days"
            )
            
            Spacer()
            
            StatPill(
                icon: "trophy.fill",
                iconColor: .yellow,
                label: "Longest",
                value: "\(emissionStore.longestStreak) days"
            )
            
            Spacer()
            
            StatPill(
                icon: "calendar",
                iconColor: accentGreen,
                label: "Total",
                value: "\(emissionStore.totalActiveDays) days"
            )
        }
    }
    
    // MARK: - Helpers
    
    /// Adaptive height based on cell size cap
    private var adaptiveGridHeight: CGFloat {
        let cellSize = min(maxCellSize, 14.0) // conservative estimate
        let rowHeight = cellSize + cellSpacing
        return 14 + 2 + 7 * rowHeight // month label + spacing + 7 rows
    }
    
    private func monthShortName(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMMM"  // Single letter: J, F, M, A, etc.
        return f.string(from: date)
    }
    
    private func colorForCount(_ count: Int) -> Color {
        guard count > 0 else { return Color.white.opacity(0.06) }
        let ratio = Double(count) / Double(maxCount)
        if ratio <= 0.25 { return accentGreen.opacity(0.25) }
        if ratio <= 0.5 { return accentGreen.opacity(0.45) }
        if ratio <= 0.75 { return accentGreen.opacity(0.7) }
        return accentGreen
    }
    
    private func legendColor(for level: Int) -> Color {
        switch level {
        case 0: return Color.white.opacity(0.06)
        case 1: return accentGreen.opacity(0.25)
        case 2: return accentGreen.opacity(0.45)
        case 3: return accentGreen.opacity(0.7)
        default: return accentGreen
        }
    }
}

// MARK: - Stat Pill

struct StatPill: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 14))
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ContributionGraphView(emissionStore: EmissionStore())
            .padding()
    }
}
