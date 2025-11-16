# Social Media Campaign Manager - Flutter App
## Project Documentation & Implementation Plan

**Project Duration:** 2 Days (16-20 working hours)
**Target:** Android App for Interview Showcase
**Client Context:** Al-Graphy Media Marketing Company (Saudi Arabia)

---

## 1. PROJECT OVERVIEW

### 1.1 App Description
A professional mobile application for social media marketing agencies to manage client campaigns, track analytics, schedule content, and monitor team tasks. Built to demonstrate Flutter expertise and understanding of the media marketing industry.

### 1.2 Core Value Proposition
- Streamlines daily marketing operations
- Centralizes client and campaign management
- Provides real-time analytics visualization
- Demonstrates professional Flutter development practices

### 1.3 Target Users
- Social Media Managers
- Marketing Agency Employees
- Account Managers
- Content Creators

---

## 2. TECHNICAL STACK

### 2.1 Framework & Language
- **Flutter SDK:** Latest stable (3.16+)
- **Dart:** 3.2+
- **Minimum Android SDK:** 21 (Android 5.0)
- **Target Android SDK:** 34 (Android 14)

### 2.2 Architecture
- **Pattern:** Clean Architecture (3-layer)
  - Presentation Layer (UI + BLoC)
  - Domain Layer (Business Logic)
  - Data Layer (Repositories + Data Sources)
- **State Management:** flutter_bloc (BLoC pattern)
- **Dependency Injection:** get_it + injectable

### 2.3 Key Packages
```yaml
dependencies:
  # Core
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  get_it: ^7.6.4
  injectable: ^2.3.2

  # Navigation
  go_router: ^12.1.1

  # Local Storage
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2

  # UI Components
  fl_chart: ^0.65.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  flutter_slidable: ^3.0.1

  # Utilities
  intl: ^0.18.1
  uuid: ^4.2.1
  logger: ^2.0.2

  # Icons & Theming
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0

dev_dependencies:
  injectable_generator: ^2.4.1
  build_runner: ^2.4.7
  flutter_lints: ^3.0.1
  mocktail: ^1.0.1
```

---

## 3. FEATURES BREAKDOWN

### 3.1 Core Features (Must Have)

#### F1: Dashboard
- Campaign performance overview
- Key metrics cards (total clients, active campaigns, pending tasks)
- Quick stats charts (engagement trends, growth metrics)
- Recent activity feed
- Quick action buttons

#### F2: Campaign Management
- List all campaigns with filters (active, completed, draft)
- Campaign details view
- Performance metrics per campaign
- Platform breakdown (Instagram, Facebook, Twitter, YouTube)
- Campaign timeline/schedule

#### F3: Client Management
- Client list with search & filter
- Client profile (company info, contact, social handles)
- Associated campaigns per client
- Client performance summary
- Add/Edit client information

#### F4: Content Calendar
- Monthly/weekly calendar view
- Scheduled posts visualization
- Post status indicators (scheduled, published, draft)
- Quick post preview
- Filter by client/platform

#### F5: Analytics Dashboard
- Interactive charts (line, bar, pie)
- Engagement metrics
- Follower growth trends
- Best performing content
- Platform comparison
- Export-ready visualizations

#### F6: Task Management
- Todo list for marketing tasks
- Task assignment (simulated)
- Priority levels
- Due dates with notifications
- Task completion tracking

### 3.2 Secondary Features (Nice to Have)

- Dark/Light theme toggle
- Onboarding screens
- Settings page
- Profile management
- Data export functionality
- Search across all sections

### 3.3 Technical Showcases

- **Smooth Animations:** Page transitions, micro-interactions
- **Responsive Design:** Adapts to different screen sizes
- **Error Handling:** Graceful error states, retry mechanisms
- **Loading States:** Skeleton loaders, shimmer effects
- **Empty States:** Informative empty state designs
- **Pull to Refresh:** Standard mobile UX pattern
- **Infinite Scroll:** For lists with pagination
- **Form Validation:** Real-time validation with error messages

---

## 4. APP ARCHITECTURE

