import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;

  final String email;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.brown,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      email: 'milda@gmail.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  // Tugas 2 Filter berdasarkan kategori
  String _filterKategori = 'Semua';

  List<Catatan> get _catatanFiltered {

    if (_filterKategori == 'Semua') {
      return _catatan;
    }

    return _catatan
        .where((c) => c.kategori == _filterKategori)
        .toList();
  }

  Future<void> _bukaTambahCatatan({
    Catatan? catatan,
    int? index,
  }) async {

    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahCatatanPage(
          catatan: catatan,
          index: index,
        ),
      ),
    );

    if (!mounted) return;

    if (hasil != null) {

      final catatanBaru = hasil['catatan'];
      final editIndex = hasil['index'];

      setState(() {

        // Tugas 1 Edit catatan
        if (editIndex != null) {
          _catatan[editIndex] = catatanBaru;
        } else {
          _catatan.add(catatanBaru);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editIndex != null
                ? 'Catatan berhasil diupdate'
                : 'Catatan berhasil ditambahkan',
          ),
        ),
      );
    }
  }

  void _hapusCatatan(int index) {

    setState(() {
      _catatan.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil dihapus'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        title: const Text('Catatan Mahasiswa'),

        // Tugas 2 Filter berdasarkan kategori
        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 12),

            child: Container(
              height: 36,

              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _filterKategori,

                  isDense: true,

                  borderRadius: BorderRadius.circular(12),

                  items: const [

                    DropdownMenuItem(
                      value: 'Semua',
                      child: Text('Semua'),
                    ),

                    DropdownMenuItem(
                      value: 'Kuliah',
                      child: Text('Kuliah'),
                    ),

                    DropdownMenuItem(
                      value: 'Tugas',
                      child: Text('Tugas'),
                    ),

                    DropdownMenuItem(
                      value: 'Pribadi',
                      child: Text('Pribadi'),
                    ),

                    DropdownMenuItem(
                      value: 'Lainnya',
                      child: Text('Lainnya'),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {
                      _filterKategori = value!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      body: _catatanFiltered.isEmpty
          ? const Center(
        child: Text(
          'Belum ada catatan',
          style: TextStyle(fontSize: 18),
        ),
      )

          : ListView.builder(
        itemCount: _catatanFiltered.length,

        itemBuilder: (context, i) {

          final c = _catatanFiltered[i];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            child: ListTile(

              title: Text(c.judul),
              subtitle: Text(c.kategori),

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailCatatanPage(
                      catatan: c,
                      onEdit: () {
                        _bukaTambahCatatan(
                          catatan: c,
                          index: _catatan.indexOf(c),
                        );
                      },
                    ),
                  ),
                );
              },

              trailing: IconButton(
                icon: const Icon(Icons.delete),

                onPressed: () {
                  _hapusCatatan(
                    _catatan.indexOf(c),
                  );
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bukaTambahCatatan();
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}

// Tambah catatan
class TambahCatatanPage extends StatefulWidget {

  // Edit catatan
  final Catatan? catatan;
  final int? index;

  const TambahCatatanPage({
    super.key,
    this.catatan,
    this.index,
  });

  @override
  State<TambahCatatanPage> createState() =>
      _TambahCatatanPageState();
}

class _TambahCatatanPageState
    extends State<TambahCatatanPage> {

  final _formKey = GlobalKey<FormState>();

  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();

  // Tugas 3 Validasi Lanjutan
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';

  final _kategoriOpsi = const [
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  // Tugas 1 Fitur edit catatan
  @override
  void initState() {
    super.initState();

    if (widget.catatan != null) {

      _judulCtrl.text = widget.catatan!.judul;
      _isiCtrl.text = widget.catatan!.isi;
      _emailCtrl.text = widget.catatan!.email;
      _kategori = widget.catatan!.kategori;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {

    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: DateTime.now(),
    );

    Navigator.pop(
      context,
      {
        'catatan': catatanBaru,
        'index': widget.index,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.catatan != null
              ? 'Edit Catatan'
              : 'Tambah Catatan',
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [

            TextFormField(
              controller: _judulCtrl,

              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),

              validator: (v) {

                if (v == null || v.trim().isEmpty) {
                  return 'Judul wajib diisi';
                }

                if (v.trim().length < 3) {
                  return 'Minimal 3 karakter';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _kategori,

              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),

              items: _kategoriOpsi
                  .map(
                    (k) => DropdownMenuItem(
                  value: k,
                  child: Text(k),
                ),
              )
                  .toList(),

              onChanged: (v) {

                setState(() {
                  _kategori = v!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Tugas 3 Validasi lanjutan
            TextFormField(
              controller: _emailCtrl,

              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),

              validator: (v) {

                if (v == null || v.trim().isEmpty) {
                  return 'Email wajib diisi';
                }

                final regex = RegExp(
                  r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                );

                if (!regex.hasMatch(v.trim())) {
                  return 'Format email tidak valid';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,

              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),

              validator: (v) {

                if (v == null || v.trim().isEmpty) {
                  return 'Isi wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatelessWidget {

  final Catatan catatan;

  final VoidCallback onEdit;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Detail Catatan'),
      ),

      // Tugas 1 Fitur edit catatan
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),

        onPressed: () {

          Navigator.pop(context);

          onEdit();
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              catatan.judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Chip(
              label: Text(catatan.kategori),
            ),

            const SizedBox(height: 16),

            Text(
              catatan.email,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 16),

            Text(
              'Tanggal: ${catatan.dibuatPada.day}/${catatan.dibuatPada.month}/${catatan.dibuatPada.year}',
            ),

            const Divider(height: 32),

            Text(
              catatan.isi,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}