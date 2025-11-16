import 'package:campaign_manager/features/clients/domain/entities/client_entity.dart';

abstract class ClientRepository {
  Future<List<ClientEntity>> getAllClients();
  Future<ClientEntity?> getClientById(String id);
  Future<void> addClient(ClientEntity client);
  Future<void> updateClient(ClientEntity client);
  Future<void> deleteClient(String id);
  Future<List<ClientEntity>> searchClients(String query);
}
