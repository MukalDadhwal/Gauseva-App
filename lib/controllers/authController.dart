import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:gauseva_app/models/post_model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../enums.dart';

class AuthController extends GetxController {
  final FirebaseAuth _instance = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Map<String, dynamic> userData = {
    'username': '',
    'phone': '',
    'uid': '',
    'isGauraksak': false,
  };
  late List<Post> userPosts;

  late Rx<User?> _firebaseUser;

  User? get user => _firebaseUser.value;
  String? get getUId => _firebaseUser.value?.uid;
  FirebaseAuth get instance => _instance;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_instance.currentUser);
    _firebaseUser.bindStream(_instance.authStateChanges());
    userPosts = [];
  }

  Future<void> uploadUserPost(
      File file,
      String address,
      double lat,
      double long,
      DateTime createdOn,
      bool hasTag,
      String severity,
      String city,
      String division) async {
    final metadata = SettableMetadata(customMetadata: {
      'postId': createdOn.toString(),
      'userUId': userData['uid'],
    });
    try {
      Reference reference = _firebaseStorage
          .ref()
          .child('images')
          .child(DateTime.now().add(Duration(minutes: 5)).toString());
      Uint8List bytes = file.readAsBytesSync();

      var snapshot = await reference.putData(bytes, metadata);

      String imageUrl = await snapshot.ref.getDownloadURL();

      await _firestoreInstance
          .collection('posts')
          .doc(createdOn.toString())
          .set({
        'imageUrls': [imageUrl],
        'upvotes': 0,
        'downvotes': 0,
        'postState': 'pending',
        'address': address,
        'location': {'lat': lat, 'long': long},
        'reviews': [],
        'timeCreated': createdOn.toIso8601String(),
        'hasTag': hasTag,
        'severity': severity,
        'city': city,
        'division': division,
        // 'data': json.encode({
        //   'imageUrls': [imageUrl],
        //   'upvotes': 0,
        //   'downvotes': 0,
        //   'postState': 'pending',
        //   'address': address,
        //   'location': json.encode({'lat': lat, 'long': long}.toString()),
        //   'reviews': [],
        //   'timeCreated': createdOn.toIso8601String(),
        //   'hasTag': hasTag,
        //   'severity': severity,
        // }),
      });
    } catch (err) {
      throw err;
    }
  }

  Future<void> searchAndSetUserData() async {
    if (user != null) {
      DocumentReference user =
          _firestoreInstance.collection('users').doc(_firebaseUser.value?.uid);

      await user.get().then((value) {
        var map = value.data() as Map<String, dynamic>;
        userData['username'] = map['username'];
        userData['phone'] = map['phonenumber'];
        userData['uid'] = getUId;
        userData['isGauraksak'] = map['isGauraksak'];
      }).onError((e, __) {
        throw e!;
      });
    }
  }

  Future<void> getUserPosts() async {
    if (user != null) {
      CollectionReference postCollection =
          _firestoreInstance.collection('posts');

      await postCollection.get().then(
        (value) {
          if (value.docs.length != userPosts.length) {
            for (var x in value.docs) {
              var imageUrls = List<String>.from(x.get('imageUrls'));
              var location = Map<String, dynamic>.from(x.get('location'));

              Post userPost = Post(
                address: x.get('address'),
                timeCreated: DateTime.parse(x.get('timeCreated')),
                hasTag: x.get('hasTag'),
                imageUrl: imageUrls,
                location: x.get('location'),
                severity: x.get('severity'),
                city: x.get('city'),
                division: x.get('division'),
              );

              userPosts.add(userPost);
            }
          }
        },
      ).onError((error, _) {
        throw error!;
      });
    }
  }

  // sort user posts according to distance
  Future<void> sortPosts() async {}

  Future<void> signUpUser(
      {required String phonenumber,
      verificationCompleted,
      verificationFailed,
      codeSent,
      codeAutoRetrievalTimeout}) async {
    await _instance
        .verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        )
        .onError((error, stackTrace) => throw error!);
  }

  Future<void> registerUserInDatabase(
      String username, String phoneNumber, bool isGauraksak) async {
    String uid = _firebaseUser.value?.uid ?? 'uidNotFound';

    DocumentReference user = _firestoreInstance.collection('users').doc(uid);
    await user.set({
      'username': username,
      'phonenumber': phoneNumber,
      'isGauraksak': isGauraksak,
    }).onError((error, _) => throw error!);
  }

  Future<bool> alreadyRegistered(String phoneNumber) async {
    bool isRegistered = false;
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var map = doc.data() as Map<String, dynamic>;
        if (map['phonenumber'] == phoneNumber) {
          isRegistered = true;
        }
        // print(doc["first_name"]);
      });
    });
    return isRegistered;
  }

  Future<void> logOutUser() async {
    try {
      await _instance.signOut();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
