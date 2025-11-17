# Flutter Campaign Manager - Issues Quick Reference

## Critical Issues (Must Fix Immediately)

### Issue #1: Campaign Details Edit Button - Critical Bug
- **Location:** `/lib/features/campaigns/presentation/pages/campaign_details_page.dart` (lines 46-57)
- **Problem:** Edit button only works when campaign is passed as parameter
- **Code:**
  ```dart
  if (widget.campaign != null) {
    Navigator.push(...)  // Only pushes if campaign passed initially
  }
  // Silent failure if campaign loaded from BLoC!
  ```
- **Fix:** Access campaign from BLoC state instead of widget property
- **Priority:** CRITICAL
- **Effort:** 1 hour

### Issue #2: Campaign Form - Missing Budget Validation
- **Location:** `/lib/features/campaigns/presentation/pages/add_edit_campaign_page.dart` (lines 207-215)
- **Problem:** Budget field accepts any input, no positive number validation
- **Current Code:**
  ```dart
  TextFormField(
    controller: _budgetController,
    keyboardType: TextInputType.number,
    // NO VALIDATOR!
  )
  ```
- **Fix:** Add `validator: Validators.positiveNumber()`
- **Priority:** HIGH
- **Effort:** 15 minutes

### Issue #3: Campaign Form - Missing Target Reach Validation
- **Location:** `/lib/features/campaigns/presentation/pages/add_edit_campaign_page.dart` (lines 217-225)
- **Problem:** Target reach field accepts any input, no validation
- **Fix:** Add `validator: Validators.positiveNumber()`
- **Priority:** HIGH
- **Effort:** 15 minutes

### Issue #4: Campaign Form - No End Date > Start Date Validation
- **Location:** `/lib/features/campaigns/presentation/pages/add_edit_campaign_page.dart` (lines 193-202)
- **Problem:** End date can be before start date
- **Fix:** Add cross-field validation in `_saveCampaign()` method
- **Code Pattern:**
  ```dart
  if (_endDate != null && _endDate!.isBefore(_startDate)) {
    ScaffoldMessenger.of(context).showSnackBar(...);
    return;
  }
  ```
- **Priority:** HIGH
- **Effort:** 1 hour

### Issue #5: Client Form - Missing Facebook Validation
- **Location:** `/lib/features/clients/presentation/pages/add_edit_client_page.dart` (lines 148-156)
- **Problem:** Facebook page field has no validation
- **Current Code:**
  ```dart
  TextFormField(
    controller: _facebookController,
    // NO VALIDATOR!
  )
  ```
- **Fix:** Add social handle or URL validator
- **Priority:** HIGH
- **Effort:** 30 minutes

### Issue #6: Client Form - Missing YouTube Validation
- **Location:** `/lib/features/clients/presentation/pages/add_edit_client_page.dart` (lines 170-178)
- **Problem:** YouTube channel field has no validation
- **Fix:** Add social handle or URL validator
- **Priority:** HIGH
- **Effort:** 30 minutes

### Issue #7: Tasks Form - Due Date Hardcoded
- **Location:** `/lib/features/tasks/presentation/pages/tasks_page.dart` (line 348)
- **Problem:** Due date always set to tomorrow, user can't choose
- **Current Code:**
  ```dart
  dueDate: DateTime.now().add(const Duration(days: 1)),
  ```
- **Fix:** Add date picker in dialog or use user-selected value
- **Priority:** HIGH
- **Effort:** 2-3 hours

### Issue #8: Client Details - "View All" Shows Snackbar Instead of Navigate
- **Location:** `/lib/features/clients/presentation/pages/client_details_page.dart` (lines 337-346)
- **Problem:** "View All" campaigns button shows snackbar message instead of navigating
- **Current Code:**
  ```dart
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Campaigns tab...'))
    );
  }
  ```
- **Fix:** Navigate to campaigns tab with client filter
- **Priority:** MEDIUM-HIGH
- **Effort:** 1 hour

---

## High Priority Issues (1-2 weeks)

### Issue #9: No Form Loading States
- **Affected Pages:** All form pages (Campaign, Client)
- **Problem:** No loading indicator while form is being submitted
- **Impact:** Users unsure if operation is in progress
- **Fix:** Wrap form in `LoadingOverlay` or add `FloatingActionButton` state
- **Effort:** 3 hours

### Issue #10: No Success Feedback After Save
- **Affected Pages:** All form pages
- **Problem:** Silent navigation after save, no confirmation message
- **Impact:** Users uncertain if save succeeded
- **Fix:** Show SnackBar before Navigator.pop()
- **Effort:** 2 hours

