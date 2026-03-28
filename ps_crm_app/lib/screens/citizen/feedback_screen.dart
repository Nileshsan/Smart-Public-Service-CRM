import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintIdController = TextEditingController();
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _complaintIdController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final api = ApiService();
      final response = await api.submitFeedback(
        complaintId: _complaintIdController.text.trim(),
        rating: _rating,
        comment: _commentController.text.trim(),
        submittedBy: authProvider.user?.email ?? '',
      );

      if (response.success) {
        setState(() {
          _message = 'Feedback submitted successfully';
        });
        _formKey.currentState?.reset();
      } else {
        setState(() {
          _message = response.message ?? 'Submission failed';
        });
      }
    } catch (e) {
      setState(() { _message = e.toString(); });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_message != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _message!,
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              TextFormField(
                controller: _complaintIdController,
                decoration: const InputDecoration(labelText: 'Complaint ID'),
                validator: (value) => value?.isEmpty ?? true ? 'Complaint ID is required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _rating,
                decoration: const InputDecoration(labelText: 'Rating'),
                items: List.generate(5, (index) => index + 1)
                  .map((value) => DropdownMenuItem(value: value, child: Text(value.toString())))
                  .toList(),
                onChanged: (value) { setState(() { _rating = value ?? 5; }); },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Comments'),
                validator: (value) => value?.isEmpty ?? true ? 'Please write something' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Feedback',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
