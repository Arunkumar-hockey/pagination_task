import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:pagination_task/model/pagination_model.dart';
import 'package:pagination_task/service/api_service.dart';

class InfiniteScrollPagination extends StatefulWidget {
  @override
  _InfiniteScrollPaginationState createState() => _InfiniteScrollPaginationState();
}

class _InfiniteScrollPaginationState extends State<InfiniteScrollPagination> {
  static const _pageSize = 10;
  var products = <Products>[];

  final PagingController<int, Products> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Products> newItems =
      await APIService().fetchProducts(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text("Infinite Scroll Pagination"),
      backgroundColor: Colors.orange,
    ),
    body: PagedListView<int, Products>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Products>(
          itemBuilder: (context, item, index) => Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0, vertical: 25.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey, width: 2)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(width: 21),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            item.title.toString(),
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black54),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            'Title',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(color: Colors.black54,thickness: 1.5,),
                //const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          item.userId.toString(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                        ),
                        const SizedBox(height: 3.0),
                        const Text(
                          'User ID',
                          style: TextStyle(
                              color: Colors.black87, fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          item.id.toString(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                        ),
                        const SizedBox(height: 3.0),
                        const Text(
                          'ID',
                          style: TextStyle(
                              color: Colors.black87, fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          item.completed.toString(),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                        ),
                        const SizedBox(height: 3.0),
                        const Text(
                          'Completed',
                          style: TextStyle(
                              color: Colors.black87, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
    ),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
