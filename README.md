# Flutter BLoC Architecture

Enterprise-grade Flutter application built with **Clean Architecture + BLoC Pattern** — scalable, modular, and production-ready.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with feature-based modularization. Each feature is divided into three layers:

| Layer | Responsibility | Contains |
|-------|---------------|----------|
| **Data** | External communication | Datasources, Models, Repository Implementations |
| **Domain** | Business logic | Entities, Repository Interfaces, Use Cases |
| **Presentation** | UI & state | BLoC, Screens, Widgets |

### State Management
- **BLoC (Business Logic Component)** via `flutter_bloc`
- No `setState` for feature state — all managed through BLoC
- Equatable for immutable events and states

### Dependency Injection
- **get_it** service locator
- Centralized registration in `core/di/injection.dart`
- Layer-ordered: core → data → domain → presentation

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/            # Environment configuration (dev/staging/prod)
│   ├── constants/         # App strings, API constants, asset paths
│   ├── di/                # Dependency injection (get_it)
│   ├── errors/            # Failures (domain) & Exceptions (data)
│   ├── extensions/        # BuildContext, String, DateTime extensions
│   ├── network/           # Dio API client, endpoints, interceptors
│   ├── services/          # Navigation, notifications
│   ├── storage/           # Local & secure storage wrappers
│   ├── theme/             # Colors, typography, spacing, shadows, theme
│   ├── utils/             # Logger, validators, debouncer
│   └── widgets/           # Reusable UI components
│
├── features/
│   ├── auth/              # ✅ Full reference implementation
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   ├── models/
│   │   │   └── repository_impl/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── home/              # Stub — ready to implement
│   ├── profile/           # Stub — ready to implement
│   ├── chat/              # Stub — ready to implement
│   └── settings/          # Stub — ready to implement
│
├── routes/
│   ├── app_routes.dart    # Centralized route constants
│   └── route_generator.dart # Named route → screen mapping
│
├── app.dart               # Root MaterialApp widget
├── main.dart              # Default entry (delegates to dev)
├── main_dev.dart          # Development environment
└── main_prod.dart         # Production environment
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.29.0
- Dart SDK >= 3.5.0

### Setup
```bash
# Clone the repository
git clone <repo-url>
cd flutter_bloc_architecture

# Install dependencies
flutter pub get

# Run in development mode
flutter run

# Run in production mode
flutter run -t lib/main_prod.dart

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## 📐 Coding Standards

### Naming Conventions
| Type | Convention | Example |
|------|-----------|---------|
| Files & directories | `snake_case` | `auth_bloc.dart` |
| Classes, widgets, enums | `PascalCase` | `AuthBloc`, `LoginScreen` |
| Variables & methods | `camelCase` | `isLoading`, `fetchUser()` |

### Documentation
- DartDoc comments on all public classes, methods, and properties
- Explain purpose, not just what — describe *why*

### Performance Rules
- ✅ Use `const` constructors wherever possible
- ✅ Use `SizedBox` instead of `Container` for spacing
- ✅ Use `ListView.builder` instead of `Column` for lists
- ✅ Cache images with `cached_network_image`
- ❌ No hardcoded strings — use `AppStrings`
- ❌ No `print()` — use `AppLogger`
- ❌ No `setState` for feature state — use BLoC

### Navigation
```dart
// ✅ Correct — centralized named routes
Navigator.pushNamed(context, Routes.login);
context.pushNamed(Routes.dashboard);

// ❌ Incorrect — inline navigation
Navigator.push(context, MaterialPageRoute(...));
```

---

## 📦 Key Dependencies

| Category | Package | Purpose |
|----------|---------|---------|
| State Management | `flutter_bloc` | BLoC pattern |
| DI | `get_it` | Service locator |
| Networking | `dio` | HTTP client |
| Storage | `shared_preferences` | Key-value storage |
| Storage | `flutter_secure_storage` | Encrypted storage |
| Database | `drift` | SQLite ORM |
| Localization | `easy_localization` | i18n support |
| Firebase | `firebase_core`, `firebase_auth` | Auth & services |
| UI | `google_fonts`, `shimmer`, `lottie` | Design polish |
| Utils | `logger`, `equatable`, `connectivity_plus` | Utilities |

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📝 License

This project is private and not published to pub.dev.


## Learning

1. Rebase completed.
2. Cherry pick learning.
