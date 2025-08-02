import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventsProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all events
  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await ApiService.getEvents();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new event
  Future<bool> createEvent({
    required String title,
    required String description,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required int maxAttendees,
    required double price,
    required String category,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    print('EventsProvider: Starting to create event');
    print('EventsProvider: Token length: ${token.length}');

    try {
      await ApiService.createEvent(
        title: title,
        description: description,
        location: location,
        startDate: startDate,
        endDate: endDate,
        maxAttendees: maxAttendees,
        price: price,
        category: category,
        token: token,
      );

      print('EventsProvider: Event created successfully');

      // Reload events to get the updated list
      await loadEvents();
      return true;
    } catch (e) {
      print('EventsProvider: Error creating event: $e');
      print('EventsProvider: Error type: ${e.runtimeType}');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 