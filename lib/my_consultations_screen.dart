import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyConsultationsScreen extends StatelessWidget {
  const MyConsultationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Consultations')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('consultations')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No consultations yet',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(
                    data['doctorName'] ?? 'Doctor',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    data['userMessage'] ?? '—',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Chip(
                    label: Text(data['status'] ?? 'pending'),
                    backgroundColor: (data['status'] ?? 'pending') == 'pending'
                        ? Colors.orange.shade100
                        : Colors.green.shade100,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConsultationStatusScreen(
                          data: data,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConsultationStatusScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ConsultationStatusScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'pending';

    return Scaffold(
      appBar: AppBar(title: const Text('Consultation Status')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 USER NAME
            const Text(
              'Your Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(data['userName'] ?? 'Not provided'),
            const Divider(height: 24),

            // 💬 USER MESSAGE
            const Text(
              'Your Message',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(data['userMessage'] ?? '—'),
            const Divider(height: 32),

            // ⏳ STATUS / REPLY
            if (status == 'pending') ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Waiting for doctor reply...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Text(
                'Doctor Reply',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['doctorReply'] ?? '—',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
