# Services Layer - Quick Reference Guide

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER (UI)                     │
│              (Pages, Widgets, BLoC Event Emission)              │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                  STATE MANAGEMENT (BLoC Layer)                  │
│  CampaignBloc  ClientBloc  TaskBloc  AnalyticsBloc  DashboardBloc│
│        │            │         │           │              │      │
│        └────────────┴─────────┴───────────┴──────────────┘      │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                   REPOSITORY LAYER (Data Access)                │
│  CampaignRepo  ClientRepo  TaskRepo  AnalyticsRepo  DashboardRepo│
│        │            │         │           │              │      │
│        └────────────┴─────────┴───────────┴──────────────┘      │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│              LOCAL DATASOURCE LAYER (Local Data)                │
│  Campaign  Client  Task  Analytics  Dashboard  Local Datasources│
│        │      │      │       │           │      (Implement)    │
│        └──────┴──────┴───────┴───────────┘                      │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE SERVICE                             │
│              (DatabaseService - SQLite)                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Services Summary

### 1. DatabaseService
- **Location**: `/lib/shared/services/database_service.dart`
- **Type**: Singleton (created once, shared globally)
- **Responsibility**: 
  - Initialize SQLite database
  - Manage database connections
  - Provide database instance to datasources
  - Handle database lifecycle

**Key Methods**:
- `initialize()` - Initialize database on app startup
- `database` (getter) - Get database instance
- `closeDatabase()` - Close connection on app close

**Issues**:
- ❌ No error handling in initialize()
- ❌ No transaction support exposed
- ❌ No migration strategy
- ❌ No backup/restore functionality

---

### 2. Dependency Injection (GetIt)
- **Location**: `/lib/injection.dart`
- **Framework**: GetIt v7.6.4
- **Setup Pattern**:
  1. Initialize DatabaseService (Singleton)
  2. Register DataSources (LazySingleton)
  3. Register Repositories (LazySingleton)
  4. Register BLoCs (Factory)

**Key Registration**:
```dart
Future<void> configureDependencies() async {
  // 1. Services
  final databaseService = DatabaseService();
  await databaseService.initialize();
  getIt.registerSingleton<DatabaseService>(databaseService);
  
  // 2. DataSources
  getIt.registerLazySingleton<CampaignLocalDataSource>(
    () => CampaignLocalDataSourceImpl(getIt()),
  );
  
  // 3. Repositories
  getIt.registerLazySingleton<CampaignRepository>(
    () => CampaignRepositoryImpl(getIt()),
  );
  
  // 4. BLoCs
  getIt.registerFactory<CampaignBloc>(
    () => CampaignBloc(getIt()),
  );
}
```

---

## BLoC Pattern Implementation

### Standard BLoC Structure

```dart
// Events (User Actions)
class LoadCampaigns extends CampaignEvent {}
class AddCampaign extends CampaignEvent {
  final CampaignEntity campaign;
  const AddCampaign(this.campaign);
}

// States (UI Updates)
class CampaignLoading extends CampaignState {}
class CampaignsLoaded extends CampaignState {
  final List<CampaignEntity> campaigns;
  const CampaignsLoaded(this.campaigns);
}
class CampaignError extends CampaignState {
  final String message;
  const CampaignError(this.message);
}

// BLoC
class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignRepository _repository;
  
  CampaignBloc(this._repository) : super(CampaignInitial()) {
    on<LoadCampaigns>(_onLoadCampaigns);
    on<AddCampaign>(_onAddCampaign);
  }
  
  Future<void> _onLoadCampaigns(
    LoadCampaigns event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());
    try {
      final campaigns = await _repository.getAllCampaigns();
      emit(CampaignsLoaded(campaigns: campaigns));
    } catch (e) {
      emit(CampaignError(e.toString()));  // ❌ ISSUE: Raw exception
    }
  }
}
```

---

## All Services & Classes

### Service Classes (1)
1. **DatabaseService** - SQLite database management

### State Management BLoCs (5)
1. **CampaignBloc** - Campaign CRUD operations
2. **ClientBloc** - Client CRUD operations
3. **TaskBloc** - Task CRUD operations
4. **AnalyticsBloc** - Analytics/metrics display
5. **DashboardBloc** - Dashboard metrics & activities

