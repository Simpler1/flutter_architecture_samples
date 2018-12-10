// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth auth;

  const FirebaseUserRepository(this.auth);

  @override
  Future<UserEntity> login() async {
    var firebaseUser;
    try {
      print('   *** Attempting login');

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print('   *** User is: ${googleUser}');

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        print('   *** Auth is: ${googleAuth}');

        firebaseUser = await auth.signInWithGoogle(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        print('   *** firebaseUser is: ${firebaseUser}');
      } else {
        return null;
      }
    } catch (e) {
      print('   *** Google Login Error: ${e.toString()}');
      return null;
    }

    return UserEntity(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }
}
