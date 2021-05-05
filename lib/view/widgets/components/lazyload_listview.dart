import 'package:anon/core/model/post.dart';
import 'package:anon/view/screens/pages/home/view_post.dart';
import 'package:anon/view/widgets/anon_widgets.dart';
import 'package:anon/view/widgets/components/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LazyLoadListView extends AnonStatefulWidget {
  final List<PostModel> defaultList;

  LazyLoadListView({@required this.defaultList});
  @override
  _LazyLoadListViewState createState() => _LazyLoadListViewState();
}

class _LazyLoadListViewState extends AnonState<LazyLoadListView> {
  ScrollController _controller = ScrollController();

  int currentMaxPostLength = 15;
  int _testMaxLength = 15;

  List<PostModel> udatedPosts;

  @override
  void initState() {
    super.initState();
    // _controller = widget.scrollController ?? ScrollController();
    udatedPosts = widget.defaultList.getRange(0, currentMaxPostLength).toList();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent)
        _updatePosts();
    });
  }

  void _updatePosts() {
    if (_testMaxLength < widget.defaultList.length)
      setState(() => _testMaxLength = _testMaxLength + 15);

    if (_testMaxLength < widget.defaultList.length) {
      udatedPosts =
          widget.defaultList.getRange(0, currentMaxPostLength + 15).toList();
      setState(() => currentMaxPostLength = currentMaxPostLength + 15);
    } else {
      udatedPosts = widget.defaultList.take(widget.defaultList.length).toList();
      setState(() => currentMaxPostLength = widget.defaultList.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildContentList();
  }

  ListView buildContentList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: currentMaxPostLength,
        controller: _controller,
        itemBuilder: (context, index) {
          if (index == currentMaxPostLength - 1) {
            return loadingAndEmptytitle();
          }
          return buildListItem(index);
        });
  }

  buildListItem(int index) => Center(
        child: PostCardWidget(
          postModel: udatedPosts[index],
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ViewPost(postModel: udatedPosts[index]),
            ),
          ),
          onViewCommentsTap: () {},
        ),
      );

  loadingAndEmptytitle() => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: _testMaxLength > widget.defaultList.length
            ? buildEmptyTitle()
            : CupertinoActivityIndicator(radius: 15),
      );

  Center buildEmptyTitle() =>
      Center(child: Text("Couldn't find more posts..."));
}