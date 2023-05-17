import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';

class ItemBloc {
  final _itemListController = StreamController<List<String>?>();
  final _random = Random();
  List<String> _itemList = [];

  Stream<List<String>?> get itemListStream => _itemListController.stream;

  ItemBloc() {
    loadItems();
  }

  void loadItems() {
    _emitLoadingState();

    // Simulating data loading delay
    Future.delayed(const Duration(seconds: 2), () {
      try {
        final shouldThrowException = _random.nextBool();

        if (shouldThrowException) {
          throw Exception('Failed to load items');
        }

        _itemList = [];
        _emitDataState();
      } catch (e) {
        _emitErrorState();
      }
    });
  }

  void addItem() {
    _itemList.add('Item ${_itemList.length + 1}');
    _emitDataState();
  }

  void removeLastItem() {
    if (_itemList.isNotEmpty) {
      _itemList.removeLast();
      _emitDataState();
    }
  }

  void _emitLoadingState() {
    _itemListController.sink.add(null);
  }

  void _emitDataState() {
    _itemListController.sink.add(_itemList);
  }

  void _emitErrorState() {
    _itemListController.sink.addError('Error loading items');
  }

  void dispose() {
    _itemListController.close();
  }
}

class BlocProvider<T extends Object> extends InheritedWidget {
  final T bloc;

  const BlocProvider({
    Key? key,
    required this.bloc,
    required Widget child,
  }) : super(key: key, child: child);

  static T of<T extends Object>(BuildContext context) {
    final BlocProvider<T>? provider =
    context.dependOnInheritedWidgetOfExactType<BlocProvider<T>>();
    assert(provider != null, 'No BlocProvider found in context');
    return provider!.bloc;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
