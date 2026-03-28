# Carbon 🌍

**Carbon** is a personal carbon-footprint tracker built entirely in **Swift Playgrounds** for the **Swift Student Challenge**. It helps you understand, reduce, and share your environmental impact through beautiful, data-driven insights.

> Climate change is the defining challenge of our generation, yet most people have no idea how much CO₂ their daily choices produce. Carbon makes the invisible visible.

---

## Screenshots

<!-- Add your screenshots here -->
<!-- Example: -->
<!-- | Home | Products | History | Journal | -->
<!-- |:---:|:---:|:---:|:---:| -->
<!-- | ![Home](screenshots/home.png) | ![Products](screenshots/products.png) | ![History](screenshots/history.png) | ![Journal](screenshots/journal.png) | -->

---

## Features

### 🏠 Dashboard
The home screen provides a real-time overview of your carbon footprint with:
- **Today's Impact Card** — tap to drill into a detailed breakdown showing your CO₂ expressed as relatable equivalents (km driven, trees needed, smartphone charges, hours of LED light)
- **Quick Actions** — one-tap access to Log, Set Goal, Tips, and Share
- **Streak Tracker** — current and longest consecutive logging streaks
- **Contribution Graph** — a GitHub-style 91-day activity heatmap showing your logging consistency
- **Weekly Bar Chart** — visualise CO₂ trends over the past 7 days
- **Recent Activity Feed** — scrollable log of your latest entries grouped by date

### 📊 Emission Logging
A guided 3-step flow to log emissions across **4 categories**:

| Category | Subcategories | Example Factors |
|---|---|---|
| 🚗 **Travel** | Car, Bus, Train, Flight, Bike, Motorcycle | Car: 0.21 kg/km · Flight: 0.255 kg/km |
| 🍽️ **Food** | Beef, Chicken, Fish, Dairy, Vegetables, Rice | Beef: 60 kg/kg · Vegetables: 2.0 kg/kg |
| ⚡ **Energy** | Electricity, Natural Gas, Heating Oil, Water | Electricity: 0.42 kg/kWh |
| 🛒 **Shopping** | Clothing, Electronics, Furniture, Groceries | Electronics: 70 kg/item |

All emission factors are sourced from DEFRA, EPA, and IEA datasets.

### 🔍 Product Lookup
Search a built-in database of **30+ everyday products** to instantly check their carbon footprint:
- Products span beverages, dairy, meat, snacks, household, clothing, energy, and transport
- Each product shows a **1–5 impact rating** with color-coded labels (Very Low → Very High)
- Actionable eco-tips per product (e.g., *"Switch to oat milk to cut carbon by 60%"*)
- One-tap logging — add any product directly to your emission log

### 📈 History & Analytics
Deep-dive into your emission data with flexible time-period filtering:
- **Segmented Picker** — toggle between Today, This Week, and This Month
- **Bar Charts** — hourly (today), daily (week), or weekly (month) breakdowns
- **Category Breakdown** — proportional bars for Travel, Food, Energy, and Shopping
- **Activity Log** — chronological list of all entries for the selected period

### 🌿 Eco-Tips
Personalised, research-backed tips tailored to your highest-emission category:
- **20 tips** across all 4 categories with annual savings estimates
- **CO₂ Analysis** — daily average vs. global average comparison
- **Category Breakdown** — visual bars showing where your emissions concentrate
- **Potential Savings** — aggregated annual CO₂ you could save
- All tips cited from **IEA, UNEP, Nature, EPA**, and peer-reviewed research

### 📓 Gratitude Journal
Celebrate your eco-friendly choices with daily reflections:
- **Daily Quote** — rotating inspirational quotes that change each day of the year
- **Impact Tracking** — log entries with estimated kg CO₂ saved
- **Journey Timeline** — a scrollable timeline of your eco-actions with emoji, dates, and impact badges

### ✨ Shareable Stats Card
A premium card you can share on social media:
- **3D tilt effect** — interactive drag-to-tilt with spring physics
- **Moving green glow** — radial gradient that follows your finger
- Displays monthly total, today, weekly, streak, daily average, and top category
- **ImageRenderer** export at 3× resolution for crisp sharing
- One-tap share via the system share sheet

### 🎬 Onboarding
A 5-page animated walkthrough introducing all features:
- **Blur-letter title animations** powered by AnimateText
- Swipe gesture navigation with spring-animated page dots
- Pages: Welcome → Track Everything → Explore Products → Grow Your Streak → Share Your Impact

### 🎯 Daily Goal
Set a personal daily CO₂ goal and track your progress:
- Slider + preset buttons (5, 8, 10, 15, 20 kg)
- **Country comparison** — see how your goal stacks up against India, World, EU, and US averages (Our World in Data, 2022)
- **Impact equivalents** — km driven, trees needed, smartphone charges, km flown

---

## Architecture

