import 'package:campaign_manager/features/clients/data/datasources/client_local_datasource.dart';
import 'package:campaign_manager/features/clients/data/models/client_model.dart';
import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';
import 'package:campaign_manager/features/clients/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDataSource _localDataSource;

  ClientRepositoryImpl(this._localDataSource);

  @override
  Future<List<ClientEntity>> getAllClients() async {
    return await _localDataSource.getAllClients();
  }

  @override
  Future<ClientEntity?> getClientById(String id) async {
    return await _localDataSource.getClientById(id);
  }

  @override
  Future<void> addClient(ClientEntity client) async {
    final model = ClientModel.fromEntity(client);
    await _localDataSource.insertClient(model);
  }

  @override
  Future<void> updateClient(ClientEntity client) async {
    final model = ClientModel.fromEntity(client);
    await _localDataSource.updateClient(model);
  }

  @override
  Future<void> deleteClient(String id) async {
    await _localDataSource.deleteClient(id);
  }

  @override
  Future<List<ClientEntity>> searchClients(String query) async {
    return await _localDataSource.searchClients(query);
  }
}
