import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class ProfileData {
  String name;
  String about;
  String education;
  String location;
  String contact;
  List<String> skills;
  Uint8List? image;

  ProfileData({
    required this.name,
    required this.about,
    required this.education,
    required this.location,
    required this.contact,
    required this.skills,
    this.image,
  });
}

class ExperienceData {
  String title;
  String description;
  Uint8List? image;

  ExperienceData({
    required this.title,
    required this.description,
    this.image,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz Praktikum Pemograman Mobile 2026',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 1;

  ProfileData profile = ProfileData(
    name: 'Milda Khaerunnisa',
    about: 'Saya mahasiswa Teknik Informatika.',
    education: 'Teknik Informatika - Semester 6',
    location: 'Bandung, Jawa Barat',
    contact: 'milda@student.ac.id',
    skills: ['Flutter', 'Dart', 'Java', 'Python', 'Git'],
  );

  List<ExperienceData> experiences = [
    ExperienceData(
      title: 'Belum ada pengalaman',
      description: 'Tambahkan pengalaman melalui drawer.',
    )
  ];

  void _updateProfile(ProfileData newData) {
    setState(() {
      profile = newData;
    });
  }

  void _addExperience(ExperienceData newData) {
    setState(() {
      if (experiences.length == 1 &&
          experiences[0].title == 'Belum ada pengalaman') {
        experiences = [newData];
      } else {
        experiences.add(newData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu Utama',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditExperiencePage(
                      data: ExperienceData(title: '', description: ''),
                    ),
                  ),
                );
                if (result != null && result is ExperienceData) {
                  _addExperience(result);
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        profile.image != null
                            ? MemoryImage(profile.image!)
                            : const AssetImage(
                                  'asset/profile.png',
                                )
                                as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: _StatBox(label: 'Post', value: '25')),
                Expanded(child: _StatBox(label: 'Followers', value: '1.5K')),
                Expanded(child: _StatBox(label: 'Following', value: '450')),
              ],
            ),
            const SizedBox(height: 24),
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: profile.about,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: profile.education,
            ),
            _SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: profile.location,
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: profile.contact,
            ),
            _SectionCard(
              icon: Icons.star,
              title: 'Skills',
              contentWidget: Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    profile.skills.map((s) => Chip(label: Text(s))).toList(),
              ),
            ),
            // BONUS: Section Pengalaman
            _SectionCard(
              icon: Icons.work,
              title: 'Pengalaman',
              trailing: CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFF6750A4),
                child: Text(
                  '${experiences.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              contentWidget: Column(
                children: experiences.map((exp) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (exp.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              exp.image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                exp.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(data: profile),
            ),
          );
          if (result != null && result is ProfileData) {
            _updateProfile(result);
          }
        },
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final ProfileData data;
  const EditProfilePage({super.key, required this.data});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _aboutController;
  late TextEditingController _educationController;
  late TextEditingController _locationController;
  late TextEditingController _contactController;
  late TextEditingController _skillsController;
  Uint8List? _imageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data.name);
    _aboutController = TextEditingController(text: widget.data.about);
    _educationController = TextEditingController(text: widget.data.education);
    _locationController = TextEditingController(text: widget.data.location);
    _contactController = TextEditingController(text: widget.data.contact);
    _skillsController = TextEditingController(text: widget.data.skills.join(', '));
    _imageBytes = widget.data.image;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageBytes != null
                            ? MemoryImage(_imageBytes!)
                            : const AssetImage(
                                  'asset/profile.png',
                                )
                                as ImageProvider,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: const Color(0xFF6750A4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('Ketuk untuk ganti foto'),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aboutController,
              decoration: const InputDecoration(
                labelText: 'Tentang Saya',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _educationController,
              decoration: const InputDecoration(
                labelText: 'Pendidikan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Kontak',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills (pisahkan dengan koma)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final newData = ProfileData(
                    name: _nameController.text,
                    image: _imageBytes,
                    about: _aboutController.text,
                    education: _educationController.text,
                    location: _locationController.text,
                    contact: _contactController.text,
                    skills:
                        _skillsController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList(),
                  );
                  Navigator.pop(context, newData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditExperiencePage extends StatefulWidget {
  final ExperienceData data;
  const EditExperiencePage({super.key, required this.data});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  Uint8List? _imageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data.title);
    _descController = TextEditingController(text: widget.data.description);
    _imageBytes = widget.data.image;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Pengalaman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Informasi Pengalaman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul *',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _imageBytes != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        )
                        : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: const Color(0xFF6750A4)),
                            Text('Ketuk untuk pilih gambar'),
                            Text(
                              'dari galeri perangkat kamu',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final newData = ExperienceData(
                  title: _titleController.text,
                  description: _descController.text,
                  image: _imageBytes,
                );
                Navigator.pop(context, newData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Simpan Pengalaman'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final Widget? contentWidget;
  final Widget? trailing;

  const _SectionCard({
    required this.icon,
    required this.title,
    this.content,
    this.contentWidget,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (content != null)
                    Text(content!, style: const TextStyle(height: 1.4)),
                  if (contentWidget != null) contentWidget!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
