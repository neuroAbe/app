import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:campaign_manager/core/constants/app_colors.dart';
import 'package:campaign_manager/core/constants/app_dimensions.dart';
import 'package:campaign_manager/core/utils/validators.dart';
import 'package:campaign_manager/features/clients/presentation/bloc/client_bloc.dart';
import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';

class AddEditClientPage extends StatefulWidget {
  final ClientEntity? client;

  const AddEditClientPage({super.key, this.client});

  bool get isEditing => client != null;

  @override
  State<AddEditClientPage> createState() => _AddEditClientPageState();
}

class _AddEditClientPageState extends State<AddEditClientPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _twitterController;
  late TextEditingController _youtubeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _companyController =
        TextEditingController(text: widget.client?.company ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _instagramController =
        TextEditingController(text: widget.client?.instagramHandle ?? '');
    _facebookController =
        TextEditingController(text: widget.client?.facebookPage ?? '');
    _twitterController =
        TextEditingController(text: widget.client?.twitterHandle ?? '');
    _youtubeController =
        TextEditingController(text: widget.client?.youtubeChannel ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Client' : 'Add Client'),
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientOperationSuccess) {
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
                _buildSection('Basic Information'),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter client name',
                  ),
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Name'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    hintText: 'Enter company name',
                  ),
                  validator: (value) =>
                      Validators.required(value, fieldName: 'Company'),
                ),
                const SizedBox(height: AppDimensions.xl),
                _buildSection('Contact Information'),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter email address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isNotEmpty ?? false) {
                      return Validators.email(value);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: AppDimensions.xl),
                _buildSection('Social Media Profiles'),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _instagramController,
                  decoration: InputDecoration(
                    labelText: 'Instagram Handle',
                    hintText: 'username (without @)',
                    prefixIcon:
                        Icon(Icons.camera_alt, color: AppColors.instagram),
                  ),
                  validator: (value) =>
                      Validators.socialHandle(value, platform: 'Instagram'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _facebookController,
                  decoration: InputDecoration(
                    labelText: 'Facebook Page',
                    hintText: 'Page name',
                    prefixIcon:
                        Icon(Icons.facebook, color: AppColors.facebook),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _twitterController,
                  decoration: InputDecoration(
                    labelText: 'Twitter Handle',
                    hintText: 'username (without @)',
                    prefixIcon: Icon(Icons.alternate_email,
                        color: AppColors.twitter),
                  ),
                  validator: (value) =>
                      Validators.socialHandle(value, platform: 'Twitter'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextFormField(
                  controller: _youtubeController,
                  decoration: InputDecoration(
                    labelText: 'YouTube Channel',
                    hintText: 'Channel name',
                    prefixIcon: Icon(Icons.play_circle_fill,
                        color: AppColors.youtube),
                  ),
                ),
                const SizedBox(height: AppDimensions.xxl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveClient,
                    child: Text(
                      widget.isEditing ? 'Update Client' : 'Add Client',
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

  void _saveClient() {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();
      final client = ClientEntity(
        id: widget.client?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        company: _companyController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        instagramHandle: _instagramController.text.trim().isEmpty
            ? null
            : _instagramController.text.trim(),
        facebookPage: _facebookController.text.trim().isEmpty
            ? null
            : _facebookController.text.trim(),
        twitterHandle: _twitterController.text.trim().isEmpty
            ? null
            : _twitterController.text.trim(),
        youtubeChannel: _youtubeController.text.trim().isEmpty
            ? null
            : _youtubeController.text.trim(),
        createdAt: widget.client?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.isEditing) {
        context.read<ClientBloc>().add(UpdateClient(client));
      } else {
        context.read<ClientBloc>().add(AddClient(client));
      }
    }
  }
}
