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

    // Try up to 3 times with exponential backoff
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        print('EventsProvider: Attempt $attempt of 3');
        
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
        _isLoading = false;
        notifyListeners();
        return true;
      } catch (e) {
        print('EventsProvider: Error creating event (attempt $attempt): $e');
        print('EventsProvider: Error type: ${e.runtimeType}');
        
        if (attempt < 3) {
          // Wait before retrying (exponential backoff)
          final delay = Duration(seconds: attempt * 2);
          print('EventsProvider: Retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
        } else {
          // Final attempt failed
          _error = e.toString();
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
    }
    
    return false;
  }

  // Retry last failed operation
  Future<bool> retryLastOperation() async {
    if (_error == null) return true;
    
    _error = null;
    notifyListeners();
    
    // Reload events as a simple retry mechanism
    await loadEvents();
    return _error == null;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 