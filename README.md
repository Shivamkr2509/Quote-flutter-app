# Quote of the Day

A beautiful, modern, and resilient Flutter application that fetches and displays inspirational quotes. This app demonstrates high-quality Flutter development practices, including state management with Provider, elegant UI design, smooth error handling, and cross-platform native sharing capabilities.

## Features

- 🎨 **Premium UI/UX**: Stunning modern design featuring a dynamic gradient background and glassmorphic card elements.
- 🔄 **Real-Time Data**: Seamlessly fetches random quotes using the reliable DummyJSON API with full CORS support for Flutter Web.
- 📱 **Native Sharing built-in**: Share quotes natively with your friends across Android, iOS, and Web.
- 🛡️ **Robust Error Handling**: Built to gracefully handle connection timeouts, JSON parsing errors, and lack of internet access.
- ♻️ **State Management**: Scalable separation of logic and presentation using the `Provider` pattern.
- ⚡ **Responsive & Fast**: Crafted to perform flawlessly on all screen shapes and sizes.

## Screenshots

*(You can add your own screenshots here after running the app)*

## Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: `provider`
- **Networking**: `http`
- **Native Sharing**: `share_plus`
- **UI Standard**: Highly customized Material Design 3

## Architecture Overview

The app's structure is clean and production-ready:

```
lib/
├── models/          # Data boundaries (e.g. Quote class & JSON parsing)
├── services/        # External wrappers (e.g. QuoteApiService talking to the internet)
├── providers/       # State controllers (e.g. QuoteProvider emitting UI updates)
├── screens/         # Top-level Views (e.g. HomeScreen with gradient backgrounds)
├── widgets/         # Granular interface pieces (e.g. QuoteCard, CustomLoadingWidget)
└── main.dart        # Entrypoint config
```

## Setup Instructions

### Prerequisites
- Flutter SDK (latest stable recommended)
- Your favorite IDE (VS Code, Android Studio, IntelliJ)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/quote_of_the_day.git
   cd quote_of_the_day
   ```

2. **Clean up & Install Dependencies**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## API Integration

This application interacts with `https://dummyjson.com/quotes/random` for resilient data.
It employs:
- Built-in network timeout constraints.
- Extensive `try/catch` handlers for decoding anomalies or socket issues.
- Asynchronous patterns to maintain 60FPS UI performance during remote calls.

## License

This project is fully open source and is intended to be used as a solid foundation or reference for beautiful Flutter architectures. Feel free to use and modify!