# Flutter Campaign Manager - Feature Overview & Quick Reference

## Executive Summary

A professional Flutter social media campaign management application featuring:
- **5 Main Screens** with tabbed navigation
- **3 Full CRUD Modules** (Campaigns, Clients, Tasks)
- **2 Read-Only Modules** (Analytics, Dashboard)
- **186+ Comprehensive Test Cases**
- **Pre-seeded Sample Data** (4 clients, 5 campaigns, 6 tasks)
- **Clean Architecture** with BLoC state management
- **SQLite Database** with foreign key constraints

---

## Feature Quick Reference

### Module: Campaigns ⭐
**CRUD Operations:** Create, Read (list/filter/detail), Update, Delete
- **List View:** Tabbed filtering (All/Active/Draft/Completed)
- **Detail View:** Metrics cards + engagement chart + campaign info
- **Create/Edit Form:** Client selection, platform, status, dates, budget, reach target
- **Data Fields:** Name, description, client, platform, status, dates, budget, target reach
- **Special Features:** 
  - Status-based filtering (4 statuses: draft, active, paused, completed)
  - Platform selection (5 platforms: Instagram, Facebook, Twitter, YouTube, Multi)
  - Engagement over time visualization
  - Cascading delete to metrics and scheduled posts

### Module: Clients ⭐
**CRUD Operations:** Create, Read (list/search/detail), Update, Delete
- **List View:** Avatar initials + name, company, social icons with real-time search
- **Detail View:** Profile card, contact info, social profiles, recent campaigns (up to 3)
- **Create/Edit Form:** Name, company, email, phone, social handles (Instagram, Facebook, Twitter, YouTube)
- **Data Fields:** Name, company, email, phone, social media handles (4 platforms)
- **Special Features:**
  - Real-time search filtering by name/company
  - Social media profile icons (color-coded)
  - Shows up to 3 client campaigns on detail page
  - Cascading delete removes all associated campaigns

### Module: Tasks ⭐
**CRUD Operations:** Create, Read (all/pending/completed), Update, Delete, Toggle Completion
- **List View:** Checkbox, title, description, priority badge, due date badge, slidable delete
- **Filter Options:** All tasks / Pending only / Completed only
- **Create Dialog:** Title (required), description, priority (4 levels), auto-set due date
- **Data Fields:** Title, description, priority, due date, completion status, campaign (optional)
- **Special Features:**
  - Checkbox to toggle completion status
  - Priority levels (Low, Medium, High, Urgent) with color coding
  - Due date intelligence: Overdue (red), Due Today (orange), Future (gray)
  - Can exist with or without campaign association
  - Strikethrough for completed tasks
  - Slidable delete action

### Module: Dashboard (Read-Only)
**Features:**
- **Time-based Greeting:** Good Morning/Afternoon/Evening
- **Today's Overview Grid (4 metrics):**
  1. Active Clients (count)
  2. Active Campaigns (count)
  3. Pending Tasks (count)
  4. Total Reach (with trend %)
- **Growth Trends Card (3 metrics with +/- indicators):**
  1. Reach Growth %
  2. Engagement Growth %
  3. Followers Growth %
- **Recent Activity Timeline (6 activity types):**
  - Campaign Created / Campaign Completed / Task Completed
  - Client Added / Post Scheduled / Metrics Updated
  - Each with icon, title, subtitle, relative timestamp
- **Pull-to-Refresh & Error Handling**

### Module: Analytics (Read-Only)
**Features:**
- **Performance Overview Cards (2 metrics):**
  1. Average Engagement Rate (%)
  2. Average Click-Through Rate (%)
- **Engagement Trend Chart (Line):** 7-day data grouped by date
- **Reach by Day Chart (Bar):** 7-day data grouped by date
- **Total Metrics Summary Card (7 metrics):**
  - Impressions, Reach, Engagement, Followers Gained
  - Clicks, Shares, Comments
  - All formatted with comma separators
- **Pull-to-Refresh & Error Handling**

---

## Data Model Overview

### Entity Relationships
```
Client (1) ──────has─────→ Campaign (Many)
                             │
                             ├──→ Campaign Metrics (Many)
                             ├──→ Scheduled Posts (Many)
                             └──→ Tasks (can have, via FK)
                             
Task (can reference Campaign or be orphaned)
```

### Core Enums

**CampaignStatusEnum:**
- draft
- active
- paused
- completed

**PlatformEnum:**
- instagram
- facebook
- twitter
- youtube
- multi

**TaskPriority:**
- low
- medium
- high
- urgent

