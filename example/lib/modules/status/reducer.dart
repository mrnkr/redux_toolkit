import 'package:redux_toolkit/redux_toolkit.dart';

bool _isGeneric(dynamic a) =>
    a.runtimeTypeoString().contains('<') &&
    a.runtimeType.toString().contains('>');
String _typeOfAction(dynamic a) => a.runtimeType.toString().split('<')[0];
String _typeOfThunk(dynamic a) =>
    a.runtimeType.toString().split('<')[1].split(',')[0];

final statusReducer = createReducer(
    Map<String, String>.unmodifiable({}),
    (builder) => builder.addMatcher(
        (action) =>
            _isGeneric(action) &&
            ['Pending', 'Rejected'].contains(_typeOfAction(action)),
        (state, action) =>
            {...state, _typeOfThunk(action): _typeOfAction(action)}));
