# 🚀 Interview Preparation Buddy

An AI-powered mock interview platform designed to help candidates prepare for technical interviews through realistic voice-based interview simulations, AI-generated questions, and intelligent performance evaluation.

---

## 📖 About The Project

Interview Preparation Buddy enables users to practice interviews in a realistic environment by leveraging Generative AI, Speech Recognition, and Voice Assistance.

The application generates personalized interview questions based on the candidate's technology stack, experience level, and focus areas. Candidates answer questions verbally, and the platform evaluates their performance across multiple dimensions, providing detailed feedback and improvement suggestions.

---

## 🎯 Problem Statement

Many job seekers struggle to prepare effectively for technical interviews due to:

- Lack of realistic interview simulations
- Limited personalized feedback
- Difficulty assessing communication and confidence
- Inability to identify knowledge gaps
- Expensive coaching and mentorship solutions

Interview Preparation Buddy addresses these challenges by providing an accessible AI-powered interview preparation platform.

---

## 💡 Solution

The platform acts as a virtual interviewer that:

- Generates personalized interview questions
- Conducts voice-based mock interviews
- Records and transcribes responses
- Evaluates candidate performance using AI
- Provides actionable feedback and readiness assessment

This enables candidates to practice anytime and improve both technical and communication skills before real interviews.

---

## ✨ Key Features

### 🤖 AI-Powered Question Generation
- Technology-specific questions
- Experience-based difficulty adjustment
- Focus-area customization
- Dynamic interview creation using Gemini AI

### 🎤 Voice-Based Interview Experience
- Text-to-Speech question narration
- Speech-to-Text answer transcription
- Real interview simulation
- Hands-free interview practice

### ⏱ Intelligent Interview Flow
- Reading time management
- Answer start countdown
- Inactivity detection
- Automatic session handling

### 📊 AI Evaluation Engine
- Technical Knowledge Assessment
- Communication Skills Analysis
- Confidence Measurement
- Problem Solving Evaluation
- Overall Interview Readiness Score

### 📈 Detailed Performance Report
- Overall Score
- Readiness Level
- Strengths
- Areas for Improvement
- Personalized Recommendations


---

## 🏗 Project Architecture

The project follows a feature-driven architecture with separation of concerns using Bloc state management and repository abstraction.

```text
lib/
│
├── app/
│   ├── routes/
│   ├── app.dart
│   └── app_bloc_observer.dart
│
├── core/
│   ├── constants/
│   ├── services/
│   ├── network/
│   ├── theme/
│   ├── utils/
│   └── extensions/
│
├── feature/
│   │
│   ├── interview/
│   │   │
│   │   ├── bloc/
│   │   │
│   │   ├── controller/
│   │   │   └── interview_setup_bloc/
│   │   │       ├── interview_setup_bloc.dart
│   │   │       ├── interview_setup_event.dart
│   │   │       └── interview_setup_state.dart
│   │   │
│   │   ├── repository/
│   │   ├── screens/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   │
│   │   └── ui/
│   │
│   ├── questions/
│   ├── feedback/
│   └── repo/
│
├── shared/
│
├── widgets/
│
└── main.dart
```

---

## 🔄 Interview Flow

```text
User Selects:
Technology
Experience
Focus Areas
        │
        ▼
Generate Questions (Gemini AI)
        │
        ▼
Store Questions In Bloc
        │
        ▼
Question Presented To User
        │
        ▼
Text-To-Speech Reads Question
        │
        ▼
User Records Answer
        │
        ▼
Speech-To-Text Conversion
        │
        ▼
Question + Answer Stored
        │
        ▼
Evaluation Request
        │
        ▼
AI Feedback Generation
        │
        ▼
Final Interview Report
```

---

## 🧠 State Management

The application uses Flutter Bloc for managing:

- Interview Setup State
- Question Generation State
- Interview Session State
- Answer Collection State
- Evaluation State
- Connectivity State

Each feature is isolated and communicates through events and states, ensuring predictable state transitions and maintainable code.
```

---

## 🛠 Technology Stack

### Frontend
- Flutter
- Dart

### State Management
- Flutter Bloc

### Dependency Injection
- GetIt

### Networking
- HTTP

### AI Services
- Google Gemini AI

### Voice Services
- Speech To Text
- Flutter TTS

### Backend Services
- Firebase

### Hosting
- Firebase Hosting

---

## 📂 Project Structure

```text
lib/
│
├── core/
│   ├── constants/
│   ├── network/
│   ├── services/
│   ├── theme/
│   └── utils/
│
├── features/
│   │
│   ├── interview_setup/
│   ├── interview_questions/
│   ├── interview_session/
│   ├── interview_evaluation/
│   └── connectivity/
│
├── injection_container.dart
│
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable Version)
- Dart SDK
- Firebase Account
- Gemini API Key

---

### Installation

Clone the repository:

```bash
git clone https://github.com/your-username/interview-preparation-buddy.git
```

Navigate to project directory:

```bash
cd interview-preparation-buddy
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

## 🔑 Configuration

Add your Gemini API key:

```env
GEMINI_API_KEY=YOUR_API_KEY
```

Configure Firebase:

```bash
flutterfire configure
```

---

## 📊 Evaluation Parameters

The platform evaluates candidates across multiple dimensions:

| Metric | Description |
|----------|------------|
| Technical Knowledge | Understanding of technical concepts |
| Problem Solving | Analytical and logical thinking |
| Communication | Clarity and articulation |
| Confidence | Confidence while answering |
| Readiness Score | Overall interview preparedness |

---

## 🎯 Target Users

- Students preparing for placements
- Freshers entering the job market
- Experienced developers preparing for job switches
- Professionals seeking interview practice
- Training institutes and bootcamps

---

## 🔮 Future Roadmap

- Resume-Based Question Generation
- Company-Specific Interview Preparation
- Video Interview Analysis
- Facial Expression Evaluation
- Behavioral Interview Assessment
- Interview History Tracking
- Multi-Language Support
- Advanced Analytics Dashboard

---

## 🌟 Impact

Interview Preparation Buddy helps candidates:

- Build interview confidence
- Improve communication skills
- Identify technical knowledge gaps
- Receive personalized feedback
- Practice interviews anytime, anywhere

---

## 👨‍💻 Built With

- Flutter
- Bloc
- Clean Architecture
- Gemini AI
- Firebase
- Speech Recognition
- Text To Speech

---

## 🏆 Hackathon Project

Built to demonstrate how Artificial Intelligence can transform interview preparation by providing scalable, personalized, and accessible coaching experiences.

---

## 📄 License

This project is developed for educational, research, and hackathon purposes.

---

### ⭐ If you found this project useful, consider giving it a star!