### Issue #11: No Search for Campaigns
- **Location:** `/lib/features/campaigns/presentation/pages/campaigns_page.dart`
- **Problem:** Clients page has search but campaigns don't
- **Impact:** Hard to find campaigns in long list
- **Fix:** Add search bar like ClientsPage
- **Effort:** 2-3 hours

### Issue #12: No Task Edit Functionality
- **Location:** `/lib/features/tasks/presentation/pages/tasks_page.dart`
- **Problem:** Can only create tasks, not edit them
- **Impact:** Users must delete and recreate to change task details
- **Fix:** Add edit option in task tile or separate edit page
- **Effort:** 3-4 hours

### Issue #13: Missing Form Unsaved Changes Warning
- **Affected Pages:** All form pages
- **Problem:** Users can lose data if they accidentally navigate back
- **Impact:** Data loss frustration
- **Fix:** Use `WillPopScope` or `PopScope` to warn before back
- **Effort:** 2 hours

### Issue #14: Campaign Details Edit Button Doesn't Update
- **Location:** `/lib/features/campaigns/presentation/pages/campaign_details_page.dart`
- **Problem:** Even after fixing button, chart doesn't update after edit
- **Impact:** Stale data after update
- **Fix:** Reload campaign details after return from edit
- **Effort:** 1 hour

---

## Medium Priority Issues (2-4 weeks)

### Issue #15: No Sort Options on Lists
- **Affected Pages:** Campaigns, Clients, Tasks
- **Problem:** Lists only filter, don't sort
- **Impact:** Can't organize by date, name, status
- **Fix:** Add sort menu to appbar
- **Effort:** 4 hours

### Issue #16: No Filter Options on Campaign List
- **Location:** `/lib/features/campaigns/presentation/pages/campaigns_page.dart`
- **Problem:** Campaigns tab-filter exists but no filter by client/platform
- **Impact:** Hard to find specific campaigns
- **Fix:** Add filter dialog or chip filters
- **Effort:** 3-4 hours

### Issue #17: No Accessibility Support
- **All Pages:** Missing semantic labels
- **Problem:** Screen readers can't read custom components
- **Impact:** App not accessible to blind/low-vision users
- **Missing Elements:**
  - No `Semantics` widgets
  - No `Tooltip` widgets
  - No keyboard navigation
  - No dark mode
- **Effort:** 8-12 hours

### Issue #18: No Responsive Design
- **All Pages:** Fixed layouts regardless of screen size
- **Problem:** Doesn't work well on tablets or landscape
- **Examples:**
  - `GridView.count(crossAxisCount: 2)` always 2 columns
  - Fixed font sizes
  - Fixed icon sizes
- **Fix:** Use `MediaQuery` and adaptive widgets
- **Effort:** 10-15 hours

### Issue #19: No Skeleton Screens During Loading
- **All Pages:** Generic spinner shown
- **Problem:** Loading state doesn't show shape of content
- **Impact:** Worse perceived performance
- **Fix:** Add skeleton screens for cards/lists
- **Effort:** 5 hours

### Issue #20: Analytics Page - No Date Range Filter
- **Location:** `/lib/features/analytics/presentation/pages/analytics_page.dart`
- **Problem:** Can't filter analytics by date range
- **Impact:** Can't compare time periods
- **Fix:** Add date range picker
- **Effort:** 3 hours

---

## Lower Priority Issues (Nice to Have)

### Issue #21: No Dark Mode
- **All Pages:** Light theme only
- **Effort:** 8 hours

### Issue #22: No Drag & Drop for Tasks
- **Tasks Page:** No reordering support
- **Effort:** 4 hours

### Issue #23: No Bulk Operations
- **All Pages:** Can't select multiple items
- **Effort:** 6 hours

### Issue #24: No Data Export
- **Analytics Page:** Can't export metrics
- **Effort:** 4 hours

### Issue #25: No Pagination
- **All Lists:** Load all items at once
- **Effort:** 5 hours

---

## Validation Gaps Summary

### Campaign Form Validation Issues
| Field | Current | Missing | Fix Effort |
|-------|---------|---------|------------|
| Name | Required ✓ | - | - |
| Description | None | - | - |
| Client | Manual check | FormField validator | 30 min |
| Platform | Enum ✓ | - | - |
| Status | Enum ✓ | - | - |
| Start Date | State only | Logic validation | 30 min |
| End Date | None | end > start | 1 hour |
| Budget | None | positiveNumber() | 15 min |
| Target Reach | None | positiveNumber() | 15 min |

