import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campaign_manager/core/theme/app_theme.dart';
import 'package:campaign_manager/core/constants/app_strings.dart';
import 'package:campaign_manager/injection.dart';
import 'package:campaign_manager/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:campaign_manager/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:campaign_manager/features/clients/presentation/bloc/client_bloc.dart';
import 'package:campaign_manager/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:campaign_manager/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:campaign_manager/features/dashboard/presentation/pages/main_shell.dart';

class CampaignManagerApp extends StatelessWidget {
  const CampaignManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (_) => getIt<DashboardBloc>(),
        ),
        BlocProvider<CampaignBloc>(
          create: (_) => getIt<CampaignBloc>(),
        ),
        BlocProvider<ClientBloc>(
          create: (_) => getIt<ClientBloc>(),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (_) => getIt<AnalyticsBloc>(),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => getIt<TaskBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainShell(),
      ),
    );
  }
}
