import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';
import '../../providers/auth_provider.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _wardController = TextEditingController();
  final _localityController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedCategory = AppConstants.categories.first;
  String _selectedUrgency = AppConstants.urgencyLow;
  bool _isLoading = false;
  String? _message;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _wardController.dispose();
    _localityController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final api = ApiService();
      final authProvider = context.read<AuthProvider>();
      final name = _nameController.text.trim().isEmpty
          ? authProvider.user?.name ?? ''
          : _nameController.text.trim();
      final email = _emailController.text.trim().isEmpty
          ? authProvider.user?.email ?? ''
          : _emailController.text.trim();

      final response = await api.submitComplaint(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        urgency: _selectedUrgency,
        ward: _wardController.text.trim(),
        locality: _localityController.text.trim(),
        address: _addressController.text.trim(),
        name: name,
        email: email,
      );

      if (response.success) {
        setState(() {
          _message = 'Complaint submitted successfully.';
        });
      } else {
        setState(() {
          _message = response.message ?? 'Failed to submit complaint';
        });
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
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
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.blue.shade50 : Colors.green.shade50,
                    border: Border.all(
                      color: _isLoading ? Colors.blue : Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLoading ? Icons.info : Icons.check_circle,
                        color: _isLoading ? Colors.blue : Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _message!,
                          style: TextStyle(
                            color: _isLoading ? Colors.blue : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Title required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Description required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: AppConstants.categories.map((category) =>
                  DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value ?? AppConstants.categories.first),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: const InputDecoration(labelText: 'Urgency'),
                items: [AppConstants.urgencyLow, AppConstants.urgencyMedium, AppConstants.urgencyHigh]
                  .map((urgency) => DropdownMenuItem(value: urgency, child: Text(urgency))).toList(),
                onChanged: (value) => setState(() => _selectedUrgency = value ?? AppConstants.urgencyLow),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(labelText: 'Ward'),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Ward required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _localityController,
                decoration: const InputDecoration(labelText: 'Locality'),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Locality required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address/Landmark'),
                validator: (v) => v?.trim().isEmpty ?? true ? 'Address required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name (optional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email (optional)'),
                keyboardType: TextInputType.emailAddress,
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
                          'Submit Complaint',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              if (_message != null && !_isLoading)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _titleController.clear();
                      _descriptionController.clear();
                      _wardController.clear();
                      _localityController.clear();
                      _addressController.clear();
                      _nameController.clear();
                      _emailController.clear();
                      setState(() {
                        _message = null;
                        _selectedCategory = AppConstants.categories.first;
                        _selectedUrgency = AppConstants.urgencyLow;
                      });
                    },
                    child: const Text('File Another Complaint'),
                  ),
                ),
            ],
          ),
        ),
      ));
  }
}
