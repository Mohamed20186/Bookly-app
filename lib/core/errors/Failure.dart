abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.errorMessage, {this.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.errorMessage);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.errorMessage);
}

class CancelFailure extends Failure {
  const CancelFailure(super.errorMessage);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.errorMessage);
}
