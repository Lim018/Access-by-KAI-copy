import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  
  factory AppwriteService() {
    return _instance;
  }
  
  AppwriteService._internal();
  
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Functions functions;
  
  final String endpoint = 'http://localhost:3309/v1';
  final String projectId = '681cf430000b8a0e6999';
  
  final String databaseId = 'main-database';
  
  final String usersCollectionId = 'users';
  final String transactionsCollectionId = 'transactions';
  final String ticketsCollectionId = 'tickets';
  final String promosCollectionId = 'promos';
  final String servicesCollectionId = 'services';
  final String membershipCollectionId = 'membership';
  
  void initialize() {
    client = Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setSelfSigned(status: true); // Set to false in production
    
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    functions = Functions(client);
    
    debugPrint('Appwrite service initialized');
  }
}
