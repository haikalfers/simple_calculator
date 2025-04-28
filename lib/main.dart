import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator Sederhana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  double? _result;
  final _formKey = GlobalKey<FormState>();

  String _selectedOperation = '+';

  // List untuk menyimpan riwayat
  List<String> _history = [];

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double num1 = double.parse(_controller1.text);
      double num2 = double.parse(_controller2.text);
      double res = 0;

      switch (_selectedOperation) {
        case '+':
          res = num1 + num2;
          break;
        case '-':
          res = num1 - num2;
          break;
        case '×':
          res = num1 * num2;
          break;
        case '÷':
          if (num2 != 0) {
            res = num1 / num2;
          } else {
            _showError('Tidak bisa dibagi dengan nol!');
            return;
          }
          break;
      }

      setState(() {
        _result = res;
        // Menyimpan riwayat perhitungan
        _history.insert(0, "$num1 $_selectedOperation $num2 = $_result");
      });
    }
  }

  void _clearFields() {
    _controller1.clear();
    _controller2.clear();
    setState(() {
      _result = null;
      _selectedOperation = '+';
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Kalkulator Sederhana'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calculate, size: 64, color: Colors.blueAccent),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _controller1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Angka pertama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan angka pertama';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Input harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedOperation,
                        decoration: InputDecoration(
                          labelText: 'Pilih Operasi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ['+', '-', '×', '÷']
                            .map((op) => DropdownMenuItem(
                                  value: op,
                                  child: Text(op),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedOperation = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Angka kedua',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan angka kedua';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Input harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _calculate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Hitung',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _clearFields,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _result != null
                            ? Text(
                                'Hasil: ${_result!.toStringAsFixed(2)}',
                                key: ValueKey<double>(_result!),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 24),
                      // Menampilkan Riwayat
                      const Divider(),
                      const SizedBox(height: 10),
                      const Text(
                        "Riwayat Perhitungan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ListView untuk Riwayat
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _history[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {
                              // Ketika riwayat diklik, bisa dipakai lagi di input
                              var parts = _history[index].split(' ');
                              _controller1.text = parts[0];
                              _controller2.text = parts[2];
                              setState(() {
                                _selectedOperation = parts[1];
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _clearHistory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear History',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
