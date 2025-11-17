# Flutter Campaign Manager - Comprehensive Test Case Documentation

## Overview
A professional Flutter social media campaign management application built with clean architecture, BLoC pattern state management, and SQLite database for persistent storage.

---

## 1. MAIN FEATURES AND SCREENS

### 1.1 Bottom Navigation Structure (5 Tabs)
The app uses a tab-based navigation pattern with IndexedStack for state preservation:
- **Dashboard** (Icon: dashboard_outlined/dashboard)
- **Campaigns** (Icon: campaign_outlined/campaign)
- **Clients** (Icon: people_outline/people)
- **Analytics** (Icon: analytics_outlined/analytics)
- **Tasks** (Icon: task_outlined/task)

### 1.2 Dashboard Screen
**Features:**
- Time-based greeting (Good Morning/Afternoon/Evening)
- Current date display
- Today's Overview Grid (4 metrics):
  - Active Clients count
  - Active Campaigns count
  - Pending Tasks count
  - Total Reach (with trend percentage)
- Growth Trends Card:
  - Reach Growth (with trend indicator: +/-)
  - Engagement Growth (with trend indicator)
  - Followers Growth (with trend indicator)
- Recent Activity Timeline:
  - Shows 6 activity types: Campaign Created, Campaign Completed, Task Completed, Client Added, Post Scheduled, Metrics Updated
  - Displays activity icon, title, subtitle, and relative timestamp
- Pull-to-Refresh capability
- Loading and error states with retry option

### 1.3 Campaigns Screen
**Features:**
- Tab-based filtering:
  - All Campaigns
  - Active Campaigns
  - Draft Campaigns
  - Completed Campaigns
- Campaign List Cards displaying:
  - Campaign name
  - Status badge (Draft/Active/Paused/Completed)
  - Description (truncated to 2 lines)
  - Platform badge (Instagram/Facebook/Twitter/YouTube/Multi)
  - Start date
  - Budget (optional, with currency formatting)
  - Target Reach (optional, with abbreviated formatting)
- Pull-to-Refresh
- Create Campaign button (FAB and empty state button)
- Campaign selection leads to Campaign Details page

### 1.4 Campaign Details Page
**Features:**
- Header with campaign name and status chip
- Description display
- Platform badge
- Edit and Delete actions (menu buttons)
- Metrics Section (3 cards):
  - Total Reach (with icon)
  - Total Engagement (with icon)
  - Total Clicks (with icon)
- Campaign Details Card:
  - Start Date
  - End Date (if set)
  - Budget (if set)
  - Target Reach (if set)
  - Created date
  - Last Updated date
- Performance Chart:
  - Engagement Over Time (Line chart using fl_chart)
  - X-axis: time periods, Y-axis: engagement values
  - Curved line with gradient fill
- Delete confirmation dialog

### 1.5 Add/Edit Campaign Page
**Features:**
- Form validation
- Campaign Information Section:
  - Campaign Name (required)
  - Description (optional)
- Client & Platform Section:
  - Client selection dropdown (required, loads from ClientBloc)
  - Platform dropdown (required): Instagram/Facebook/Twitter/YouTube/Multi
  - Status dropdown (required): Draft/Active/Paused/Completed
- Timeline Section:
  - Start Date picker (required)
  - End Date picker (optional, with clear button)
- Budget & Goals Section:
  - Budget input (optional, currency format)
  - Target Reach input (optional, number format)
- Create/Update Campaign button
- Form submission shows success snackbar

### 1.6 Clients Screen
**Features:**
- Search bar with:
  - Search icon
  - Clear button (appears when text entered)
  - Real-time search results filtering
- Client List Cards displaying:
  - Avatar with first initial
  - Client name
  - Company name
  - Social media icons (Instagram/Facebook/Twitter/YouTube) shown conditionally
- Pull-to-Refresh
- Create Client button (FAB and empty state button)
- Search "No Results" empty state vs "No Clients Yet" empty state
- Client selection leads to Client Details page

### 1.7 Client Details Page
**Features:**
- Profile Header Card:
  - Large avatar with first initial
  - Client name
  - Company name
  - "Client since" date
- Contact Information Card:
  - Email (if available) with email icon
  - Phone (if available) with phone icon
- Social Profiles Card (only shown if social profiles exist):
  - Instagram handle (@username format)
  - Facebook page
  - Twitter handle (@username format)
  - YouTube channel
  - Color-coded icons per platform
