import 'package:flutter/material.dart';

/// PUBLIC ENTRY: the screen we mount from bottom navigation

class ConsultDoctorScreen extends StatelessWidget {
  const ConsultDoctorScreen({super.key});
  @override
  Widget build(BuildContext context) => const SpecialistsGridPage();
}

/// SPECIALISTS GRID (search + chips) → navigates to DoctorsListPage

class SpecialistsGridPage extends StatefulWidget {
  const SpecialistsGridPage({super.key});
  @override
  State<SpecialistsGridPage> createState() => _SpecialistsGridPageState();
}

class _SpecialistsGridPageState extends State<SpecialistsGridPage> {
  final TextEditingController _search = TextEditingController();
  String selectedChip = 'All';

  final List<String> chips = const [
    'All',
    'Medicine',
    'Cardiology',
    'Dermatology',
    'Pediatrics'
  ];

  late List<Specialist> specialists;

  @override
  void initState() {
    super.initState();
    specialists = _demoSpecialists;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = specialists.where((s) {
      final byChip =
          selectedChip == 'All' || s.specialty.contains(selectedChip);
      final q = _search.text.trim().toLowerCase();
      final bySearch = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.specialty.toLowerCase().contains(q);
      return byChip && bySearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5FE),
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Available', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('Specialist'),
          ],
        ),
        actions: const [
          Icon(Icons.search, size: 22),
          SizedBox(width: 14),
          Icon(Icons.chat_bubble_outline, size: 22),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search specialists',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = chips[i];
                final active = c == selectedChip;
                return ChoiceChip(
                  label: Text(c),
                  selected: active,
                  onSelected: (_) => setState(() => selectedChip = c),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle:
                      TextStyle(color: active ? Colors.white : Colors.black87),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GridView.builder(
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, i) {
                  final s = filtered[i];
                  return _SpecialistTile(
                    specialist: s,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DoctorsListPage(
                          headerYears: s.years,
                          headerConsultations: 2000 + i * 137,
                          filterSpecialty: s.specialtyBase,
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialistTile extends StatelessWidget {
  final Specialist specialist;
  final VoidCallback onTap;
  const _SpecialistTile(
      {super.key, required this.specialist, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Hero(
                  tag: 'avatar_${specialist.id}',
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(specialist.photo),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(specialist.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(specialist.specialty,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Experience', style: TextStyle(color: Colors.grey.shade600)),
              Text('${specialist.years} Years',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Patients', style: TextStyle(color: Colors.grey.shade600)),
              Text(specialist.patients,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class Specialist {
  final String id;
  final String name;
  final String specialty; // display (can be multi-line)
  final String specialtyBase; // base for filtering
  final int years;
  final String patients;
  final String photo;

  Specialist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.specialtyBase,
    required this.years,
    required this.patients,
    required this.photo,
  });
}

/// Demo data
final _demoSpecialists = <Specialist>[
  Specialist(
    id: 's1',
    name: 'Dr. Serena Gome',
    specialty: 'Medicine\nSpecialist',
    specialtyBase: 'General Physician',
    years: 8,
    patients: '1.08K',
    photo:
        'https://img.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7807.jpg?semt=ais_hybrid&w=740&q=80',
  ),
  Specialist(
    id: 's2',
    name: 'Dr. Asma Khan',
    specialty: 'Medicine\nSpecialist',
    specialtyBase: 'General Physician',
    years: 5,
    patients: '2.7K',
    photo:
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=640&auto=format&fit=crop',
  ),
  Specialist(
    id: 's3',
    name: 'Dr. Kiran Shakia',
    specialty: 'Cardiology\nSpecialist',
    specialtyBase: 'Cardiologist',
    years: 5,
    patients: '2.7K',
    photo:
        'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=640&auto=format&fit=crop',
  ),
  Specialist(
    id: 's4',
    name: 'Dr. Masuda Rahman',
    specialty: 'Dermatology\nSpecialist',
    specialtyBase: 'Dermatologist',
    years: 6,
    patients: '2.7K',
    photo:
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?q=80&w=640&auto=format&fit=crop',
  ),
  Specialist(
    id: 's5',
    name: 'Dr. Johir Raihan',
    specialty: 'Pediatrics\nSpecialist',
    specialtyBase: 'Pediatrician',
    years: 5,
    patients: '2.7K',
    photo:
        'https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=640&auto=format&fit=crop',
  ),
];

/// ---------------------------------------------------------------------------
/// DOCTOR LIST (filters + sort)
/// ---------------------------------------------------------------------------
enum SortBy { experience, consultations }

class DoctorsListPage extends StatefulWidget {
  final int headerYears;
  final int headerConsultations;
  final String filterSpecialty;

  const DoctorsListPage({
    super.key,
    required this.headerYears,
    required this.headerConsultations,
    required this.filterSpecialty,
  });

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  SortBy sort = SortBy.experience;
  final Set<String> langFilters = {};
  double minYears = 0;

  late List<Doctor> _doctors;

  @override
  void initState() {
    super.initState();
    _doctors = _demoDoctors
        .where((d) => d.specialty == widget.filterSpecialty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var results =
        _doctors.where((d) => d.experienceYears >= minYears.round()).toList();
    if (langFilters.isNotEmpty) {
      results =
          results.where((d) => d.languages.any(langFilters.contains)).toList();
    }
    results.sort((a, b) => sort == SortBy.experience
        ? b.experienceYears.compareTo(a.experienceYears)
        : b.consultations.compareTo(a.consultations));

    final allLangs = {'English', 'Hindi', 'Punjabi', 'Gujarati'};

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.filterSpecialty),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.notifications_none))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _ExperiencePill(
              years: widget.headerYears,
              consultations: widget.headerConsultations),
          const SizedBox(height: 10),
          // Filters row
          Card(
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort
                  Row(
                    children: [
                      const Text('Sort: '),
                      const SizedBox(width: 6),
                      ChoiceChip(
                        label: const Text('Experience'),
                        selected: sort == SortBy.experience,
                        onSelected: (_) =>
                            setState(() => sort = SortBy.experience),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Consultations'),
                        selected: sort == SortBy.consultations,
                        onSelected: (_) =>
                            setState(() => sort = SortBy.consultations),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Languages
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const Text('Languages:'),
                      ...allLangs.map((l) {
                        final active = langFilters.contains(l);
                        return FilterChip(
                          label: Text(l),
                          selected: active,
                          onSelected: (v) => setState(() {
                            if (v) {
                              langFilters.add(l);
                            } else {
                              langFilters.remove(l);
                            }
                          }),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Experience slider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Min Experience: ${minYears.round()} yrs'),
                      Slider(
                        value: minYears,
                        min: 0,
                        max: 15,
                        divisions: 15,
                        label: '${minYears.round()}',
                        onChanged: (v) => setState(() => minYears = v),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Results
          ...results.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DoctorCard(doctor: d),
              )),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text('No doctors match your filters',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExperiencePill extends StatelessWidget {
  final int years;
  final int consultations;
  const _ExperiencePill({required this.years, required this.consultations});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Text('$years Year Experience',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          const Text('•', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('$consultations consultations',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorCard({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.shade300),
    );
    return Card(
      elevation: 0,
      shape: border,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DoctorDetailsPage(doctor: doctor))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'doc_${doctor.name}',
                    child: _Avatar(photoUrl: doctor.photoUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _MainInfo(doctor: doctor)),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 8),
              _PriceAndCTA(doctor: doctor),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String photoUrl;
  const _Avatar({required this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:
              Image.network(photoUrl, width: 86, height: 86, fit: BoxFit.cover),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.person_outline, size: 16),
          ),
        ),
      ],
    );
  }
}

class _MainInfo extends StatelessWidget {
  final Doctor doctor;
  const _MainInfo({required this.doctor});
  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${doctor.name} .', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(doctor.specialty,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.translate, size: 16, color: Colors.black54),
            const SizedBox(width: 6),
            Expanded(
              child: Text(doctor.languages.join(', '),
                  style: TextStyle(color: muted, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(doctor.degree,
            style: TextStyle(color: muted, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: muted, height: 1.3),
            children: [
              const TextSpan(text: 'Expertise in: '),
              TextSpan(
                  text: doctor.expertise,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _PriceAndCTA extends StatelessWidget {
  final Doctor doctor;
  const _PriceAndCTA({required this.doctor});
  @override
  Widget build(BuildContext context) {
    final priceStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontWeight: FontWeight.w900);
    return Row(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Consultation Price:',
              style: TextStyle(
                  color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Row(children: [
            Text('₹${doctor.price}', style: priceStyle),
            const SizedBox(width: 8),
            Text('₹${doctor.mrp}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.black38,
                  fontWeight: FontWeight.w600,
                )),
          ]),
        ]),
        const Spacer(),
        SizedBox(
          width: 132,
          height: 44,
          child: FilledButton.tonal(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ConfirmPage(doctor: doctor))),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Select'),
          ),
        ),
      ],
    );
  }
}

class ConfirmPage extends StatelessWidget {
  final Doctor doctor;
  const ConfirmPage({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm consultation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(doctor.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(doctor.specialty,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 16),
              Text('Consultation Price: ₹${doctor.price}',
                  style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Consultation booked (demo).'))),
                  child: const Text('Confirm & Pay'),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;
  const DoctorDetailsPage({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Hero(
                tag: 'doc_${doctor.name}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(doctor.photoUrl,
                      width: 96, height: 96, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.specialty,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Languages: ${doctor.languages.join(', ')}'),
                      const SizedBox(height: 6),
                      Text('Degree: ${doctor.degree}'),
                      const SizedBox(height: 6),
                      Text('Experience: ${doctor.experienceYears} years'),
                      const SizedBox(height: 6),
                      Text('Consultations: ${doctor.consultations}+'),
                    ]),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text('Expertise',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(doctor.expertise),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// DATA MODELS + DEMO DATA
/// ---------------------------------------------------------------------------
class Doctor {
  final String name;
  final String specialty;
  final int experienceYears;
  final int consultations;
  final List<String> languages;
  final String degree;
  final String expertise;
  final int price;
  final int mrp;
  final String photoUrl;

  Doctor({
    required this.name,
    required this.specialty,
    required this.experienceYears,
    required this.consultations,
    required this.languages,
    required this.degree,
    required this.expertise,
    required this.price,
    required this.mrp,
    required this.photoUrl,
  });
}

final _demoDoctors = <Doctor>[
  Doctor(
    name: 'Dr. Ria',
    specialty: 'General Physician',
    experienceYears: 7,
    consultations: 2143,
    languages: const ['Hindi', 'English', 'Punjabi'],
    degree: 'MBBS',
    expertise: 'General Health, Heart Health, Breathing and Lung Health, ...',
    price: 199,
    mrp: 249,
    photoUrl:
        'https://thumbs.dreamstime.com/b/smiling-medical-doctor-woman-stethoscope-isolated-over-white-background-35552912.jpg',
  ),
  Doctor(
    name: 'Dr. Pooja Dayma',
    specialty: 'General Physician',
    experienceYears: 5,
    consultations: 1513,
    languages: const ['English', 'Hindi'],
    degree: 'M.B.B.S',
    expertise: 'General Health, Kidney Care, Bone and Joint Health',
    price: 199,
    mrp: 249,
    photoUrl:
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=640&auto=format&fit=crop',
  ),
  Doctor(
    name: 'Dr. Akshita Singh',
    specialty: 'General Physician',
    experienceYears: 3,
    consultations: 248,
    languages: const ['English', 'Hindi', 'Gujarati'],
    degree: 'MBBS',
    expertise: 'Fever, Cough & Cold, Women’s General Health',
    price: 149,
    mrp: 249,
    photoUrl:
        'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=640&auto=format&fit=crop',
  ),
  Doctor(
    name: 'Dr. Arjun Patel',
    specialty: 'Cardiologist',
    experienceYears: 11,
    consultations: 4321,
    languages: const ['English', 'Hindi', 'Gujarati'],
    degree: 'MD (Cardiology)',
    expertise: 'Heart Health, Hypertension, ECG Interpretation',
    price: 499,
    mrp: 799,
    photoUrl:
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?q=80&w=640&auto=format&fit=crop',
  ),
  Doctor(
    name: 'Dr. Nisha Kapoor',
    specialty: 'Dermatologist',
    experienceYears: 9,
    consultations: 1890,
    languages: const ['English', 'Hindi'],
    degree: 'MD (Dermatology)',
    expertise: 'Acne, Hairfall, Skin Allergies',
    price: 399,
    mrp: 699,
    photoUrl:
        'https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=640&auto=format&fit=crop',
  ),
  Doctor(
    name: 'Dr. Rohan Iyer',
    specialty: 'Pediatrician',
    experienceYears: 6,
    consultations: 980,
    languages: const ['English', 'Hindi'],
    degree: 'MD (Pediatrics)',
    expertise: 'Child Growth, Vaccination, Fever',
    price: 349,
    mrp: 599,
    photoUrl:
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=640&auto=format&fit=crop',
  ),
];