### 4.1 Project Structure
```
lib/
├── main.dart
├── app.dart
├── injection.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_dimensions.dart
│   │   └── app_routes.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── extensions.dart
│   │   ├── validators.dart
│   │   └── formatters.dart
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── loading_indicator.dart
│   │   ├── error_widget.dart
│   │   ├── empty_state.dart
│   │   └── metric_card.dart
│   └── errors/
│       └── failures.dart
│
├── features/
│   ├── dashboard/
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── data/
│   │       ├── models/
│   │       ├── repositories/
│   │       └── datasources/
│   │
│   ├── campaigns/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   │
│   ├── clients/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   │
│   ├── calendar/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   │
│   ├── analytics/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   │
│   └── tasks/
│       ├── presentation/
│       ├── domain/
│       └── data/
│
└── shared/
    ├── models/
    ├── services/
    └── repositories/
```

### 4.2 Navigation Structure
```
App
├── Splash Screen
├── Onboarding (first launch only)
└── Main Shell (Bottom Navigation)
    ├── Dashboard (Home)
    ├── Campaigns
    │   ├── Campaign List
    │   ├── Campaign Details
    │   └── Create/Edit Campaign
    ├── Clients
    │   ├── Client List
    │   ├── Client Profile
    │   └── Add/Edit Client
    ├── Calendar
    │   └── Post Details
    └── More
        ├── Analytics
        ├── Tasks
        └── Settings
```

### 4.3 Data Flow
```
UI (Widget)
    ↓ (User Action)
BLoC (Event)
    ↓ (Process)
UseCase (Business Logic)
    ↓ (Execute)
Repository (Abstract)
    ↓ (Implement)
Data Source (Local DB / Mock API)
    ↓ (Return)
Model → Entity → State → UI Update
```

---

## 5. DATABASE SCHEMA

### 5.1 SQLite Tables

#### clients
```sql
CREATE TABLE clients (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  company TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  instagram_handle TEXT,
  facebook_page TEXT,
  twitter_handle TEXT,
  youtube_channel TEXT,
  logo_url TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
```

#### campaigns
```sql
CREATE TABLE campaigns (
  id TEXT PRIMARY KEY,
  client_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL, -- draft, active, completed, paused
  platform TEXT NOT NULL, -- instagram, facebook, twitter, youtube, multi
  start_date INTEGER NOT NULL,
  end_date INTEGER,
  budget REAL,
  target_reach INTEGER,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  FOREIGN KEY (client_id) REFERENCES clients(id)
);
```

#### campaign_metrics
```sql
CREATE TABLE campaign_metrics (
  id TEXT PRIMARY KEY,
  campaign_id TEXT NOT NULL,
  date INTEGER NOT NULL,
  impressions INTEGER DEFAULT 0,
  reach INTEGER DEFAULT 0,
  engagement INTEGER DEFAULT 0,
  followers_gained INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  shares INTEGER DEFAULT 0,
  comments INTEGER DEFAULT 0,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);
```

#### scheduled_posts
```sql
CREATE TABLE scheduled_posts (
  id TEXT PRIMARY KEY,
  campaign_id TEXT NOT NULL,
  content TEXT NOT NULL,
  media_url TEXT,
  platform TEXT NOT NULL,
  scheduled_time INTEGER NOT NULL,
  status TEXT NOT NULL, -- draft, scheduled, published, failed
  created_at INTEGER NOT NULL,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);
```

#### tasks
```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  campaign_id TEXT,
  priority TEXT NOT NULL, -- low, medium, high, urgent
  due_date INTEGER,
  is_completed INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  completed_at INTEGER,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);
```

---

## 6. UI/UX DESIGN GUIDELINES

### 6.1 Color Palette
```dart
// Primary Brand Colors
static const primary = Color(0xFF2563EB);      // Blue
static const primaryLight = Color(0xFF60A5FA);
static const primaryDark = Color(0xFF1D4ED8);

// Secondary Colors
static const secondary = Color(0xFF7C3AED);    // Purple
static const accent = Color(0xFF06B6D4);       // Cyan

// Status Colors
static const success = Color(0xFF10B981);      // Green
static const warning = Color(0xFFF59E0B);      // Amber
static const error = Color(0xFFEF4444);        // Red
static const info = Color(0xFF3B82F6);         // Blue

// Platform Colors
static const instagram = Color(0xFFE4405F);
static const facebook = Color(0xFF1877F2);
static const twitter = Color(0xFF1DA1F2);
static const youtube = Color(0xFFFF0000);

// Neutrals
static const background = Color(0xFFF8FAFC);
static const surface = Color(0xFFFFFFFF);
static const textPrimary = Color(0xFF1E293B);
static const textSecondary = Color(0xFF64748B);
static const border = Color(0xFFE2E8F0);
```

