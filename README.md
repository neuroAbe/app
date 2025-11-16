# Campaign Manager - Flutter App

A professional Social Media Campaign Manager application built with Flutter, demonstrating clean architecture, BLoC pattern, and modern Android development practices.

## Overview

This app is designed for social media marketing agencies to manage client campaigns, track analytics, schedule content, and monitor team tasks. Built to showcase Flutter expertise and understanding of the media marketing industry.

## Features

### Core Features
- **Dashboard** - Overview of key metrics, growth trends, and recent activities
- **Campaign Management** - Create, track, and manage marketing campaigns
- **Client Management** - Manage client profiles and their social media presence
- **Analytics Dashboard** - Interactive charts showing engagement, reach, and growth metrics
- **Task Management** - Track and manage marketing tasks with priorities and due dates

### Technical Highlights
- **Clean Architecture** - 3-layer architecture (Presentation, Domain, Data)
- **BLoC Pattern** - Robust state management using flutter_bloc
- **Dependency Injection** - Using get_it for service locator pattern
- **Local Database** - SQLite with sqflite for persistent storage
- **Professional UI/UX** - Material Design 3 with custom theming
- **Interactive Charts** - fl_chart for data visualization

## Architecture

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App configuration
├── injection.dart            # Dependency injection setup
├── core/                     # Shared utilities and widgets
│   ├── constants/           # App-wide constants
│   ├── theme/               # Theme configuration
│   ├── utils/               # Extensions and validators
│   ├── widgets/             # Reusable widgets
│   └── errors/              # Error handling
├── features/                 # Feature modules
│   ├── dashboard/           # Dashboard feature
│   ├── campaigns/           # Campaign management
│   ├── clients/             # Client management
│   ├── analytics/           # Analytics dashboard
│   └── tasks/               # Task management
└── shared/                   # Shared services
    └── services/            # Database and other services
```

Each feature follows clean architecture:
```
feature/
├── presentation/            # UI Layer
│   ├── bloc/               # State management
│   ├── pages/              # Screen widgets
│   └── widgets/            # Feature-specific widgets
├── domain/                  # Business Logic Layer
│   ├── entities/           # Business objects
│   └── repositories/       # Abstract data contracts
└── data/                    # Data Layer
    ├── models/             # Data transfer objects
    ├── repositories/       # Repository implementations
    └── datasources/        # Data source implementations
```

## Tech Stack

- **Framework:** Flutter 3.16+
- **Language:** Dart 3.2+
- **State Management:** flutter_bloc ^8.1.3
- **Dependency Injection:** get_it ^7.6.4
- **Local Storage:** sqflite ^2.3.0
- **Charts:** fl_chart ^0.65.0
- **Navigation:** Material Navigator
- **Architecture:** Clean Architecture + BLoC

## Getting Started

### Prerequisites
- Flutter SDK 3.16 or higher
- Android Studio / VS Code
- Android SDK 21+ (Android 5.0+)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd campaign_manager
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

4. Build release APK:
```bash
flutter build apk --release
```

## Database Schema

The app uses SQLite with 5 main tables:
- **clients** - Client information and social profiles
- **campaigns** - Marketing campaign data
- **campaign_metrics** - Performance metrics over time
- **scheduled_posts** - Content scheduling
- **tasks** - Task management

Pre-seeded with realistic sample data for demonstration.

## Key Design Decisions

### Why BLoC Pattern?
- Clear separation of UI and business logic
- Highly testable
- Scales well for complex applications
- Industry standard for Flutter apps

### Why Clean Architecture?
- Maintainable and scalable codebase
- Independent layers allow easy testing
- Business logic is framework-agnostic
- Easy to add new features or change implementations

### Why SQLite?
- Reliable local storage
- SQL query flexibility
- Works offline
- Easy migration path to remote API

## Interview Talking Points

1. **Architecture** - Clean Architecture ensures maintainability
2. **State Management** - BLoC provides predictable state changes
3. **Database Design** - Normalized schema with proper relationships
4. **UI/UX** - Material Design 3 with attention to detail
5. **Code Quality** - Consistent patterns, proper error handling
6. **Scalability** - Easy to add API integration, more features

## Future Enhancements

- [ ] API integration for real-time data
- [ ] Push notifications for tasks
- [ ] Image upload for posts
- [ ] Report generation and export
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Offline sync capabilities

## Screenshots

The app includes:
- Dashboard with metrics overview and growth trends
- Campaign list with filtering by status
- Client profiles with social media handles
- Analytics charts (engagement, reach, CTR)
- Task management with priorities and slidable actions

## Project Structure Benefits

- **Feature-based organization** - Easy to navigate and maintain
- **Consistent patterns** - Same structure across all features
- **Separation of concerns** - UI, business logic, and data are independent
- **Reusable components** - Core widgets can be used anywhere

## Author

Built to demonstrate professional Flutter development skills for Al-Graphy Media Marketing Company interview.

## License

This project is for demonstration purposes.
