import 'package:flutter/material.dart';
import 'package:ps_crm_app/services/api_service.dart';

class PublicDashboardScreen extends StatefulWidget {
  const PublicDashboardScreen({super.key});

  @override
  State<PublicDashboardScreen> createState() => _PublicDashboardScreenState();
}

class _PublicDashboardScreenState extends State<PublicDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<Map<String, dynamic>> _dashboardFuture;
  final ApiService _apiService = ApiService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _apiService.getPublicDashboard();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dashboardFuture = _apiService.getPublicDashboard();
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _dashboardFuture = _apiService.getPublicDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDashboard,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading dashboard...'),
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
                      onPressed: _refreshDashboard,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final data = snapshot.data ?? {};
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  _buildStatCard(
                    icon: '📋',
                    title: 'Total Complaints',
                    value: '${data['total'] ?? 0}',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    icon: '✅',
                    title: 'Resolved',
                    value: '${data['resolved'] ?? 0}',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    icon: '⏳',
                    title: 'Pending',
                    value: '${data['pending'] ?? 0}',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    icon: '🚨',
                    title: 'Escalated',
                    value: '${data['escalated'] ?? 0}',
                    color: Colors.red,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
