import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://103.160.63.165/api';
  
  // Get all events
  static Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/events')).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          final List<dynamic> eventsJson = data['data']['events'];
          return eventsJson.map((json) => Event.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load events');
    } catch (e) {
      print('Exception in getEvents: $e');
      print('Exception type: ${e.runtimeType}');
      print('Exception details: ${e.toString()}');
      
      if (e.toString().contains('SocketException') || e.toString().contains('Failed to fetch')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection and try again.');
      } else if (e.toString().contains('HandshakeException')) {
        throw Exception('SSL/TLS error: Unable to establish secure connection. This might be due to network security settings.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: The server took too long to respond. Please try again.');
      }
      throw Exception('Failed to load events: $e');
    }
  }

  // Create a new event
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
      final requestBody = {
        'name': title,
        'description': description,
        'location': location,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'max_attendees': maxAttendees,
        'price': price,
        'category': category,
      };

      print('Request URL: $baseUrl/events');
      print('Request body: ${json.encode(requestBody)}');
      print('Authorization token: ${token.isNotEmpty ? 'Present' : 'Missing'}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          // Handle different possible response structures
          if (data['data'] != null) {
            if (data['data']['event'] != null) {
              return Event.fromJson(data['data']['event']);
            } else if (data['data']['events'] != null && data['data']['events'].isNotEmpty) {
              return Event.fromJson(data['data']['events'][0]);
            } else {
              // If no event data in response, create a mock event with the input data
              return Event(
                id: 0,
                title: title,
                description: description,
                location: location,
                startDate: startDate,
                endDate: endDate,
                maxAttendees: maxAttendees,
                price: price,
                status: 'active',
                category: category,
                creator: User(
                  id: 0,
                  name: 'Current User',
                  studentNumber: 'N/A',
                  email: 'user@example.com',
                  major: 'Unknown',
                  classYear: 0,
                ),
                registrationsCount: 0,
                availableSpots: maxAttendees,
                isAvailable: true,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
            }
          }
        }
      }
      throw Exception('Failed to create event: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Exception in createEvent: $e');
      print('Exception type: ${e.runtimeType}');
      print('Exception details: ${e.toString()}');
      
      if (e.toString().contains('SocketException') || e.toString().contains('Failed to fetch')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection and try again.');
      } else if (e.toString().contains('HandshakeException')) {
        throw Exception('SSL/TLS error: Unable to establish secure connection. This might be due to network security settings.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: The server took too long to respond. Please try again.');
      }
      throw Exception('Failed to create event: $e');
    }
  }

  // Register a new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String studentNumber,
    required String major,
    required int classYear,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'student_number': studentNumber,
          'major': major,
          'class_year': classYear,
          'password': password,
          'password_confirmation': password,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String studentNumber,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'student_number': studentNumber,
          'password': password,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Get user profile
  static Future<User> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['data']['user']);
        }
      }
      throw Exception('Failed to get user profile');
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
} 