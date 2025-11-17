# Flutter Campaign Manager App - Exploration Summary

## Project Overview
A professional Flutter social media campaign management application designed for agencies managing client campaigns, tracking analytics, and organizing team tasks.

**Location:** `/home/user/app`
**Generated Documentation:** 
- `/home/user/app/TEST_CASES_COMPREHENSIVE.md` (186 test cases)
- `/home/user/app/FEATURE_OVERVIEW.md` (Quick reference guide)

---

## 1. ALL MAIN FEATURES AND SCREENS

### Primary Navigation (5 Tabs - Bottom Navigation)
The app uses MaterialApp with BottomNavigationBar and IndexedStack to preserve state:

1. **Dashboard** - Overview and metrics hub
2. **Campaigns** - Campaign management
3. **Clients** - Client/company management
4. **Analytics** - Performance visualization
5. **Tasks** - Task tracking and management

### Screen Breakdown

#### Dashboard (Read-Only)
- Greeting with time-based message
- Current date display
- Metrics Grid (2×2):
  - Active Clients count
  - Active Campaigns count
  - Pending Tasks count
  - Total Reach with trend percentage
- Growth Trends Card:
  - Reach Growth % (with +/- indicator)
  - Engagement Growth % (with +/- indicator)
  - Followers Growth % (with +/- indicator)
- Recent Activity Timeline (6 activity types with icons)
- Pull-to-Refresh capability

#### Campaigns (CRUD)
**List Screen:**
- Tab filtering: All / Active / Draft / Completed
- Campaign cards showing: name, status, description, platform, date, budget, reach
- FAB for creating new campaigns
- Pull-to-Refresh

**Details Screen:**
- Campaign header with name and status chip
- 3 metric cards: Reach, Engagement, Clicks
- Campaign details card: dates, budget, reach target, timestamps
- Engagement Over Time chart (line chart, 7-day data)
- Edit/Delete actions

**Add/Edit Screen:**
- Campaign Information: name (required), description (optional)
- Client selection dropdown (required)
- Platform selection: Instagram/Facebook/Twitter/YouTube/Multi (required)
- Status selection: Draft/Active/Paused/Completed (required)
- Timeline: start date (required), end date (optional)
- Budget & Goals: budget (optional), target reach (optional)
- Form validation with error messages

#### Clients (CRUD)
**List Screen:**
- Real-time search bar (by name/company)
- Client cards: avatar, name, company, social media icons (conditional)
- FAB for creating new clients
- Pull-to-Refresh
- Empty states: "No Clients Yet" vs "No Results Found"

**Details Screen:**
- Profile header: avatar, name, company, "Client since" date
- Contact Information card: email, phone (if available)
- Social Profiles card: Instagram, Facebook, Twitter, YouTube (if available)
- Campaigns card: up to 3 recent client campaigns
- Edit/Delete actions

**Add/Edit Screen:**
- Basic Information: name (required), company (required)
- Contact: email (optional, validated), phone (optional, validated)
- Social Media: Instagram, Facebook, Twitter, YouTube (all optional)
- Color-coded social platform icons
- Form validation

#### Analytics (Read-Only)
**Charts and Data:**
- Performance Overview: Avg Engagement Rate %, Avg CTR %
- Engagement Trend (Line Chart): 7-day data grouped by date
- Reach by Day (Bar Chart): 7-day data grouped by date
- Total Metrics Summary: 7 metrics (Impressions, Reach, Engagement, Followers Gained, Clicks, Shares, Comments)
- All numbers formatted with comma separators
- Pull-to-Refresh

#### Tasks (CRUD with Toggle)
**List Screen:**
- Filter menu: All Tasks / Pending / Completed
- Task cards with:
  - Checkbox to toggle completion
  - Title (strikethrough if completed)
  - Description (optional, 2 lines max)
  - Priority badge: Low/Medium/High/Urgent (color-coded)
  - Due date badge:
    - Red: "Overdue"
    - Orange: "Due Today"
    - Gray: Formatted date
  - Slidable delete action
- FAB for creating new tasks
- Pull-to-Refresh

