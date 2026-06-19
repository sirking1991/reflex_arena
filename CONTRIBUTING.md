# Contributing to Reflex Arena 🤝

Thank you for your interest in contributing to Reflex Arena! As an open-source project, we welcome contributions of all forms—whether it's reporting bugs, suggesting new features, improving documentation, or writing code.

---

## Code of Conduct

By participating in this project, you agree to abide by the terms of our [Code of Conduct](file:///Users/sirking/Projects/Others/reflex_arena/CODE_OF_CONDUCT.md). Please report any unacceptable behavior to the project maintainers.

---

## How Can I Contribute?

### 🐛 Reporting Bugs

If you find a bug in the application:
1. Check the [Issues Page](https://github.com/sirking1991/reflex_arena/issues) to see if it has already been reported.
2. If it hasn't, open a new issue using the **Bug Report Template**.
3. Provide as much detail as possible, including:
   - Your device model and OS version.
   - The steps to reproduce the bug.
   - Expected vs. actual behavior.
   - Relevant screenshots, screen recordings, or logs.

### 💡 Suggesting Features

We love new ideas! To suggest a feature:
1. Search existing issues to ensure the idea hasn't been proposed yet.
2. Open a new issue using the **Feature Request Template**.
3. Clearly explain the feature, why it would be beneficial, and how you envision it working.

### 🛠️ Submitting Code Changes

If you'd like to fix a bug or implement a feature:

1. **Find or Open an Issue:** Before starting work, ensure there is an issue describing the work. Comment on the issue to let others know you're working on it.
2. **Fork and Clone:** Fork the repository on GitHub and clone it locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/reflex_arena.git
   cd reflex_arena
   ```
3. **Create a Branch:** Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```
4. **Develop:**
   - Make your changes in the codebase.
   - Follow standard Dart and Flutter coding styles.
   - Maintain clear comments and document public APIs.
5. **Verify Your Changes:**
   - Run the Flutter analyzer to check for errors and lint warnings:
     ```bash
     flutter analyze
     ```
   - Run existing unit/widget tests:
     ```bash
     flutter test
     ```
6. **Commit:** Keep commits clean and descriptive. Reference issues if applicable:
   ```bash
   git commit -m "feat: add particle explosion effects to classic mode targets (#123)"
   ```
7. **Push and Pull Request:** Push your branch to GitHub and open a Pull Request (PR) against our `main` branch. Complete the PR template details.

---

## Style Guidelines

- **Dart Style:** Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- **Linter Rules:** The project enforces standard Flutter lint rules configured in [analysis_options.yaml](file:///Users/sirking/Projects/Others/reflex_arena/analysis_options.yaml). Make sure `flutter analyze` runs with zero warnings or errors before submitting.
- **Formatting:** Format your code using:
  ```bash
  dart format .
  ```
