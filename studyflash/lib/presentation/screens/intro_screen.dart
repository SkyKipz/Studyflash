import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    _IntroPage(
      title: 'Bienvenido a StudyFlash',
      description: 'La mejor app para aprender con flashcards',
      color: Colors.deepPurple,
    ),
    _IntroPage(
      title: 'Crea tus propios sets',
      description: 'Organiza tu material de estudio fácilmente',
      color: Colors.indigo,
    ),
    _IntroPage(
      title: 'Comienza ahora',
      description: 'Empieza a mejorar tu aprendizaje',
      color: Colors.blue,
    ),
  ];

  void _onSkipPressed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introShown', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NewHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (_, index) => _pages[index],
            ),
          ),
          _BottomControls(
            currentPage: _currentPage,
            totalPages: _pages.length,
            onSkipPressed: _onSkipPressed,
            onNextPressed: () {
              if (_currentPage < _pages.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                _onSkipPressed();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _IntroPage({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, size: 100, color: Colors.white),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkipPressed;
  final VoidCallback onNextPressed;

  const _BottomControls({
    required this.currentPage,
    required this.totalPages,
    required this.onSkipPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onSkipPressed,
            child: Text(currentPage == totalPages - 1 ? 'Empezar' : 'Saltar'),
          ),
          Row(
            children: List.generate(totalPages, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                ),
              );
            }),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: onNextPressed,
          ),
        ],
      ),
    );
  }
}