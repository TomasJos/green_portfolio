# Green Portfolio Tracker

A production-ready Flutter mobile application designed to help users track their stock investments alongside the carbon footprint of the companies they invest in. Track your financial growth and environmental impact in one unified dashboard!

## Features

- **Portfolio Management**: Add, view, and track your stock investments.
- **Real-time Stock Data**: Fetches up-to-date stock prices.
- **ESG Data Integration**: Analyzes the Environmental, Social, and Governance (ESG) criteria of your investments.
- **Green Score Calculation**: Calculates an overall "Green Score" for your portfolio based on carbon footprint and ESG metrics.
- **Eco-Friendly Suggestions**: Get recommendations for sustainable and green stocks to improve your portfolio's environmental impact.
- **Secure Storage**: Safely stores user credentials and session information using standard encryption via Flutter Secure Storage.
- **Dark Mode**: Fully supports an elegant dark mode for an optimized user experience in low-light environments.
- **Interactive Charts**: Visualizes stock performance directly within the app.

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Architecture**: Clean Architecture with MVVM (Model-View-ViewModel)
- **State Management**: `provider`
- **Network**: `dio` for API handling
- **Local Storage**: `flutter_secure_storage` for secure credential management
- **UI/Charting**: `fl_chart` for graphs, `google_fonts` for typography

## Prerequisites

Before you begin, ensure you have met the following requirements:
- **Flutter SDK**: Installed and configured (version 3.x or latest)
- **Dart SDK**: Installed (comes with Flutter)
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA with Flutter/Dart plugins installed.
- **Device**: An Android/iOS simulator or a physical device connected.

## Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone <your-repository-url>
   cd stocktask
   ```
   *(If you already have the code locally, just navigate to the `stocktask` directory.)*

2. **Install Dependencies:**
   Run the following command in the project root to fetch all required Dart packages:
   ```bash
   flutter pub get
   ```

3. **Configure API Keys (If Applicable):**
   - The app uses API services to fetch stock data and ESG metrics (`lib/services/`).
   - If required by the API providers, ensure your API keys or base URLs are properly set in the respective service files or environment variables.

4. **Run the Application:**
   Ensure you have a device connected or an emulator running, then execute:
   ```bash
   flutter run
   ```

## Project Structure

```text
lib/
├── models/         # Data models (e.g., Stock and User models)
├── providers/      # State management (Provider classes like PortfolioProvider)
├── screens/        # UI screens (Dashboard, Splash, Login, Profile screens)
├── services/       # External integrations (Dio API clients, Auth service)
├── utils/          # Constants, colors, and theming utilities
├── widgets/        # Reusable UI components (buttons, custom text fields)
└── main.dart       # Primary application entry point
```

## Building for Production

### Android
To build an APK for Android:
```bash
flutter build apk --release
```
To build an App Bundle (recommended for Google Play):
```bash
flutter build appbundle --release
```

### iOS
To build for iOS, ensure you are on a macOS environment with Xcode installed, then run:
```bash
flutter build ios --release
```

## Contributing
Contributions are always welcome! Let's make sustainable investing easier for everyone. Please submit a pull request or open an issue if you encounter bugs or want to suggest new features.

## License
This project is provided as an open-source example. Implement your preferred licensing correctly.
