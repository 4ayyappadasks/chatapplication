# Chat Us

Chat Us is a real-time chat application built using Flutter. It leverages GetX for state management, Firebase as the backend for data storage, and Google Sign-In for user authentication. This app provides a seamless and smooth user experience for chatting and real-time communication.

## Features

- **Real-time Chat**: Send and receive messages in real-time.
- **Firebase Integration**: Store user information, messages, and other data using Firebase Firestore.
- **Google Sign-In**: Secure login and authentication using Google Sign-In.
- **GetX State Management**: Efficient and reactive state management using GetX.
- **User Registration**: Manual user registration with email and password.
- **Auto Sign-In**: Automatic login using Google account after initial sign-in.

## Getting Started

### Prerequisites

Before running this application, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A Google Firebase project set up (see instructions below)

### Setup Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project and enable Firebase Firestore.
3. Enable Firebase Authentication and configure Google Sign-In.
4. Download the `google-services.json` file from Firebase Console and place it in your `android/app` directory.
5. Download the `GoogleService-Info.plist` file and place it in your `ios/Runner` directory (if you are building for iOS).

### Clone the Repository

```bash
git clone https://gitlab.com/your-username/chat-us.git
cd chat-us
