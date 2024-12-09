import 'dart:core';
import 'dart:io';

import 'package:car_wash_light/constants/app_colors.dart';
import 'package:car_wash_light/view/screens/launch/splash_screen.dart';
import 'package:car_wash_light/view/widget/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  var userId = ''.obs;
  var userName = ''.obs;
  var imageUrl = ''.obs;
  var emailText = ''.obs;
  var message = 'Please complete all fields!'.obs;
  var colorController = true.obs;
  var loginMessage = ''.obs;
  var loginColor = true.obs;
  var isLoading = false.obs;
  var regLoading = false.obs;
  var regMessage = ''.obs;
  var hiveUserId = ''.obs;
  var imageLoading = false.obs;
  late final Color color;
  var userValue =
      0.obs; //using for accesing the user node from realtime database
  var conId = ''.obs;
  // Observable list to store fetched groups
  RxList<String> groups = <String>[].obs;

  // FOR USING HIVE
  late Box<String> dataBox;

  // OPEN HIVE BOX
  Future<void> openBox() async {
    dataBox = await Hive.openBox<String>('dataBox');
  }

  // SAVE DATA
  void saveData(String data) {
    dataBox.put('userId', data);
  }

  // RETRIEVE DATA
  String? retrieveData() {
    return dataBox.get('userId');
  }

  // DELETE DATA
  void deleteData() {
    dataBox.delete('userId');
  }

  @override
  void onInit() {
    super.onInit();
    openBox().then((_) {
      userId.value = retrieveData() ?? '';
      getUsernameAndImage();
      fetchGroupsFromFirestore();
    });
  }

  void changeIsLoading(bool value) {
    isLoading.value = value;
  }

  void changeRegLoading(bool value) {
    regLoading.value = value;
  }

  void changeImageLoading(bool value) {
    imageLoading.value = value;
  }

  Rx<User?> firebaseUser = Rx<User?>(null);

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Adding instances of Firebase services
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // LOGIN METHOD
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId.value = userCredential.user!.uid;
      hiveUserId.value = userId.value;
      saveData(hiveUserId.value);
      getUsernameAndImage();
      emailText.value = email;

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      loginMessage.value = e.message.toString();
      loginColor.value = false;
      print('Error: $e');
      return null;
    }
  }

