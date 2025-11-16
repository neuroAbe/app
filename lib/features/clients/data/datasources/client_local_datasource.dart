import 'package:campaign_manager/features/clients/data/models/client_model.dart';
import 'package:campaign_manager/shared/services/database_service.dart';

abstract class ClientLocalDataSource {
  Future<List<ClientModel>> getAllClients();
  Future<ClientModel?> getClientById(String id);
  Future<void> insertClient(ClientModel client);
  Future<void> updateClient(ClientModel client);
  Future<void> deleteClient(String id);
  Future<List<ClientModel>> searchClients(String query);
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final DatabaseService _databaseService;

  ClientLocalDataSourceImpl(this._databaseService);

  @override
  Future<List<ClientModel>> getAllClients() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'clients',
      orderBy: 'updated_at DESC',
    );
    return maps.map((map) => ClientModel.fromMap(map)).toList();
  }

  @override
  Future<ClientModel?> getClientById(String id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return ClientModel.fromMap(maps.first);
  }

  @override
  Future<void> insertClient(ClientModel client) async {
    final db = await _databaseService.database;
    await db.insert('clients', client.toMap());
  }

  @override
  Future<void> updateClient(ClientModel client) async {
    final db = await _databaseService.database;
    await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  @override
  Future<void> deleteClient(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ClientModel>> searchClients(String query) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'clients',
      where: 'name LIKE ? OR company LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return maps.map((map) => ClientModel.fromMap(map)).toList();
  }
}
