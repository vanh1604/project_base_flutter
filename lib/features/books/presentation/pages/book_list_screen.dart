import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injections/service_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/books_bloc.dart';
import '../bloc/books_event.dart';
import '../bloc/books_state.dart';
import '../widgets/book_card.dart';
import '../widgets/book_list_shimmer.dart';
import '../../../../core/widgets/connected/search_bar/search_bloc.dart';
import '../../../../core/widgets/connected/search_bar/search_event.dart';
import '../../../../core/widgets/connected/search_bar/search_state.dart';
import '../../../../core/widgets/connected/search_bar/search_bar_widget.dart';
import 'book_details_screen.dart';

/// Composite Screen: Uses Books feature + Search component
///
/// - Books Feature: Display all books (FEATURE - has business domain)
/// - Search Component: Search functionality (CONNECTED COMPONENT - no domain)
///
/// Location: screens/composite/book_list/ (Composite screen with multiple components)
class BookListScreen extends StatefulWidget {
  final String? initialQuery;
  final VoidCallback? onSearchConsumed;

  const BookListScreen({
    super.key,
    this.initialQuery,
    this.onSearchConsumed,
  });

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BooksBloc>()..add(const LoadBooksEvent()),
        ),
        BlocProvider(
          create: (_) => sl<SearchBloc>(),
        ),
      ],
      child: _BookListContent(
        initialQuery: widget.initialQuery,
        onSearchConsumed: widget.onSearchConsumed,
      ),
    );
  }
}

/// Internal widget that has access to the providers
class _BookListContent extends StatefulWidget {
  final String? initialQuery;
  final VoidCallback? onSearchConsumed;

  const _BookListContent({
    this.initialQuery,
    this.onSearchConsumed,
  });

  @override
  State<_BookListContent> createState() => _BookListContentState();
}

class _BookListContentState extends State<_BookListContent> {
  @override
  void initState() {
    super.initState();
    // Trigger search after first frame if there's an initial query
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<SearchBloc>().add(SearchBooksEvent(widget.initialQuery!));
          widget.onSearchConsumed?.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Stephen King Books',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Search Feature
            Container(
              color: Colors.deepPurple,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SearchBarWidget(
                initialValue: widget.initialQuery,
                onSearch: (query) {
                  if (query.isEmpty) {
                    // Show all books when search is empty
                    context.read<SearchBloc>().add(const ClearSearchEvent());
                  } else {
                    context.read<SearchBloc>().add(SearchBooksEvent(query));
                  }
                },
                onClear: () {
                  context.read<SearchBloc>().add(const ClearSearchEvent());
                },
              ),
            ),

            // Books display (either from search or all books)
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  // If search is active, show search results
                  if (searchState is SearchLoading) {
                    return const BookListShimmer();
                  } else if (searchState is SearchLoaded) {
                    return _buildBooksList(
                      context,
                      books: searchState.books,
                      isSearching: true,
                      searchQuery: searchState.query,
                    );
                  } else if (searchState is SearchError) {
                    return ErrorWidgetCustom(
                      message: searchState.message,
                      onRetry: () => context.read<BooksBloc>().add(const LoadBooksEvent()),
                    );
                  }

                  // Default: show all books from BooksBloc
                  return BlocBuilder<BooksBloc, BooksState>(
                    builder: (context, booksState) {
                      if (booksState is BooksLoading) {
                        return const BookListShimmer();
                      } else if (booksState is BooksLoaded) {
                        return _buildBooksList(
                          context,
                          books: booksState.books,
                          isSearching: false,
                          searchQuery: '',
                        );
                      } else if (booksState is BooksError) {
                        return ErrorWidgetCustom(
                          message: booksState.message,
                          onRetry: () => context.read<BooksBloc>().add(const LoadBooksEvent()),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildBooksList(
    BuildContext context, {
    required List books,
    required bool isSearching,
    required String searchQuery,
  }) {
    if (books.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: isSearching ? 'No books found' : 'No books available',
        message: isSearching ? 'No results for "$searchQuery"' : null,
        actionText: isSearching ? 'Clear Search' : null,
        onAction: isSearching
            ? () => context.read<SearchBloc>().add(const ClearSearchEvent())
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BooksBloc>().add(const RefreshBooksEvent());
      },
      child: Column(
        children: [
          if (isSearching)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue[50],
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 20, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Found ${books.length} ${books.length == 1 ? 'book' : 'books'} for "$searchQuery"',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(
                  book: book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