// SIGNUP METHOD
  Future<User?> signUpWithEmailPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;
        userId.value = uid;

        // Fetch and increment user value before saving to Firestore
        await fetchUserValue(); // Fetches and increments the value from Realtime Database
        await createNewNode();

        // Add user data to Firestore after increment
        await firestore.collection('users').doc(uid).set({
          'username': username,
          'email': email,
          'uid': uid,
          'imageurl': '',
          'idNo':
              userValue.value, // Correct incremented value should now be stored
          'conId': conId.value,
        });

        print('User added successfully!');
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      message.value = e.message.toString();
      colorController.value = false;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // RESET PASSWORD METHOD
  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent! Check your inbox.';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // PICK AND UPLOAD IMAGE
  Future<void> pickFileAndUpload() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      print("Successfully picked file!");

      // UPLOAD IMAGE TO FIREBASE STORAGE
      UploadTask uploadTask = storage
          .ref('users/${userId}/profilePic/profile.jpg')
          .putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrl.value = downloadUrl;
      DocumentReference usersDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId.value);
      await usersDocRef.update({'imageurl': downloadUrl});
    }
  }

  // RETRIEVE USERNAME, IMAGE AND EMAIL,idNO and conid
  Future<void> getUsernameAndImage() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.value)
          .get();

      if (documentSnapshot.exists) {
        String? username = documentSnapshot['username'];
        String? image = documentSnapshot['imageurl'];
        String? email = documentSnapshot['email'];
        int? idNo = documentSnapshot['idNo'];
        String? conid = documentSnapshot['conId'];
        userName.value = username!;
        imageUrl.value = image!;
        emailText.value = email!;
        userValue.value = idNo!;
        conId.value = conid!;
        print('Username: $username');
        print('SHAHYK JAHAN YOU ID NUMBER IS ${userValue.value}');
        print('SHAHYK JAHAN YOUR ConID NUMBER IS ${conId.value}');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error retrieving document: $e');
    }
  }

  // SIGN-OUT METHOD
  Future<String?> signOut() async {
    try {
      await auth.signOut();
      deleteData();
      Get.offAll(() => SplashScreen());
      return "${userName} signed out successfully";
    } catch (e) {
      return null;
    }
  }

  //ADDING GROUP DATA INSIDE A CLOUD FIRESTORE
  Future<void> addGroupToFirestore(String groupName) async {
    try {
      DocumentReference userDoc =
          firestore.collection('users').doc(userId.value);
      await userDoc.update({
        'groups': FieldValue.arrayUnion([groupName]),
      });
      //ADD A METHOD HERE TO ADD A GROUP NDDE INSIDE REALTIME DATABSE
      await createGroupInsideRealtime(groupName);

      // Get.snackbar('Success', 'Group added successfully!');
      showToast('Group added successfully!', darkGreen);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add group: $e');
    }
  }

  //FETCH THE GROUPS FROM THE CLOUD FIRESTORE
  Future<void> fetchGroupsFromFirestore() async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId.value).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('groups')) {
          List<dynamic> fetchedGroups = userData['groups'] as List<dynamic>;
          groups.assignAll(fetchedGroups.cast<String>());
          print("SHAHYK JAHAN THE FETCHED GROUPS WERE: ${groups}");
          // Get.snackbar('Success', 'Groups fetched successfully!');
          // Use fetchedGroups here or assign it to a class property
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch groups: $e');
      print('Error fetching groups: $e');
    }
  }

  //REMOVE GROUP FUNCTIONALITY
  Future<void> removeGroupFromFirestore(String groupName) async {
    try {
      // String userId =
      //     "xwNtsaPieubSEoWDBj2tz6k2sqb2"; // Replace with current user ID

      // Remove the group from Firestore array
      await firestore.collection('users').doc(userId.value).update({
        'groups': FieldValue.arrayRemove([groupName])
      });

      // Refresh the list of groups after deletion
      await deleteGroupFromRealtime(groupName);
      await fetchGroupsFromFirestore();

      showToast('Group deleted successfully!', darkGreen);

      // Get.snackbar('Success', 'Group deleted successfully!');
    } catch (e) {
      // Get.snackbar('Error', 'Failed to delete group: $e');
      showToast('Failed to delete group', color.red as Color);
    }
  }

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  //WHEN CREATING A NEW USER THE NODE USER FROM REALTIME DATABASE SHOULD ALSO HAVE TO GET INCREMENTED
  Future<void> fetchUserValue() async {
    DatabaseReference userRef = databaseReference.child('user');
    DataSnapshot snapshot = await userRef.get();
    if (snapshot.exists) {
      userValue.value = snapshot.value as int;
      incrementUserValue();
    } else {
      userValue.value = 0; //Being default;
    }
  }

  //INCREMENT THE USER VALUE FROM REALTIME DATABASE
  Future<void> incrementUserValue() async {
    DatabaseReference userRef = databaseReference.child('user');
    int newUserValue = userValue.value + 1;
    await userRef.set(newUserValue).then((_) {
      userValue.value = newUserValue; // Update observable value
      print("User value updated successfully!");
    }).catchError((error) {
      print("Failed to update user value: $error");
    });
  }

  //CREATE A NEW CON NODE AS NEW USER REGISTERS
//CREATE A NEW CON NODE AS NEW USER REGISTERS
  Future<void> createNewNode() async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      DatabaseReference conRef = databaseReference.child('con');
      // Create a new child node with conId (e.g., "con91") without setting values
      await conRef.child('con${userValue.value}').set({
        'status': 'active' // Example value, can be anything
      });
      conId.value = 'con${userValue.value}';
      print("NODE created successfully!");
    } catch (e) {
      print(e.toString());
    }
  }

  //CREATING A NEW GROUP INSIDE SPECIFIC CON VALUE

  Future<void> createGroupInsideRealtime(String groupName) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    try {
      DatabaseReference conRef = databaseReference.child('con');
      await conRef.child('${conId.value}/${groupName}').set({
        'status': 'active',
      });
    } catch (e) {
      print(e);
    }
  }

  //ALSO HAVE TO IMPLEMENT THE DELETE GROUP FUNCTIONALITY FROM REALTIME DATABASE
  Future<void> deleteGroupFromRealtime(String groupName) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    try {
      DatabaseReference conRef = databaseReference.child('con');

      // Delete the specific group node
      await conRef.child('${conId.value}/$groupName').remove();

      print("Group '$groupName' deleted successfully!");
    } catch (e) {
      print("Error deleting group: ${e.toString()}");
    }
  }
}
