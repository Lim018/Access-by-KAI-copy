import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import '../services/appwrite_service.dart';

class AuthService {
  final AppwriteService _appwrite = AppwriteService();
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  // Current user
  models.User? currentUser;
  models.Session? currentSession;
  
  // Login user
  Future<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      
      currentSession = session;
      await _getCurrentUser();
      
      return session;
    } on AppwriteException catch (e) {
      debugPrint('Login error: ${e.message}');
      throw e;
    }
  }
  
  // Register user
  Future<models.User> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final user = await _appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      
      // Create extended user profile in database
      await _appwrite.databases.createDocument(
        databaseId: _appwrite.databaseId,
        collectionId: _appwrite.usersCollectionId,
        documentId: user.$id,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'member_status': 'Basic',
          'kaipay_activated': false,
          'kaipay_balance': 0,
          'rail_points': 0,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
      
      // Login after registration
      await login(email: email, password: password);
      
      return user;
    } on AppwriteException catch (e) {
      debugPrint('Register error: ${e.message}');
      throw e;
    }
  }
  
  // Get current user
  Future<models.User?> _getCurrentUser() async {
    try {
      currentUser = await _appwrite.account.get();
      return currentUser;
    } on AppwriteException catch (e) {
      debugPrint('Get current user error: ${e.message}');
      currentUser = null;
      return null;
    }
  }
  
  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      if (currentUser == null) {
        await _getCurrentUser();
      }
      
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      final document = await _appwrite.databases.getDocument(
        databaseId: _appwrite.databaseId,
        collectionId: _appwrite.usersCollectionId,
        documentId: currentUser!.$id,
      );
      
      return document.data;
    } on AppwriteException catch (e) {
      debugPrint('Get user profile error: ${e.message}');
      throw e;
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      if (currentUser == null) {
        await _getCurrentUser();
      }
      
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // Update account name if provided
      if (name != null) {
        await _appwrite.account.updateName(name: name);
      }
      
      // Prepare data for update
      final Map<String, dynamic> data = {
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;
      
      // Update user profile in database
      await _appwrite.databases.updateDocument(
        databaseId: _appwrite.databaseId,
        collectionId: _appwrite.usersCollectionId,
        documentId: currentUser!.$id,
        data: data,
      );
    } on AppwriteException catch (e) {
      debugPrint('Update user profile error: ${e.message}');
      throw e;
    }
  }
  
  // Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _appwrite.account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );
    } on AppwriteException catch (e) {
      debugPrint('Change password error: ${e.message}');
      throw e;
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      if (currentSession != null) {
        await _appwrite.account.deleteSession(
          sessionId: currentSession!.$id,
        );
      }
      currentUser = null;
      currentSession = null;
    } on AppwriteException catch (e) {
      debugPrint('Logout error: ${e.message}');
      throw e;
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final user = await _getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}