**ActivityType:**
- campaignCreated
- campaignCompleted
- taskCompleted
- clientAdded
- postScheduled
- metricsUpdated

---

## Database Tables (SQLite)

| Table | Rows | Purpose | FK Relationships |
|-------|------|---------|------------------|
| **clients** | Pre-seeded: 4 | Client management | None |
| **campaigns** | Pre-seeded: 5 | Campaign management | client_id (CASCADE) |
| **campaign_metrics** | Pre-seeded: 21 (7 days × 3 campaigns) | Performance tracking | campaign_id (CASCADE) |
| **scheduled_posts** | Pre-seeded: 3 | Content scheduling | campaign_id (CASCADE) |
| **tasks** | Pre-seeded: 6 | Task management | campaign_id (SET NULL) |

### Indexed Columns (Query Performance)
- campaigns.client_id
- campaigns.status
- campaign_metrics.campaign_id
- scheduled_posts.campaign_id
- tasks.priority
- tasks.is_completed

---

## Navigation Structure

```
MainShell (BottomNavigationBar - 5 Tabs, IndexedStack)
│
├─ Tab 1: Dashboard
│  └─ (No sub-navigation, read-only)
│
├─ Tab 2: Campaigns
│  ├─ CampaignDetailsPage
│  │  ├─ AddEditCampaignPage (Edit)
│  │  └─ Delete Dialog
│  └─ AddEditCampaignPage (Create)
│
├─ Tab 3: Clients
│  ├─ ClientDetailsPage
│  │  ├─ AddEditClientPage (Edit)
│  │  └─ Delete Dialog
│  └─ AddEditClientPage (Create)
│
├─ Tab 4: Analytics
│  └─ (No sub-navigation, read-only)
│
└─ Tab 5: Tasks
   ├─ AddTaskDialog (Modal)
   ├─ Delete Action (Slidable)
   └─ Toggle Completion (Checkbox)
```

**Navigation Type:** Material Navigator (Navigator.push/pop), no GoRouter

---

## State Management (BLoC Pattern)

### BLoC Instances (5 Total)
1. **DashboardBloc** - LoadDashboard, RefreshDashboard
2. **CampaignBloc** - Load, Create, Update, Delete, Filter
3. **ClientBloc** - Load, Create, Update, Delete, Search
4. **TaskBloc** - Load, Create, Update, Delete, Toggle Completion
5. **AnalyticsBloc** - LoadAnalytics, LoadCampaignAnalytics

### Common State Patterns
```
Initial → Loading → Success/Error
Success → OperationSuccess (after CRUD)
Error → ErrorView with Retry
```

### Dependency Injection (GetIt Service Locator)
- DatabaseService (singleton)
- All Repositories (singletons)
- All BLoCs (singletons, created with getIt)

---

## Pre-Seeded Test Data

### Clients (4)
| ID | Name | Company | Email | Socials |
|----|------|---------|-------|---------|
| UUID | Ahmed Al-Rashid | Riyadh Restaurant Group | ahmed@rrg.sa | Insta, FB, Twitter |
| UUID | Fatima Hassan | Jeddah Fashion House | fatima@jfh.com | Insta, FB, Twitter, YouTube |
| UUID | Omar Khalid | TechStart Solutions | omar@techstart.sa | Insta, FB, Twitter, YouTube |
| UUID | Layla Mohammed | Wellness Center KSA | layla@wellnessksa.com | Insta, FB, Twitter |

### Campaigns (5)
| Status | Platform | Client | Start | End | Budget | Reach Target |
|--------|----------|--------|-------|-----|--------|--------------|
| Active | Multi | Restaurant | 1 week ago | next week | 15,000 | 50,000 |
| Active | Instagram | Fashion | 2 weeks ago | — | 25,000 | 100,000 |
| Active | YouTube | Tech | 1 week ago | — | 10,000 | 25,000 |
| Completed | Twitter | Wellness | 1 month ago | 1 week ago | 8,000 | 30,000 |
| Draft | Facebook | Restaurant | next week | — | 12,000 | 40,000 |

### Tasks (6)
| Priority | Due | Campaign | Status |
|----------|-----|----------|--------|
| High | Tomorrow | Campaign 1 | Pending |
| Urgent | Today | Campaign 2 | Pending |
| Medium | Next week | Campaign 3 | Pending |
| High | Tomorrow | None | Pending |
| Low | Next week | None | Pending |
| Medium | Today | Campaign 2 | Completed |

### Metrics (7-Day Window)
- **Campaign 1:** 8000+ impressions, 5000+ reach, 400+ engagement per day
- **Campaign 2:** 15000+ impressions, 10000+ reach, 1200+ engagement per day
- **Campaign 3:** 5000+ impressions, 3500+ reach, 600+ engagement per day

