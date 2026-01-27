import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'payment_screen.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final String customerName;
  final String deliveryAddress;

  const PrescriptionDetailsScreen({
    super.key,
    required this.customerName,
    required this.deliveryAddress,
  });

  @override
  State<PrescriptionDetailsScreen> createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _doctorNameCtrl = TextEditingController();
  final _prescriptionTextCtrl = TextEditingController();

  final auth = FirebaseAuth.instance;

  File? _image;
  bool _loading = false;

  /* -------------------------------------------------------------------------- */
  /*                              PICK IMAGE (GALLERY)                           */
  /* -------------------------------------------------------------------------- */

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                 CONTINUE → GO TO PAYMENT SCREEN                             */
  /* -------------------------------------------------------------------------- */

  Future<void> _continueToPayment() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Must have either text OR image
    if (_prescriptionTextCtrl.text.trim().isEmpty && _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please add prescription text or upload prescription image'),
        ),
      );
      return;
    }

    final user = auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    try {
      String? imageUrl;

      // Upload image if provided
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref('prescriptions')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      if (!mounted) return;

      // ✅ GO TO PAYMENT SCREEN (NO ORDER CREATED YET)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            customerName: widget.customerName,
            deliveryAddress: widget.deliveryAddress,
            doctorName: _doctorNameCtrl.text.trim(),
            prescriptionText: _prescriptionTextCtrl.text.trim(),
            prescriptionImageUrl: imageUrl,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _doctorNameCtrl.dispose();
    _prescriptionTextCtrl.dispose();
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  /*                                   UI                                       */
  /* -------------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescription Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Doctor Name (Required)
              TextFormField(
                controller: _doctorNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Doctor name required' : null,
              ),
              const SizedBox(height: 16),

              // Prescription Text (Optional)
              TextFormField(
                controller: _prescriptionTextCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Prescription Details (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Upload Prescription Image
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Prescription Image'),
                onPressed: _pickImage,
              ),

              if (_image != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Image selected',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _loading ? null : _continueToPayment,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Continue to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
