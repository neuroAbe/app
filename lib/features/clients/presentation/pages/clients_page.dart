import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/constants/app_strings.dart';
import 'package:campaign_manager/core/widgets/loading_indicator.dart';
import 'package:campaign_manager/core/widgets/error_view.dart';
import 'package:campaign_manager/core/widgets/empty_state.dart';
import 'package:campaign_manager/features/clients/presentation/bloc/client_bloc.dart';
import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';
import 'package:campaign_manager/features/clients/presentation/pages/client_details_page.dart';
import 'package:campaign_manager/features/clients/presentation/pages/add_edit_client_page.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ClientBloc>().add(LoadClients());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.clients),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoading) {
                  return const LoadingIndicator();
                }

                if (state is ClientError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<ClientBloc>().add(LoadClients());
                    },
                  );
                }

                if (state is ClientsLoaded) {
                  if (state.clients.isEmpty) {
                    return EmptyState(
                      icon: Icons.people_outline,
                      title: state.searchQuery != null
                          ? 'No Results Found'
                          : 'No Clients Yet',
                      subtitle: state.searchQuery != null
                          ? 'Try a different search term'
                          : 'Add your first client to get started',
                      action: state.searchQuery == null
                          ? ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddEditClientPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(AppStrings.newClient),
                            )
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ClientBloc>().add(LoadClients());
                    },
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.all(AppDimensions.screenPadding),
                      itemCount: state.clients.length,
                      itemBuilder: (context, index) {
                        final client = state.clients[index];
                        return _buildClientCard(client);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditClientPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search clients...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ClientBloc>().add(LoadClients());
                  },
                )
              : null,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            context.read<ClientBloc>().add(LoadClients());
          } else {
            context.read<ClientBloc>().add(SearchClients(value));
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildClientCard(ClientEntity client) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientDetailsPage(
                clientId: client.id,
                client: client,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  client.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      client.company,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Row(
                      children: [
                        if (client.instagramHandle != null &&
                            client.instagramHandle!.isNotEmpty)
                          _buildSocialIcon(
                            Icons.camera_alt,
                            AppColors.instagram,
                          ),
                        if (client.facebookPage != null &&
                            client.facebookPage!.isNotEmpty)
                          _buildSocialIcon(
                            Icons.facebook,
                            AppColors.facebook,
                          ),
                        if (client.twitterHandle != null &&
                            client.twitterHandle!.isNotEmpty)
                          _buildSocialIcon(
                            Icons.alternate_email,
                            AppColors.twitter,
                          ),
                        if (client.youtubeChannel != null &&
                            client.youtubeChannel!.isNotEmpty)
                          _buildSocialIcon(
                            Icons.play_circle_fill,
                            AppColors.youtube,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.sm),
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }
}
