import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'screens/composite/dashboard/dashboard_screen.dart';
import 'screens/composite/book_list/book_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stephen King Books',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  String? _pendingSearchQuery;

  // Navigate to BookListScreen with search query
  void _navigateToSearch(String query) {
    setState(() {
      _selectedIndex = 1; // Navigate to BookListScreen
      _pendingSearchQuery = query;
    });
  }

  // Clear pending search after BookListScreen uses it
  void _clearPendingSearch() {
    if (_pendingSearchQuery != null) {
      setState(() {
        _pendingSearchQuery = null;
      });
    }
  }

  // Build screens dynamically to avoid const issues with providers
  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(onSearch: _navigateToSearch);
      case 1:
        return BookListScreen(
          initialQuery: _pendingSearchQuery,
          onSearchConsumed: _clearPendingSearch,
        );
      default:
        return DashboardScreen(onSearch: _navigateToSearch);
    }
  }

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.list_outlined),
      selectedIcon: Icon(Icons.list),
      label: 'Book List',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
        elevation: 8,
      ),
    );
  }
}
