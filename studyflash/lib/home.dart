import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  bool _showIntro = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('first_time') ?? true;

    setState(() {
      _showIntro = isFirstTime;
      _isLoading = false;
    });
  }

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
    setState(() => _showIntro = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _showIntro ? IntroScreen(onComplete: _completeIntro) : const HomeScreen();
  }
}

class IntroScreen extends StatelessWidget {
  final VoidCallback onComplete;

  const IntroScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              _IntroPage(
                title: "Bienvenido",
                color: Colors.blue[100]!,
              ),
              _IntroPage(
                title: "Funcionalidades",
                color: Colors.green[100]!,
              ),
              _IntroPage(
                title: "¡Comencemos!",
                color: Colors.orange[100]!,
                isLast: true,
                onPressed: onComplete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLast;
  final VoidCallback? onPressed;

  const _IntroPage({
    required this.title,
    required this.color,
    this.isLast = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          if (isLast)
            ElevatedButton(
              onPressed: onPressed,
              child: const Text("Entrar a la app"),
            ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Hola",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}