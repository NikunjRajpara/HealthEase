import 'package:flutter/material.dart';

class AskPharmacistScreen extends StatefulWidget {
  const AskPharmacistScreen({super.key});

  @override
  State<AskPharmacistScreen> createState() => _AskPharmacistScreenState();
}

class _AskPharmacistScreenState extends State<AskPharmacistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: send to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inquiry submitted!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask a Pharmacist'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // Heading
              Text(
                'Describe Your Symptoms',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Please provide as much detail as possible for a better suggestion. '
                'Our pharmacist will review your inquiry and respond shortly.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 16),

              // Multiline input (styled like the mock)
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: TextFormField(
                  controller: _controller,
                  maxLines: 8,
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText:
                        'e.g., "I have a mild headache, a runny nose, and have been sneezing since yesterday morning."',
                    border: InputBorder.none,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please describe your symptoms'
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              // Disclaimer card
              _DisclaimerCard(),

              const SizedBox(height: 20),

              // Submit button (rounded, green)
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary, // brand green from theme
                    foregroundColor: cs.onPrimary,
                    shape: const StadiumBorder(),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Submit Inquiry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5EC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFC690)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_outlined, color: Color(0xFFFF9800)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Disclaimer: The suggestions provided are for general guidance only and are not a substitute for a professional medical diagnosis. '
              'Please consult a doctor for serious conditions.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFDA7C37),
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
