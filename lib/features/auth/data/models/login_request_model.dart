/// Login request body model.
///
/// Encapsulates the data needed for a login API call.
/// Provides `toJson` for serialization.
class LoginRequestModel {
  /// User's email address.
  final String email;

  /// User's password.
  final String password;

  /// Creates a [LoginRequestModel].
  const LoginRequestModel({
    required this.email,
    required this.password,
  });

  /// Converts to a JSON [Map] for the API request body.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