- Campaigns Card:
  - Shows up to 3 most recent campaigns for the client
  - Campaign name, status, and start date
  - "View All" button (shows snackbar message)
- Edit and Delete actions (menu buttons)
- Delete confirmation dialog (mentions cascading campaign deletion)

### 1.8 Add/Edit Client Page
**Features:**
- Form validation
- Basic Information Section:
  - Full Name (required)
  - Company Name (required)
- Contact Information Section:
  - Email (optional, email validation)
  - Phone (optional, phone validation)
- Social Media Profiles Section:
  - Instagram Handle (optional, Instagram validation)
  - Facebook Page (optional)
  - Twitter Handle (optional, Twitter validation)
  - YouTube Channel (optional)
  - Color-coded icons per platform
- Add/Update Client button
- Form submission shows success snackbar

### 1.9 Analytics Page
**Features:**
- Performance Overview Cards (2):
  - Average Engagement Rate (%)
  - Average Click-Through Rate (%)
- Engagement Trend Chart (Line chart):
  - Grouped by date
  - Shows engagement over last 7 days
  - X-axis: date labels, Y-axis: engagement count
  - Grid, dots, curved line with gradient fill
- Reach by Day Chart (Bar chart):
  - Grouped by date
  - Shows reach for each day of last 7 days
  - X-axis: date labels, Y-axis: reach count
- Total Metrics Summary Card:
  - Total Impressions (formatted with commas)
  - Total Reach (formatted with commas)
  - Total Engagement (formatted with commas)
  - Total Followers Gained (formatted with commas)
  - Total Clicks (formatted with commas)
  - Total Shares (formatted with commas)
  - Total Comments (formatted with commas)
- Pull-to-Refresh
- Loading and error states with retry option

### 1.10 Tasks Screen
**Features:**
- Popup menu filter options:
  - All Tasks
  - Pending Tasks (is_completed = false)
  - Completed Tasks (is_completed = true)
- Task List with Slidable Cards:
  - Checkbox to toggle completion status
  - Task title (with strikethrough if completed)
  - Task description (optional, 2 lines max)
  - Priority badge: Low/Medium/High/Urgent (color-coded)
  - Due date badge with conditional coloring:
    - Red: Overdue
    - Orange/Yellow: Due Today
    - Gray: Future date
  - Delete action (slide right to reveal)
- Create Task button (FAB and empty state button)
- Task creation dialog (modal):
  - Task Title (required)
  - Description (optional)
  - Priority dropdown (default: Medium)
  - Auto-sets due date to tomorrow
- Pull-to-Refresh
- Success snackbar on task operation
- Loading and error states with retry option

---

## 2. CRUD OPERATIONS AVAILABLE

### 2.1 Campaigns Module

| Operation | Event | Handler | Success State | Notes |
|-----------|-------|---------|---------------|-------|
| **Create** | AddCampaign | _onAddCampaign | CampaignOperationSuccess | Generates UUID, sets timestamps |
| **Read (List)** | LoadCampaigns | _onLoadCampaigns | CampaignsLoaded | All campaigns without filter |
| **Read (Filtered)** | LoadCampaignsByStatus | _onLoadCampaignsByStatus | CampaignsLoaded | Filtered by status enum |
| **Read (Detail)** | LoadCampaignDetails | _onLoadCampaignDetails | CampaignDetailsLoaded | Single campaign by ID |
| **Update** | UpdateCampaign | _onUpdateCampaign | CampaignOperationSuccess | Updates modified fields |
| **Delete** | DeleteCampaign | _onDeleteCampaign | CampaignOperationSuccess | Cascades to metrics/posts |

### 2.2 Clients Module

| Operation | Event | Handler | Success State | Notes |
|-----------|-------|---------|---------------|-------|
| **Create** | AddClient | _onAddClient | ClientOperationSuccess | Generates UUID, sets timestamps |
| **Read (List)** | LoadClients | _onLoadClients | ClientsLoaded | All clients |
| **Read (Search)** | SearchClients | _onSearchClients | ClientsLoaded | Search by name/company |
| **Read (Detail)** | LoadClientDetails | _onLoadClientDetails | ClientDetailsLoaded | Single client by ID |
| **Update** | UpdateClient | _onUpdateClient | ClientOperationSuccess | Updates modified fields |
| **Delete** | DeleteClient | _onDeleteClient | ClientOperationSuccess | Cascades to campaigns |

### 2.3 Tasks Module