---

## Special Features & Utilities

### Data Formatting Extensions
```dart
// Numbers
1000.abbreviated       → "1K"
1000000.abbreviated    → "1M"
1000.withCommas        → "1,000"
15000.0.currency       → "$15,000.00"

// Dates
DateTime.formatted     → "Mar 15, 2024"
DateTime.shortDate     → "3/15"
DateTime.relativeDate  → "2 hours ago", "Today", "Yesterday"

// Strings
"draft".capitalize     → "Draft"
```

### Task Computed Properties
```dart
task.isOverdue   → dueDate < now && !isCompleted
task.isDueToday  → dueDate.date == today.date && !isCompleted
```

### Metric Computed Properties
```dart
metric.engagementRate   → (engagement / reach) * 100
metric.clickThroughRate → (clicks / impressions) * 100
```

### Validations
```dart
Validators.required()           // Non-empty string
Validators.email()              // Valid email format
Validators.phone()              // Valid phone format
Validators.socialHandle()       // Instagram/Twitter format
```

---

## Test Coverage Summary

### Test Case Breakdown (186 Total)
- **Functional Tests:** 100 test cases
- **State Management Tests:** 7 test cases
- **Validation Tests:** 14 test cases
- **Data Persistence Tests:** 7 test cases
- **Edge Cases:** 8 test cases
- **Navigation Tests:** 7 test cases
- **UI/UX Tests:** 10 test cases
- **Performance Tests:** 7 test cases
- **Data Integrity Tests:** 7 test cases
- **Integration Tests:** 7 test cases

### Test Execution Strategy
1. **Unit Tests:** Test individual functions, validators, extensions
2. **Widget Tests:** Test widgets in isolation with mock BLoCs
3. **Integration Tests:** Full user flows (create → read → update → delete)
4. **Manual Tests:** UI/UX, animations, charts, edge cases

---

## Key Implementation Details

### Form Validation
- Campaign name: Required
- Client selection: Required
- Platform: Required (5 options)
- Status: Required (4 options)
- Start date: Required (date picker)
- End date: Optional with clear button
- Budget: Optional (numeric)
- Target reach: Optional (numeric)

### Filtering & Search
- Campaigns: Filter by 4 status values
- Clients: Real-time search by name/company
- Tasks: Filter by completion status (All/Pending/Completed)
- Analytics: Fixed 7-day rolling window

### Charts & Visualizations
- Line Chart: Engagement Over Time (Campaign Details + Analytics)
- Bar Chart: Reach by Day (Analytics)
- Grid View: Dashboard metrics (2×2 grid)
- Metric Cards: Various sizes and styles

### Error Handling
- LoadingIndicator on data fetch
- ErrorView with retry button on failure
- SnackBar for success messages
- AlertDialog for confirmations
- Validation errors on form fields

---

## Architecture Summary

### Tech Stack
- **Framework:** Flutter 3.16+
- **Language:** Dart 3.2+
- **State Management:** flutter_bloc ^8.1.3
- **Dependency Injection:** get_it ^7.6.4
- **Database:** sqflite ^2.3.0
- **Charts:** fl_chart ^0.65.0
- **Navigation:** Material Navigator (no GoRouter)
- **Design:** Material Design 3

### File Structure
```
lib/
├── main.dart
├── app.dart
├── injection.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── widgets/
│   └── errors/
├── features/
│   ├── dashboard/
│   ├── campaigns/
│   ├── clients/
│   ├── analytics/
│   └── tasks/
└── shared/
    └── services/
```

Each feature follows: presentation/ → domain/ → data/ (3-layer architecture)

---

## Quick Testing Checklist

Essential tests to perform first:

1. **Create Flow:** Client → Campaign → Task
2. **Read Operations:** List, Search, Filter, Detail views
3. **Update Operations:** Edit client, campaign, or task
4. **Delete Operations:** Verify cascading deletes
5. **Validations:** Form field validators
6. **Data Persistence:** App restart data survival
7. **Navigation:** Tab switching, dialog flows
8. **Charts:** Analytics page rendering
9. **Filters:** Campaign status, task completion
10. **Search:** Client name/company search

---

## Success Criteria for Testing

- All 186 test cases pass
- No validation bypass possible
- All CRUD operations work correctly
- Cascading deletes work as expected
- Pre-seeded data loads properly
- Charts render without errors
- Search filters work in real-time
- Navigation is smooth and intuitive
- Data persists after app restart
- Error states are handled gracefully

