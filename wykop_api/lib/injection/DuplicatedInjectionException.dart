class DuplicatedInjectionException implements Exception {
  final message;

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }

  DuplicatedInjectionException(this.message);
}
