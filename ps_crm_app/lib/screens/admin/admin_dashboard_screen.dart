import 'package:flutter/material.dart';
import 'package:ps_crm_app/services/api_service.dart';
import '../../models/complaint.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Complaint>> _allComplaints;
  final ApiService _apiService = ApiService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _allComplaints = _apiService.getAllComplaints();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _allComplaints = _apiService.getAllComplaints();
  }

  Future<void> _refreshComplaints() async {
    setState(() {
      _allComplaints = _apiService.getAllComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshComplaints,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshComplaints,
        child: FutureBuilder<List<Complaint>>(
          future: _allComplaints,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading all complaints...'),
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
                    Text('No complaints found.'),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final item = complaints[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('ID: ${item.complaintNumber ?? item.id ?? 'N/A'}'),
                        Text('Status: ${item.status ?? 'N/A'}'),
                      ],
                    ),
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
    );
  }
}
