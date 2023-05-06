import 'package:car_reference_book/screens/article_screen.dart';
import 'package:car_reference_book/widgets/image_container.dart';
import 'package:car_reference_book/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/databaseHelper.dart';

class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({Key? key}) : super(key: key);

  static const routeName = '/discover';

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      'На заметку',
      'Штрафы',
      'Об авто',
      'Неисправности',
      'Полезное'
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        drawer: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: SideMenu(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: const BottomNavBar(index: 1),
        body: FutureBuilder<List<Article>>(
          future: databaseHelper.getArticles(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasData) {
              return ListView(padding: const EdgeInsets.all(20.0), children: [
                _DiscoverArticles(),
                _CategoryArticles(tabs: tabs, articles: snapshot.data!)
              ]);
            } else if (snapshot.hasError) {
              return const Center(child: Text('Ошибка вывода данных'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class _CategoryArticles extends StatelessWidget {
  const _CategoryArticles({
    required this.tabs,
    required this.articles,
    Key? key,
  }) : super(key: key);

  final List<String> tabs;
  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            tabs: tabs
                .map((tab) => Tab(
                      icon: Text(
                        tab,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList()),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            children: tabs
                .map(
                  (tab) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: articles
                        .where((article) => article.category == tab)
                        .length,
                    itemBuilder: ((context, index) {
                      final article = articles
                          .where((article) => article.category == tab)
                          .toList()[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ArticleScreen.routeName,
                            arguments: article,
                          );
                        },
                        child: Row(
                          children: [
                            ImageContainer(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.all(10.0),
                              borderRadius: 5,
                              image: article.imageUrl,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    article.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${DateTime.now().difference(article.createdAt).inDays} дней назад',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 20),
                                      const Icon(
                                        Icons.visibility,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${article.views} просмотров',
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}

class _DiscoverArticles extends StatelessWidget {
  _DiscoverArticles({
    Key? key,
  }) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Найти',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'Узнайте больше о своем авто',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: 'Поиск (в разработке)',
                fillColor: Colors.grey.shade200,
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.tune,
                    color: Colors.grey,
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none)),
          )
        ],
      ),
    );
  }
}
