import 'package:meta/meta.dart';

/// Base abstract class to make your custom actions more uniform
/// 
/// ### Examples
/// 
/// ```dart
/// @immutable
/// class CompleteTodo extends PayloadAction<Todo, void, void> {
///   const CompleteTodo(Todo todo) : super(payload: todo);
/// }
/// ```
/// 
/// ```dart
/// @immutable
/// class Fulfilled<T, P, M> extends PayloadAction<P, Meta<M>, dynamic> {
///   Fulfilled(P payload, M meta, String requestId) :
///     super(payload: payload, meta: Meta(meta, requestId));
/// }
/// ```
@immutable
abstract class PayloadAction<Payload, Meta, Error> {
  final Payload payload;
  final Meta meta;
  final Error error;

  const PayloadAction({
    this.payload,
    this.meta,
    this.error,
  });
}