**Add Task Dialog (Modal):**
- Task Title (required)
- Description (optional, 3 lines)
- Priority dropdown (default: Medium)
- Auto-sets due date to tomorrow
- Dialog actions: Cancel, Add Task

---

## 2. CRUD OPERATIONS AVAILABLE

### Campaigns Module
```
CREATE    → AddCampaign event → _onAddCampaign → CampaignOperationSuccess
READ      → LoadCampaigns → _onLoadCampaigns → CampaignsLoaded
READ      → LoadCampaignsByStatus → _onLoadCampaignsByStatus → CampaignsLoaded
READ      → LoadCampaignDetails → _onLoadCampaignDetails → CampaignDetailsLoaded
UPDATE    → UpdateCampaign → _onUpdateCampaign → CampaignOperationSuccess
DELETE    → DeleteCampaign → _onDeleteCampaign → CampaignOperationSuccess
```

### Clients Module
```
CREATE    → AddClient → _onAddClient → ClientOperationSuccess
READ      → LoadClients → _onLoadClients → ClientsLoaded
READ      → SearchClients → _onSearchClients → ClientsLoaded
READ      → LoadClientDetails → _onLoadClientDetails → ClientDetailsLoaded
UPDATE    → UpdateClient → _onUpdateClient → ClientOperationSuccess
DELETE    → DeleteClient → _onDeleteClient → ClientOperationSuccess
```

### Tasks Module
```
CREATE    → AddTask → _onAddTask → TaskOperationSuccess
READ      → LoadTasks → _onLoadTasks → TasksLoaded
READ      → LoadPendingTasks → _onLoadPendingTasks → TasksLoaded (filtered)
READ      → LoadCompletedTasks → _onLoadCompletedTasks → TasksLoaded (filtered)
UPDATE    → UpdateTask → _onUpdateTask → TaskOperationSuccess
DELETE    → DeleteTask → _onDeleteTask → TaskOperationSuccess
TOGGLE    → ToggleTaskCompletion → _onToggleTaskCompletion → TasksLoaded
```

### Analytics Module (Read-Only)
```
READ      → LoadAnalytics → _onLoadAnalytics → AnalyticsLoaded (7-day metrics)
READ      → LoadCampaignAnalytics → _onLoadCampaignAnalytics → CampaignAnalyticsLoaded
```

### Dashboard Module (Read-Only)
```
READ      → LoadDashboard → _onLoadDashboard → DashboardLoaded
REFRESH   → RefreshDashboard → _onRefreshDashboard → DashboardLoaded
```

---

## 3. DATA RELATIONSHIPS

### Entity Diagram
```
┌─────────────┐
│   CLIENTS   │ (1)
└──────┬──────┘
       │ (has many)
       ↓
┌──────────────────┐
│   CAMPAIGNS      │ (Many)
└──────┬───────────┘
       │
       ├─→ CAMPAIGN_METRICS (cascade delete)
       ├─→ SCHEDULED_POSTS (cascade delete)
       └─→ TASKS (set null on delete)
```

### Database Schema

**Tables (5):**
1. **clients** - 4 pre-seeded clients with social media handles
2. **campaigns** - 5 pre-seeded campaigns across different platforms
3. **campaign_metrics** - 21 pre-seeded metric records (7 days × 3 campaigns)
4. **scheduled_posts** - 3 pre-seeded posts
5. **tasks** - 6 pre-seeded tasks (5 pending, 1 completed)

**Key Relationships:**
- Campaign.clientId → Client.id (Foreign Key, ON DELETE CASCADE)
- Metric.campaignId → Campaign.id (Foreign Key, ON DELETE CASCADE)
- ScheduledPost.campaignId → Campaign.id (Foreign Key, ON DELETE CASCADE)
- Task.campaignId → Campaign.id (Foreign Key, ON DELETE SET NULL - optional)

**Database Indexes:**
- campaigns.client_id
- campaigns.status
- campaign_metrics.campaign_id
- scheduled_posts.campaign_id
- tasks.priority
- tasks.is_completed

---

## 4. SPECIAL FEATURES

### Filtering & Search
- **Campaign Filtering:** By status (draft, active, paused, completed) - 4 tabs
- **Client Search:** Real-time search by name or company name
- **Task Filtering:** All / Pending (is_completed=0) / Completed (is_completed=1)
- **Analytics Window:** Fixed 7-day rolling window

