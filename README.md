# Synonym Quiz - Flutter Mobile & Web Application

A modern, interactive, and beautifully designed **Flutter Quiz Application** for practicing Indonesian and English word synonyms featuring **Neumorphism (Soft UI)** design principles.

![Neumorphism Soft UI Banner](https://img.shields.value/badge/Design-Neumorphism%20Soft%20UI-blue?style=for-the-badge)
![Flutter](https://img.shields.value/badge/Flutter-3.44+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.value/badge/Dart-3.12+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.value/badge/License-MIT-green?style=for-the-badge)

---

## 🌟 Key Features

- **Soft UI / Neumorphism Styling**: Dual soft drop shadows, concave & convex elements, floating pill buttons, and soft embossed tiles matching high-end modern UI specifications.
- **Multiple Quiz Categories**:
  - 🇮🇩 **Bahasa Indonesia - Pemula**: Everyday vocabulary & popular synonyms.
  - 🇮🇩 **Bahasa Indonesia - Mahir**: Formal, academic, and literary vocabulary.
  - 🇬🇧 **English Vocabulary (TOEFL/IELTS)**: Advanced English synonyms.
- **Interactive Gameplay**:
  - Real-time answer verification (Instant soft-green success / soft-red failure feedback).
  - 15-second animated Neumorphic countdown timer per question.
  - 50:50 Lifeline hint system.
  - Context sentence usage hints.
  - Streak multipliers & 3-life system.
- **In-Depth Word Explanations**: Full dictionary definitions and sentence examples provided after every question.
- **Comprehensive Results Dashboard**: Gauge accuracy meter, performance badges (Master Sinonim, Kamus Berjalan), and itemized evaluation breakdown.
- **Dark Mode Support**: Neumorphic Dark mode & Light mode toggle.

---

## 📱 Screenshots & Design Concept

The UI is inspired by Neumorphic (Soft UI) design principles:
- **Background & Elevation**: Soft blue-gray palette (`#E2E8F0` / `#1E222A`).
- **Shadow System**: Dual light top-left and dark bottom-right soft shadows.
- **Tactile Feedback**: Interactive pressed states and smooth animations.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.20.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code / Chrome Browser

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/rizkiram123/ujian.git
   cd ujian
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   - On Web (Chrome):
     ```bash
     flutter run -d chrome
     ```
   - On Android / iOS / Desktop:
     ```bash
     flutter run
     ```

4. **Build Release**:
   - Web: `flutter build web --release`
   - Android APK: `flutter build apk --release`

---

## 📂 Project Structure

```
lib/
├── data/
│   └── quiz_dataset.dart       # Rich dataset of Indonesian & English synonym questions
├── models/
│   └── quiz_question.dart      # Question & Category data models
├── screens/
│   ├── home_screen.dart        # Category selection & Hero dashboard
│   ├── quiz_screen.dart        # Main Neumorphic Quiz gameplay & timer logic
│   └── result_screen.dart      # Results gauge & itemized performance review
├── theme/
│   └── neumorphic_theme.dart   # Neumorphic design tokens, decorations & colors
├── widgets/
│   ├── neumorphic_button.dart  # Custom Soft UI pill buttons & icon buttons
│   └── neumorphic_card.dart    # Interactive Soft UI cards with pressed states
└── main.dart                   # Application entrypoint & theme configuration
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
