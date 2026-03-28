import 'package:flutter/material.dart';
import 'package:ps_crm_app/services/api_service.dart';
import '../../models/complaint.dart';

class OfficerDashboardScreen extends StatefulWidget {
  const OfficerDashboardScreen({super.key});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Complaint>> _assignedComplaints;
  final ApiService _apiService = ApiService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _assignedComplaints = _apiService.getAssignedComplaints();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignedComplaints = _apiService.getAssignedComplaints();
  }

  Future<void> _refreshComplaints() async {
    setState(() {
      _assignedComplaints = _apiService.getAssignedComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Officer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshComplaints,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshComplaints,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Complaint>>(
            future: _assignedComplaints,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading assigned complaints...'),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '⚠️',
                        style: TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshComplaints,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              final complaints = snapshot.data ?? [];
              if (complaints.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('📋', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 16),
                      Text('No assigned complaints yet.'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final item = complaints[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text('Status: ${item.status ?? 'N/A'}'),
                      trailing: Chip(
                        label: Text(item.urgency ?? 'N/A'),
                        backgroundColor: item.urgency == 'High'
                            ? Colors.red.shade100
                            : item.urgency == 'Medium'
                                ? Colors.orange.shade100
                                : Colors.green.shade100,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