### 6.2 Typography
- **Font Family:** Inter (Google Fonts)
- **Headings:** Bold, proper hierarchy (H1-H6)
- **Body:** Regular 16sp, line height 1.5
- **Captions:** 12sp, secondary color

### 6.3 Spacing System
- Base unit: 4dp
- Consistent padding: 16dp (screens), 12dp (cards)
- Margins between sections: 24dp
- Card border radius: 12dp
- Button border radius: 8dp

### 6.4 Component Library
- Custom AppBar with gradient option
- Metric Cards (icon, value, label, trend indicator)
- Platform Badges (colored icons)
- Status Chips (draft, active, completed)
- Progress Indicators (circular, linear)
- Action Buttons (primary, secondary, text)
- Input Fields (with validation states)
- Bottom Sheets (for quick actions)
- Dialogs (confirmation, forms)

---

## 7. IMPLEMENTATION PHASES

### PHASE 1: Project Setup & Core Infrastructure (4 hours)
**Day 1 - Morning**

#### Hour 1: Project Initialization
- [ ] Create Flutter project with proper package name
- [ ] Configure Android settings (min SDK, permissions)
- [ ] Set up Git repository structure
- [ ] Add .gitignore for Flutter
- [ ] Create initial folder structure

#### Hour 2: Dependencies & Configuration
- [ ] Add all required packages to pubspec.yaml
- [ ] Configure flutter_bloc
- [ ] Set up get_it for dependency injection
- [ ] Configure go_router for navigation
- [ ] Set up asset folders (images, fonts, icons)

#### Hour 3: Core Setup
- [ ] Create app theme (colors, typography, component themes)
- [ ] Set up constants (strings, dimensions, routes)
- [ ] Create base widgets (loading, error, empty states)
- [ ] Configure app entry point (main.dart, app.dart)
- [ ] Set up environment configuration

#### Hour 4: Database Setup
- [ ] Create database helper class
- [ ] Define all table schemas
- [ ] Implement database initialization
- [ ] Create migration strategy
- [ ] Seed initial mock data

---

### PHASE 2: Data Layer Implementation (3 hours)
**Day 1 - Late Morning**

#### Hour 5: Models & Entities
- [ ] Create all entity classes (Client, Campaign, Task, etc.)
- [ ] Create corresponding data models with JSON serialization
- [ ] Implement model-to-entity mappers
- [ ] Add equatable for value equality
- [ ] Create factory constructors for mock data

#### Hour 6: Data Sources
- [ ] Implement ClientLocalDataSource
- [ ] Implement CampaignLocalDataSource
- [ ] Implement TaskLocalDataSource
- [ ] Implement MetricsLocalDataSource
- [ ] Add error handling for database operations

#### Hour 7: Repositories
- [ ] Create abstract repository interfaces (domain layer)
- [ ] Implement concrete repositories (data layer)
- [ ] Add caching strategy where applicable
- [ ] Implement data transformation logic
- [ ] Register repositories in DI container

---

### PHASE 3: Feature Implementation - Dashboard (3 hours)
**Day 1 - Afternoon**

#### Hour 8: Dashboard BLoC
- [ ] Define DashboardEvent classes
- [ ] Define DashboardState classes
- [ ] Implement DashboardBloc logic
- [ ] Create use cases (GetDashboardMetrics, GetRecentActivity)
- [ ] Handle loading, success, and error states

#### Hour 9: Dashboard UI - Main Screen
- [ ] Create DashboardPage scaffold
- [ ] Implement header with greeting and date
- [ ] Build metrics overview cards row
- [ ] Add quick stats section with mini charts
- [ ] Implement pull-to-refresh

#### Hour 10: Dashboard UI - Components
- [ ] Create MetricCard widget with animations
- [ ] Build RecentActivityList widget
- [ ] Implement QuickActionsRow
- [ ] Add CampaignSummaryCard
- [ ] Create shimmer loading placeholders

---

### PHASE 4: Feature Implementation - Campaigns (3 hours)
**Day 1 - Evening**

