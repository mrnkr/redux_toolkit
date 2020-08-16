import 'tests/action_test.dart' as action_tests;
import 'tests/async_thunk_test.dart' as async_thunk_tests;
import 'tests/configure_store_test.dart' as configure_store_tests;
import 'tests/create_reducer_test.dart' as create_reducer_test;

void main() {
  action_tests.main();
  async_thunk_tests.main();
  configure_store_tests.main();
  create_reducer_test.main();
}
