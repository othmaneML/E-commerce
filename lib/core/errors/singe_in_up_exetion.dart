import 'package:ecomerce/core/errors/failures.dart';

class SignUpOrInWithEmailAndPasswordException implements Exception {
  
  const SignUpOrInWithEmailAndPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

   factory SignUpOrInWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpOrInWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpOrInWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpOrInWithEmailAndPasswordException(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpOrInWithEmailAndPasswordException(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpOrInWithEmailAndPasswordException(
          'Please enter a stronger password.',
        );
         case 'INVALID_PASSWORD':
        return const SignUpOrInWithEmailAndPasswordException(
          'Incorrect password, please try again.',
        );
      default:
        return const SignUpOrInWithEmailAndPasswordException();
    }
  }

 
  final String message;
}