#### Hour 11: Campaigns BLoC & Data
- [ ] Define Campaign events and states
- [ ] Implement CampaignListBloc
- [ ] Implement CampaignDetailBloc
- [ ] Create filter and sort functionality
- [ ] Add CRUD operations

#### Hour 12: Campaign List UI
- [ ] Create CampaignListPage with tabs (All, Active, Completed)
- [ ] Build CampaignListTile widget
- [ ] Implement search functionality
- [ ] Add filter bottom sheet
- [ ] Create empty state for no campaigns

#### Hour 13: Campaign Details UI
- [ ] Create CampaignDetailPage layout
- [ ] Build performance metrics section
- [ ] Implement platform breakdown chart
- [ ] Add scheduled posts preview
- [ ] Create edit/delete actions

---

### PHASE 5: Feature Implementation - Clients (2 hours)
**Day 2 - Morning**

#### Hour 14: Clients Feature
- [ ] Implement ClientListBloc
- [ ] Create ClientListPage UI
- [ ] Build ClientCard widget with social icons
- [ ] Implement ClientDetailPage
- [ ] Add client search and filter

#### Hour 15: Client Management
- [ ] Create AddEditClientPage
- [ ] Implement form with validation
- [ ] Add social media handle inputs
- [ ] Create client deletion with confirmation
- [ ] Link clients to campaigns view

---

### PHASE 6: Feature Implementation - Calendar & Analytics (3 hours)
**Day 2 - Late Morning**

#### Hour 16: Content Calendar
- [ ] Implement CalendarBloc
- [ ] Create CalendarPage with month view
- [ ] Build day cell with post indicators
- [ ] Implement PostPreviewBottomSheet
- [ ] Add platform filter for calendar

#### Hour 17: Analytics Dashboard
- [ ] Implement AnalyticsBloc
- [ ] Create AnalyticsPage layout
- [ ] Build EngagementLineChart using fl_chart
- [ ] Create PlatformComparisonBarChart
- [ ] Add follower growth visualization

#### Hour 18: Analytics Polish
- [ ] Implement date range selector
- [ ] Add metric comparison cards
- [ ] Create top performing content section
- [ ] Build export functionality (mock)
- [ ] Add smooth chart animations

---

### PHASE 7: Feature Implementation - Tasks (1.5 hours)
**Day 2 - Afternoon**

#### Hour 19: Tasks Feature
- [ ] Implement TaskBloc with CRUD
- [ ] Create TaskListPage with priority sections
- [ ] Build TaskTile with slidable actions
- [ ] Implement AddTaskBottomSheet
- [ ] Add task completion animations

---

### PHASE 8: Navigation & Polish (2 hours)
**Day 2 - Afternoon**

#### Hour 20: Main Navigation
- [ ] Implement MainShell with BottomNavigationBar
- [ ] Configure go_router with all routes
- [ ] Add page transitions
- [ ] Implement deep linking setup
- [ ] Create More/Settings page

#### Hour 21: UI Polish & Animations
- [ ] Add Hero animations for transitions
- [ ] Implement staggered list animations
- [ ] Add micro-interactions (button feedback, etc.)
- [ ] Polish empty states with illustrations
- [ ] Ensure consistent spacing and alignment

---

### PHASE 9: Testing & Quality Assurance (2 hours)
**Day 2 - Late Afternoon**

#### Hour 22: Testing
- [ ] Write unit tests for BLoCs
- [ ] Test repository implementations
- [ ] Verify all CRUD operations
- [ ] Test edge cases (empty data, errors)
- [ ] Performance testing on device

#### Hour 23: Bug Fixes & Optimization
- [ ] Fix any UI overflow issues
- [ ] Optimize database queries
- [ ] Ensure smooth scrolling performance
- [ ] Memory leak checks
- [ ] Battery usage optimization

---

### PHASE 10: Documentation & Finalization (1.5 hours)
**Day 2 - Evening**

#### Hour 24: Documentation
- [ ] Update README with setup instructions
- [ ] Document architecture decisions
- [ ] Add code comments for complex logic
- [ ] Create feature showcase document
- [ ] Prepare talking points for interview

#### Final 30 Minutes: Release Prep
- [ ] Build release APK
- [ ] Test on physical device
- [ ] Record demo video (optional)
- [ ] Final git commit and push
- [ ] Backup project

