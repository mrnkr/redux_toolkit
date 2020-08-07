import 'dart:math';

// Borrowed from https://github.com/pd4d10/nanoid-dart/blob/master/lib/non_secure/generate.dart

final _random = Random();
final _alphabet = 'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

/// An inlined copy of nanoid/nonsecure. Generates a non-cryptographically-secure
/// random ID string. Automatically used by createAsyncThunk for request IDs, but
/// may also be useful for other cases as well.
String generate([int size = 21]) {
  var id = '';
  while (0 < size--) {
    id += _alphabet[_random.nextInt(64)];
  }
  return id;
}
