import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'app/app_bloc_observer.dart';
import 'core/injections/service_locator.dart';
import 'features/books/presentation/pages/dashboard_screen.dart';
import 'features/books/presentation/pages/book_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup BLoC Observer cho logging
  Bloc.observer = AppBlocObserver();

  // Initialize Dependency Injection
  await initializeDependencies();

  runApp(const App(
    home: MainNavigationScreen(),
  ));
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
