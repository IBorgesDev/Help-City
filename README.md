# Help City - Noise Pollution Map Tracker

**Author:** Marina Cabreira  
**Organization:** CEMEP at 3Y

## Introduction

Welcome to the Help City Noise Pollution Map Tracker, a private application designed to help monitor and address noise pollution complaints within the city. This README provides an overview of the application, its features, and how to get started.

## About Help City

Help City is a Noise Pollution Map Tracker that allows users to report and track noise pollution complaints in their area. It serves as a valuable tool for both residents and local authorities to address noise pollution issues effectively.

## Features

### Noise Pollution Complaints Map

Help City provides a user-friendly map interface where users can:

- Report noise pollution complaints by pinpointing the location on the map.
- View and search existing noise pollution complaints.
- Get detailed information about each complaint, including date, time, and description.
- Monitor the status of complaints, including resolution updates.

### Privacy and Security

As a private application, Help City prioritizes data privacy and security. All user data and complaint information are protected, and access is restricted to authorized individuals.

## Getting Started

Since Help City is a private project, access is limited to authorized users only. If you have the necessary permissions, follow these steps to get started:

1. Clone the repository to your local machine.

```bash
git clone https://github.com/CodeRinth/help-city.git
```


Dependencies:
```
Flutter: Ensure you have Flutter installed. You can download it from the official Flutter website.

Firebase: Your project relies on Firebase for real-time database functionality. Make sure to set up Firebase for your project by following the official Firebase documentation.

Google Maps for Flutter: You will need to include the google_maps_flutter package for displaying maps. Add it to your pubspec.yaml file:
```

Pubspec.yaml Dependencies

```
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.3
  google_maps_flutter: ^2.2.2
  geocoding: ^2.1.0
  intl: ^0.17.0
  firebase_core: ^2.15.1
  firebase_database: ^10.2.5
  flutter_map: ^4.0.0
  fluttertoast: ^8.0.8
```

Your Flutter project should follow a structure similar to the one below:
```


- lib/
  - main.dart
  - pages/
    - address_search.dart
    - address_confirmation.dart
    - location_complaint.dart
    - complaint_details.dart
  - firebase_service.dart
- android/
- ios/
- pubspec.yaml
- ...
```

Firebase Configuration:
```
Make sure to configure Firebase correctly by adding your google-services.json (for Android) and GoogleService-Info.plist (for iOS) files to your project.

Google Maps API Key:

Replace YOUR_API_KEY with your actual Google Maps API key in the AddressConfirmation and LocationComplaint widgets where you access the Geocoding API. Ensure that your API key has the necessary permissions for the Geocoding API.

Firebase Database Rules:

Set up Firebase database rules to ensure security for your data. You can find Firebase rules configuration in the Firebase Console.

Firebase Database Structure:

Your Firebase Realtime Database should have a structure similar to:


- your-firebase-project-id
  - reclamacoes
    - unique-id-1
      - tipoDeBarulho: "Example"
      - endereco: "123 Main St, City"
      - detalhes: "Loud music"
      - horaReclamacao: "08:00"
      - latitude: 123.456
      - longitude: 789.012
    - unique-id-2
      - ...
  - ...
```
