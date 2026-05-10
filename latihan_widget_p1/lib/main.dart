import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Latihan Widget'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // latihan 1
                const SizedBox(height: 20),
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Hello Flutter!',
                        style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue,
                        ),
                      ),

                      SizedBox(height: 8),
                      Text('Ini teks biasa dengan ukuran kecil',
                        style: TextStyle(fontSize: 14, color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // latihan 2
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 200, height: 200,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: const Center(
                      child: Text('Box',
                        style: TextStyle(color: Colors.white, fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                // latihan 3
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 70, height: 70, color: Colors.red,
                    ),

                    Container(
                      width: 70, height: 70, color: Colors.green,
                    ),

                    Container(
                      width: 70, height: 70, color: Colors.orange,
                    ),
                  ],
                ),

                // latihan 4
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1), blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.home, size: 32, color: Colors.red,
                      ),

                      Icon(Icons.favorite, size: 32, color: Colors.green,
                      ),

                      Icon(
                        Icons.person, size: 32, color: Colors.purple,
                      ),

                      Icon(Icons.settings, size: 32, color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}