### Data Visualization
- **Line Charts:** Engagement Over Time (Campaign Details + Analytics)
  - Using fl_chart library
  - Curved lines with gradient fill
  - Grid lines and dot markers
- **Bar Charts:** Reach by Day (Analytics)
  - Using fl_chart library
  - Formatted with abbreviated numbers
- **Metric Cards:** Dashboard grid with 4 cards (2×2)
- **Growth Indicators:** +/- percentage with color coding

### Data Formatting
- **Numbers:** Abbreviated (1K, 1M), with commas (1,000), currency format ($15,000.00)
- **Dates:** Formatted display (Mar 15, 2024), short format (3/15), relative format (2 hours ago)
- **Enums:** Capitalized labels (Draft → "Draft")

### Task Intelligence
- **Overdue Detection:** Tasks with past due dates show "Overdue" (red)
- **Today Highlight:** Tasks due today show "Due Today" (orange)
- **Completion Tracking:** Completed tasks show strikethrough text
- **Status Toggling:** Checkbox toggles completion and sets/clears completedAt timestamp

### Analytics Metrics
- **Calculated Rates:**
  - Engagement Rate = (engagement / reach) × 100
  - Click-Through Rate = (clicks / impressions) × 100
- **Aggregated Data:** Sum of all metrics across campaigns for dashboard
- **Growth Calculations:** % change in reach, engagement, followers

### Activity Timeline
**6 Activity Types:**
1. Campaign Created (icon: add_circle, color: info)
2. Campaign Completed (icon: check_circle, color: success)
3. Task Completed (icon: task_alt, color: success)
4. Client Added (icon: person_add, color: secondary)
5. Post Scheduled (icon: schedule, color: warning)
6. Metrics Updated (icon: analytics, color: primary)

---

## 5. NAVIGATION PATTERNS

### Architecture
- **Primary:** BottomNavigationBar with 5 tabs
- **Stack Management:** IndexedStack preserves tab states
- **Sub-navigation:** Material Navigator.push/pop for detail screens
- **Modals:** AlertDialog for confirmations, showDatePicker for dates
- **No GoRouter:** Uses standard Material Navigation

### Navigation Graph
```
MainShell (IndexedStack with BottomNavigationBar)
│
├─ DashboardPage (read-only, no sub-navigation)
│
├─ CampaignsPage (list view)
│   ├─ CampaignDetailsPage (detail view)
│   │   ├─ AddEditCampaignPage (edit campaign)
│   │   └─ AlertDialog (delete confirmation)
│   └─ AddEditCampaignPage (create campaign)
│
├─ ClientsPage (list view with search)
│   ├─ ClientDetailsPage (detail view)
│   │   ├─ AddEditClientPage (edit client)
│   │   └─ AlertDialog (delete confirmation)
│   └─ AddEditClientPage (create client)
│
├─ AnalyticsPage (read-only, no sub-navigation)
│
└─ TasksPage (list view)
    ├─ AlertDialog (create task via modal)
    ├─ Slidable widget (delete action)
    └─ Checkbox (toggle completion)
```

### State Passing
- Campaign entity passed to details page to avoid re-fetch
- Client entity passed to details page to avoid re-fetch
- Search query maintained in ClientBloc state

---

## 6. STATE MANAGEMENT APPROACH

### BLoC Pattern (5 BLoCs)
```
┌──────────────────────────────────────────┐
│ Event (User Action)                      │
│ AddCampaign / UpdateClient / DeleteTask  │
└────────────────┬─────────────────────────┘
                 │
                 ↓
         ┌──────────────┐
         │ BLoC Handler │
         │ (_onAdd...)  │
         └────────┬─────┘
                  │
                  ↓
        ┌─────────────────┐
        │ Repository Call │
        │ addCampaign()   │
        └────────┬────────┘
                 │
                 ↓
          ┌──────────────┐
          │ Database Op  │
          │ (SQLite)     │
          └────────┬─────┘
                   │
                   ↓
         ┌─────────────────┐
         │ Emit State      │
         │ (Success/Error) │
         └────────┬────────┘
                  │
                  ↓
       ┌──────────────────────┐
       │ BlocBuilder Rebuilds │
       │ UI                   │
       └──────────────────────┘
```