| Operation | Event | Handler | Success State | Notes |
|-----------|-------|---------|---------------|-------|
| **Create** | AddTask | _onAddTask | TaskOperationSuccess | Generates UUID, auto-sets due date |
| **Read (All)** | LoadTasks | _onLoadTasks | TasksLoaded | All tasks |
| **Read (Pending)** | LoadPendingTasks | _onLoadPendingTasks | TasksLoaded | Where is_completed = false |
| **Read (Completed)** | LoadCompletedTasks | _onLoadCompletedTasks | TasksLoaded | Where is_completed = true |
| **Update** | UpdateTask | _onUpdateTask | TaskOperationSuccess | Updates modified fields |
| **Delete** | DeleteTask | _onDeleteTask | TaskOperationSuccess | Soft delete (marks completed) |
| **Toggle Status** | ToggleTaskCompletion | _onToggleTaskCompletion | TasksLoaded | Marks completed/incomplete |

### 2.4 Analytics Module (Read-Only)

| Operation | Event | Handler | Success State | Notes |
|-----------|-------|---------|---------------|-------|
| **Load Analytics** | LoadAnalytics | _onLoadAnalytics | AnalyticsLoaded | 7-day metrics + aggregated |
| **Load Campaign Analytics** | LoadCampaignAnalytics | _onLoadCampaignAnalytics | CampaignAnalyticsLoaded | Metrics for specific campaign |

### 2.5 Dashboard Module (Read-Only)

| Operation | Event | Handler | Success State | Notes |
|-----------|-------|---------|---------------|-------|
| **Load Dashboard** | LoadDashboard | _onLoadDashboard | DashboardLoaded | Metrics + recent activities |
| **Refresh Dashboard** | RefreshDashboard | _onRefreshDashboard | DashboardLoaded | Manual refresh |

---

## 3. DATA RELATIONSHIPS AND SCHEMA

### 3.1 Database Tables and Foreign Keys

```
CLIENTS (1)
  ├─ CAMPAIGNS (Many) [FK: client_id -> id, ON DELETE CASCADE]
  │   ├─ CAMPAIGN_METRICS (Many) [FK: campaign_id -> id, ON DELETE CASCADE]
  │   ├─ SCHEDULED_POSTS (Many) [FK: campaign_id -> id, ON DELETE CASCADE]
  │   └─ TASKS (Many) [FK: campaign_id -> id, ON DELETE SET NULL]
  └─ No direct relationship to TASKS (orphaned tasks allowed)

TASKS
  └─ May reference CAMPAIGNS (optional, campaign_id can be NULL)
```

### 3.2 Table Structure

**CLIENTS**
- id (TEXT, PRIMARY KEY)
- name (TEXT, NOT NULL)
- company (TEXT, NOT NULL)
- email (TEXT)
- phone (TEXT)
- instagram_handle (TEXT)
- facebook_page (TEXT)
- twitter_handle (TEXT)
- youtube_channel (TEXT)
- logo_url (TEXT)
- created_at (INTEGER, NOT NULL) - millisecondsSinceEpoch
- updated_at (INTEGER, NOT NULL) - millisecondsSinceEpoch
- Index: None explicitly created

**CAMPAIGNS**
- id (TEXT, PRIMARY KEY)
- client_id (TEXT, NOT NULL, FK)
- name (TEXT, NOT NULL)
- description (TEXT)
- status (TEXT, NOT NULL) - "draft", "active", "paused", "completed"
- platform (TEXT, NOT NULL) - "instagram", "facebook", "twitter", "youtube", "multi"
- start_date (INTEGER, NOT NULL) - millisecondsSinceEpoch
- end_date (INTEGER) - millisecondsSinceEpoch
- budget (REAL)
- target_reach (INTEGER)
- created_at (INTEGER, NOT NULL)
- updated_at (INTEGER, NOT NULL)
- Indexes: idx_campaigns_client_id, idx_campaigns_status

**CAMPAIGN_METRICS**
- id (TEXT, PRIMARY KEY)
- campaign_id (TEXT, NOT NULL, FK)
- date (INTEGER, NOT NULL) - millisecondsSinceEpoch
- impressions (INTEGER, DEFAULT 0)
- reach (INTEGER, DEFAULT 0)
- engagement (INTEGER, DEFAULT 0)
- followers_gained (INTEGER, DEFAULT 0)
- clicks (INTEGER, DEFAULT 0)
- shares (INTEGER, DEFAULT 0)
- comments (INTEGER, DEFAULT 0)
- Index: idx_metrics_campaign_id

