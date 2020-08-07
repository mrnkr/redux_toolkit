## 0.1.0

Initial Version of the library.

* Includes `createStore`, `createReducer`, `PayloadAction` and `AsyncThunk`.
* Actions dispatched by `AsyncThunk` carry only `requestId` and `payload` within `meta`.
* Exports `reselect ^0.4.0` and `nanoid`.
