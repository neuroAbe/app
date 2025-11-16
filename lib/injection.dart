import 'package:get_it/get_it.dart';
import 'package:campaign_manager/shared/services/database_service.dart';
import 'package:campaign_manager/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:campaign_manager/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:campaign_manager/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:campaign_manager/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:campaign_manager/features/campaigns/data/datasources/campaign_local_datasource.dart';
import 'package:campaign_manager/features/campaigns/data/repositories/campaign_repository_impl.dart';
import 'package:campaign_manager/features/campaigns/domain/repositories/campaign_repository.dart';
import 'package:campaign_manager/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:campaign_manager/features/clients/data/datasources/client_local_datasource.dart';
import 'package:campaign_manager/features/clients/data/repositories/client_repository_impl.dart';
import 'package:campaign_manager/features/clients/domain/repositories/client_repository.dart';
import 'package:campaign_manager/features/clients/presentation/bloc/client_bloc.dart';
import 'package:campaign_manager/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:campaign_manager/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:campaign_manager/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:campaign_manager/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:campaign_manager/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:campaign_manager/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:campaign_manager/features/tasks/domain/repositories/task_repository.dart';
import 'package:campaign_manager/features/tasks/presentation/bloc/task_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Services
  final databaseService = DatabaseService();
  await databaseService.initialize();
  getIt.registerSingleton<DatabaseService>(databaseService);

  // Data Sources
  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CampaignLocalDataSource>(
    () => CampaignLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ClientLocalDataSource>(
    () => ClientLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AnalyticsLocalDataSource>(
    () => AnalyticsLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<CampaignRepository>(
    () => CampaignRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(getIt()),
  );

  // BLoCs
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(getIt()),
  );
  getIt.registerFactory<CampaignBloc>(
    () => CampaignBloc(getIt()),
  );
  getIt.registerFactory<ClientBloc>(
    () => ClientBloc(getIt()),
  );
  getIt.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(getIt()),
  );
  getIt.registerFactory<TaskBloc>(
    () => TaskBloc(getIt()),
  );
}
