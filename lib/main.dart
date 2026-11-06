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
      title: 'Text previewer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C62A1),
          primary: const Color(0xFF6750A4),
          surface: const Color(0xFFFAF7FF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD0BCFF),
          foregroundColor: Colors.black87,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _textController = TextEditingController();
  double _fontSize = 73.0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Вікно з діалогом та правильним роботом
  void _showResultDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          content: Column(
            mainAxisSize: minAxisSizeMax(MainAxisSize.min),
            children: [
              Image.asset(
                'assets/images/robot.png',
                height: 90,
                width: 90,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.android, size: 80, color: Colors.purple),
              ),
              const SizedBox(height: 20),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Помічник для розрахунку розмірів колонки
  MainAxisSize minAxisSizeMax(MainAxisSize value) => value;

  Future<void> _navigateToPreview() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          text: _textController.text,
          fontSize: _fontSize,
        ),
      ),
    );

    if (!mounted) return;

    if (result == 'ok') {
      _showResultDialog('Cool!');
    } else if (result == 'cancel') {
      _showResultDialog("Let's try something else.");
    } else {
      _showResultDialog("Don't know what to say.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text previewer',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Text',
                  helperText: 'Enter some text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Font size: ${_fontSize.round()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Slider(
                      value: _fontSize,
                      min: 10,
                      max: 100,
                      activeColor: const Color(0xFF6750A4),
                      onChanged: (double value) {
                        setState(() {
                          _fontSize = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _navigateToPreview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Preview',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final String text;
  final double fontSize;

  const PreviewScreen({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    text.isEmpty ? 'No text' : text,
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'ok');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Ok'),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, 'cancel');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}