//
// enum ResultType { success, error }
// class Result<T> {
//   final ResultType type;
//   final T? data;
//   final String errorMessage;
//   Result.success(this.data) : type = ResultType.success, errorMessage = '';
//   Result.error(this.errorMessage) : type = ResultType.error, data = null;
// }

enum NetworkResultType { success, error }
abstract class NetworkResult<T> {
  final NetworkResultType type;
  NetworkResult(this.type);
}
// Represents a successful network result with associated data.
class Success<T> extends NetworkResult<T> {
  final T data;
  Success(this.data) : super(NetworkResultType.success);
}
// Represents a network result indicating an error.
class Error<T> extends NetworkResult<T> {
  final int? code;
  final String message;
  Error({this.code, required this.message}) : super(NetworkResultType.error);
}
// Represents a network result indicating an exception.
