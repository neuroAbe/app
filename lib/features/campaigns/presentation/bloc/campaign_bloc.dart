import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:campaign_manager/features/campaigns/domain/entities/campaign_entity.dart';
import 'package:campaign_manager/features/campaigns/domain/repositories/campaign_repository.dart';

// Events
abstract class CampaignEvent extends Equatable {
  const CampaignEvent();

  @override
  List<Object?> get props => [];
}

class LoadCampaigns extends CampaignEvent {}

class LoadCampaignsByStatus extends CampaignEvent {
  final CampaignStatusEnum status;

  const LoadCampaignsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadCampaignDetails extends CampaignEvent {
  final String campaignId;

  const LoadCampaignDetails(this.campaignId);

  @override
  List<Object?> get props => [campaignId];
}

class AddCampaign extends CampaignEvent {
  final CampaignEntity campaign;

  const AddCampaign(this.campaign);

  @override
  List<Object?> get props => [campaign];
}

class UpdateCampaign extends CampaignEvent {
  final CampaignEntity campaign;

  const UpdateCampaign(this.campaign);

  @override
  List<Object?> get props => [campaign];
}

class DeleteCampaign extends CampaignEvent {
  final String campaignId;

  const DeleteCampaign(this.campaignId);

  @override
  List<Object?> get props => [campaignId];
}

// States
abstract class CampaignState extends Equatable {
  const CampaignState();

  @override
  List<Object?> get props => [];
}

class CampaignInitial extends CampaignState {}

class CampaignLoading extends CampaignState {}

class CampaignsLoaded extends CampaignState {
  final List<CampaignEntity> campaigns;
  final CampaignStatusEnum? filterStatus;

  const CampaignsLoaded({
    required this.campaigns,
    this.filterStatus,
  });

  @override
  List<Object?> get props => [campaigns, filterStatus];
}

class CampaignDetailsLoaded extends CampaignState {
  final CampaignEntity campaign;

  const CampaignDetailsLoaded(this.campaign);

  @override
  List<Object?> get props => [campaign];
}

class CampaignOperationSuccess extends CampaignState {
  final String message;

  const CampaignOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CampaignError extends CampaignState {
  final String message;

  const CampaignError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class CampaignBloc extends Bloc<CampaignEvent, CampaignState> {
  final CampaignRepository _repository;

  CampaignBloc(this._repository) : super(CampaignInitial()) {
    on<LoadCampaigns>(_onLoadCampaigns);
    on<LoadCampaignsByStatus>(_onLoadCampaignsByStatus);
    on<LoadCampaignDetails>(_onLoadCampaignDetails);
    on<AddCampaign>(_onAddCampaign);
    on<UpdateCampaign>(_onUpdateCampaign);
    on<DeleteCampaign>(_onDeleteCampaign);
  }

  Future<void> _onLoadCampaigns(
    LoadCampaigns event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());
    try {
      final campaigns = await _repository.getAllCampaigns();
      emit(CampaignsLoaded(campaigns: campaigns));
    } catch (e) {
      emit(CampaignError(e.toString()));
    }
  }

  Future<void> _onLoadCampaignsByStatus(
    LoadCampaignsByStatus event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());
    try {
      final campaigns = await _repository.getCampaignsByStatus(event.status);
      emit(CampaignsLoaded(campaigns: campaigns, filterStatus: event.status));
    } catch (e) {
      emit(CampaignError(e.toString()));
    }
  }

  Future<void> _onLoadCampaignDetails(
    LoadCampaignDetails event,
    Emitter<CampaignState> emit,
  ) async {
    emit(CampaignLoading());
    try {
      final campaign = await _repository.getCampaignById(event.campaignId);
      if (campaign != null) {
        emit(CampaignDetailsLoaded(campaign));
      } else {
        emit(const CampaignError('Campaign not found'));
      }
    } catch (e) {
      emit(CampaignError(e.toString()));
    }
  }

  Future<void> _onAddCampaign(
    AddCampaign event,
    Emitter<CampaignState> emit,
  ) async {
    try {
      await _repository.addCampaign(event.campaign);
      // Load fresh campaigns before emitting success
      final campaigns = await _repository.getAllCampaigns();
      emit(const CampaignOperationSuccess('Campaign added successfully'));
      emit(CampaignsLoaded(campaigns: campaigns));
    } catch (e) {
      emit(CampaignError(e.toString()));
    }
  }

  Future<void> _onUpdateCampaign(
    UpdateCampaign event,
    Emitter<CampaignState> emit,
  ) async {
    try {
      await _repository.updateCampaign(event.campaign);
      // Load fresh campaigns before emitting success
      final campaigns = await _repository.getAllCampaigns();
      emit(const CampaignOperationSuccess('Campaign updated successfully'));
      emit(CampaignsLoaded(campaigns: campaigns));
      // Also emit updated campaign details for detail page
      final updatedCampaign = await _repository.getCampaignById(event.campaign.id);
      if (updatedCampaign != null) {
        emit(CampaignDetailsLoaded(updatedCampaign));
      }
    } catch (e) {
      emit(CampaignError(e.toString()));
    }
  }

  Future<void> _onDeleteCampaign(
    DeleteCampaign event,
    Emitter<CampaignState> emit,
  ) async {
    try {
      await _repository.deleteCampaign(event.campaignId);
      // Load fresh campaigns before emitting success
      final campaigns = await _repository.getAllCampaigns();
      emit(const CampaignOperationSuccess('Campaign deleted successfully'));
      emit(CampaignsLoaded(campaigns: campaigns));
    } catch (e) {
      emit(CampaignError(e.toString()));
    }
  }
}