---

## 8. RISK MITIGATION

### 8.1 Time Risks
- **Risk:** Feature creep
- **Mitigation:** Strict MVP scope, cut nice-to-haves early

- **Risk:** Complex bugs
- **Mitigation:** Simple implementations first, enhance later

- **Risk:** UI polish takes too long
- **Mitigation:** Use pre-built components, minimal custom designs

### 8.2 Technical Risks
- **Risk:** Database issues
- **Mitigation:** Start with simple schema, test early

- **Risk:** State management complexity
- **Mitigation:** Follow BLoC patterns strictly, avoid shortcuts

- **Risk:** Performance issues
- **Mitigation:** Lazy loading, pagination, minimal rebuilds

### 8.3 Contingency Plan
If running behind schedule:
1. **Cut Tasks feature** - Move to "nice to have"
2. **Simplify Calendar** - List view instead of calendar grid
3. **Reduce Analytics charts** - 2 charts instead of 4
4. **Skip animations** - Focus on functionality
5. **Use simpler forms** - Fewer validation rules

---

## 9. SUCCESS CRITERIA

### 9.1 Must Achieve
- [ ] App launches without crashes
- [ ] All core navigation works smoothly
- [ ] CRUD operations function correctly
- [ ] Charts display with real data
- [ ] Professional, polished UI appearance
- [ ] Code follows clean architecture
- [ ] Proper error handling throughout
- [ ] App is performant (no jank)

### 9.2 Interview Talking Points
1. **Architecture:** Explain clean architecture benefits
2. **State Management:** Why BLoC pattern was chosen
3. **Code Organization:** Feature-based structure benefits
4. **Performance:** Optimization strategies used
5. **Scalability:** How to add new features
6. **Testing:** Testing strategy and coverage
7. **Industry Relevance:** Understanding of marketing domain

### 9.3 Demo Flow (5 minutes)
1. Launch app → Dashboard overview (30s)
2. Browse campaigns → Show filtering (45s)
3. View campaign details → Metrics visualization (45s)
4. Client management → CRUD operations (60s)
5. Analytics dashboard → Charts and insights (60s)
6. Calendar view → Content scheduling (45s)
7. Code walkthrough → Architecture highlights (45s)

---

## 10. POST-DEVELOPMENT

### 10.1 What to Highlight in Interview
- Clean, maintainable codebase
- Understanding of business domain
- Professional UI/UX decisions
- Scalable architecture choices
- Attention to detail (animations, states)
- Error handling and edge cases
- Code documentation

### 10.2 Potential Questions & Answers

**Q: Why BLoC over other state management?**
A: BLoC provides clear separation of concerns, is highly testable, and scales well for complex apps. It's widely adopted in professional Flutter development.

**Q: How would you add API integration?**
A: The clean architecture makes this easy - just add a RemoteDataSource, implement a network client, and the repository will coordinate between local and remote sources.

**Q: How would you handle offline sync?**
A: Implement a sync queue in the local database, track changes with timestamps, and reconcile when online using conflict resolution strategies.

**Q: Why this specific app idea?**
A: I researched Al-Graphy's business model and built something directly relevant to your operations, demonstrating both technical skills and business understanding.

---

## 11. QUICK START COMMANDS

```bash
# Create project
flutter create --org com.showcase --project-name campaign_manager campaign_manager

# Add dependencies (after editing pubspec.yaml)
flutter pub get

# Generate DI code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Build release APK
flutter build apk --release

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

## 12. FINAL CHECKLIST

### Pre-Interview
- [ ] App runs without errors
- [ ] All features functional
- [ ] Code is clean and documented
- [ ] README is comprehensive
- [ ] Release APK is built
- [ ] Demo script is practiced
- [ ] Can explain every architectural decision
- [ ] Familiar with all code written

### Day of Interview
- [ ] Phone is charged
- [ ] APK installed on device
- [ ] Laptop has project open in IDE
- [ ] Can do live code walkthrough
- [ ] Prepared for technical questions
- [ ] Confident in explaining business relevance

---

**Document Version:** 1.0
**Created:** November 16, 2024
**Last Updated:** November 16, 2024
**Author:** Development Team
**Project Status:** Planning Complete - Ready for Implementation