**SCHEDULED_POSTS**
- id (TEXT, PRIMARY KEY)
- campaign_id (TEXT, NOT NULL, FK)
- content (TEXT, NOT NULL)
- media_url (TEXT)
- platform (TEXT, NOT NULL)
- scheduled_time (INTEGER, NOT NULL) - millisecondsSinceEpoch
- status (TEXT, NOT NULL) - "draft", "scheduled", "published"
- created_at (INTEGER, NOT NULL)
- Index: idx_posts_campaign_id

**TASKS**
- id (TEXT, PRIMARY KEY)
- title (TEXT, NOT NULL)
- description (TEXT)
- campaign_id (TEXT) - FK (OPTIONAL, ON DELETE SET NULL)
- priority (TEXT, NOT NULL) - "low", "medium", "high", "urgent"
- due_date (INTEGER) - millisecondsSinceEpoch
- is_completed (INTEGER, DEFAULT 0) - 0 = false, 1 = true
- created_at (INTEGER, NOT NULL)
- completed_at (INTEGER)
- Indexes: idx_tasks_priority, idx_tasks_completed

### 3.3 Entity Relationships in Code

**CampaignEntity** relationships:
- `clientId` (String) → Links to ClientEntity
- One campaign belongs to exactly one client

**ClientEntity** relationships:
- Implicitly has many campaigns (no direct reference in entity)

**TaskEntity** relationships:
- `campaignId` (String, optional) → Can link to CampaignEntity
- Can exist without a campaign (general tasks)

**MetricEntity** relationships:
- `campaignId` (String) → Links to CampaignEntity
- One metric belongs to exactly one campaign

---

## 4. SPECIAL FEATURES AND OPERATIONS

### 4.1 Data Formatting and Extensions

**Numeric Extensions:**
```dart
int.abbreviated      // 1000+ → "1K", 1000000+ → "1M"
int.withCommas       // 1000 → "1,000"
double.currency      // 15000.0 → "$15,000.00"
```

**Date Extensions:**
```dart
DateTime.formatted       // "Mar 15, 2024"
DateTime.shortDate       // "3/15"
DateTime.relativeDate    // "2 hours ago", "Today", "Yesterday"
```

**String Extensions:**
```dart
String.capitalize   // "draft" → "Draft"
```

### 4.2 Task-Specific Logic

**Task Computed Properties:**
```dart
bool isOverdue   // dueDate < now && !isCompleted
bool isDueToday  // dueDate == today && !isCompleted
```

**Task Status Behavior:**
- Completion sets `completedAt` timestamp
- Can toggle completion status on/off
- Default due date when creating: DateTime.now() + 1 day
- Priority levels: Low, Medium, High, Urgent

### 4.3 Analytics Computed Properties

**MetricEntity:**
```dart
double engagementRate   // (engagement / reach) * 100
double clickThroughRate // (clicks / impressions) * 100
```

**AggregatedMetrics:**
```dart
avgEngagementRate    // Average across all metrics
avgClickThroughRate  // Average across all metrics
```

### 4.4 Dashboard Metrics

**DashboardMetrics calculates:**
- totalClients (COUNT of clients)
- activeCampaigns (COUNT where status = "active")
- pendingTasks (COUNT where is_completed = 0)
- totalReach (SUM of reach from all campaign metrics)
- reachGrowth (% change in reach, trend indicator)
- engagementGrowth (% change in engagement, trend indicator)
- followersGrowth (% change in followers, trend indicator)

### 4.5 Search Functionality

**Clients Search:**
- Searches in: client name, company name
- Real-time filtering
- Can be cleared with "Clear" button
- Maintains search query in state

### 4.6 Activity Timeline

**Activity Types:**
1. CampaignCreated - new campaign created
2. CampaignCompleted - campaign status changed to completed
3. TaskCompleted - task marked as complete
4. ClientAdded - new client created
5. PostScheduled - new scheduled post created
6. MetricsUpdated - campaign metrics updated

Each activity has:
- Unique icon and color per type
- Title (action description)
- Subtitle (resource details)
- Timestamp (relative format: "2 hours ago")

---

## 5. NAVIGATION PATTERNS

### 5.1 Navigation Architecture
- **Main Navigation:** BottomNavigationBar with 5 tabs
- **Navigation Type:** Stack-based (Navigator.push/pop)
- **State Preservation:** IndexedStack keeps tab states alive
- **No GoRouter:** Uses standard Material Navigator

