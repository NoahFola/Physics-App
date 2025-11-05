Newtonium - A Physics Learning App

Newtonium is a mobile app built with Flutter, designed to make learning complex physics concepts intuitive, accessible, and less stressful for students. It's built with a focus on offline-first functionality and a clean, scalable, and testable architecture.

This project began as a personal learning journey: to deeply understand and apply clean architecture principles, state management, and dependency injection in a real-world Flutter application.

✨ Core Features

📚 Structured Learning Modules: Breaks down complex topics into small, digestible lessons.

📖 Past Question Library:

Browse thousands of real past questions (JUPEB Physics).

Filter by Year, Topic, or Question Type (MCQ & Theory).

View detailed explanations for every question.

⏱️ Graded Practice Quizzes:

Simulate real exam conditions with a countdown timer.

Take "Official Exam Mode" quizzes or create Custom Quizzes from specific topics.

Get instant scores upon completion.

📊 Performance Tracking:

View a history of all past quiz attempts.

Track scores and time taken.

Review all incorrect answers to identify weak areas.

✈️ 100% Offline First: All questions and modules are bundled with the app, making it fully functional without an internet connection.

🛠️ Tech Stack & Architecture

The primary goal of this project was to build a scalable and maintainable app. The entire codebase is structured following Clean Architecture principles.

Key Libraries & Tools:

Framework: Flutter & Dart

State Management: (Your chosen solution, e.g., BLoC, Riverpod, Provider)

Dependency Injection: (Your chosen solution, e.g., GetIt, Provider)

Local Storage: sqflite (For user data like quiz attempts)

Math Rendering: flutter_math_fork (For rendering LaTeX equations)

Static Data: Bundled JSON for all questions, parsed into SQLite on first launch.

🏛️ Architectural Design

The app is decoupled into three core layers:

Domain Layer:

Contains the core business logic, entities (models), and abstract repositories/use cases.

This layer is pure Dart and has no dependencies on Flutter or any data source.

Files: domain/entities, domain/repositories, domain/usecases

Data Layer:

Implements the abstract repositories defined in the Domain layer.

It handles all data operations, deciding whether to fetch from the local SQLite database (for user data) or the static data source (for questions).

Files: data/models, data/repositories, data/datasources

Presentation Layer:

Contains all the UI (Flutter widgets) and the state management logic (BLoCs/Cubits/ViewModels).

This layer depends on the Domain layer to execute use cases and get data, but knows nothing about the Data layer.

Files: presentation/screens, presentation/bloc

This separation of concerns makes the app:

Easy to test: Business logic can be unit-tested without a UI.

Easy to maintain: Changes to the UI don't break the database, and changes to the database don't break the UI.

Scalable: New features can be added by following the same, clear pattern.

🚀 Getting Started

Prerequisites:

Flutter SDK (v3.x.x)

An IDE (VS Code, Android Studio)

Clone & Run:

Clone this repository:

git clone [https://github.com/your-username/newtonium.git](https://github.com/your-username/newtonium.git)


Navigate to the project directory:

cd newtonium


Install dependencies:

flutter pub get


Run the app:

flutter run


📜 License

This project is licensed under the MIT License - see the LICENSE.md file for details.

This app is a reminder that learning something new — whether code or Physics — doesn’t have to be overwhelming. It just needs structure, clarity, and consistency.