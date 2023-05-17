import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_app/bloc/item_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ItemBloc itemBloc = BlocProvider.of<ItemBloc>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverFillRemaining(
            child: Image.asset("assets/logo.png"),
          ),
          StreamBuilder<List<String>?>(
            stream: itemBloc.itemListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final itemList = snapshot.data!;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (itemList.isNotEmpty) {
                    _scrollToLatestItem();
                  }
                });

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 8.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0),
                            // borderRadius: BorderRadius.all(
                            //     Radius.circular(5.0)
                            // ),
                          ),
                          // contentPadding: EdgeInsets.only(bottom: -8),
                          // shape: RoundedRectangleBorder(
                          //   side: BorderSide(color: Colors.black, width: 1),
                          //   borderRadius: BorderRadius.circular(5),
                          // ),
                          child: Text(
                            itemList[index],
                            textAlign: TextAlign.center,
                          ));
                    },
                    childCount: itemList.length,
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Error loading items: ${snapshot.error}'),
                  ),
                );
              }

              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              itemBloc.addItem();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToLatestItem();
              });
            },
            child: const Icon(CupertinoIcons.add),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: () => itemBloc.removeLastItem(),
            child: const Icon(CupertinoIcons.minus),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }

  void _scrollToLatestItem() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
