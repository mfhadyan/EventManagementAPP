import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';

class ApiService {
  // Configuration
  static const String baseUrl = 'http://103.160.63.165/api';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectivityTestTimeout = Duration(seconds: 10);
  static const bool enableDebugLogging = true;

  // Headers
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> _authHeaders(String token) => {
    ..._defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // Health Check
  static Future<bool> healthCheck() async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Checking API health...');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: _defaultHeaders,
      ).timeout(connectivityTestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Health check response: ${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Health check failed: $e');
      }
      return false;
    }
  }

  // Authentication Methods
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String studentNumber,
    required String major,
    required int classYear,
    required String password,
  }) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Registering user: $studentNumber');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _defaultHeaders,
        body: json.encode({
          'name': name,
          'email': email,
          'student_number': studentNumber,
          'major': major,
          'class_year': classYear,
          'password': password,
          'password_confirmation': password,
        }),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Register response: ${response.statusCode}');
        print('ApiService: Register body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Register error: $e');
      }
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> login({
    required String studentNumber,
    required String password,
  }) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Logging in user: $studentNumber');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _defaultHeaders,
        body: json.encode({
          'student_number': studentNumber,
          'password': password,
        }),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Login response: ${response.statusCode}');
        print('ApiService: Login body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Login error: $e');
      }
      rethrow;
    }
  }

  static Future<User> getProfile(String token) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Getting user profile...');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Profile response: ${response.statusCode}');
        print('ApiService: Profile body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return User.fromJson(data['data']['user']);
      } else {
        throw Exception(data['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Profile error: $e');
      }
      rethrow;
    }
  }

  static Future<bool> logout(String token) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Logging out...');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Logout response: ${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Logout error: $e');
      }
      return false;
    }
  }

  // Events Methods
  static Future<List<Event>> getEvents({String? search, String? category}) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Getting events...');
      }

      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final uri = Uri.parse('$baseUrl/events').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: _defaultHeaders,
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Get events response: ${response.statusCode}');
        print('ApiService: Get events body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> eventsJson = data['data']['events'];
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load events');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Get events error: $e');
      }
      rethrow;
    }
  }

  static Future<Event> getEvent(int eventId) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Getting event: $eventId');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: _defaultHeaders,
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Get event response: ${response.statusCode}');
        print('ApiService: Get event body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return Event.fromJson(data['data']['event']);
      } else {
        throw Exception(data['message'] ?? 'Failed to load event');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Get event error: $e');
      }
      rethrow;
    }
  }

  static Future<Event> createEvent({
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
    try {
      if (enableDebugLogging) {
        print('ApiService: Creating event: $title');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: _authHeaders(token),
        body: json.encode({
          'title': title,
          'description': description,
          'location': location,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'max_attendees': maxAttendees,
          'price': price,
          'category': category,
        }),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Create event response: ${response.statusCode}');
        print('ApiService: Create event body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Event.fromJson(data['data']['event']);
      } else {
        throw Exception(data['message'] ?? 'Failed to create event');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Create event error: $e');
      }
      rethrow;
    }
  }

  static Future<Event> updateEvent({
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
    try {
      if (enableDebugLogging) {
        print('ApiService: Updating event: $eventId');
      }

      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (location != null) updateData['location'] = location;
      if (startDate != null) updateData['start_date'] = startDate.toIso8601String();
      if (endDate != null) updateData['end_date'] = endDate.toIso8601String();
      if (maxAttendees != null) updateData['max_attendees'] = maxAttendees;
      if (price != null) updateData['price'] = price;
      if (category != null) updateData['category'] = category;

      final response = await http.put(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: _authHeaders(token),
        body: json.encode(updateData),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Update event response: ${response.statusCode}');
        print('ApiService: Update event body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return Event.fromJson(data['data']['event']);
      } else {
        throw Exception(data['message'] ?? 'Failed to update event');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Update event error: $e');
      }
      rethrow;
    }
  }

  static Future<bool> deleteEvent({
    required int eventId,
    required String token,
  }) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Deleting event: $eventId');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Delete event response: ${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Delete event error: $e');
      }
      return false;
    }
  }

  static Future<List<Event>> getMyEvents(String token) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Getting my events...');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/my-events'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Get my events response: ${response.statusCode}');
        print('ApiService: Get my events body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        final List<dynamic> eventsJson = data['data']['events'];
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load my events');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Get my events error: $e');
      }
      rethrow;
    }
  }

  // Registration Methods
  static Future<bool> registerForEvent({
    required int eventId,
    required String token,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Registering for event: $eventId');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/events/$eventId/register'),
        headers: _authHeaders(token),
        body: json.encode({
          'additional_info': additionalInfo ?? {},
        }),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Register for event response: ${response.statusCode}');
        print('ApiService: Register for event body: ${response.body}');
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Register for event error: $e');
      }
      return false;
    }
  }

  static Future<bool> cancelRegistration({
    required int eventId,
    required String token,
  }) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Canceling registration for event: $eventId');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId/cancel'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Cancel registration response: ${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Cancel registration error: $e');
      }
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getMyRegistrations(String token) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Getting my registrations...');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/my-registrations'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Get my registrations response: ${response.statusCode}');
        print('ApiService: Get my registrations body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(data['data']['registrations']);
      } else {
        throw Exception(data['message'] ?? 'Failed to load registrations');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Get my registrations error: $e');
      }
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getEventRegistrations({
    required int eventId,
    required String token,
  }) async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Getting event registrations: $eventId');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId/registrations'),
        headers: _authHeaders(token),
      ).timeout(requestTimeout);

      if (enableDebugLogging) {
        print('ApiService: Get event registrations response: ${response.statusCode}');
        print('ApiService: Get event registrations body: ${response.body}');
      }

      final data = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(data['data']['registrations']);
      } else {
        throw Exception(data['message'] ?? 'Failed to load event registrations');
      }
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Get event registrations error: $e');
      }
      rethrow;
    }
  }

  // Error handling helpers
  static String getErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'Network error: Unable to connect to the server. Please check your internet connection.';
    } else if (error.toString().contains('Failed to fetch')) {
      return 'Network error: Unable to connect to the server. Please check your internet connection.';
    } else if (error.toString().contains('HandshakeException')) {
      return 'SSL/TLS error: Unable to establish secure connection.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout: The server took too long to respond. Please try again.';
    } else {
      return error.toString();
    }
  }
} 