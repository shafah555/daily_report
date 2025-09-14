# Daily Activity Tracker

A comprehensive Flutter application for tracking daily Islamic activities, prayer times, and personal development goals.

## Features

### 🔐 Authentication System
- **Login/Register**: Secure authentication with email or phone number
- **User Roles**: Multiple membership levels (General, Primary Member, Kormi, Ogrosor Kormi, Dayittoshila)
- **Auto-login**: Remembers user session for seamless experience

### 📅 Activity Tracking
- **Daily Activities**: Track 9 different activities:
  - Quran Reading
  - Hadith Study
  - Islamic Literature
  - Salat (Prayers)
  - Academic Study
  - Friends & Social
  - Work Activities
  - Self Criticism
  - Notes
- **Interactive Calendar**: Click any date to add/edit activities
- **Last 7 Days Summary**: Visual overview of recent activities

### 🕌 Prayer Times
- **Location-based**: Automatic GPS detection for accurate prayer times
- **7 Prayer Times**: Fajr, Sunrise, Dhuhr, Asr, Maghrib, Sunset, Isha
- **Real-time Updates**: Fetches current prayer times from API
- **Current Status**: Shows current prayer and time until next prayer

### ⏰ Reminder System
- **Custom Reminders**: Set date, time, and reminder type
- **Notifications**: Local notifications with sound and vibration
- **Multiple Types**: Notification only, alarm only, or both
- **Persistent Storage**: Reminders saved and restored

### 📊 Analytics & Progress
- **Monthly Planning**: Set goals for each activity
- **Monthly Activities**: View totals and daily breakdowns
- **Monthly Progress**: Compare with previous month and goals
- **Visual Progress**: Progress bars and completion percentages

## Screenshots

The app features a modern, eye-soothing design with:
- Teal and blue gradient theme
- Rounded corners and shadows
- Bengali and English text support
- Responsive layout for different screen sizes

## Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Setup
1. Clone the repository:
```bash
git clone https://github.com/yourusername/daily-activity-tracker.git
cd daily-activity-tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

- `table_calendar`: Calendar widget for date selection
- `intl`: Internationalization and date formatting
- `shared_preferences`: Local data storage
- `geolocator`: GPS location services
- `permission_handler`: Permission management
- `flutter_local_notifications`: Local notifications
- `http`: API calls for prayer times
- `timezone`: Timezone handling for notifications

## Usage

### First Time Setup
1. **Register/Login**: Create an account or login with existing credentials
2. **Select Role**: Choose "Primary Member" for full access
3. **Grant Permissions**: Allow location access for prayer times

### Daily Usage
1. **Calendar**: Click any date to add daily activities
2. **Prayer Times**: View current prayer times and next prayer
3. **Reminders**: Set custom reminders with notifications
4. **Progress**: Check monthly planning and progress reports

### Menu Options
- **Home**: Main calendar and activity tracking
- **Monthly Planning**: Set monthly goals
- **Monthly Activities**: View activity totals and breakdowns
- **Monthly Progress**: Compare progress with goals and previous months

## Data Storage

All data is stored locally using SharedPreferences:
- User authentication state
- Daily activity entries
- Monthly plans and goals
- Custom reminders
- User preferences

## API Integration

The app uses the Aladhan API for prayer times:
- Automatic location detection
- Real-time prayer time calculation
- Fallback to sample data if API fails

## Platform Support

- ✅ Windows (Desktop)
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Aladhan API for prayer time calculations
- Flutter team for the amazing framework
- Material Design for UI components

## Support

If you encounter any issues or have questions, please:
1. Check the existing issues
2. Create a new issue with detailed description
3. Contact the development team

---

**Made with ❤️ for the Muslim community**