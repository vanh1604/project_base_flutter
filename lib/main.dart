import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_base_flutter_handle/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ProviderScope bắt buộc phải bọc ngoài cùng để Riverpod hoạt động
  runApp(const ProviderScope(child: MyApp()));
}
