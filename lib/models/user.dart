import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String uid;
  final String? displayName;
  final String email;
  final String? photoURL;
  final DateTime? createdAt;

  User({
    required this.uid,
    this.displayName,
    required this.email,
    this.photoURL,
    this.createdAt,
  });

  factory User.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email!,
      photoURL: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