### 5.2 Navigation Flows

```
MainShell (IndexedStack)
├── DashboardPage
├── CampaignsPage
│   ├── → CampaignDetailsPage
│   │   ├── → AddEditCampaignPage (Edit)
│   │   └── [Delete with confirmation]
│   └── → AddEditCampaignPage (Create)
├── ClientsPage
│   ├── → ClientDetailsPage
│   │   ├── → AddEditClientPage (Edit)
│   │   └── [Delete with confirmation]
│   └── → AddEditClientPage (Create)
├── AnalyticsPage (no sub-navigation)
└── TasksPage
    ├── [Create via dialog]
    ├── [Toggle completion]
    └── [Delete via slidable]
```

### 5.3 Modal and Dialog Navigation
- **Add Task:** AlertDialog from TasksPage
- **Delete Confirmation:** AlertDialog (Campaigns, Clients, Tasks)
- **Date Picker:** showDatePicker (1920-2030 range)

### 5.4 State Passing Between Screens
- Campaign entity passed to CampaignDetailsPage for optimization
- Client entity passed to ClientDetailsPage for optimization
- Search query stored in state for pagination/filtering

---

## 6. STATE MANAGEMENT APPROACH

### 6.1 BLoC Pattern Implementation

**Architecture Layers:**
1. **Presentation Layer:** Pages + Widgets
   - BlocBuilder for state listening
   - BlocListener for side effects
   - BlocConsumer for both
2. **Domain Layer:** Entities + Repository interfaces
3. **Data Layer:** Models + Repositories + Datasources

**BLoC Instances:**
- DashboardBloc
- CampaignBloc
- ClientBloc
- AnalyticsBloc
- TaskBloc

### 6.2 State Management Pattern

**Event → Handler → State Flow:**
```
User Action
  ↓
Event (immutable, extends CampaignEvent/ClientEvent/etc.)
  ↓
BLoC Handler (async, calls repository)
  ↓
Emit State (immutable, extends XxxState)
  ↓
UI Rebuilds (BlocBuilder listens to state)
```

### 6.3 Common BLoC States

**Loading State:**
- Emitted at start of async operation
- Triggers LoadingIndicator widget
- Prevents duplicate requests

**Success State:**
- Emitted after successful operation
- Data payload included (list, single item, or message)
- Triggers UI update or snackbar

**Error State:**
- Emitted on exception
- Contains error message
- Triggers ErrorView with retry button

**Initial State:**
- Starting state before any event
- No data, no error

### 6.4 Dependency Injection Setup

**Service Locator Pattern:**
```dart
// In injection.dart
GetIt getIt = GetIt.instance;

// Registered as singletons:
- DatabaseService
- All repositories (campaign, client, task, analytics, dashboard)
- All BLoCs
```

**BLoC Creation:**
```dart
BlocProvider<CampaignBloc>(
  create: (_) => getIt<CampaignBloc>(),
)
```

### 6.5 Side Effects and Snackbars

**OperationSuccess State:**
- Used in BlocListener
- Triggers snackbar or navigation
- Example: "Campaign added successfully"

**Error State:**
- Triggers ErrorView with retry option
- OR: Triggers snackbar (in BlocListener)

**Confirmation Dialogs:**
- User confirms delete
- BLoC adds DeleteEvent
- BLoC emits OperationSuccess
- Navigation pops screen

---

## 7. TESTING SCOPE AND TEST CASES

### 7.1 Functional Testing

#### Dashboard Screen Tests
1. [ ] Dashboard loads on app startup
2. [ ] Dashboard shows correct greeting based on time of day
3. [ ] Current date displays correctly
4. [ ] Metrics grid displays: client count, active campaigns, pending tasks, total reach
5. [ ] Growth trends display with correct +/- indicators
6. [ ] Recent activity items display in correct order (newest first)
7. [ ] Pull-to-refresh updates all metrics
8. [ ] Loading state shows spinner
9. [ ] Error state shows error message with retry button
10. [ ] Retry button re-fetches dashboard data

#### Campaign List Tests
11. [ ] Campaigns list loads on tab selection
12. [ ] Campaign cards display name, status, platform, date, budget, reach
13. [ ] Tab filtering works: All, Active, Draft, Completed
14. [ ] Tap campaign card opens campaign details page
15. [ ] FAB button opens add campaign dialog
16. [ ] Empty state shows when no campaigns exist
17. [ ] Pull-to-refresh reloads campaign list
18. [ ] Status chip displays correct color for each status
19. [ ] Platform badge shows correct platform icon
20. [ ] Budget displays in currency format

