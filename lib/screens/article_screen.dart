import 'package:car_reference_book/services/databaseHelper.dart';
import 'package:car_reference_book/widgets/custom_tag.dart';
import 'package:car_reference_book/widgets/image_container.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  ArticleScreen({Key? key}) : super(key: key);

  static const routeName = '/article';

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)!.settings.arguments as Article;
    return FutureBuilder(
      future: databaseHelper.getArticleById(article.id),
      builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Ошибка вывода данных'));
        }
        final article = snapshot.data!;
        return ImageContainer(
          width: double.infinity,
          image: article.imageUrl,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: ListView(
              children: [
                _ArticlesHeadline(article: article),
                _ArticleBody(article: article)
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomTag(backgroundColor: Colors.black, children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: AssetImage(
                    article.authorImageUrl,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  article.author,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                )
              ]),
              const SizedBox(width: 10),
              CustomTag(backgroundColor: Colors.grey.shade200, children: [
                const Icon(
                  Icons.timer,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  '${DateTime.now().difference(article.createdAt).inDays} дн',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
              const SizedBox(width: 10),
              CustomTag(backgroundColor: Colors.grey.shade200, children: [
                const Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  '${article.views}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            article.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(article.body,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}

class _ArticlesHeadline extends StatelessWidget {
  const _ArticlesHeadline({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          CustomTag(backgroundColor: Colors.grey.withAlpha(150), children: [
            Text(
              article.category,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            article.subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
