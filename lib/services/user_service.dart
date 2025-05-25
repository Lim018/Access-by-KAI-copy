import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'appwrite_service.dart';
import 'appwrite_config.dart';

class UserService {
  // Create a user profile in the Appwrite database
  static Future<UserModel> createUserProfile({
    required String userId,
    required String fullName,
    required String email,
    String? phoneNumber,
  }) async {
    try {
      debugPrint('Membuat dokumen untuk userId: $userId');
      final document = await AppwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: userId,
        data: {
          'userId': userId,
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'membershipType': 'Basic',
          'railPoints': 0,
          'kaiPayBalance': 0,
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.write(Role.user(userId)),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      debugPrint('Dokumen berhasil dibuat: ${document.$id}');
      return UserModel.fromJson({
        ...document.data,
        'id': document.$id,
      });
    } catch (e) {
      debugPrint('Gagal membuat profil pengguna: $e');
      throw Exception('Failed to create user profile: $e');
    }
  }

  // Retrieve a user profile by Appwrite user ID
  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      final documents = await AppwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        queries: [
          Query.equal('userId', userId), // Query by userId field
        ],
      );

      if (documents.documents.isNotEmpty) {
        return UserModel.fromJson({
          ...documents.documents.first.data,
          'id': documents.documents.first.$id, // Ensure document ID is included
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // Update a user profile by document ID
  static Future<UserModel> updateUserProfile({
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Validate input data
      if (data.isEmpty) {
        throw Exception('No data provided for update');
      }

      // Ensure only allowed fields are updated
      final allowedFields = [
        'fullName',
        'phoneNumber',
        'membershipType',
        'railPoints',
        'kaiPayBalance'
      ];
      final filteredData = Map<String, dynamic>.fromEntries(
        data.entries.where((entry) => allowedFields.contains(entry.key)),
      );

      if (filteredData.isEmpty) {
        throw Exception('No valid fields provided for update');
      }

      final document = await AppwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: documentId,
        data: filteredData,
      );

      return UserModel.fromJson({
        ...document.data,
        'id': document.$id, // Ensure document ID is included
      });
    } catch (e) {
      if (e is AppwriteException) {
        throw Exception('Failed to update user profile: ${e.message} (Code: ${e.code})');
      }
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Update RailPoints for a user
  static Future<void> updateRailPoints({
    required String userId,
    required int points,
  }) async {
    try {
      final userProfile = await getUserProfile(userId);
      if (userProfile == null) {
        throw Exception('User profile not found for userId: $userId');
      }

      await updateUserProfile(
        documentId: userProfile.id,
        data: {
          'railPoints': userProfile.railPoints + points,
        },
      );
    } catch (e) {
      throw Exception('Failed to update RailPoints: $e');
    }
  }

  // Update KAIPay balance for a user
  static Future<void> updateKaiPayBalance({
    required String userId,
    required int amount,
  }) async {
    try {
      final userProfile = await getUserProfile(userId);
      if (userProfile == null) {
        throw Exception('User profile not found for userId: $userId');
      }

      await updateUserProfile(
        documentId: userProfile.id,
        data: {
          'kaiPayBalance': userProfile.kaiPayBalance + amount,
        },
      );
    } catch (e) {
      throw Exception('Failed to update KAIPay balance: $e');
    }
  }
}