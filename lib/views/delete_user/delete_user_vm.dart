// // ignore_for_file: avoid_print, annotate_overrides

// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';

// class DeleteUserVM extends BaseViewModel {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final uidController =
//       TextEditingController(text: 'ABC123XYZ'); // Pre-fill UID
//   final reasonController = TextEditingController();

//   Future<void> deleteAccount() async {
//     setBusy(true);
//     try {

//       // Show success message or navigate
//     } catch (e) {
//       // Handle error
//     } finally {
//       setBusy(false);
//     }
//   }

//   String? tokenParam;
//   String _errorMessage = '';

//   String get errorMessage => _errorMessage;
//   bool get hasError => _errorMessage.isNotEmpty;

//   Future<void> init() async {
//     setBusy(true); // Start loading state
//     _errorMessage = ''; // Clear previous errors

//     try {
//       _extractUrlParameter(); // Extract 'token' parameter

//       if (tokenParam == null || tokenParam!.isEmpty) {
//         _errorMessage = 'Missing required URL parameter: token.\n'
//             'URL must contain ?token=YOUR_ACCESS_TOKEN';
//         print(_errorMessage);
//         setBusy(false); // Stop busy state on error
//         notifyListeners();
//         return;
//       }

//       await fetchData(tokenParam); // Fetch your data using the token
//     } catch (e) {
//       _errorMessage = 'An error occurred: $e';
//       print('Error during init: $e');
//     } finally {
//       setBusy(false); // End loading state regardless of success or error
//       notifyListeners();
//     }
//   }

//   /// Extracts 'token' from the current browser URL.
//   void _extractUrlParameter() {
//     try {
//       final Uri uri = Uri.base;
//       print('Current URL: ${uri.toString()}'); // Debugging line
//       final Map<String, String> queryParams = uri.queryParameters;

//       tokenParam = queryParams['token'];

//       print('URL Parameter Extracted: token=$tokenParam');
//     } catch (e) {
//       _errorMessage = 'Failed to extract token from URL: $e';
//       print(_errorMessage);
//     }
//   }

//   Future<void> fetchData(tokenParam) async {
//     return null;
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     uidController.dispose();
//     reasonController.dispose();
//     super.dispose();
//   }
// }

