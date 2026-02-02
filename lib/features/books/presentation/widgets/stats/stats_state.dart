import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {
  const StatsInitial();
}

class StatsLoading extends StatsState {
  const StatsLoading();
}

class StatsLoaded extends StatsState {
  final int totalBooks;
  final int totalPages;
  final double averagePages;
  final Map<int, int> yearGroups;
  final Map<String, int> publisherGroups;
  final int oldestYear;
  final int newestYear;

  const StatsLoaded({
    required this.totalBooks,
    required this.totalPages,
    required this.averagePages,
    required this.yearGroups,
    required this.publisherGroups,
    required this.oldestYear,
    required this.newestYear,
  });

  @override
  List<Object?> get props => [
        totalBooks,
        totalPages,
        averagePages,
        yearGroups,
        publisherGroups,
        oldestYear,
        newestYear,
      ];
}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object?> get props => [message];
}
