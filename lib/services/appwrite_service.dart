import 'package:appwrite/appwrite.dart';
import 'appwrite_config.dart';

class AppwriteService {
  static Client? _client;
  static Account? _account;
  static Databases? _databases;

  static Client get client {
    _client ??= Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId)
        .setSelfSigned(status: AppwriteConfig.selfSigned);
    return _client!;
  }

  static Account get account {
    _account ??= Account(client);
    return _account!;
  }

  static Databases get databases {
    _databases ??= Databases(client);
    return _databases!;
  }

  static String get databaseId => AppwriteConfig.databaseId;
  static String get usersCollectionId => AppwriteConfig.usersCollectionId;

  static void initialize() {
    client;
    account;
    databases;
  }
}