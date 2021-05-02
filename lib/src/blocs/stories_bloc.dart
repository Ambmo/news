import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>(); //added functionality later on
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher =
      PublishSubject<int>(); //adding another stream before transformer block

  //Getters to Streams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;
  // Observable<Map<int, Future<ItemModel>>> items;
  //Declaring variable without value    <<<<< this stream with the cache map
  //Getters to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    //calling transform initializes a new Stream !!
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
    //assigning value once with class constructor to call transformer only one time to get only one Cache
  }

  /////////////////////////

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        // print(index); //
        cache[id] = _repository.fetchItem(id);
        return cache; //accumulator must return to pump it in again into cache map
      },
      <int, Future<ItemModel>>{}, //seed value = initial accumulator value
    );
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
