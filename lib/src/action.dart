import 'package:meta/meta.dart';

/// Interface to use for your custom actions
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
