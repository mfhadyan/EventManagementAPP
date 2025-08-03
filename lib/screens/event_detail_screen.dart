import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/auth_provider.dart';
import '../providers/events_provider.dart';
import '../theme/app_theme.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Header Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(event.category),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                event.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          event.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Event Details Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Location
                        _buildDetailRow(
                          context,
                          Icons.location_on,
                          'Location',
                          event.location,
                        ),
                        const SizedBox(height: 12),

                        // Start Date & Time
                        _buildDetailRow(
                          context,
                          Icons.calendar_today,
                          'Start Date & Time',
                          '${dateFormat.format(event.startDate)} at ${timeFormat.format(event.startDate)}',
                        ),
                        const SizedBox(height: 12),

                        // End Date & Time
                        _buildDetailRow(
                          context,
                          Icons.calendar_today,
                          'End Date & Time',
                          '${dateFormat.format(event.endDate)} at ${timeFormat.format(event.endDate)}',
                        ),
                        const SizedBox(height: 12),

                        // Duration
                        _buildDetailRow(
                          context,
                          Icons.access_time,
                          'Duration',
                          _calculateDuration(event.startDate, event.endDate),
                        ),
                        const SizedBox(height: 12),

                        // Price
                        _buildDetailRow(
                          context,
                          Icons.attach_money,
                          'Price',
                          event.price == 0 ? 'Free' : '\$${event.price.toStringAsFixed(2)}',
                          valueColor: event.price == 0 ? Colors.green : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Attendance Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildAttendanceInfo(
                                context,
                                'Registered',
                                '${event.registrationsCount}',
                                Icons.people,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildAttendanceInfo(
                                context,
                                'Available',
                                '${event.availableSpots}',
                                Icons.event_seat,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildAttendanceInfo(
                                context,
                                'Total',
                                '${event.maxAttendees}',
                                Icons.group,
                                AppTheme.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Progress Bar
                        LinearProgressIndicator(
                          value: event.maxAttendees > 0 
                              ? event.registrationsCount / event.maxAttendees 
                              : 0,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            event.isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${((event.registrationsCount / event.maxAttendees) * 100).toStringAsFixed(1)}% filled',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Organizer Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organizer',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                event.creator.name.isNotEmpty 
                                    ? event.creator.name[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.creator.name,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Student ID: ${event.creator.studentNumber}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Event Status Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Status',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: event.isAvailable ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              event.isAvailable ? 'Available for Registration' : 'Event is Full',
                              style: TextStyle(
                                color: event.isAvailable ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: event.status == 'active' ? Colors.green : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Status: ${event.status.toUpperCase()}',
                              style: TextStyle(
                                color: event.status == 'active' ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (!authProvider.isAuthenticated) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        // Register Button
                        if (event.isAvailable)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _registerForEvent(context, authProvider),
                              icon: const Icon(Icons.how_to_reg),
                              label: const Text('Register for Event'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 12),
                        
                        // Delete Button (only for event creator)
                        if (authProvider.user?.id == event.creator.id)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showDeleteConfirmation(context, authProvider),
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete Event'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerForEvent(BuildContext context, AuthProvider authProvider) async {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    
    try {
      final success = await eventsProvider.registerForEvent(
        eventId: event.id,
        token: authProvider.token!,
      );

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully registered for the event!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(eventsProvider.error ?? 'Failed to register for event'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, AuthProvider authProvider) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: Text(
            'Are you sure you want to delete "${event.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEvent(context, authProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEvent(BuildContext context, AuthProvider authProvider) async {
    final eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    
    try {
      final success = await eventsProvider.deleteEvent(
        eventId: event.id,
        token: authProvider.token!,
      );

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(eventsProvider.error ?? 'Failed to delete event'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.secondaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceInfo(BuildContext context, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} ${minutes > 0 ? '$minutes minute${minutes > 1 ? 's' : ''}' : ''}';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'workshop':
        return Colors.blue;
      case 'meetup':
        return Colors.green;
      case 'conference':
        return Colors.purple;
      case 'course':
        return Colors.orange;
      case 'exam':
        return Colors.red;
      default:
        return AppTheme.secondaryColor;
    }
  }
} 