import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';
import 'package:trackify/domain/interfaces/expense.dart';
import 'package:trackify/infrastructure/repositories/expense.dart';
import 'package:trackify/ui/blocs/expenses/bloc.dart';

final class Injector {
  const Injector._();

  static final instance = GetIt.instance;

  static Future<void> setupDependencies() async {
    instance
      ..registerSingletonAsync<ExpenseRepository>(
        () async {
          final directory = await getApplicationDocumentsDirectory();
          final repository = ExpenseRepositoryImpl(
            SqliteDatabase(path: '${directory.path}/expenses.db'),
          );
          await repository.init();

          return repository;
        },
      )
      ..registerFactory<ExpensesBloc>(() => ExpensesBloc(instance()));

    await instance.allReady();
  }
}