### BLoC Instances
1. **DashboardBloc** - Events: LoadDashboard, RefreshDashboard
2. **CampaignBloc** - Events: Load, Filter, Add, Update, Delete
3. **ClientBloc** - Events: Load, Search, Add, Update, Delete
4. **TaskBloc** - Events: Load, Add, Update, Delete, Toggle
5. **AnalyticsBloc** - Events: Load (general), Load (campaign-specific)

### State Hierarchy
```
Initial State → Loading State
             ↘
              └→ Loaded State (with data)
             ↙
           Error State
```

**Common States:**
- XxxInitial - Starting state
- XxxLoading - Data fetch in progress
- XxxLoaded - Successful load
- XxxOperationSuccess - CRUD operation success
- XxxError - Error with message

### Dependency Injection
- **Service Locator:** GetIt singleton pattern
- **Registration:** DatabaseService, Repositories, BLoCs
- **Access:** `getIt<CampaignBloc>()`
- **Scope:** Application-wide singletons

---

## 7. ARCHITECTURE & TECH STACK

### Architecture Pattern
**Clean Architecture (3-Layer):**
1. **Presentation Layer** (UI)
   - Pages (StatefulWidget / StatelessWidget)
   - BlocBuilder / BlocListener / BlocConsumer
   - Widgets

2. **Domain Layer** (Business Logic)
   - Entities (immutable data classes)
   - Repository abstract classes
   - Use cases (not explicitly used, logic in BLoC)

3. **Data Layer** (Data Access)
   - Models (entities + serialization)
   - Repository implementations
   - Data sources (local/remote)

### Tech Dependencies
```
Core: flutter_bloc ^8.1.3, equatable ^2.0.5, get_it ^7.6.4
Navigation: Material Navigator (no external routing)
Database: sqflite ^2.3.0, path ^1.8.3, shared_preferences ^2.2.2
Charts: fl_chart ^0.65.0
UI: flutter_svg ^2.0.9, google_fonts ^6.1.0, cupertino_icons ^1.0.6
Utils: intl ^0.18.1, uuid ^4.2.1
Sliding: flutter_slidable ^3.0.1
Shimmer: shimmer ^3.0.0
```

### Project Structure
```
lib/
├── main.dart
├── app.dart
├── injection.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_dimensions.dart
│   │   └── app_strings.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── extensions.dart
│   │   └── validators.dart
│   ├── widgets/
│   │   ├── empty_state.dart
│   │   ├── error_view.dart
│   │   ├── loading_indicator.dart
│   │   ├── metric_card.dart
│   │   ├── platform_badge.dart
│   │   └── status_chip.dart
│   └── errors/
│       └── failures.dart
├── features/
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── bloc/ (DashboardBloc)
│   │   │   ├── pages/ (DashboardPage, MainShell)
│   │   │   └── widgets/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── data/
│   │       ├── datasources/
│   │       ├── models/
│   │       └── repositories/
│   ├── campaigns/
│   │   ├── presentation/
│   │   │   ├── bloc/ (CampaignBloc)
│   │   │   └── pages/ (CampaignsPage, CampaignDetailsPage, AddEditCampaignPage)
│   │   ├── domain/
│   │   │   ├── entities/ (CampaignEntity with enums)
│   │   │   └── repositories/
│   │   └── data/
│   │       ├── datasources/
│   │       ├── models/
│   │       └── repositories/
│   ├── clients/
│   │   ├── presentation/
│   │   │   ├── bloc/ (ClientBloc)
│   │   │   └── pages/ (ClientsPage, ClientDetailsPage, AddEditClientPage)
│   │   ├── domain/
│   │   │   ├── entities/ (ClientEntity)
│   │   │   └── repositories/
│   │   └── data/
│   │       ├── datasources/
│   │       ├── models/
│   │       └── repositories/
│   ├── analytics/
│   │   ├── presentation/
│   │   │   ├── bloc/ (AnalyticsBloc)
│   │   │   └── pages/ (AnalyticsPage)
│   │   ├── domain/
│   │   │   ├── entities/ (MetricEntity, AggregatedMetrics)
│   │   │   └── repositories/
│   │   └── data/
│   │       ├── datasources/
│   │       ├── models/
│   │       └── repositories/
│   └── tasks/
│       ├── presentation/
│       │   ├── bloc/ (TaskBloc)
│       │   └── pages/ (TasksPage)
│       ├── domain/
│       │   ├── entities/ (TaskEntity with enum)
│       │   └── repositories/
│       └── data/
│           ├── datasources/
│           ├── models/
│           └── repositories/
└── shared/
    └── services/
        └── database_service.dart
```

