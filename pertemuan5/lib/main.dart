import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final String email;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'judul': judul,
        'isi': isi,
        'kategori': kategori,
        'email': email,
        'dibuat_pada': dibuatPada.millisecondsSinceEpoch,
      };

  static Catatan fromMap(Map<String, Object?> m) => Catatan(
        id: m['id'] as int?,
        judul: (m['judul'] as String?) ?? '',
        isi: (m['isi'] as String?) ?? '',
        kategori: (m['kategori'] as String?) ?? 'Lainnya',
        email: (m['email'] as String?) ?? '',
        dibuatPada: DateTime.fromMillisecondsSinceEpoch(
          (m['dibuat_pada'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
        ),
      );

  Catatan copyWith({String? judul, String? isi, String? kategori, String? email}) =>
      Catatan(
        id: id,
        judul: judul ?? this.judul,
        isi: isi ?? this.isi,
        kategori: kategori ?? this.kategori,
        email: email ?? this.email,
        dibuatPada: dibuatPada,
      );
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/form':
            final arg = settings.arguments;
            return MaterialPageRoute(
              builder: (_) => CatatanFormPage(initial: arg as Catatan?),
            );
          case '/detail':
            final c = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: c),
            );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Catatan>> _futureCatatan;
  String _filterKategori = 'Semua';

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futureCatatan = DbHelper.instance.getAll();
    });
  }

  Future<void> _bukaForm({Catatan? initial}) async {
    await Navigator.pushNamed(context, '/form', arguments: initial);
    _muatUlang();
  }

  Future<void> _konfirmasiHapus(Catatan c) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('"${c.judul}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      await DbHelper.instance.delete(c.id!);
      if (!mounted) return;
      _muatUlang();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${c.judul}" dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        title: const Text('Catatan Mahasiswa'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _filterKategori,
                  isDense: true,
                  style: const TextStyle(color: Colors.brown),
                  borderRadius: BorderRadius.circular(12),
                  items: const [
                    DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                    DropdownMenuItem(value: 'Kuliah', child: Text('Kuliah')),
                    DropdownMenuItem(value: 'Tugas', child: Text('Tugas')),
                    DropdownMenuItem(value: 'Pribadi', child: Text('Pribadi')),
                    DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: FutureBuilder<List<Catatan>>(
        future: _futureCatatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          var data = snapshot.data ?? const [];
          
          if (_filterKategori != 'Semua') {
            data = data.where((c) => c.kategori == _filterKategori).toList();
          }

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada catatan',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            padding: const EdgeInsets.all(12),
            itemBuilder: (_, i) => _itemCatatan(data[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  Widget _itemCatatan(Catatan c) {
    return Card(
      child: ListTile(
        title: Text(c.judul),
        subtitle: Text(c.kategori),
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: c).then((_) => _muatUlang()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _bukaForm(initial: c),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _konfirmasiHapus(c),
            ),
          ],
        ),
      ),
    );
  }
}

class CatatanFormPage extends StatefulWidget {
  final Catatan? initial;
  const CatatanFormPage({super.key, this.initial});

  @override
  State<CatatanFormPage> createState() => _CatatanFormPageState();
}

class _CatatanFormPageState extends State<CatatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late final TextEditingController _emailCtrl;
  late String _kategori;
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  bool get _isEdit => widget.initial != null;
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    _judulCtrl = TextEditingController(text: widget.initial?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.initial?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.initial?.email ?? '');
    _kategori = widget.initial?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _menyimpan = true);
    try {
      if (_isEdit) {
        final updated = widget.initial!.copyWith(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
          email: _emailCtrl.text.trim(),
        );
        await DbHelper.instance.update(updated);
      } else {
        final baru = Catatan(
          judul: _judulCtrl.text.trim(),
          isi: _isiCtrl.text.trim(),
          kategori: _kategori,
          email: _emailCtrl.text.trim(),
          dibuatPada: DateTime.now(),
        );
        await DbHelper.instance.insert(baru);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEdit ? 'Catatan diperbarui' : 'Catatan ditambahkan'),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
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
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
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
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                final regex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                if (!regex.hasMatch(v.trim())) return 'Format email tidak valid';
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
                if (v == null || v.trim().isEmpty) return 'Isi wajib diisi';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _menyimpan ? null : _simpan,
              icon: _menyimpan
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save),
              label: Text(_menyimpan ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, '/form', arguments: catatan);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
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
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
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