### Client Form Validation Issues
| Field | Current | Missing | Fix Effort |
|-------|---------|---------|------------|
| Name | Required ✓ | maxLength | 30 min |
| Company | Required ✓ | maxLength | 30 min |
| Email | Conditional | - | - |
| Phone | Conditional | - | - |
| Instagram | socialHandle ✓ | - | - |
| Facebook | None | socialHandle or URL | 30 min |
| Twitter | socialHandle ✓ | - | - |
| YouTube | None | socialHandle or URL | 30 min |

### Task Form Validation Issues
| Field | Current | Missing | Fix Effort |
|-------|---------|---------|------------|
| Title | Manual check | Validators.required() | 1 hour |
| Description | None | maxLength | 1 hour |
| Priority | Enum ✓ | - | - |
| Due Date | Hardcoded | User selection | 2-3 hours |

---

## Code Example Fixes

### Fix #1: Add Budget Validation
**File:** `add_edit_campaign_page.dart`
```dart
// BEFORE
TextFormField(
  controller: _budgetController,
  keyboardType: TextInputType.number,
  // NO VALIDATOR
),

// AFTER
TextFormField(
  controller: _budgetController,
  keyboardType: TextInputType.number,
  validator: (value) {
    if (value?.isNotEmpty ?? false) {
      return Validators.positiveNumber(value);
    }
    return null;
  },
),
```

### Fix #2: Fix Campaign Details Edit Button
**File:** `campaign_details_page.dart`
```dart
// BEFORE
if (widget.campaign != null) {
  Navigator.push(...)
}

// AFTER
final campaign = widget.campaign ?? 
  (state is CampaignDetailsLoaded ? state.campaign : null);
  
if (campaign != null) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AddEditCampaignPage(campaign: campaign),
    ),
  );
}
```

### Fix #3: Add Date Range Validation
**File:** `add_edit_campaign_page.dart`
```dart
void _saveCampaign() {
  // ... existing validation ...
  
  // Add date validation
  if (_endDate != null && _endDate!.isBefore(_startDate)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('End date must be after start date'),
      ),
    );
    return;
  }
  
  // ... rest of save logic ...
}
```

---

## Test Cases for Fixes

### Validation Tests
```
Campaign Budget Field:
- [ ] Accept positive numbers (100, 1000.50)
- [ ] Reject negative numbers (-100)
- [ ] Reject zero (0)
- [ ] Reject non-numeric (abc, 12.34.56)
- [ ] Allow empty (optional)

Campaign Date Range:
- [ ] Accept end > start
- [ ] Reject end < start
- [ ] Reject end == start
- [ ] Allow same date for single-day campaign

Client Form Facebook:
- [ ] Accept valid handle (Facebook page name)
- [ ] Reject invalid characters
- [ ] Allow empty (optional)

Task Due Date:
- [ ] Show date picker
- [ ] Allow custom date selection
- [ ] Don't default to tomorrow
- [ ] Allow past dates
```

### Navigation Tests
```
Campaign Edit Flow:
- [ ] Navigate campaigns list -> campaign details
- [ ] Click edit button
- [ ] Verify edit page loads
- [ ] Make change, save
- [ ] Verify change persists in details

Client "View All":
- [ ] Navigate clients -> client details
- [ ] Click "View All" campaigns
- [ ] Verify navigation to campaigns tab
- [ ] Verify client campaigns are shown
```

---

## Files Status

| File | Issues | Status |
|------|--------|--------|
| `dashboard_page.dart` | 2 | Good |
| `campaigns_page.dart` | 1 | Good |
| `campaign_details_page.dart` | 2 | Critical |
| `add_edit_campaign_page.dart` | 4 | High |
| `clients_page.dart` | 1 | Good |
| `client_details_page.dart` | 1 | Medium |
| `add_edit_client_page.dart` | 2 | High |
| `analytics_page.dart` | 1 | Medium |
| `tasks_page.dart` | 3 | High |
| `main_shell.dart` | 1 | Low |
| **Total Issues** | **18** | - |

---

## Recommended Action Items

### Immediate (Today)
1. Log campaign details edit button as critical bug
2. Review all validation gaps with team

### This Week
1. Fix budget validation
2. Fix reach validation
3. Fix campaign edit button
4. Fix date range validation
5. Fix Facebook/YouTube validation
6. Add task date picker

### Next Week
1. Add form loading states
2. Add success feedback
3. Fix client details navigation
4. Add search to campaigns
5. Add form unsaved warning

### Following Weeks
1. Add task edit functionality
2. Add sort/filter to lists
3. Implement accessibility features
4. Add responsive design support
5. Add skeleton screens