---

## 8. PRE-SEEDED TEST DATA

The app comes with sample data pre-loaded:

**Clients (4):**
1. Ahmed Al-Rashid - Riyadh Restaurant Group
2. Fatima Hassan - Jeddah Fashion House
3. Omar Khalid - TechStart Solutions
4. Layla Mohammed - Wellness Center KSA

**Campaigns (5):**
1. Ramadan Special Menu Launch (Active, Multi-platform)
2. Summer Collection 2024 (Active, Instagram)
3. Product Demo Series (Active, YouTube)
4. Mental Health Awareness (Completed, Twitter)
5. Customer Loyalty Program (Draft, Facebook)

**Tasks (6):**
1-5. Various high/medium/low/urgent priority tasks
6. One completed task (for testing completed state)

**Metrics:**
21 metric records (7 days of data for 3 active campaigns)

---

## 9. KEY TESTING CONSIDERATIONS

### Must-Test Features
1. All CRUD operations (Create, Read, Update, Delete)
2. Cascading deletes (client → campaigns → metrics)
3. Tab navigation and state preservation
4. Form validations and error messages
5. Real-time search on clients
6. Task completion toggle
7. Campaign status filtering
8. Analytics charts rendering
9. Data persistence across app restart
10. All error states with retry buttons

### Pre-Seeded Data Usage
- Immediately visible on first app launch
- Allows testing without manual data entry
- Includes various statuses for filter testing
- Includes both complete and incomplete tasks
- Includes metrics data for chart testing

### Edge Cases to Test
- Empty states for all list views
- Long text truncation (names, descriptions)
- Large numbers formatting (1K, 1M)
- Overdue/Today/Future task badges
- Campaign with no end date
- Tasks without campaign assignment
- Clients with no social profiles
- Campaigns with no metrics

---

## 10. DOCUMENTATION FILES GENERATED

### Created Files
1. **TEST_CASES_COMPREHENSIVE.md** (in `/home/user/app/`)
   - 186 detailed test cases organized by module
   - Coverage: Functional, state management, validation, persistence, integration
   - Success criteria and testing tips

2. **FEATURE_OVERVIEW.md** (in `/home/user/app/`)
   - Quick reference guide
   - Feature summaries
   - Data model overview
   - Navigation structure
   - Test coverage breakdown

3. **EXPLORATION_SUMMARY.md** (this file)
   - Complete exploration findings
   - Architecture details
   - State management explanation
   - Tech stack breakdown
   - Pre-seeded data inventory

---

## Summary Statistics

- **Total Pages:** 10 unique pages/screens
- **CRUD Modules:** 3 (Campaigns, Clients, Tasks)
- **Read-Only Modules:** 2 (Dashboard, Analytics)
- **BLoCs:** 5
- **Database Tables:** 5 (with 34 total pre-seeded records)
- **Chart Types:** 2 (Line, Bar)
- **Navigation Patterns:** 5 (Tab, Stack, Modal, Dialog, Slidable)
- **Test Cases:** 186
- **Validation Rules:** 12+
- **Status Enums:** Multiple (campaign status, platform, priority, activity type)

---

## Recommended Testing Order

1. Dashboard (simplest, read-only)
2. Clients (simpler CRUD, less related data)
3. Campaigns (more complex, metrics linked)
4. Tasks (feature-rich with toggles)
5. Analytics (read-only, chart heavy)
6. Integration tests (cross-module flows)
7. Performance tests (scaling, large datasets)

