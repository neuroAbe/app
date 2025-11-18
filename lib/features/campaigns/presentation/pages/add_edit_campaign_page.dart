import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/utils/validators.dart';
import 'package:campaign_manager/core/utils/extensions.dart';
import 'package:campaign_manager/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';
import 'package:campaign_manager/features/clients/presentation/bloc/client_bloc.dart';

class AddEditCampaignPage extends StatefulWidget {
  final CampaignEntity? campaign;

  const AddEditCampaignPage({super.key, this.campaign});

  bool get isEditing => campaign != null;

  @override
  State<AddEditCampaignPage> createState() => _AddEditCampaignPageState();
}

class _AddEditCampaignPageState extends State<AddEditCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;
  late TextEditingController _targetReachController;

  String? _selectedClientId;
  CampaignStatusEnum _selectedStatus = CampaignStatusEnum.draft;
  PlatformEnum _selectedPlatform = PlatformEnum.instagram;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.campaign?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.campaign?.description ?? '');
    _budgetController = TextEditingController(
        text: widget.campaign?.budget?.toString() ?? '');
    _targetReachController = TextEditingController(
        text: widget.campaign?.targetReach?.toString() ?? '');

    if (widget.isEditing) {
      _selectedClientId = widget.campaign!.clientId;
      _selectedStatus = widget.campaign!.status;
      _selectedPlatform = widget.campaign!.platform;
      _startDate = widget.campaign!.startDate;
      _endDate = widget.campaign!.endDate;
    }

    // Load clients if not already loaded
    final clientState = context.read<ClientBloc>().state;
    if (clientState is! ClientsLoaded) {
      context.read<ClientBloc>().add(LoadClients());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _targetReachController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Campaign' : 'New Campaign'),
      ),
      body: BlocListener<CampaignBloc, CampaignState>(
        listener: (context, state) {
          if (state is CampaignOperationSuccess) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Campaign Information'),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Campaign Name *',
                    hintText: 'Enter campaign name',
                  ),
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Campaign name'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe the campaign goals',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimensions.xl),
                _buildSection('Client & Platform'),
                const SizedBox(height: AppDimensions.md),
                BlocBuilder<ClientBloc, ClientState>(
                  builder: (context, state) {
                    if (state is ClientsLoaded) {
                      return DropdownButtonFormField<String>(
                        value: _selectedClientId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Client *',
                        ),
                        items: state.clients.map((client) {
                          return DropdownMenuItem(
                            value: client.id,
                            child: Text(
                              '${client.name} - ${client.company}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClientId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a client';
                          }
                          return null;
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                DropdownButtonFormField<PlatformEnum>(
                  value: _selectedPlatform,
                  decoration: const InputDecoration(
                    labelText: 'Platform *',
                  ),
                  items: PlatformEnum.values.map((platform) {
                    return DropdownMenuItem(
                      value: platform,
                      child: Text(_platformToLabel(platform)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPlatform = value!;
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                DropdownButtonFormField<CampaignStatusEnum>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status *',
                  ),
                  items: CampaignStatusEnum.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name.capitalize),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.xl),
                _buildSection('Timeline'),
                const SizedBox(height: AppDimensions.md),
                _buildDatePicker(
                  'Start Date *',
                  _startDate,
                  (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                _buildDatePicker(
                  'End Date (Optional)',
                  _endDate,
                  (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                  isOptional: true,
                ),
                const SizedBox(height: AppDimensions.xl),
                _buildSection('Budget & Goals'),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: 'Budget (Optional)',
                    hintText: 'Enter campaign budget',
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _targetReachController,
                  decoration: const InputDecoration(
                    labelText: 'Target Reach (Optional)',
                    hintText: 'Enter target audience reach',
                    suffixText: 'people',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppDimensions.xxl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveCampaign,
                    child: Text(
                      widget.isEditing ? 'Update Campaign' : 'Create Campaign',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? date,
    Function(DateTime) onDateSelected, {
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOptional && date != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _endDate = null;
                    });
                  },
                ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
        child: Text(
          date?.formatted ?? 'Select date',
          style: TextStyle(
            color: date != null
                ? AppColors.textPrimary
                : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  String _platformToLabel(PlatformEnum platform) {
    switch (platform) {
      case PlatformEnum.instagram:
        return 'Instagram';
      case PlatformEnum.facebook:
        return 'Facebook';
      case PlatformEnum.twitter:
        return 'Twitter';
      case PlatformEnum.youtube:
        return 'YouTube';
      case PlatformEnum.multi:
        return 'Multi-Platform';
    }
  }

  void _saveCampaign() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedClientId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a client')),
        );
        return;
      }

      final now = DateTime.now();
      final campaign = CampaignEntity(
        id: widget.campaign?.id ?? const Uuid().v4(),
        clientId: _selectedClientId!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        status: _selectedStatus,
        platform: _selectedPlatform,
        startDate: _startDate,
        endDate: _endDate,
        budget: _budgetController.text.trim().isEmpty
            ? null
            : double.tryParse(_budgetController.text.trim()),
        targetReach: _targetReachController.text.trim().isEmpty
            ? null
            : int.tryParse(_targetReachController.text.trim()),
        createdAt: widget.campaign?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.isEditing) {
        context.read<CampaignBloc>().add(UpdateCampaign(campaign));
      } else {
        context.read<CampaignBloc>().add(AddCampaign(campaign));
      }
    }
  }
}
