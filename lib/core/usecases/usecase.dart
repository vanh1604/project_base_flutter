import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base UseCase Interface - Core Layer (Clean Architecture)
///
/// Abstract class định nghĩa contract cho tất cả Use Cases.
/// Mỗi Use Case thực hiện một hành động nghiệp vụ cụ thể.
///
/// Type: Kiểu dữ liệu trả về
/// Params: Tham số đầu vào
///
/// Location: core/usecases/
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No Params - Sử dụng khi Use Case không cần tham số
class NoParams {
  const NoParams();
}
