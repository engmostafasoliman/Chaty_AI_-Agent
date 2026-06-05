sealed class AppException implements Exception {
  const AppException();
}

final class NoInternetException extends AppException {
  const NoInternetException();
}

final class TimeoutException extends AppException {
  const TimeoutException();
}

final class RateLimitException extends AppException {
  const RateLimitException();
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException();
}

final class ServerException extends AppException {
  final int statusCode;
  const ServerException(this.statusCode);
}

final class UnknownException extends AppException {
  final String detail;
  const UnknownException(this.detail);
}
