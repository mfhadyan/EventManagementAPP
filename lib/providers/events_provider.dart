import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventsProvider with ChangeNotifier {
  List<Event> _events = [];
  List<Event> _myEvents = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  List<Event> get myEvents => _myEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all events
  Future<void> loadEvents({String? search, String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await ApiService.getEvents(search: search, category: category);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load my events
  Future<void> loadMyEvents(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myEvents = await ApiService.getMyEvents(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
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

      // Reload events to get the updated list
      await loadEvents();
      return true;
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update an event
  Future<bool> updateEvent({
    required int eventId,
    required String token,
    String? title,
    String? description,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    int? maxAttendees,
    double? price,
    String? category,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.updateEvent(
        eventId: eventId,
        token: token,
        title: title,
        description: description,
        location: location,
        startDate: startDate,
        endDate: endDate,
        maxAttendees: maxAttendees,
        price: price,
        category: category,
      );

      // Reload events to get the updated list
      await loadEvents();
      return true;
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete an event
  Future<bool> deleteEvent({
    required int eventId,
    required String token,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await ApiService.deleteEvent(
        eventId: eventId,
        token: token,
      );

      if (success) {
        // Reload events to get the updated list
        await loadEvents();
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register for an event
  Future<bool> registerForEvent({
    required int eventId,
    required String token,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      final success = await ApiService.registerForEvent(
        eventId: eventId,
        token: token,
        additionalInfo: additionalInfo,
      );

      if (success) {
        // Reload events to get updated registration count
        await loadEvents();
      }

      return success;
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  // Cancel registration for an event
  Future<bool> cancelRegistration({
    required int eventId,
    required String token,
  }) async {
    try {
      final success = await ApiService.cancelRegistration(
        eventId: eventId,
        token: token,
      );

      if (success) {
        // Reload events to get updated registration count
        await loadEvents();
      }

      return success;
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  // Get my registrations
  Future<List<Map<String, dynamic>>> getMyRegistrations(String token) async {
    try {
      return await ApiService.getMyRegistrations(token);
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      notifyListeners();
      return [];
    }
  }

  // Get event registrations
  Future<List<Map<String, dynamic>>> getEventRegistrations({
    required int eventId,
    required String token,
  }) async {
    try {
      return await ApiService.getEventRegistrations(
        eventId: eventId,
        token: token,
      );
    } catch (e) {
      _error = ApiService.getErrorMessage(e);
      notifyListeners();
      return [];
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
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
} 