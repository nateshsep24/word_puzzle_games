import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool _isMusicEnabled = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  ThemeData get currentTheme => _isDarkTheme ? ThemeData.dark() : ThemeData.light();
  bool get isDarkTheme => _isDarkTheme;
  bool get isMusicEnabled => _isMusicEnabled;

  ThemeProvider() {
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    print("Initializing Preferences...");
    await _loadPreferences();

    // Play or stop background music based on the saved preference
    if (_isMusicEnabled) {
      print("Music is enabled. Playing background music.");
      await playBackgroundMusic(); // Ensure background music plays on initialization
    } else {
      print("Music is disabled. Stopping background music.");
      await stopBackgroundMusic();
    }

    notifyListeners(); // Notify listeners to reflect the state in UI
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _savePreferences();
    print("Theme toggled: ${_isDarkTheme ? "Dark" : "Light"}");
    notifyListeners();
  }

  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    _savePreferences();

    if (_isMusicEnabled) {
      print("Music enabled. Attempting to play music.");
      playBackgroundMusic();
    } else {
      print("Music disabled. Attempting to stop music.");
      stopBackgroundMusic();
    }

    notifyListeners();
  }

  Future<void> playBackgroundMusic() async {
    try {
      await _audioPlayer.setSourceAsset('audio/background_music.mp3');
      _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
      await _audioPlayer.resume();
      print("Background music is playing.");
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _audioPlayer.stop();
      print("Background music stopped.");
    } catch (e) {
      print("Error stopping background music: $e");
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _isMusicEnabled = prefs.getBool('isMusicEnabled') ?? true;

    print("Loaded Preferences: isDarkTheme=$_isDarkTheme, isMusicEnabled=$_isMusicEnabled");
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _isDarkTheme);
    await prefs.setBool('isMusicEnabled', _isMusicEnabled);

    print("Preferences saved: isDarkTheme=$_isDarkTheme, isMusicEnabled=$_isMusicEnabled");
  }
}
