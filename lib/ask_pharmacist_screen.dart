// lib/ask_pharmacist_screen.dart
import 'package:flutter/material.dart';
import 'consult_doctor_screen.dart';

/// Ask Pharmacist / Symptom -> simplified version
/// - Only 4 specialties (General Medicine, Cardiology, Dermatology, Pediatrics)
/// - Selecting a specialty shows 4 cards (styled like home)
/// - Tapping a card navigates to DoctorsListPage (from consult_doctor_screen.dart)
class AskPharmacistScreen extends StatefulWidget {
  const AskPharmacistScreen({super.key});

  @override
  State<AskPharmacistScreen> createState() => _AskPharmacistScreenState();
}

class _AskPharmacistScreenState extends State<AskPharmacistScreen> {
  final List<String> specialties = const [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Pediatrics',
  ];

  // 4 sample cards per specialty. Replace image paths with your real home images if desired.
  final Map<String, List<_CardInfo>> specialtyCards = {
    'General Medicine': const [
      _CardInfo('Cold & Flu', 'assets/images/card_generic_1.png'),
      _CardInfo('Pain Relief', 'assets/images/card_generic_2.png'),
      _CardInfo('Vitamins', 'assets/images/card_generic_3.png'),
      _CardInfo('Digestive Care', 'assets/images/card_generic_4.png'),
    ],
    'Cardiology': const [
      _CardInfo('BP Care', 'assets/images/card_cardio_1.png'),
      _CardInfo('Cholesterol', 'assets/images/card_cardio_2.png'),
      _CardInfo('Heart Support', 'assets/images/card_cardio_3.png'),
      _CardInfo('ECG & Tests', 'assets/images/card_cardio_4.png'),
    ],
    'Dermatology': const [
      _CardInfo('Acne Care', 'assets/images/card_derm_1.png'),
      _CardInfo('Skin Creams', 'assets/images/card_derm_2.png'),
      _CardInfo('Anti-allergy', 'assets/images/card_derm_3.png'),
      _CardInfo('Hair Care', 'assets/images/card_derm_4.png'),
    ],
    'Pediatrics': const [
      _CardInfo('Baby Care', 'assets/images/card_pedia_1.png'),
      _CardInfo('Fever & Antibiotics', 'assets/images/card_pedia_2.png'),
      _CardInfo('Supplements', 'assets/images/card_pedia_3.png'),
      _CardInfo('Vaccinations', 'assets/images/card_pedia_4.png'),
    ],
  };

  String? _selectedSpecialty;
  final TextEditingController _detailsCtrl = TextEditingController();

  @override
  void dispose() {
    _detailsCtrl.dispose();
    super.dispose();
  }

  void _selectSpecialty(String s) {
    setState(() {
      if (_selectedSpecialty == s) {
        // toggle off
        _selectedSpecialty = null;
      } else {
        _selectedSpecialty = s;
      }
    });
  }

  /// Map the UI specialty labels to the exact Doctor.specialty values
  /// expected by DoctorsListPage.filterSpecialty.
  String _mapToDoctorSpecialty(String uiSpecialty) {
    const map = {
      'General Medicine': 'General Physician',
      'Cardiology': 'Cardiologist',
      'Dermatology': 'Dermatologist',
      'Pediatrics': 'Pediatrician',
    };
    return map[uiSpecialty] ?? 'General Physician';
  }

  /// Open the DoctorsListPage filtered for the selected specialty.
  /// [source] can be either a selected specialty or a card title; we prefer
  /// the currently selected specialty when available.
  void _openConsultDoctor(BuildContext context, String source) {
    final useUiSpecialty = _selectedSpecialty ?? source;
    final filterSpecialty = _mapToDoctorSpecialty(useUiSpecialty);

    // Choose header numbers based on specialty (simple heuristics; tweak as needed)
    int headerYears = 5;
    int headerConsultations = 1500;
    if (filterSpecialty == 'Cardiologist') {
      headerYears = 8;
      headerConsultations = 3200;
    } else if (filterSpecialty == 'Dermatologist') {
      headerYears = 6;
      headerConsultations = 1900;
    } else if (filterSpecialty == 'Pediatrician') {
      headerYears = 6;
      headerConsultations = 980;
    } else if (filterSpecialty == 'General Physician') {
      headerYears = 5;
      headerConsultations = 2000;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DoctorsListPage(
          headerYears: headerYears,
          headerConsultations: headerConsultations,
          filterSpecialty: filterSpecialty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final cardsForSelected = _selectedSpecialty == null
        ? <_CardInfo>[]
        : (specialtyCards[_selectedSpecialty!] ?? <_CardInfo>[]);

    return Scaffold(
      appBar: AppBar(title: const Text('Describe your symptoms')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Top reminder card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child:
                      Icon(Icons.medical_services_outlined, color: cs.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Not sure what to get?',
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Pick a specialty to see recommended categories',
                          style: text.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Specialties chips (only the four)
          Text('Pick a specialty',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in specialties)
                ChoiceChip(
                  label: Text(s),
                  selected: _selectedSpecialty == s,
                  onSelected: (_) => _selectSpecialty(s),
                  selectedColor: cs.primary,
                  backgroundColor: cs.surfaceVariant,
                  labelStyle: TextStyle(
                    color:
                        _selectedSpecialty == s ? cs.onPrimary : cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          // Details text input (optional)
          Text('More details (symptoms, duration, allergies)',
              style: text.bodyMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _detailsCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(
              hintText:
                  'E.g. Fever for 2 days, temp 101°F, took paracetamol...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 18),

          // If no specialty selected show a helpful hint
          if (_selectedSpecialty == null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Text(
                'Select a specialty above to view recommended categories and consult doctors.',
                style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ] else ...[
            // Header for the selected specialty + change button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedSpecialty!,
                    style:
                        text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedSpecialty = null),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Grid of 4 cards
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cardsForSelected.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final c = cardsForSelected[index];
                return _CategoryCard(
                  title: c.title,
                  imageAsset: c.imageAsset,
                  onTap: () => _openConsultDoctor(context, c.title),
                );
              },
            ),

            const SizedBox(height: 18),

            // Submit to pharmacist — navigates to consult for the specialty
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: () {
                  if (_selectedSpecialty != null) {
                    _openConsultDoctor(context, _selectedSpecialty!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select a specialty first')),
                    );
                  }
                },
                child: const Text('Submit to Pharmacist'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small helper for card metadata
class _CardInfo {
  final String title;
  final String imageAsset;
  const _CardInfo(this.title, this.imageAsset);
}

/// Visual category/medicine card used in grid (home-like style)
class _CategoryCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final VoidCallback onTap;
  const _CategoryCard({
    required this.title,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceVariant,
                      child: Center(
                        child: Icon(Icons.medication_outlined,
                            size: 36, color: cs.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
