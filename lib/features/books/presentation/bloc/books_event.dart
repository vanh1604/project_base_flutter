import 'package:equatable/equatable.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();

  @override
  List<Object?> get props => [];
}

class LoadBooksEvent extends BooksEvent {
  const LoadBooksEvent();
}

class RefreshBooksEvent extends BooksEvent {
  const RefreshBooksEvent();
}
