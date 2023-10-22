
class Failure {
  final int errorCode;
  final String message;

  Failure({required this.errorCode, required this.message});

  static Failure? fromJson(dynamic response) {
    try {
      final Map<String, dynamic>? json = response['error'] as Map<String, dynamic>?;
      return json == null
          ? null
          : Failure(
        errorCode: int.parse(json['code'].toString()),
        message: json['message'].toString(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
