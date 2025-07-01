import 'package:postgres/postgres.dart';

import 'config.dart';

class Database {
  late final Pool _pool;

  Database() {
    final (username, password, host, port, dbName) = _parseDbUrl(Config().databaseUrl);
    _pool = Pool.withEndpoints(
      [
        Endpoint(
          host: host,
          port: port,
          database: dbName,
          username: username,
          password: password,
        ),
      ],
      settings: PoolSettings(
        maxConnectionCount: 10, // Bisa disesuaikan
        sslMode: Config().databaseNoSsl ? SslMode.disable : SslMode.require,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, [
    Map<String, dynamic> params = const {},
  ]) async {
    final result = await _pool.execute(
      Sql.named(sql),
      parameters: params,
    );

    return result.map((row) => row.toColumnMap()).toList();
  }

  (String, String, String, int, String) _parseDbUrl(String dbUrl) {
    final uri = Uri.parse(dbUrl);
    final username = uri.userInfo.split(':')[0];
    final password = uri.userInfo.split(':')[1];
    final host = uri.host;
    final port = uri.port;
    final dbName = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    return (username, password, host, port, dbName);
  }
}

final db = Database();