#### Campaign Details Tests
21. [ ] Campaign details page loads campaign data
22. [ ] Campaign name and description display correctly
23. [ ] Campaign status is shown in chip with correct color
24. [ ] Platform badge displays
25. [ ] Metrics cards show: Total Reach, Engagement, Clicks
26. [ ] Campaign details card shows: start date, end date, budget, target reach, created/updated dates
27. [ ] Engagement Over Time chart renders correctly
28. [ ] Edit button navigates to edit campaign page
29. [ ] Delete button shows confirmation dialog
30. [ ] Confirming delete removes campaign and navigates back

#### Add/Edit Campaign Tests
31. [ ] Campaign name field is required
32. [ ] Campaign name accepts text input
33. [ ] Description field is optional
34. [ ] Client dropdown loads all clients
35. [ ] Client selection is required
36. [ ] Platform dropdown shows all 5 options
37. [ ] Status dropdown shows all 4 options
38. [ ] Start date picker opens and allows date selection
39. [ ] End date picker is optional with clear button
40. [ ] Budget field accepts numeric input with currency symbol
41. [ ] Target reach field accepts numeric input with "people" suffix
42. [ ] Form validation prevents submission with empty required fields
43. [ ] Creating campaign generates UUID and timestamps
44. [ ] Updating campaign preserves original timestamps
45. [ ] Success shows snackbar and navigates back
46. [ ] Error shows error state

#### Client List Tests
47. [ ] Clients list loads on tab selection
48. [ ] Client cards display avatar, name, company, social icons
49. [ ] Search bar filters clients in real-time
50. [ ] Search with empty text shows all clients
51. [ ] Clear button in search empties search
52. [ ] Tap client card opens client details page
53. [ ] FAB button opens add client dialog
54. [ ] Empty state shows when no clients exist
55. [ ] Search empty state shows "No Results Found"
56. [ ] Pull-to-refresh reloads client list
57. [ ] Social media icons show only for connected platforms

#### Client Details Tests
58. [ ] Client details page loads client data
59. [ ] Profile header shows avatar and client info
60. [ ] "Client since" date displays correctly
61. [ ] Contact info card shows email and phone (if available)
62. [ ] Social profiles card shows only if profiles exist
63. [ ] Social handles display with correct @ symbols
64. [ ] Campaigns section shows up to 3 recent campaigns
65. [ ] Edit button navigates to edit client page
66. [ ] Delete button shows confirmation dialog
67. [ ] Confirming delete removes client and cascades to campaigns

#### Add/Edit Client Tests
68. [ ] Client name field is required
69. [ ] Company name field is required
70. [ ] Email field is optional with email validation
71. [ ] Phone field is optional with phone validation
72. [ ] Social media handles show correct color icons
73. [ ] Creating client generates UUID and timestamps
74. [ ] Updating client preserves original timestamps
75. [ ] Success shows snackbar and navigates back
76. [ ] Empty optional fields are saved as null

#### Analytics Page Tests
77. [ ] Analytics page loads metrics data
78. [ ] Avg. Engagement Rate card displays percentage
79. [ ] Avg. CTR card displays percentage
80. [ ] Engagement Trend chart renders line chart
81. [ ] Reach by Day chart renders bar chart
82. [ ] Total metrics summary shows all 7 metrics
83. [ ] Numbers are formatted with commas
84. [ ] Pull-to-refresh updates all charts
85. [ ] Charts handle empty data gracefully
86. [ ] Chart axes and labels display correctly

#### Tasks Page Tests
87. [ ] Tasks list loads on tab selection
88. [ ] Task cards display title, description, priority, due date
89. [ ] Filter menu shows: All, Pending, Completed
90. [ ] Filter correctly shows/hides completed tasks
91. [ ] Checkbox toggles task completion status
92. [ ] Completed tasks show strikethrough
93. [ ] Priority badges display correct color per level
94. [ ] Overdue tasks show "Overdue" with red color
95. [ ] Due today shows "Due Today" with orange color
96. [ ] Future dates show formatted date
97. [ ] Delete action (swipe) removes task
98. [ ] FAB button opens add task dialog
99. [ ] Empty state shows when no tasks
100. [ ] Pull-to-refresh reloads tasks

