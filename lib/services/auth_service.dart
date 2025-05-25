import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'appwrite_service.dart';
import 'appwrite_config.dart';
import 'user_service.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    AppwriteService.initialize(); // Initialize AppwriteService
  }

  // Current user and session
  models.User? currentUser;
  models.Session? currentSession;

  // Get current user
  Future<models.User?> getCurrentUser() async {
    try {
      currentUser = await AppwriteService.account.get();
      return currentUser;
    } on AppwriteException catch (e) {
      debugPrint('Get current user error: ${e.message}');
      currentUser = null;
      return null;
    }
  }

  // Sign up user
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      debugPrint('Mencoba membuat akun untuk email: $email');
      final user = await AppwriteService.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullName,
      );
      debugPrint('Akun berhasil dibuat: ${user.$id}');

      // Tidak perlu signIn karena account.create sudah membuat sesi aktif
      debugPrint('Sesi aktif untuk pengguna: ${user.$id}');

      // Buat profil pengguna
      debugPrint('Membuat profil pengguna untuk userId: ${user.$id}');
      final userProfile = await UserService.createUserProfile(
        userId: user.$id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
      );
      debugPrint('Profil pengguna berhasil dibuat: ${userProfile.id}');

      // Simpan pengguna dan sesi saat ini
      currentUser = user;
      currentSession = await AppwriteService.account.getSession(sessionId: 'current');
      debugPrint('Sesi saat ini: ${currentSession?.$id}');

      return userProfile;
    } on AppwriteException catch (e) {
      debugPrint('Gagal mendaftar: ${e.message}, Kode: ${e.code}, Tipe: ${e.type}');
      throw e;
    }
  }
  // Sign in user
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await AppwriteService.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      currentSession = session;
      final user = await getCurrentUser();

      if (user != null) {
        final userProfile = await UserService.getUserProfile(user.$id);
        return userProfile;
      }

      return null;
    } on AppwriteException catch (e) {
      debugPrint('Sign in error: ${e.message}');
      throw e;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    try {
      if (currentSession != null) {
        await AppwriteService.account.deleteSession(
          sessionId: currentSession!.$id,
        );
      }
      currentUser = null;
      currentSession = null;
    } on AppwriteException catch (e) {
      debugPrint('Sign out error: ${e.message}');
      throw e;
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      // Create a password recovery request
      await AppwriteService.account.createRecovery(
        email: email,
        url: 'YOUR_PASSWORD_RESET_REDIRECT_URL', // Replace with your redirect URL
      );
    } on AppwriteException catch (e) {
      debugPrint('Reset password error: ${e.message}');
      throw e;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      if (currentUser == null) {
        await getCurrentUser();
      }

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final document = await AppwriteService.databases.getDocument(
        databaseId: AppwriteService.databaseId,
        collectionId: AppwriteService.usersCollectionId,
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
        await getCurrentUser();
      }

      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Update account name if provided
      if (name != null) {
        await AppwriteService.account.updateName(name: name);
      }

      // Prepare data for update
      final Map<String, dynamic> data = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      // Update user profile in database
      await AppwriteService.databases.updateDocument(
        databaseId: AppwriteService.databaseId,
        collectionId: AppwriteService.usersCollectionId,
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
      await AppwriteService.account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );
    } on AppwriteException catch (e) {
      debugPrint('Change password error: ${e.message}');
      throw e;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}