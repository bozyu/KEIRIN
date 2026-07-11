import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Подключили шрифты
import 'screens/home_screen.dart';

void main() {
  runApp(const KeirinApp());
}

class KeirinApp extends StatefulWidget {
  const KeirinApp({super.key});

  @override
  State<KeirinApp> createState() => _KeirinAppState();
}

class _KeirinAppState extends State<KeirinApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Базовая тема для темного режима
    final baseTheme = ThemeData(brightness: Brightness.dark);

    return MaterialApp(
      title: 'Keirin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1611),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.greenAccent.withValues(alpha: 0.12)),
          ),
          color: const Color(0xFF14231A),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: Color(0xFF2ECC71),
          backgroundColor: Color(0xFF101A13),
        ),
      ),
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          }
        },
        child: Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: IndexedStack(
              key: ValueKey<int>(_currentIndex),
              index: _currentIndex,
              children: const [
                HomeScreen(),
                MySetupsScreen(),
                SettingsScreen(),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'фиксы',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_bike_outlined),
                selectedIcon: Icon(Icons.directions_bike),
                label: 'мои сэтапы',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'настройки',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySetupsScreen extends StatelessWidget {
  const MySetupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'мои сэтапы',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'сохранённые сэйтапы появятся здесь, ля будто бы их нету, но они есть, просто их пока нету. и вообще я ногу сломал, так что тильт у меня. эх, еще до байка 3-4 месяца не могу сидеть.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'настройки и что?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'ну я хз, что сюда написать, но тут будут настройки приложения. крч, автор ленивый и пока что не придумал, что сюда добавить, но в будущем тут будут настройки. ну а пока что тут пусто, но это не значит, что тут ничего нету, просто пока что тут ничего нету, но в будущем тут будет что-то.абид',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('о приложении'),
                subtitle: const Text(
                  'о, ма бой, аптору лень, да и ваще он уже многое начал забывать. ЕГО ЮЗЕРКА В ТГ: @bozyu',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
