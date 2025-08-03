import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';

class ApiService {
  // Configuration - Change this to test with different servers
  static const String baseUrl = 'http://103.160.63.165/api';
  
  // Enable/disable debug logging
  static const bool enableDebugLogging = true;
  
  // Timeout settings
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectivityTestTimeout = Duration(seconds: 10);
  
  // Get all events
  static Future<List<Event>> getEvents() async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Attempting to fetch events from $baseUrl/events');
      }
      final response = await http.get(Uri.parse('$baseUrl/events')).timeout(requestTimeout);
      
      print('ApiService: Response status: ${response.statusCode}');
      print('ApiService: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          final List<dynamic> eventsJson = data['data']['events'];
          return eventsJson.map((json) => Event.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load events: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Exception in getEvents: $e');
      print('Exception type: ${e.runtimeType}');
      print('Exception details: ${e.toString()}');
      
      if (e is SocketException) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection and try again.');
      } else if (e.toString().contains('Failed to fetch')) {
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
      // Format dates as ISO 8601 with 'Z' suffix (like the working code)
      final String formattedStartDateTime = startDate.toIso8601String().split('.')[0] + 'Z';
      final String formattedEndDateTime = endDate.toIso8601String().split('.')[0] + 'Z';

      final requestBody = {
        'title': title,
        'description': description,
        'start_date': formattedStartDateTime,
        'end_date': formattedEndDateTime,
        'location': location,
        'max_attendees': maxAttendees,
        'price': price,
        'category': category,
      };

      print('ApiService: Creating event...');
      print('ApiService: Request URL: $baseUrl/events');
      print('ApiService: Request body: ${json.encode(requestBody)}');
      print('ApiService: Authorization token: ${token.isNotEmpty ? 'Present (${token.length} chars)' : 'Missing'}');
      print('ApiService: Token preview: ${token.isNotEmpty ? token.substring(0, token.length > 20 ? 20 : token.length) + '...' : 'N/A'}');
      
      // Test connectivity first
      try {
        if (enableDebugLogging) {
          print('ApiService: Testing connectivity to $baseUrl...');
        }
        final testResponse = await http.get(Uri.parse('$baseUrl')).timeout(connectivityTestTimeout);
        if (enableDebugLogging) {
          print('ApiService: Connectivity test response: ${testResponse.statusCode}');
        }
      } catch (e) {
        if (enableDebugLogging) {
          print('ApiService: Connectivity test failed: $e');
        }
        throw Exception('Server connectivity test failed: $e');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      ).timeout(requestTimeout);

      print('ApiService: Response status: ${response.statusCode}');
      print('ApiService: Response headers: ${response.headers}');
      print('ApiService: Response body: ${response.body}');
      
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
      
      if (e is SocketException) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection and try again.');
      } else if (e.toString().contains('Failed to fetch')) {
        throw Exception('Network error: Unable to connect to the server. Please check your internet connection and try again.');
      } else if (e.toString().contains('HandshakeException')) {
        throw Exception('SSL/TLS error: Unable to establish secure connection. This might be due to network security settings.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout: The server took too long to respond. Please try again.');
      } else if (e.toString().contains('Connectivity test failed')) {
        throw Exception('Server is not reachable. Please check if the server is running and accessible.');
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

  // Test network connectivity
  static Future<bool> testConnectivity() async {
    try {
      if (enableDebugLogging) {
        print('ApiService: Testing connectivity to $baseUrl...');
      }
      final response = await http.get(Uri.parse('$baseUrl')).timeout(connectivityTestTimeout);
      if (enableDebugLogging) {
        print('ApiService: Connectivity test successful: ${response.statusCode}');
      }
      return true;
    } catch (e) {
      if (enableDebugLogging) {
        print('ApiService: Connectivity test failed: $e');
      }
      return false;
    }
  }

  // Get server status
  static Future<Map<String, dynamic>> getServerStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl')).timeout(connectivityTestTimeout);
      return {
        'status': 'online',
        'statusCode': response.statusCode,
        'responseTime': '${response.headers['x-response-time'] ?? 'unknown'}',
      };
    } catch (e) {
      return {
        'status': 'offline',
        'error': e.toString(),
      };
    }
  }
} 