### Data Sources (5)
1. **CampaignLocalDataSource** - Campaign queries
   - getAllCampaigns(), getCampaignsByStatus(), getCampaignById(), addCampaign(), updateCampaign(), deleteCampaign(), getActiveCampaignsCount()
   
2. **ClientLocalDataSource** - Client queries
   - getAllClients(), getClientById(), addClient(), updateClient(), deleteClient(), searchClients()
   
3. **TaskLocalDataSource** - Task queries
   - getAllTasks(), getPendingTasks(), getCompletedTasks(), getTasksByPriority(), getTasksByCampaignId(), addTask(), updateTask(), deleteTask(), toggleTaskCompletion()
   
4. **AnalyticsLocalDataSource** - Metrics queries
   - getMetricsByCampaignId(), getMetricsByDateRange(), getAllRecentMetrics(), getTotalMetrics(), insertMetric()
   
5. **DashboardLocalDataSource** - Dashboard data
   - getDashboardMetrics(), getRecentActivities()

### Repositories (5)
1. **CampaignRepository** - Campaign business logic
2. **ClientRepository** - Client business logic
3. **TaskRepository** - Task business logic
4. **AnalyticsRepository** - Analytics business logic
5. **DashboardRepository** - Dashboard business logic

### Models (5) - Data Serialization
1. **CampaignModel** - Campaign data mapping
2. **ClientModel** - Client data mapping
3. **TaskModel** - Task data mapping
4. **MetricModel** - Metrics data mapping
5. No model for Dashboard (uses domain entities directly)

### Database Tables (5)
```sql
1. clients (11 columns) - indexed by id, created_at
2. campaigns (11 columns) - indexed by id, client_id, status
3. campaign_metrics (9 columns) - indexed by id, campaign_id
4. scheduled_posts (8 columns) - indexed by id, campaign_id
5. tasks (9 columns) - indexed by id, priority, is_completed
```

---

## Error Handling - Current vs Recommended

### Current (❌ PROBLEMATIC)
```dart
try {
  final data = await repository.getData();
  emit(SuccessState(data));
} catch (e) {
  emit(ErrorState(e.toString()));  // Raw exception to UI
}
```

### Recommended (✓ PROPER)
```dart
// 1. Create Result wrapper
class Result<T> {
  final T? data;
  final Failure? failure;
  
  bool get isSuccess => data != null;
  bool get isFailure => failure != null;
  
  Result.ok(this.data) : failure = null;
  Result.error(this.failure) : data = null;
}

// 2. Use in repository
Future<Result<List<CampaignEntity>>> getAllCampaigns() async {
  try {
    final campaigns = await _datasource.getAllCampaigns();
    return Result.ok(campaigns);
  } on DatabaseException catch (e) {
    return Result.error(DatabaseFailure(e.message));
  } catch (e) {
    return Result.error(UnexpectedFailure('$e'));
  }
}

// 3. Use in BLoC
try {
  final result = await _repository.getAllCampaigns();
  if (result.isSuccess) {
    emit(CampaignsLoaded(campaigns: result.data!));
  } else {
    final message = _mapFailureToMessage(result.failure!);
    emit(CampaignError(message));
  }
} catch (e) {
  emit(CampaignError('An unexpected error occurred'));
}
```

---

## Data Flow Example: Loading Campaigns

