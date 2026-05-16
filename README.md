# RenovateIQ 🏠

A native iOS & iPadOS home renovation planning app built in Swift, designed specifically for UK homeowners.

## Features

**Plan**
- Task checklists grouped by phase (Preparation, Build, Finishing)
- Custom task creation
- Progress tracking
- 8 UK room types (Kitchen, Main Bathroom, Ensuite, Living Room, Bedroom, Home Office, Garden, Other)

**Budget**
- Set your own budget and track expenses
- UK market cost estimates per room type
- Estimate vs actual comparison
- Quality level selector (Budget, Standard, Premium)
- UK-specific budget tips

**Photos**
- Before & after photo documentation
- Drag slider to reveal transformations
- Photo grid organised by Before/After

**Projects**
- Multiple renovation projects (Pro)
- Rich project cards with photos, progress rings and budget bars

**Widget**
- Home screen widget showing current project progress and next task

**Pro Features (£3.99 one-time purchase)**
- Unlimited projects
- Expense tracking
- Before & after slider
- Custom tasks
- Home screen widget

## Tech Stack

- Swift & SwiftUI
- WidgetKit
- StoreKit 2
- UserDefaults with App Groups for widget data sharing
- PhotosUI

## Requirements

- iOS 17+
- iPadOS 17+
- Xcode 16+

## Installation

1. Clone the repo
2. Open `RenovateIQ.xcodeproj` in Xcode
3. Add your own Apple Developer team under Signing & Capabilities
4. Update the App Group ID to match your own (`group.com.yourname.renovateiq`)
5. Replace the StoreKit Product ID in `StoreKitManager.swift`
6. Build and run

## Privacy

RenovateIQ does not collect any user data. All data is stored locally on device. See [Privacy Policy](https://tasty-dash-858.notion.site/Privacy-Policy-RenovateIQ-3618bcb4c20e806496f5ee567caba1a8).

## Developer

Joanna Gillan

## License

All rights reserved. This project is not open source.
