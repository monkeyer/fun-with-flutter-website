import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/filtered_blog/filtered_blog_bloc.dart';
import '../../../application/page/page_bloc.dart';
import '../../../application/page/page_event.dart';
import '../../../application/page/page_state.dart';
import '../error/error_widget.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key, this.width}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    final filteredBlogBloc = BlocProvider.of<FilterBlogBloc>(context);
    final pageBloc = BlocProvider.of<PageBloc>(context);
    return SingleChildScrollView(
      child: Container(
        width: width,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            _MenuButton(
                iconData: Icons.widgets,
                lable: 'Custom Widgets',
                onPressed: () {
                  filteredBlogBloc.add(const FilterBlogEvent.clearFilters());
                  pageBloc.add(const UpdatePage(PageState.packages));
                }),
            _MenuSection(
              title: 'Tags',
              child: BlocBuilder<FilterBlogBloc, FilterBlogState>(
                builder: (BuildContext context, FilterBlogState state) {
                  return state.map(
                    error: (_) => const CustomError(
                      errorMessage: 'Tags could not be loaded',
                    ),
                    loading: (_) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Loading data...'),
                    ),
                    loaded: (data) => Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        for (final tag in data.filteredBlog.tags)
                          _Tag(
                            tagName: tag.name,
                            currentFilter: data.tagFilter,
                          ),
                      ],
                    ),
                  );
                  // if (state is FilteredBlogLoading) {
                  //   return const Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Text('Loading data...'),
                  //   );
                  // }
                  // if (state is FilteredBlogLoaded) {
                  //   return Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: <Widget>[
                  //       for (final tag in state.filteredBlog.tags)
                  //         _Tag(
                  //           tagName: tag.name,
                  //           currentFilter: state.tagFilter,
                  //         ),
                  //     ],
                  //   );
                  // }
                  // return const CustomError(
                  //   errorMessage: 'Tags could not be loaded',
                  // );
                },
              ),
            ),
            _MenuSection(
              child: _MenuButton(
                iconData: Icons.question_answer,
                lable: 'About',
                onPressed: () {
                  filteredBlogBloc.add(const FilterBlogEvent.clearFilters());
                  pageBloc.add(const UpdatePage(PageState.about));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({Key key, this.onPressed, this.iconData, this.lable})
      : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;
  final String lable;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: _MenuLable(
        iconData: iconData,
        lable: lable,
      ),
    );
  }
}

class _MenuLable extends StatelessWidget {
  const _MenuLable({Key key, this.iconData, this.lable}) : super(key: key);

  final IconData iconData;
  final String lable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
        ),
        const SizedBox(
          width: 20,
        ),
        Flexible(
          child: Text(
            lable,
            overflow: TextOverflow.ellipsis,
            // style: TextStyle(
            //   color: AppTheme.fadedBlackColor,
            // ),
          ),
        ),
      ],
    );
  }
}

@immutable
class _Tag extends StatelessWidget {
  const _Tag({Key key, this.tagName, this.currentFilter}) : super(key: key);

  final String tagName;
  final String currentFilter;

  @override
  Widget build(BuildContext context) {
    final filteredBlogBloc = BlocProvider.of<FilterBlogBloc>(context);
    final pageBloc = BlocProvider.of<PageBloc>(context);
    final iconData =
        (tagName == currentFilter) ? Icons.label : Icons.label_outline;
    return _MenuButton(
      iconData: iconData,
      lable: tagName,
      onPressed: () {
        pageBloc.add(const UpdatePage(PageState.blog));
        filteredBlogBloc.add(FilterBlogEvent.filterByTag(tagName));
      },
    );
  }
}

@immutable
class _MenuSection extends StatelessWidget {
  const _MenuSection({Key key, @required this.child, this.title})
      : super(key: key);

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Text(
              title?.toUpperCase(),
              // style: TextStyle(color: AppTheme.fadedBlackColor),
            ),
          ),
        child,
        const SizedBox(
          height: 32,
        )
      ],
    );
  }
}