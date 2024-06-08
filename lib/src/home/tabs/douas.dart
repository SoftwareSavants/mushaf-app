import 'package:flutter/material.dart';
import 'package:mushaf_app/src/doua/model.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../doua/category_controler.dart';
import '../../doua/detail_doua.dart';

class DouaTab extends StatelessWidget {
  static const routeName = '/douaViewe';

  const DouaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryController(),
      child: const _DouaTabBody(),
    );
  }
}

class _DouaTabBody extends StatelessWidget {
  const _DouaTabBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controler = context.watch<CategoryController>();

    if (controler.loading) return const LoadingWidget();

    return ListView(
      padding: MediaQuery.of(context).padding.copyWith(top: 30),
      children: [
        Text(
          "الأدعية والأذكار",
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        GridView(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final category in controler.categories)
              CardService(category: category)
          ],
        )
      ],
    );
  }
}

class CardService extends StatelessWidget {
  final Category category;

  const CardService({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => AppNavigator.push(DouaView.routeName, arguments: category),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                category.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
