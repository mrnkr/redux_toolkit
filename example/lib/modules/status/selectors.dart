import 'package:example/modules/app_state.dart';
import 'package:redux_toolkit/redux_toolkit.dart';

final _selectStatus = (AppState state) => state.status;

final selectIsPending = (String key) => createSelector1(_selectStatus, (status) => status[key] == 'Pending');
final selectWasFulfilled = (String key) => createSelector1(_selectStatus, (status) => status[key] == 'Fulfilled');
final selectWasRejected = (String key) => createSelector1(_selectStatus, (status) => status[key] == 'Rejected');