```
USER ACTION
     │
     ▼
┌─────────────────────────────┐
│ UI: BlocBuilder<CampaignBloc>
│ Calls: add(LoadCampaigns())
└────────┬────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ CampaignBloc (State Management)
│ Event: LoadCampaigns
│ Action: _onLoadCampaigns()
│ 1. emit(CampaignLoading)
│ 2. calls _repository.getAllCampaigns()
└────────┬────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ CampaignRepository (Repository)
│ Method: getAllCampaigns()
│ Action: calls _datasource.getAllCampaigns()
└────────┬────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ CampaignLocalDataSource (Data Access)
│ Method: getAllCampaigns()
│ 1. Get database instance
│ 2. Execute: db.query('campaigns', orderBy: 'updated_at DESC')
│ 3. Map results to CampaignModel objects
└────────┬────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ DatabaseService (Database)
│ SQLite: SELECT * FROM campaigns ORDER BY updated_at DESC
│ Returns: List<Map<String, dynamic>>
└────────┬────────────────────────────────────────┘
         │
         ▼ (returns data)
         
(Reverse path)

         │
         ▼
┌─────────────────────────────────────────────────┐
│ CampaignLocalDataSource
│ Returns: List<CampaignModel>
└────────┬────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ CampaignRepository
│ Returns: List<CampaignEntity>
└────────┬────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ CampaignBloc
│ 3. emit(CampaignsLoaded(campaigns: data))
└────────┬────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│ UI: BlocBuilder rebuilds with CampaignsLoaded
│ Displays: List of campaigns
└─────────────────────────────────────────────────┘
```

---

## Health Check Checklist

- [ ] **Database Initialization**: Has error handling and fails gracefully
- [ ] **Type Safety**: All queries validate data before type casting
- [ ] **Error Handling**: All exceptions caught and mapped to Failures
- [ ] **Validation**: Input validation before database operations
- [ ] **Transactions**: Multi-step operations use database transactions
- [ ] **Logging**: All important operations logged for debugging
- [ ] **Testing**: Mockable datasources for unit tests
- [ ] **Caching**: Frequently accessed data cached in memory
- [ ] **Authentication**: User authentication and authorization implemented
- [ ] **API Integration**: Remote datasources for backend sync

**Current Status**: 0/10 ✗

---

## Next Steps (Priority Order)

### 1. CRITICAL - Error Handling Fix
**Time**: 4-6 hours
```
- Remove unused Failure classes OR use them properly
- Implement Either<Failure, T> pattern
- Update all datasources to catch exceptions
- Update all BLoCs to map exceptions to user messages
```

### 2. CRITICAL - Type Safety Fix
**Time**: 2-3 hours
```
- Add safe type casting to all datasources
- Add null checks in model fromMap() methods
- Add validation in model constructors
```

### 3. HIGH - Database Robustness
**Time**: 3-4 hours
```
- Add error handling to DatabaseService.initialize()
- Add transaction support for multi-step operations
- Add migration strategy for schema evolution
```

### 4. HIGH - Input Validation
**Time**: 3-4 hours
```
- Create Validator classes for each entity
- Validate in repositories before database operations
- Show meaningful error messages to users
```

### 5. MEDIUM - API Integration (when backend ready)
**Time**: 6-8 hours
```
- Add http/dio package
- Create ApiService
- Create RemoteDataSources
- Implement sync strategy
```

---

## Files to Review

**Core**:
- `/lib/injection.dart` - DI setup
- `/lib/shared/services/database_service.dart` - Database

**Datasources** (5):
- `/lib/features/campaigns/data/datasources/campaign_local_datasource.dart`
- `/lib/features/clients/data/datasources/client_local_datasource.dart`
- `/lib/features/tasks/data/datasources/task_local_datasource.dart`
- `/lib/features/analytics/data/datasources/analytics_local_datasource.dart`
- `/lib/features/dashboard/data/datasources/dashboard_local_datasource.dart`

**Repositories** (5):
- `/lib/features/campaigns/data/repositories/campaign_repository_impl.dart`
- `/lib/features/clients/data/repositories/client_repository_impl.dart`
- `/lib/features/tasks/data/repositories/task_repository_impl.dart`
- `/lib/features/analytics/data/repositories/analytics_repository_impl.dart`
- `/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart`

**BLoCs** (5):
- `/lib/features/campaigns/presentation/bloc/campaign_bloc.dart`
- `/lib/features/clients/presentation/bloc/client_bloc.dart`
- `/lib/features/tasks/presentation/bloc/task_bloc.dart`
- `/lib/features/analytics/presentation/bloc/analytics_bloc.dart`
- `/lib/features/dashboard/presentation/bloc/dashboard_bloc.dart`

**Error Handling**:
- `/lib/core/errors/failures.dart` - Defined but unused!