#### Add Task Dialog Tests
101. [ ] Task title field is required
102. [ ] Description field is optional
103. [ ] Priority dropdown shows all 4 levels
104. [ ] Default priority is Medium
105. [ ] Dialog closes on cancel
106. [ ] Task creation sets due date to tomorrow
107. [ ] Success shows snackbar
108. [ ] Task appears in list after creation

### 7.2 State Management Testing

#### BLoC Event/State Tests
109. [ ] LoadCampaigns event loads all campaigns
110. [ ] LoadCampaignsByStatus filters by status
111. [ ] AddCampaign event creates new campaign
112. [ ] UpdateCampaign event updates existing campaign
113. [ ] DeleteCampaign event removes campaign
114. [ ] CampaignError state displays error message
115. [ ] Similar tests for ClientBloc, TaskBloc

#### Data Flow Tests
116. [ ] Campaign creation triggers LoadCampaigns event
117. [ ] Campaign deletion triggers LoadCampaigns event
118. [ ] Task completion updates task in database
119. [ ] Search results update in real-time

### 7.3 Validation Testing

#### Campaign Validation
120. [ ] Campaign name cannot be empty
121. [ ] Client selection is required
122. [ ] Platform selection is required
123. [ ] Status selection is required
124. [ ] Start date is required
125. [ ] Budget must be valid number if provided
126. [ ] Target reach must be valid number if provided
127. [ ] End date can be null (optional)

#### Client Validation
128. [ ] Client name cannot be empty
129. [ ] Company name cannot be empty
130. [ ] Email must be valid if provided
131. [ ] Phone validation works if provided
132. [ ] Instagram/Twitter handles must match regex if provided
133. [ ] Social media fields can be empty (optional)

### 7.4 Data Persistence Testing

134. [ ] Campaign data persists after app restart
135. [ ] Client data persists after app restart
136. [ ] Task data persists after app restart
137. [ ] Metric data persists after app restart
138. [ ] Deleted campaigns are removed from database
139. [ ] Deleted clients cascade delete campaigns
140. [ ] Updated timestamps reflect changes

### 7.5 Edge Cases and Error Handling

141. [ ] Opening app with no data shows empty states correctly
142. [ ] Network error gracefully shows error view
143. [ ] Task with no due date doesn't show due badge
144. [ ] Campaign with no metrics shows "No data" gracefully
145. [ ] Client with no social profiles doesn't show social card
146. [ ] Campaign with very long name truncates properly
147. [ ] Task with very long description truncates to 2 lines
148. [ ] Large numbers format correctly (millions, billions)

### 7.6 Navigation Testing

149. [ ] Back button on details page returns to list
150. [ ] Edit screen back button cancels edit
151. [ ] Dialog cancel button closes dialog
152. [ ] Successful submission navigates back
153. [ ] Tab switching preserves state (IndexedStack)
154. [ ] Tab switching preserves scroll position
155. [ ] Deep linking (if implemented) works correctly

### 7.7 UI/UX Testing

156. [ ] Loading spinner shows during data fetch
157. [ ] Snackbars display success messages
158. [ ] Error messages are user-friendly
159. [ ] Button states (enabled/disabled) correct
160. [ ] Form fields show validation errors
161. [ ] Cards and containers have correct shadows
162. [ ] Text colors meet accessibility standards
163. [ ] Icons display correctly
164. [ ] Charts are readable and properly scaled
165. [ ] Fonts are readable at all sizes

### 7.8 Performance Testing

166. [ ] App loads in < 2 seconds
167. [ ] Switching tabs is smooth (no jank)
168. [ ] Scrolling lists is smooth
169. [ ] Charts animate smoothly
170. [ ] Search updates in real-time without lag
171. [ ] Database queries are indexed and fast
172. [ ] Large lists (100+ items) scroll smoothly

### 7.9 Data Integrity Testing

173. [ ] Campaign cannot be created without client
174. [ ] Campaign deletion removes associated metrics
175. [ ] Client deletion removes associated campaigns
176. [ ] Task can exist without campaign (optional FK)
177. [ ] Foreign key constraints enforced
178. [ ] Duplicate IDs are not possible (UUID)
179. [ ] Timestamps are always set

### 7.10 Integration Testing

180. [ ] Creating client → Creating campaign for client works
181. [ ] Viewing client details → Shows client's campaigns
182. [ ] Deleting client → Cascades to delete campaigns
183. [ ] Viewing campaign details → Shows analytics for campaign
184. [ ] Dashboard metrics update when new data added
185. [ ] Activity timeline updates in real-time
186. [ ] Task completion updates pending count on dashboard

