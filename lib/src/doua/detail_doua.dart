import 'package:mushaf_app/src/doua/controller.dart';
import 'package:mushaf_app/src/doua/model.dart';
import 'package:mushaf_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DouaView extends StatelessWidget {
  static const routeName = "/doua";
  const DouaView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArticlesController(
        ModalRoute.of(context)!.settings.arguments as Category,
      ),
      child: const _DouaViewBody(),
    );
  }
}

class _DouaViewBody extends StatefulWidget {
  const _DouaViewBody({Key? key}) : super(key: key);

  @override
  State<_DouaViewBody> createState() => _DouaViewBodyState();
}

class _DouaViewBodyState extends State<_DouaViewBody> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.offset <
          scrollController.position.maxScrollExtent - 150) {
        context.read<ArticlesController>().fetchArticlesDown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ArticlesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.category.name,
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: controller.articlesLoading && controller.articles.isEmpty
                ? const LoadingWidget()
                : RefreshIndicator(
                    onRefresh: controller.fetchArticlesUp,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.articles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == controller.articles.length) {
                          if (controller.articlesLoading) {
                            return const LoadingWidget(height: 64);
                          }
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            _ArticleCard(article: controller.articles[index])
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  const _ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
            offset: Offset(0, 2),
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Text(
            article.url.toString(),
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
            maxLines: 2,
          ),
          Center(
            child: Text(
              article.title,
              style: Theme.of(context).textTheme.subtitle2,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6),
          ),
          Text(
            "مرات التكرار:${article.repeat}",
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
        ],
      ),
    );
  }
}
