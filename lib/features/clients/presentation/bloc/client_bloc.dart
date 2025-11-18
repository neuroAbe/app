import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';
import 'package:campaign_manager/features/clients/domain/repositories/client_repository.dart';

// Events
abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientEvent {}

class SearchClients extends ClientEvent {
  final String query;

  const SearchClients(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadClientDetails extends ClientEvent {
  final String clientId;

  const LoadClientDetails(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

class AddClient extends ClientEvent {
  final ClientEntity client;

  const AddClient(this.client);

  @override
  List<Object?> get props => [client];
}

class UpdateClient extends ClientEvent {
  final ClientEntity client;

  const UpdateClient(this.client);

  @override
  List<Object?> get props => [client];
}

class DeleteClient extends ClientEvent {
  final String clientId;

  const DeleteClient(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

// States
abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object?> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientsLoaded extends ClientState {
  final List<ClientEntity> clients;
  final String? searchQuery;

  const ClientsLoaded({
    required this.clients,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [clients, searchQuery];
}

class ClientDetailsLoaded extends ClientState {
  final ClientEntity client;

  const ClientDetailsLoaded(this.client);

  @override
  List<Object?> get props => [client];
}

class ClientOperationSuccess extends ClientState {
  final String message;

  const ClientOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientError extends ClientState {
  final String message;

  const ClientError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository _repository;

  ClientBloc(this._repository) : super(ClientInitial()) {
    on<LoadClients>(_onLoadClients);
    on<SearchClients>(_onSearchClients);
    on<LoadClientDetails>(_onLoadClientDetails);
    on<AddClient>(_onAddClient);
    on<UpdateClient>(_onUpdateClient);
    on<DeleteClient>(_onDeleteClient);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final clients = await _repository.getAllClients();
      emit(ClientsLoaded(clients: clients));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> _onSearchClients(
    SearchClients event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final clients = await _repository.searchClients(event.query);
      emit(ClientsLoaded(clients: clients, searchQuery: event.query));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> _onLoadClientDetails(
    LoadClientDetails event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final client = await _repository.getClientById(event.clientId);
      if (client != null) {
        emit(ClientDetailsLoaded(client));
      } else {
        emit(const ClientError('Client not found'));
      }
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> _onAddClient(
    AddClient event,
    Emitter<ClientState> emit,
  ) async {
    try {
      await _repository.addClient(event.client);
      // Load fresh clients before emitting success
      final clients = await _repository.getAllClients();
      emit(const ClientOperationSuccess('Client added successfully'));
      emit(ClientsLoaded(clients: clients));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> _onUpdateClient(
    UpdateClient event,
    Emitter<ClientState> emit,
  ) async {
    try {
      await _repository.updateClient(event.client);
      // Load fresh clients before emitting success
      final clients = await _repository.getAllClients();
      emit(const ClientOperationSuccess('Client updated successfully'));
      emit(ClientsLoaded(clients: clients));
      // Also emit updated client details for detail page
      final updatedClient = await _repository.getClientById(event.client.id);
      if (updatedClient != null) {
        emit(ClientDetailsLoaded(updatedClient));
      }
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

  Future<void> _onDeleteClient(
    DeleteClient event,
    Emitter<ClientState> emit,
  ) async {
    try {
      await _repository.deleteClient(event.clientId);
      // Load fresh clients before emitting success
      final clients = await _repository.getAllClients();
      emit(const ClientOperationSuccess('Client deleted successfully'));
      emit(ClientsLoaded(clients: clients));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}
