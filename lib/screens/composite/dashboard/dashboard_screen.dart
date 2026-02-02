import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/widgets/widgets.dart';
import '../../../features/books/presentation/bloc/books_bloc.dart';
import '../../../features/books/presentation/bloc/books_event.dart';
import '../../../features/books/presentation/bloc/books_state.dart';
import '../../../features/books/presentation/widgets/stats/stats_bloc.dart';
import '../../../features/books/presentation/widgets/stats/stats_event.dart';
import '../../../features/books/presentation/widgets/stats/stats_state.dart';
import '../../../core/widgets/connected/search_bar/search_bar_widget.dart';
import '../../../features/books/presentation/pages/book_details_screen.dart';

/// Composite Screen: Uses Books feature + Search component + Stats component
///
/// - Books Feature: Display recent books (FEATURE - has business domain)
/// - Search Component: Quick search functionality (CONNECTED COMPONENT - no domain)
/// - Stats Component: Statistics overview (BOOKS WIDGET - aggregates Books data)
///
/// Location: screens/composite/dashboard/ (Composite screen with multiple components)
class DashboardScreen extends StatelessWidget {
  final Function(String)? onSearch;

  const DashboardScreen({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BooksBloc>()..add(const LoadBooksEvent()),
        ),
        BlocProvider(
          create: (_) => sl<StatsBloc>()..add(const LoadStatsEvent()),
        ),
      ],
      child: Builder(
        builder: (context) => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Stephen King Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<BooksBloc>().add(const RefreshBooksEvent());
            context.read<StatsBloc>().add(const LoadStatsEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Feature Widget
                Container(
                  color: Colors.indigo,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SearchBarWidget(
                    hintText: 'Quick search books...',
                    onSearch: (query) {
                      if (onSearch != null && query.isNotEmpty) {
                        onSearch!(query);
                      }
                    },
                    onClear: () {
                      // Do nothing on clear - user is still on dashboard
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Stats Feature Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.indigo[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Statistics Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<StatsBloc, StatsState>(
                  builder: (context, state) {
                    if (state is StatsLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: LoadingIndicator(
                          message: 'Loading statistics...',
                        ),
                      );
                    } else if (state is StatsLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    title: 'Total Books',
                                    value: state.totalBooks.toString(),
                                    icon: Icons.menu_book,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Total Pages',
                                    value: state.totalPages.toString(),
                                    icon: Icons.description,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    title: 'Avg Pages',
                                    value: state.averagePages.toStringAsFixed(0),
                                    icon: Icons.analytics,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Year Range',
                                    value: '${state.oldestYear}-${state.newestYear}',
                                    icon: Icons.calendar_today,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (state is StatsError) {
                      return ErrorWidgetCustom(
                        message: state.message,
                        onRetry: () => context
                            .read<StatsBloc>()
                            .add(const LoadStatsEvent()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),

                // Books Feature Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.new_releases, color: Colors.indigo[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'Recent Books',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<BooksBloc, BooksState>(
                  builder: (context, state) {
                    if (state is BooksLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: LoadingIndicator(
                          message: 'Loading books...',
                        ),
                      );
                    } else if (state is BooksLoaded) {
                      final recentBooks = state.books.take(5).toList();
                      return Column(
                        children: recentBooks.map((book) {
                          return BaseCard(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            elevation: 1,
                            padding: EdgeInsets.zero,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDetailsScreen(
                                    book: book,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getColorFromYear(book.year),
                                child: Text(
                                  book.year.toString().substring(2),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              title: Text(
                                book.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${book.publisher} • ${book.pages} pages',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (state is BooksError) {
                      return ErrorWidgetCustom(
                        message: state.message,
                        onRetry: () => context
                            .read<BooksBloc>()
                            .add(const LoadBooksEvent()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
        ),
    );
  }

  Color _getColorFromYear(int year) {
    final colors = [
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.deepOrange,
      Colors.red,
    ];
    return colors[year % colors.length];
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      elevation: 2,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
