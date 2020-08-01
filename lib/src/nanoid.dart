import 'dart:math';

// Borrowed from https://github.com/pd4d10/nanoid-dart/blob/master/lib/non_secure/generate.dart

final random = Random();
final alphabet = 'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

String generate([int size = 21]) {
  var id = '';
  while (0 < size--) {
    id += alphabet[random.nextInt(64)];
  }
  return id;
}
