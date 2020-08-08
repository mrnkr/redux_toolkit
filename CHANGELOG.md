## 0.1.0

Initial Version of the library.

* Includes `createStore`, `createReducer`, `PayloadAction` and `AsyncThunk`.
* Actions dispatched by `AsyncThunk` carry only `requestId` and `payload` within `meta`.
* Exports `reselect ^0.4.0` and `nanoid`.

## 0.1.1

* Enhanced docs by adding examples and correcting mistakes in the README.
* Added docs to the example
* Migrated the example to functional widgets using [`functional_widget`](https://github.com/rrousselGit/functional_widget)
* Fixed code styling and setup pedantic
