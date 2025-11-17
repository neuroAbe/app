import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/widgets/loading_indicator.dart';
import 'package:campaign_manager/core/widgets/error_view.dart';
import 'package:campaign_manager/core/utils/extensions.dart';
import 'package:campaign_manager/features/clients/presentation/bloc/client_bloc.dart';
import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';
import 'package:campaign_manager/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:campaign_manager/features/clients/presentation/pages/add_edit_client_page.dart';

class ClientDetailsPage extends StatefulWidget {
  final String clientId;
  final ClientEntity? client;

  const ClientDetailsPage({
    super.key,
    required this.clientId,
    this.client,
  });

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.client == null) {
      context.read<ClientBloc>().add(LoadClientDetails(widget.clientId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Client Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (widget.client != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditClientPage(client: widget.client),
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Client'),
              ),
            ],
          ),
        ],
      ),
      body: widget.client != null
          ? _buildContent(widget.client!)
          : BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoading) {
                  return const LoadingIndicator();
                }
                if (state is ClientError) {
                  return ErrorView(message: state.message);
                }
                if (state is ClientDetailsLoaded) {
                  return _buildContent(state.client);
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }

  Widget _buildContent(ClientEntity client) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(client),
          const SizedBox(height: AppDimensions.xl),
          _buildContactInfo(client),
          const SizedBox(height: AppDimensions.xl),
          _buildSocialProfiles(client),
          const SizedBox(height: AppDimensions.xl),
          _buildClientCampaigns(client.id),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ClientEntity client) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                client.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              client.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              client.company,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'Client since ${client.createdAt.formatted}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(ClientEntity client) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            if (client.email != null && client.email!.isNotEmpty)
              _buildContactRow(Icons.email, 'Email', client.email!),
            if (client.phone != null && client.phone!.isNotEmpty)
              _buildContactRow(Icons.phone, 'Phone', client.phone!),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppDimensions.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialProfiles(ClientEntity client) {
    final hasSocialProfiles = (client.instagramHandle?.isNotEmpty ?? false) ||
        (client.facebookPage?.isNotEmpty ?? false) ||
        (client.twitterHandle?.isNotEmpty ?? false) ||
        (client.youtubeChannel?.isNotEmpty ?? false);

    if (!hasSocialProfiles) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Social Profiles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            if (client.instagramHandle?.isNotEmpty ?? false)
              _buildSocialRow(
                Icons.camera_alt,
                'Instagram',
                '@${client.instagramHandle}',
                AppColors.instagram,
              ),
            if (client.facebookPage?.isNotEmpty ?? false)
              _buildSocialRow(
                Icons.facebook,
                'Facebook',
                client.facebookPage!,
                AppColors.facebook,
              ),
            if (client.twitterHandle?.isNotEmpty ?? false)
              _buildSocialRow(
                Icons.alternate_email,
                'Twitter',
                '@${client.twitterHandle}',
                AppColors.twitter,
              ),
            if (client.youtubeChannel?.isNotEmpty ?? false)
              _buildSocialRow(
                Icons.play_circle_fill,
                'YouTube',
                client.youtubeChannel!,
                AppColors.youtube,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialRow(
    IconData icon,
    String platform,
    String handle,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimensions.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platform,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                handle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientCampaigns(String clientId) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Campaigns',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigate to Campaigns tab to view all campaigns'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            BlocBuilder<CampaignBloc, CampaignState>(
              builder: (context, state) {
                if (state is CampaignsLoaded) {
                  final clientCampaigns = state.campaigns
                      .where((c) => c.clientId == clientId)
                      .take(3)
                      .toList();

                  if (clientCampaigns.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.lg),
                        child: Text(
                          'No campaigns yet',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: clientCampaigns.map((campaign) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(campaign.name),
                        subtitle: Text(campaign.status.name.capitalize),
                        trailing: Text(campaign.startDate.shortDate),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    final pageContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Client'),
        content: const Text(
          'Are you sure you want to delete this client? All associated campaigns will also be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              pageContext.read<ClientBloc>().add(DeleteClient(widget.clientId));
              Navigator.pop(pageContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