```
Carbon.swiftpm/
├── MyApp.swift                        # App entry point
├── ContentView.swift                  # Onboarding gate + tab routing
│                                      # iOS 26+ → native TabView (Liquid Glass)
│                                      # iOS < 26 → custom tab bar
├── Components/
│   ├── AppColors.swift                # Shared colour palette
│   ├── BackgroundView.swift           # Animated radial-gradient background
│   ├── CustomTabBar.swift             # Tab bar with central "Add" button
│   ├── GlassmorphicCard.swift         # Reusable frosted-glass card
│   ├── NativeTabBarEnvironment.swift  # Environment key for tab bar mode
│   ├── ProgressiveBlur.swift          # Gradient blur overlays
│   └── SegmentedPicker.swift          # Custom segmented control
├── Models/
│   ├── EmissionModel.swift            # Categories, entries, store + statistics
│   ├── JournalModel.swift             # Journal entries + persistence
│   ├── ProductDatabase.swift          # 30+ products with emission data
│   └── TipStore.swift                 # 20 eco-tips with sources
└── Views/
    ├── Home/
    │   ├── HomeScreenView.swift       # Main dashboard
    │   ├── HomeComponents.swift       # Header, impact card, streak, charts
    │   ├── TrackerCards.swift          # Goal and weekly chart cards
    │   ├── AddEmissionView.swift      # 3-step emission logging flow
    │   ├── EmissionInput.swift        # Quantity input + calculation
    │   ├── EmissionPickers.swift      # Category & subcategory pickers
    │   ├── ImpactDetailView.swift     # Detailed impact breakdown
    │   └── ShareableStatsCard.swift   # 3D interactive share card
    ├── Products/
    │   ├── ProductLookupView.swift    # Search + browse products
    │   ├── ProductComponents.swift    # List rows, tip rows
    │   └── ProductResultView.swift    # Detailed product result
    ├── History/
    │   ├── HistoryView.swift          # Analytics dashboard
    │   ├── BarChartCard.swift         # Animated bar charts
    │   ├── CategoryBreakdownCard.swift# Proportional category bars
    │   ├── ContributionGraphView.swift# GitHub-style heatmap
    │   └── HistoryComponents.swift    # Entry rows, period cards
    ├── Journal/
    │   ├── JournalView.swift          # Journal + daily quote
    │   └── AddJournalEntryView.swift  # New entry form
    ├── Tips/
    │   ├── EcoTipsView.swift          # Personalised tip feed
    │   └── TipCard.swift              # Individual tip card
    └── Onboarding/
        ├── OnboardingView.swift       # 5-page walkthrough
        └── OnboardingBackground.swift # Animated background
```

### Data Flow

```
ContentView (@StateObject)
├── EmissionStore ──→ UserDefaults (JSON)
│   ├── entries: [EmissionEntry]
│   ├── Computed: todayTotal, weeklyTotal, monthlyTotal
│   ├── Charts: todayHourlyData(), weeklyDailyData(), monthlyWeeklyData()
│   ├── Breakdown: categoryBreakdown(since:)
│   ├── Activity: activityGrid(days:), currentStreak, longestStreak
│   └── Filtering: entries(forPeriod:)
│
└── GratitudeStore ──→ UserDefaults (JSON)
    ├── entries: [GratitudeEntry]
    ├── totalEntries, totalImpactSaved
    └── formattedDate per entry
```

Both stores persist to `UserDefaults` using `Codable` JSON encoding. Statistics (streaks, totals, chart data) are computed properties — no redundant storage.

### iOS Version Adaptivity

Carbon automatically adapts its tab bar to the running iOS version:

| iOS Version | Tab Bar Style |
|---|---|
| **iOS 26+** | Native `TabView` with **Liquid Glass** styling |
| **iOS 18.1 – 25** | Custom `CustomTabBar` with central "Add" button |

This is controlled via a `useNativeTabBar` environment key that suppresses the custom tab bar when the native one is active.

---

## Design Language

- **Dark mode only** — deep green/black gradients throughout
- **Glassmorphism** — frosted-glass cards with `Color.white.opacity(0.1)` fill and subtle border strokes
- **Green accent** — `#00CC66` as the primary accent color
- **Spring animations** — `.spring(response: 0.4, dampingFraction: 0.75)` on all interactive elements
- **Progressive blur** — gradient blur overlays at screen edges for seamless content fading
- **3D effects** — `rotation3DEffect` with interactive spring physics on the shareable card
- **Typography** — system font with rounded design variant for numerics

---

## Dependencies

| Package | Purpose |
|---|---|
| [AnimateText](https://github.com/jasudev/AnimateText) | Blur-letter animation on onboarding titles |

---

## Requirements

- **iOS 18.1+**
- **Swift Playgrounds 4** on iPad/Mac, or **Xcode 16+**

## Running

1. Open `Carbon.swiftpm` in **Swift Playgrounds** on iPad/Mac, or in **Xcode**
2. Press **Run** ▶️

---

## Data Sources

All emission factors and eco-tips are sourced from published, peer-reviewed, or institutional data:

| Source | Used For |
|---|---|
| DEFRA (UK Gov) | Flight emission factors |
| EPA (US) | Vehicle & tree absorption rates |
| IEA | Transport & energy reports |
| UNEP | Food waste, fashion, plastic reports |
| Our World in Data | Per-capita CO₂ by country |
| Science (Poore & Nemecek, 2018) | Food lifecycle analysis |
| Nature Sustainability | Remote work emission savings |
| European Commission JRC | Heating & thermostat studies |

---

## License

This project was created for the **Apple Swift Student Challenge**.

---

<p align="center">
  <b>🌱 Track your footprint. Shrink your impact. Share the journey.</b>
</p>