---

## 8. PRE-SEEDED TEST DATA

The app includes sample data for testing:

**Clients (4):**
1. Ahmed Al-Rashid - Riyadh Restaurant Group
2. Fatima Hassan - Jeddah Fashion House
3. Omar Khalid - TechStart Solutions
4. Layla Mohammed - Wellness Center KSA

**Campaigns (5):**
1. Ramadan Special Menu Launch (Active, Multi) - Restaurant
2. Summer Collection 2024 (Active, Instagram) - Fashion
3. Product Demo Series (Active, YouTube) - Tech
4. Mental Health Awareness (Completed, Twitter) - Wellness
5. Customer Loyalty Program (Draft, Facebook) - Restaurant

**Tasks (6):**
1. Review campaign analytics report (High priority, Tomorrow) - with campaign
2. Create content calendar (Urgent priority, Today) - with campaign
3. Schedule product demo video (Medium priority, Next week) - with campaign
4. Client meeting preparation (High priority, Tomorrow) - no campaign
5. Update brand guidelines (Low priority, Next week) - no campaign
6. Respond to customer inquiries (Medium, Today, Completed) - with campaign

**Metrics (7 days):**
- Campaign 1: Impressions 8000+, Reach 5000+, Engagement 400+
- Campaign 2: Impressions 15000+, Reach 10000+, Engagement 1200+
- Campaign 3: Impressions 5000+, Reach 3500+, Engagement 600+

---

## 9. API AND DATABASE OPERATIONS

### 9.1 Repository Methods

**CampaignRepository:**
```dart
Future<List<CampaignEntity>> getAllCampaigns()
Future<List<CampaignEntity>> getCampaignsByStatus(CampaignStatusEnum status)
Future<CampaignEntity?> getCampaignById(String id)
Future<void> addCampaign(CampaignEntity campaign)
Future<void> updateCampaign(CampaignEntity campaign)
Future<void> deleteCampaign(String id)
```

**ClientRepository:**
```dart
Future<List<ClientEntity>> getAllClients()
Future<List<ClientEntity>> searchClients(String query)
Future<ClientEntity?> getClientById(String id)
Future<void> addClient(ClientEntity client)
Future<void> updateClient(ClientEntity client)
Future<void> deleteClient(String id)
```

**TaskRepository:**
```dart
Future<List<TaskEntity>> getAllTasks()
Future<List<TaskEntity>> getPendingTasks()
Future<List<TaskEntity>> getCompletedTasks()
Future<void> addTask(TaskEntity task)
Future<void> updateTask(TaskEntity task)
Future<void> deleteTask(String id)
Future<void> toggleTaskCompletion(String id, bool isCompleted)
```

**AnalyticsRepository:**
```dart
Future<List<MetricEntity>> getAllRecentMetrics(int days)
Future<AggregatedMetrics> getAggregatedMetrics()
Future<List<MetricEntity>> getMetricsByCampaignId(String campaignId)
```

**DashboardRepository:**
```dart
Future<DashboardMetrics> getDashboardMetrics()
Future<List<RecentActivity>> getRecentActivities()
```

---

## 10. KNOWN LIMITATIONS AND FUTURE ENHANCEMENTS

### Current Limitations:
- No API integration (SQLite only)
- No authentication/authorization
- No image uploads
- No offline sync
- No push notifications
- No report generation/export
- No dark mode theme
- No multi-language support

### Future Enhancements (from README):
- API integration for real-time data
- Push notifications for tasks
- Image upload for posts
- Report generation and export
- Multi-language support
- Dark mode theme
- Offline sync capabilities

---

## 11. KEY TESTING TIPS

1. **Use Pre-seeded Data:** App comes with 4 clients, 5 campaigns, and tasks pre-loaded for testing
2. **Test Cascading Deletes:** Deleting client should also delete their campaigns
3. **Test Filters:** Campaign status filters and task completion filters
4. **Test Charts:** Analytics page has 2 charts (line and bar) - verify rendering
5. **Test Validations:** Form fields have validators - test invalid input
6. **Test Search:** Real-time search on clients page
7. **Test State Persistence:** Switching tabs maintains state
8. **Test Date Picking:** Custom date pickers in campaign form
9. **Test Metrics Calculation:** Engagement rate = (engagement/reach)*100
10. **Test Timestamps:** All operations should update "Last Updated" field