// ignore_for_file: avoid_print, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeleteUserVM extends BaseViewModel {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final uidController = TextEditingController(text: 'ABC123XYZ');
  final reasonController = TextEditingController();

  String? idTokenParam;
  String? accessTokenParam;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  Future<void> init() async {
    setBusy(true); // Start loading
    _errorMessage = ''; // Clear previous errors

    try {
      _extractUrlParameters();

      if (idTokenParam == null ||
          idTokenParam!.isEmpty ||
          accessTokenParam == null ||
          accessTokenParam!.isEmpty) {
        _errorMessage = 'Missing required URL parameters.\n'
            'URL must contain ?idToken=YOUR_ID_TOKEN&accessToken=YOUR_ACCESS_TOKEN';
        print(_errorMessage);
        setBusy(false);
        notifyListeners();
        return;
      }

      // Sign in to Firebase with these tokens
      await _signInWithGoogleTokens(idTokenParam!, accessTokenParam!);
      nameController.text =
          FirebaseAuth.instance.currentUser?.displayName ?? '';
      emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
      uidController.text = FirebaseAuth.instance.currentUser?.uid ?? '';
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Error during init: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  void _extractUrlParameters() {
    try {
      final Uri uri = Uri.base;
      print('Current URL: ${uri.toString()}');

      final queryParams = uri.queryParameters;

      idTokenParam = queryParams['idToken'];
      accessTokenParam = queryParams['accessToken'];

      print('Extracted idToken: $idTokenParam');
      print('Extracted accessToken: $accessTokenParam');
    } catch (e) {
      _errorMessage = 'Failed to extract URL parameters: $e';
      print(_errorMessage);
    }
  }

  Future<void> _signInWithGoogleTokens(
      String idToken, String accessToken) async {
    try {
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('✅ Firebase sign-in successful: ${userCredential.user?.email}');
    } on FirebaseAuthException catch (e) {
      _errorMessage = 'Firebase Auth error: ${e.code} - ${e.message}';
      print(_errorMessage);
    } catch (e) {
      _errorMessage = 'Unknown sign-in error: $e';
      print(_errorMessage);
    }
  }

  Future<void> deleteAccount() async {
    setBusy(true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _errorMessage = 'No user is currently signed in.';
        print(_errorMessage);
        return;
      }
      await deleteAllParticipants(user.uid);
      await deleteParentCollection(user.uid);

      await user.delete();
    } catch (e) {
      print('Error deleting account: $e');
    } finally {
      setBusy(false);

      // close WebView
    }
  }

  Future<void> deleteParentCollection(String parentCollectionName) async {
    final firestore = FirebaseFirestore.instance;
    final parentCollection = firestore.collection(parentCollectionName);

    print('🔴 Deleting all documents in $parentCollectionName...');

    try {
      final querySnapshot = await parentCollection.get();
      print('Found ${querySnapshot.docs} documents in $parentCollectionName');

      for (final doc in querySnapshot.docs) {
        final docId = doc.id;
        print('🗑️ Processing document: $docId');

        if (docId == 'AllParticipants') {
          // Special case: delete only Participant subcollection inside AllParticipants
          await _deleteSubcollection(doc.reference, 'Participants');
          print('✅ Deleted AllParticipants → Participant collection');

          // Delete AllParticipants document itself
          await doc.reference.delete();
          print('✅ Deleted document: $docId');
        } else {
          // Regular Tournament documents: delete their 4 subcollections
          final subcollections = [
            'Matches',
            'MatchRules',
            'Participant',
            'Tournament Details'
          ];

          for (final subcollectionName in subcollections) {
            await _deleteSubcollection(doc.reference, subcollectionName);
          }
          print('✅ Deleted all subcollections for $docId');

          // Delete the Tournament document itself
          await doc.reference.delete();
          print('✅ Deleted document: $docId');
        }
      }

      print('🎉 Entire $parentCollectionName cleaned successfully.');
    } catch (e) {
      print('❌ Error deleting parent collection: $e');
    }
  }

  Future<void> _deleteSubcollection(
      DocumentReference docRef, String subcollectionName) async {
    final subcollection = docRef.collection(subcollectionName);
    final snapshot = await subcollection.get();

    if (snapshot.docs.isEmpty) {
      print('⚠ No documents found in $subcollectionName');
      return;
    }

    for (final subDoc in snapshot.docs) {
      print('🗑️ Deleting ${subDoc.id} from $subcollectionName');
      await subDoc.reference.delete();
    }

    print('✅ Deleted all documents in $subcollectionName');
  }

  // Future<void> deleteAllParticipants(String uid) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final allParticipantsDoc = firestore.collection(uid).doc('AllParticipants');

  //   print('🔴 Deleting Participants subcollection...');
  //   await _deleteSubcollection(allParticipantsDoc, 'Participants');

  //   print('🗑️ Deleting AllParticipants document...');
  //   await allParticipantsDoc.delete();

  //   print('✅ AllParticipants and its Participants subcollection deleted');
  // }

  Future<void> deleteAllParticipants(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final allParticipantsDoc = firestore.collection(uid).doc('AllParticipants');

    print('🔴 Deleting Participants subcollection...');
    await _deleteSubcollection(allParticipantsDoc, 'Participants');

    print('🗑️ Deleting AllParticipants document...');
    try {
      await allParticipantsDoc.delete();
      print('✅ Deleted AllParticipants document (placeholder or not)');
    } catch (e) {
      print('❌ Error deleting AllParticipants: $e');
    }
  }

  // Future<void> _deleteParticipant(
  //     DocumentReference docRef, String subcollectionName) async {
  //   final subcollection = docRef.collection(subcollectionName);
  //   final snapshot = await subcollection.get();

  //   if (snapshot.docs.isEmpty) {
  //     print('⚠ No documents found in $subcollectionName');
  //     return;
  //   }

  //   for (final subDoc in snapshot.docs) {
  //     print('🗑️ Deleting ${subDoc.id} from $subcollectionName');
  //     await subDoc.reference.delete();
  //   }

  //   print('✅ Deleted all documents in $subcollectionName');
  // }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    uidController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}
