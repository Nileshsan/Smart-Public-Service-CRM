import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ps_crm_app/services/api_service.dart';
import '../../models/complaint.dart';

class TrackComplaintScreen extends StatefulWidget {
  const TrackComplaintScreen({super.key});

  @override
  State<TrackComplaintScreen> createState() => _TrackComplaintScreenState();
}

class _TrackComplaintScreenState extends State<TrackComplaintScreen> {
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Complaint? _complaint;

  @override
  void dispose() {
    _numberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (_numberController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please provide complaint number and email';
        _complaint = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _complaint = null;
    });

    try {
      final api = ApiService();
      final result = await api.trackComplaint(
        complaintNumber: _numberController.text.trim(),
        email: _emailController.text.trim(),
      );
      setState(() {
        _complaint = result;
      });
      if (result == null) {
        setState(() {
          _error = 'No complaint found for this ID/email';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _buildTimeline(Complaint complaint) {
    final steps = <Map<String, dynamic>>[];

    steps.add({
      'icon': '📝',
      'title': 'Filed',
      'desc': 'Complaint created',
      'time': complaint.createdAt,
      'done': true,
      'color': Colors.blue,
    });

    if (complaint.assignedTo != null && complaint.assignedTo!.isNotEmpty) {
      steps.add({
        'icon': '👮',
        'title': 'Officer assigned',
        'desc': 'Assigned to ${complaint.assignedOfficerName ?? complaint.assignedTo}',
        'time': complaint.updatedAt,
        'done': true,
        'color': Colors.deepPurple,
      });
    }

    final status = complaint.status ?? 'Pending';
    if (status == 'In Progress' || status == 'Resolved') {
      steps.add({
        'icon': '🔄',
        'title': 'In progress',
        'desc': 'Work underway',
        'time': complaint.updatedAt,
        'done': true,
        'color': Colors.orange,
      });
    }

    if (status == 'Resolved') {
      steps.add({
        'icon': '✅',
        'title': 'Resolved',
        'desc': complaint.resolution ?? 'Issue resolved by department',
        'time': complaint.updatedAt,
        'done': true,
        'color': Colors.green,
      });
    }

    if (status == 'Escalated') {
      steps.add({
        'icon': '🚨',
        'title': 'Escalated',
        'desc': 'SLA deadline exceeded',
        'time': complaint.updatedAt,
        'done': true,
        'color': Colors.red,
      });
    }

    if (status != 'Resolved' && status != 'Escalated') {
      steps.add({
        'icon': '⏳',
        'title': 'Awaiting closing',
        'desc': 'Pending action from officer',
        'time': null,
        'done': false,
        'color': Colors.grey,
      });
    }

    return steps;
  }

  Widget _buildBadge(String status) {
    Color color;
    switch (status) {
      case 'Resolved':
        color = Colors.green;
        break;
      case 'In Progress':
        color = Colors.orange;
        break;
      case 'Escalated':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Complaint'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(
                labelText: 'Complaint Number',
                hintText: 'e.g., CMP-12345678',
                prefixIcon: Icon(Icons.receipt),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                hintText: 'your@email.com',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _search,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Track Complaint',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            if (_complaint != null) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complaint Number',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _complaint!.complaintNumber ?? _complaint!.id ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildBadge(_complaint!.status ?? 'Pending'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      _buildDetailRow('Title', _complaint!.title),
                      _buildDetailRow('Category', _complaint!.category ?? 'N/A'),
                      _buildDetailRow('Urgency', _complaint!.urgency ?? 'N/A'),
                      _buildDetailRow('Status', _complaint!.status ?? 'Pending'),
                      _buildDetailRow(
                        'Location',
                        '${_complaint!.locality ?? 'N/A'}, ${_complaint!.ward ?? 'N/A'}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Progress Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._buildTimeline(_complaint!).map((step) => _buildTimelineItem(step)).toList(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        color: step['done'] ? Colors.green.shade50 : Colors.grey.shade50,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (step['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(step['icon'] as String, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  step['desc'] as String,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          if (step['time'] != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Completed', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  step['time'] as String,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
