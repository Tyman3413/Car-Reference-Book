import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  Future<void> createArticlesTable(Database db) async {
    await db.execute('''
    CREATE TABLE articles (
      id TEXT PRIMARY KEY,
      title TEXT,
      subtitle TEXT,
      body TEXT,
      author TEXT,
      authorImageUrl TEXT,
      category TEXT,
      imageUrl TEXT,
      views INTEGER,
      createdAt TEXT
    )
  ''');
  }

  Future<void> addArticle(Article article) async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'my_database.db'),
            onCreate: (db, version) async {
              await createArticlesTable(db);
            },
            version: 1,
            onOpen: (db) async {
              //
            });
    await db.transaction((txn) async {
      await txn.insert('articles', article.toMap());
    });
  }

  Future<List<Article>> getArticles() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) async {
        await createArticlesTable(db);
      },
      version: 1,
    );
    final List<Map<String, dynamic>> maps = await db.query('articles');
    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        title: maps[i]['title'],
        subtitle: maps[i]['subtitle'],
        body: maps[i]['body'],
        author: maps[i]['author'],
        authorImageUrl: maps[i]['authorImageUrl'],
        category: maps[i]['category'],
        imageUrl: maps[i]['imageUrl'],
        views: maps[i]['views'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  Future<Article> getArticleById(String id) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) async {
        await createArticlesTable(db);
      },
      version: 1,
    );
    final List<Map<String, dynamic>> maps = await db.query(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Article not found');
    }
    return Article(
      id: maps[0]['id'],
      title: maps[0]['title'],
      subtitle: maps[0]['subtitle'],
      body: maps[0]['body'],
      author: maps[0]['author'],
      authorImageUrl: maps[0]['authorImageUrl'],
      category: maps[0]['category'],
      imageUrl: maps[0]['imageUrl'],
      views: maps[0]['views'],
      createdAt: DateTime.parse(maps[0]['createdAt']),
    );
  }

  Future<List<Article>> searchArticles(String query) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) async {
        await createArticlesTable(db);
      },
      version: 1,
    );
    final List<Map<String, dynamic>> maps = await db.query(
      'articles',
      where: 'UPPER(title) LIKE UPPER(?)',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        title: maps[i]['title'],
        subtitle: maps[i]['subtitle'],
        body: maps[i]['body'],
        author: maps[i]['author'],
        authorImageUrl: maps[i]['authorImageUrl'],
        category: maps[i]['category'],
        imageUrl: maps[i]['imageUrl'],
        views: maps[i]['views'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  Future<void> fillDatabase() async {
    await addArticle(Article(
      id: '1',
      title: 'Обкатка двигателя',
      subtitle: 'Обкатка двигателя на новом автомобиле',
      body:
          'Обкатка двигателя - это процесс, в котором новый двигатель приводится в рабочее состояние. Правильная обкатка поможет увеличить срок службы двигателя и улучшить его работу в будущем. Вот несколько полезных советов для обкатки двигателя:\n\n1. Следуйте рекомендациям производителя. Каждый производитель предоставляет рекомендации по обкатке двигателя. Следуйте им, чтобы убедиться, что двигатель будет обкатан правильно.\n\n2. Не превышайте максимальные обороты. Во время обкатки двигатель не должен работать на максимальных оборотах. Это может привести к повреждению двигателя.\n\n3. Не перегружайте двигатель. Во время обкатки не следует перегружать двигатель, например, не тяните слишком тяжелую нагрузку или не ездите на максимальной скорости.\n\n4. Избегайте длительных простоев. Не держите двигатель длительное время на малых оборотах или в состоянии простоя. Это может привести к образованию нагара в двигателе.\n\n5. Избегайте резких торможений. Резкие торможения также могут повредить двигатель во время обкатки.\n\n6. Проверяйте уровень масла. Во время обкатки двигатель может потреблять больше масла, чем обычно. Проверяйте уровень масла и доливайте его при необходимости.\n\n7. Поддерживайте оптимальную температуру двигателя. Не допускайте перегрева двигателя во время обкатки. Убедитесь, что он работает в оптимальном диапазоне температур.\n\n8. Послушайте звуки двигателя. Если вы заметили какие-либо странные звуки, обратитесь к специалисту.\n\n9. Не забывайте про обслуживание. Следите за регулярным обслуживанием двигателя после обкатки. Это поможет продлить срок его службы и улучшить его работу.\n\nСледуя этим советам, вы сможете правильно обкатать свой двигатель и продлить его срок службы. Помните, что правильная обкатка - это инвестиция в будущее вашего автомобиля.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'На заметку',
      views: 1204,
      imageUrl: 'assets/images/engine.jpg',
      createdAt: DateTime(2023, 4, 8, 13, 15, 37),
    ));
    await addArticle(Article(
      id: '2',
      title: 'Зарядка аккумуляторной батареи',
      subtitle:
          'Как правильно заряжать аккумулятор автомобиля зарядным устройством',
      body:
          'Зарядка аккумуляторной батареи на автомобиле с помощью зарядного устройства может происходить по-разному в зависимости от типа зарядного устройства. Но в основном процесс зарядки проходит следующим образом:\n\n1. Подготовьте батарею и зарядное устройство. Убедитесь, что батарея находится в хорошем состоянии, не имеет повреждений и коррозии на контактах. Зарядное устройство должно быть подключено к электрической розетке.\n\n2. Подключите клеммы. Сначала подключите кабель с положительной клеммой к положительному контакту батареи, затем отрицательную клемму к отрицательному контакту.\n\n3. Установите параметры зарядки. На некоторых зарядных устройствах можно установить параметры зарядки вручную, например, ток и напряжение зарядки. Убедитесь, что параметры зарядки соответствуют требованиям вашей батареи.\n\n4. Включите зарядное устройство. После подключения клемм включите зарядное устройство. Зарядное устройство начнет заряжать батарею.\n\n5. Следите за процессом зарядки. Во время зарядки следите за показаниями зарядного устройства и убедитесь, что процесс зарядки проходит без каких-либо проблем.\n\n6. Отключите зарядное устройство. После того как батарея полностью зарядилась, отключите зарядное устройство. Сначала отключите отрицательную клемму, затем положительную.\n\nНесколько советов для начинающего водителя:\n\n- Приобретайте только качественные зарядные устройства и следуйте рекомендациям производителя.\n\n- Никогда не пытайтесь зарядить батарею, которая имеет трещины, повреждения или видимые признаки коррозии.\n\n- Перед зарядкой убедитесь, что зарядное устройство и батарея находятся в хорошо проветриваемом месте.\n\n- Никогда не подключайте кабель отрицательной клеммы к кузову автомобиля или другим металлическим поверхностям, это может привести к короткому замыканию.\n\n- Следите за процессом зарядки и не оставляйте зарядное устройство без присмотра.\n\n- При зарядке используйте рекомендуемые параметры зарядки для вашей батареи.\n\n- Если батарея не заряжается, проверьте кабели на наличие повреждений или коррозии на контактах.\n\n- Если зарядное устройство не работает или вы заметили какие-либо необычные звуки, выключите его и обратитесь к специалисту.\n\n- Никогда не заряжайте батарею в помещении, где находятся легко воспламеняемые материалы, такие как бензин, керосин или лаки.\n\n- После зарядки отключите зарядное устройство и удалите клеммы. Сначала отключите положительный кабель, затем отрицательный.\n\n- Проверяйте уровень электролита в батарее. Если уровень электролита низкий, добавьте дистиллированную воду до рекомендуемого уровня.\n\nВажно понимать, что зарядка аккумуляторной батареи зарядным устройством не всегда является единственным решением проблемы с батареей. Если батарея не заряжается нормально или быстро разряжается, возможно, ее нужно заменить. Также стоит помнить, что некоторые автомобили имеют сложные системы электроники, и неправильная зарядка может привести к поломке электронных компонентов. Если у вас есть какие-либо сомнения, обратитесь к специалисту.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'На заметку',
      views: 869,
      imageUrl: 'assets/images/battery.jpg',
      createdAt: DateTime(2023, 4, 13, 15, 24, 13),
    ));
    await addArticle(Article(
      id: '3',
      title: 'Штрафы',
      subtitle: 'Административные штрафы ПДД 2023',
      body:
          'В России действует кодекс административных правонарушений, в котором предусмотрены штрафы за нарушение ПДД. Ниже приведен список основных штрафов за нарушение ПДД, согласно информации на сайте ГИБДД (Государственной инспекции безопасности дорожного движения) на май 2023 года:\n\n1. Превышение скорости:\n   - до 20 км/ч - от 500 до 1500 рублей\n   - от 20 до 40 км/ч - от 1500 до 2500 рублей\n   - свыше 40 км/ч - от 5000 до 30 000 рублей, либо лишение прав на срок от 1 до 3 месяцев\n\n2. Несоблюдение дистанции:\n   - от 500 до 1500 рублей\n\n3. Неправильный обгон:\n   - от 1000 до 5000 рублей, либо лишение прав на срок до 6 месяцев\n\n4. Нарушение правил перестроения:\n   - от 500 до 1500 рублей\n\n5. Нарушение правил проезда пешеходного перехода:\n   - от 500 до 1500 рублей\n\n6. Нарушение правил парковки:\n   - от 500 до 3000 рублей\n\n7. Нарушение правил управления транспортным средством:\n   - от 500 до 1500 рублей\n\n8. Управление транспортным средством в состоянии алкогольного опьянения:\n   - от 30 000 до 50 000 рублей, либо лишение прав на срок до 1,5 лет\n\n9. Отказ в прохождении медицинского освидетельствования на состояние алкогольного опьянения:\n   - от 30 000 до 50 000 рублей, либо лишение прав на срок до 1,5 лет\n\n10. Нарушение правил эксплуатации транспортных средств:\n   - от 500 до 1500 рублей\n\nСтоит отметить, что размер штрафов может быть увеличен в зависимости от обстоятельств и тяжести нарушения ПДД, а также повторяемости нарушения. Кроме того, за некоторые нарушения предусмотрено лишение прав и даже уголовная ответственность. Поэтому очень важно соблюдать правила дорожного движения и быть внимательным за рулем.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Штрафы',
      views: 273,
      imageUrl: 'assets/images/penalties.jpg',
      createdAt: DateTime(2023, 5, 1, 3, 19, 49),
    ));
    await addArticle(Article(
      id: '4',
      title: 'Жесты и сигналы для водителей',
      subtitle: 'Памятка: Разговор на дороге. Жесты и сигналы для водителей',
      body:
          'Сегодня темой нашего разговора будут разнообразные сигналы водителей: от размашек рук до световых сигналов. Вы скажете, что и без них отлично живете, но некоторое время пользуясь ими ваша без того сложная жизнь станет значительно проще, хотя бы на дороге. Особенно полезная эта информация будет для начинающих водителей, которые попросту теряются от того, что от них хотят водители сигналя, или моргая фарами. Ну что ж, приступим.\n\n1. Звуковые сигналы:\n   - Короткий гудок – это своеобразное приветствие и "пожалуйста", если поблагодарили аварийкой.\n   - Длинный гудок совместно с морганием дальним светом информирует о том, что автомобиль неисправен, или впереди опасность\n\n2. Сигналы ближним и дальним светом:\n   - Одиночный короткий сигнал дальним светом (встречному транспорту, пешеходу, или с боку им) обозначает "Уступаю тебе дорогу, проезжай".\n   - Два коротких сигнала дальним светом на встречному транспорту информирует его об опасности впереди (авария, туман, гололед, ремонт дороги, ДПС).\n   - Один длинный сигнал дальним светом во время обгона обозначает просьбу для сбоку идущего транспорта уступить дорогу и предоставить возможность возвращения на попутную полосу.\n   - Несколько длинных, или коротких миганий дальним светом в спину обозначают просьбу уступить дорогу.\n   - Несколько длинных миганий дальним светом с включенным правым поворотником в спину обозначает просьбу остановится у обочины.\n   - При ослеплении светом фар используется кратковременное включение дальнего света чтобы сообщить встречному водителю, что в него включен дальний свет.\n   - Если вас обгоняет фура (ночью) подайте ей сигнал дальним светом, обозначающий "Обгоняй, никого не зацепишь!"\n\n3. Сигналы аварийной сигнализацией и поворотниками:\n   - Несколько миганий аварийкой (аварийной сигнализацией) обозначает благодарность за уступленную дорогу, или еще может расцениваться как знак извинения за предоставленное неудобство при маневре. Альтернативно можно использовать включение сначала левого, затем правого поворотника.\n   - Включение левого поворотника на трассе после обгона оставаясь при этом на встречной полосе указывает позади идущим транспортам, что дорога по встречной полосе свободна.\n   - Включенный левый поворотник автобуса, или грузового транспорта на трассе обозначает запрет на обгон (по встречной дороге имеются автомобили).\n   - Включенный правый поворотник автобуса, или грузового транспорта на трассе разрешает обгон.\n   - Резкое торможение и остановка должна обязательно сопровождаться включением аварийки предупреждая об опасности позади идущий транспорт.\n   - Обгон автомобиля и продолжения езды с включенной аварийкой информирует позади идущего, что включенный дальний свет, и он мешает впереди идущему.\n\n4. Жесты рук:\n   - Рукой, или точнее кистью рисуется круг в воздухе, после чего можно указать на колесо – этот жест означает, что спущена шина, или проблема с колесом.\n   - Сжимание и разжимание кулака (напоминает мигающую лампочку) – информирует о том, что нужно включить фары.\n   - Указывание рукой на обочину обозначает, что автомобиль неисправен и необходимо выполнить остановку.\n   - Жест, удар ладонью по воздуху (как будто вы бьете по невидимому предмету) сообщает об том, что багажник открыт.\n   - Указывание рукой на дверь автомобиля информирует о том, что дверь плохо (неплотно) закрыта, или в проеме застрял какой-то предмет (ремень безопасности, одежда и т.д.).\n   - Плавное движение ладонью вверх-вниз сообщает водителю, что нужно скинуть скорость (этот жест часто используется с другими жестами и при обгоне, когда водитель непроизвольно увеличил скорость движения).\n   - Поблагодарить других водителей можно обычным поднятием руки.\n   - Оттопыренные большой палец вверх и мизинец поперек при сжатом кулаке обозначает просьбу поделится топливом за "магарыч".\n   - Поднятая ладонь (приветственный жест) информирует об том, что дорога чиста и можно ехать не тревожась.\n   - Похлопывание по плечу информирует об наличии на дороге ДПС.\n   - Аналогично, растопыренная пятерня информирует про ДПС.\n   - При остановке перед пешеходным переходом махните рукой в окно проинформировав пешеходом, что они могут идти не дожидаясь полной остановки автомобиля.\n   - И последний жест, для грузовиков и транспорта со спаренными колесами между которых застрял камень. Для сообщения этой проблемы используется жест фиги.\n\n5. Сигнал тормозом:\n   - Короткие интервалы торможения обозначают просьбу держать дистанцию позади идущего.\n\nДа, это все. Надеюсь жизнь ваша станет хоть чуточку проще. Удачи на дорогах и не забывайте говорить "Спасибо".',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'На заметку',
      views: 501,
      imageUrl: 'assets/images/gestures.jpg',
      createdAt: DateTime(2023, 4, 3, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '5',
      title: 'Hyundai Solaris',
      subtitle: 'Характеристики автомобиля Hyundai Solaris',
      body:
          'Hyundai Solaris - это компактный седан, выпускаемый с 2010 года. Hyundai Solaris создан на базе платформы Hyundai Accent и предназначен для продажи на рынке Южной Кореи, России, Украины и других стран СНГ.\n\nДвигатель:\nHyundai Solaris может быть оснащен двумя типами бензиновых двигателей: 1,4-литровым (Kappa II) с мощностью 100 л.с. и крутящим моментом 132 Нм, а также 1,6-литровым (Gamma II) с мощностью 123 л.с. и крутящим моментом 151 Нм.\n\nЭти двигатели имеют много общих деталей и построены на базе современной технологии, называемой Dual CVVT, которая позволяет изменять фазы газораспределения на впуске и выпуске, что улучшает динамику, экономичность и снижает выбросы.\n\nТрансмиссия:\nКоробка передач может быть механической с 5 ступенями или автоматической с 6 ступенями. Автоматическая коробка доступна только для 1,6-литрового двигателя.\n\nТормозная система:\nАвтомобиль оснащен дисковыми тормозами на всех колесах. Это обеспечивает надежное и безопасное торможение на всех скоростях.\n\nРулевое управление:\nHyundai Solaris имеет электромеханическое рулевое управление, которое обеспечивает удобное управление и повышенную эффективность, снижая расходы на топливо.\n\nПодвеска:\nПередняя подвеска - типа McPherson, а задняя - полузависимая балка. Эта конструкция обеспечивает комфортную поездку на дорогах различного типа и улучшенную устойчивость при поворотах.\n\nКузов:\nHyundai Solaris предлагается в двух версиях кузова - седан и хэтчбек. Оба варианта имеют пятидверный кузов и способны вместить до пяти человек.\n\nМодификации:\nHyundai Solaris доступен в нескольких модификациях, включая базовую, Comfort, Comfort Plus, Elegance, Sport и другие. В зависимости от выбранной комплектации, автомобиль может иметь такие опции, как подогрев передних сидений, мультимедийную систему с навигацией и подключением к смартфону, систему контроля давления в шинах, камеру заднего вида, климат-контроль и другие.\n\nГод выпуска:\nHyundai Solaris начал производство в 2010 году. С тех пор модель обновлялась несколько раз, включая рестайлинги в 2014, 2017 и 2020 годах. На протяжении всех лет выпуска автомобиль показывал хорошие результаты в продажах и получал высокие оценки экспертов и владельцев.\n\nВ целом, Hyundai Solaris является надежным и экономичным автомобилем, который может удовлетворить потребности широкого круга водителей. Он обладает высокими характеристиками двигателя, удобным управлением, комфортной подвеской и различными опциями, делающими езду более комфортной и безопасной.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Об авто',
      views: 1,
      imageUrl: 'assets/images/solaris.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '6',
      title: 'Kia Rio',
      subtitle: 'Характеристики автомобиля Kia Rio',
      body:
          'Kia Rio - это компактный автомобиль, производимый южнокорейским автопроизводителем Kia Motors с 2000 года. Модель была представлена как замена для Kia Pride и продается в нескольких кузовных вариантах, включая седан, хэтчбек и универсал.\n\nЭксплуатационные характеристики:\nKia Rio характеризуется как надежный автомобиль с низкой стоимостью обслуживания. Расход топлива у этого автомобиля достаточно экономичен и составляет от 6 до 7 литров на 100 км в зависимости от модификации двигателя и условий эксплуатации.\n\nХарактеристики двигателя:\nKia Rio предлагается с несколькими модификациями двигателя, включая бензиновые и дизельные. В базовой комплектации устанавливается 1,4-литровый бензиновый двигатель мощностью 100 л.с., а также 6-ступенчатая механическая коробка передач. Также доступна модификация с 1,6-литровым бензиновым двигателем мощностью 123 л.с. и 6-ступенчатой автоматической коробкой передач.\n\nТормозная система:\nКиа Рио оснащена дисковыми тормозами спереди и барабанными тормозами сзади, что обеспечивает эффективное торможение на любых дорогах. Также модели с более мощными двигателями могут оснащаться более продвинутой тормозной системой.\n\nРулевое управление:\nУправление Kia Rio довольно легкое и чувствительное благодаря гидроусилителю руля, который обеспечивает высокую маневренность автомобиля на дороге.\n\nПодвеска:\nПодвеска Kia Rio позволяет автомобилю обеспечивать комфортную поездку как на гладких дорогах, так и на неровных поверхностях. Зависимо от комплектации, в автомобиле может быть установлена передняя независимая подвеска типа "макферсон" или задняя полузависимая балка.\n\nКузов:\nKia Rio выпускается в нескольких кузовных вариантах: седан, хэтчбек и универсал. Кузов Kia Rio имеет современный дизайн и хорошо сбалансированные пропорции. В зависимости от комплектации, автомобиль может быть оснащен широким спектром опций, включая LED-фары, обогреваемое лобовое стекло и электрорегулируемые зеркала.\n\nГод выпуска:\nKia Rio был представлен в 2000 году и с тех пор был обновлен несколько раз. Наиболее значительное обновление произошло в 2017 году, когда автомобиль получил обновленный дизайн, новые двигатели и улучшенное оснащение.\n\nВ целом, Kia Rio представляет собой компактный и экономичный автомобиль, который обладает достойными характеристиками и отличными эксплуатационными качествами. Большой выбор модификаций двигателя, опций и комплектаций делает этот автомобиль привлекательным выбором для многих автолюбителей.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Об авто',
      views: 1,
      imageUrl: 'assets/images/rio.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '7',
      title: 'Lada Granta',
      subtitle: 'Характеристики автомобиля Lada Granta',
      body:
          'Lada Granta - это российский автомобиль, производимый компанией "АвтоВАЗ" с 2011 года. Это седан с передним приводом, который имеет неплохие эксплуатационные характеристики и доступен по разумной цене.\n\nХарактеристики двигателя:\nLada Granta доступна с двумя бензиновыми двигателями - объемом 1,6 литра и мощностью 87 лошадиных сил (л.с.) и 106 л.с. Первый двигатель устанавливается на базовую комплектацию, второй - на более дорогие комплектации. Оба двигателя имеют четыре цилиндра и работают в паре с пятиступенчатой механической коробкой передач или с четырехступенчатой автоматической коробкой передач.\n\nМодификации двигателя:\nДля Lada Granta существует несколько модификаций двигателей, включая газовое оборудование. Газобаллонное оборудование можно установить на 1,6-литровый двигатель, что позволяет значительно снизить расходы на топливо.\n\nТормозная система:\nLada Granta оснащена передними дисковыми тормозами и задними барабанными тормозами. Некоторые комплектации могут иметь антиблокировочную систему (ABS) и систему распределения тормозных усилий (EBD).\n\nРулевое управление:\nLada Granta имеет гидроусилитель руля, что делает управление автомобилем легким и комфортным. Поворотный радиус составляет 5,3 метра.\n\nПодвеска:\nLada Granta оснащена классической независимой передней подвеской типа "Макферсон" и полузависимой задней балочной подвеской. Подвеска обеспечивает комфортную езду и хорошую устойчивость на дороге.\n\nКузов:\nLada Granta выпускается в двух версиях - седан и хэтчбек. Седан имеет просторный багажник с объемом 480 литров. Хэтчбек имеет меньший багажник, объем которого составляет 275 литров. Кузов Lada Granta выполнен в современном дизайне и имеет хорошую аэродинамическую форму, что позволяет снизить сопротивление воздуха и улучшить экономичность движения.\n\nГод выпуска:\nLada Granta была впервые представлена в 2011 году на автосалоне в Москве и начала продаваться в России в том же году. Затем она была экспортирована в некоторые страны СНГ и Европы. За время своего производства Lada Granta получила несколько обновлений и улучшений, в том числе новый дизайн и дополнительное оборудование.\n\nВ целом, Lada Granta является недорогим и надежным автомобилем, который отлично подходит для ежедневной эксплуатации. Она имеет достаточно простой и надежный дизайн, хорошо сбалансированную подвеску, экономичный и надежный двигатель, а также различные комплектации, включающие в себя дополнительное оборудование. Однако, стоит заметить, что Lada Granta не является премиальным автомобилем, поэтому она может не иметь некоторых функций, которые могут быть доступны в более дорогих моделях.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Об авто',
      views: 1,
      imageUrl: 'assets/images/granta.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '8',
      title: 'Ford Focus',
      subtitle: 'Характеристики автомобиля Ford Focus',
      body:
          'Ford Focus - это компактный автомобиль, выпускаемый компанией Ford с 1998 года. Он является одним из самых популярных автомобилей на рынке, и его продажи по всему миру превышают 16 миллионов единиц.\n\nХарактеристики двигателя:\nВ зависимости от модели и года выпуска, Ford Focus может иметь разные двигатели. Например, в 2021 году в США предлагаются два типа двигателей: 1,0-литровый трехцилиндровый EcoBoost и 2,0-литровый четырехцилиндровый EcoBoost. Оба двигателя могут работать с 6-ступенчатой механической или 8-ступенчатой автоматической трансмиссией.\n\nМодификации двигателя:\nКроме того, существует несколько модификаций двигателя для разных рынков и моделей, включая дизельные и гибридные варианты. Например, в Европе доступен 1,5-литровый дизельный двигатель мощностью 120 л.с.\n\nТормозная система:\nFord Focus оснащен дисковыми тормозами на всех колесах. Диаметр тормозных дисков может различаться в зависимости от модели и комплектации.\n\nРулевое управление:\nРулевое управление Ford Focus может быть электромеханическим или гидроусилителем. Электромеханическое рулевое управление использует электродвигатель для усиления усилий водителя, что позволяет уменьшить расход топлива и улучшить динамику движения.\n\nПодвеска:\nFord Focus имеет независимую подвеску всех колес, что обеспечивает хорошую устойчивость и управляемость на дороге. В зависимости от модели и комплектации, подвеска может быть спортивной или комфортной.\n\nКузов:\nFord Focus доступен в двух типах кузова: хэтчбек и универсал. Хэтчбек имеет более спортивный и компактный дизайн, а универсал обладает большим пространством для багажа и пассажиров. Кузов может быть выполнен из различных материалов, включая сталь, алюминий и кевлар.\n\nГод выпуска:\nFord Focus был представлен в 1998 году как замена для модели Escort. С тех пор он прошел множество обновлений и рестайлингов. Наиболее значительные обновления произошли в 2004, 2011, 2014 и 2018 годах.\n\nВ целом, Ford Focus является надежным и популярным автомобилем, который обладает хорошей проходимостью, экономичностью, безопасностью и комфортом в управлении. Он доступен в различных модификациях и комплектациях, что позволяет выбрать наиболее подходящую опцию для каждого покупателя.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Об авто',
      views: 1,
      imageUrl: 'assets/images/focus.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '9',
      title: 'Отказ тормозов',
      subtitle: 'Причины отказа тормозов и действия водителя',
      body:
          'Отказ тормозной системы в автомобиле является серьезной проблемой, которая может привести к аварии или другим опасным ситуациям на дороге. Прежде всего, следует понимать, что отказ тормозов может быть вызван различными причинами, включая механические поломки, проблемы с гидравликой или электроникой тормозной системы, а также нехватку тормозной жидкости или ее замерзание в холодную погоду.\n\nЕсли у вас возникла ситуация с отказом тормозов, то в первую очередь необходимо сохранять спокойствие и сосредоточиться на действиях, которые помогут избежать аварии или минимизировать ее последствия. Вот несколько рекомендаций:\n\n   1. Нажмите на педаль тормоза сильнее, чтобы попытаться установить контроль над автомобилем. Если тормозная система не работает, то это не гарантирует ее восстановление, но все же стоит попробовать.\n   2. Используйте аварийный тормоз (ручной тормоз), если он доступен в вашем автомобиле. Он может помочь замедлить автомобиль, но следует помнить, что его использование на высокой скорости может привести к потере управления и заносу автомобиля.\n   3. Попробуйте использовать двигатель для замедления автомобиля. Если вы находитесь на спуске, то уменьшите скорость, переключившись на низший передачу и давая двигателю работать на оборотах.\n   4. Используйте сигналы для предупреждения других водителей о вашей проблеме. Включите аварийную сигнализацию и используйте световые сигналы, чтобы дать понять, что у вас проблемы с тормозами.\n   5. Ищите место для безопасной остановки автомобиля. Если у вас получается управлять автомобилем, то старайтесь найти место для безопасной остановки, где вы сможете не мешать движению других автомобилей и людей на дороге.\n\nВ любом случае, отказ тормозов является экстренной ситуацией, которая требует быстрого и правильного реагирования со стороны водителя. Если вы не можете восстановить работу тормозной системы, то следует связаться с экстренными службами, такими как пожарная, скорая помощь или полиция, чтобы сообщить о проблеме и запросить помощь. Они могут отправить на место происшествия специалистов, которые помогут справиться с ситуацией и организовать эвакуацию автомобиля.\n\nВажно помнить, что отказ тормозов является опасной ситуацией, которая может привести к серьезным последствиям. Поэтому необходимо соблюдать все меры предосторожности, сосредоточиться на действиях, которые помогут сохранить контроль над автомобилем, и своевременно вызвать на помощь специалистов, если это необходимо.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Неисправности',
      views: 1,
      imageUrl: 'assets/images/brakes.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '10',
      title: 'Проблемы с запуском двигателя',
      subtitle: 'Мотор вращается, но пуск не происходит',
      body:
          'Проблема, когда мотор вращается, но не происходит пуск, может быть вызвана многими факторами. Ниже приведены несколько путей решения этой проблемы:\n\n   1. Проверьте топливную систему: Проверьте, есть ли достаточно топлива в баке, а также проверьте, правильно ли настроен карбюратор или система впрыска топлива. Если вы обнаружите какие-либо проблемы, то вам может потребоваться произвести настройку или замену деталей.\n   2. Проверьте зажигание: Убедитесь, что зажигание настроено правильно и что свечи зажигания в порядке. Если свечи зажигания старые или изношены, их нужно заменить. Также проверьте, работают ли датчики, контролирующие зажигание.\n   3. Проверьте батарею: Убедитесь, что батарея полностью заряжена и что контакты батареи чисты. Если батарея слишком старая или изношена, ее нужно заменить.\n   4. Проверьте стартер: Если все вышеперечисленные пункты в порядке, то проблема может быть в самом стартере. Проверьте соединения стартера и замените его, если он не работает должным образом.\n   5. Проверьте проводку: Убедитесь, что проводка в порядке и что все соединения хорошо зажаты. Если проводка повреждена, ее нужно заменить.\n   6. Обратитесь к профессионалам: Если вы не уверены, как решить проблему, обратитесь к механику или сервисному центру. Они могут произвести диагностику и определить причину проблемы, а также произвести необходимый ремонт.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Неисправности',
      views: 1,
      imageUrl: 'assets/images/starter.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
    await addArticle(Article(
      id: '11',
      title: 'Спустило колесо',
      subtitle: 'Замена колеса',
      body: 'Если у вас спустило колесо на автомобиле, необходимо срочно принять меры, чтобы избежать дальнейших проблем и опасности на дороге. Вот несколько рекомендаций о том, что нужно делать в такой ситуации:\n\n   1. Убедитесь в безопасности: Переместитесь на безопасное место, если это возможно, и включите аварийную сигнализацию. Если вы находитесь на трассе или дороге с высоким потоком транспорта, остановитесь как можно дальше от проезжей части.\n   2. Не пытайтесь продолжать движение: Не продолжайте ехать, если колесо спущено или повреждено, потому что это может привести к еще большим проблемам и повреждениям автомобиля.\n   3. Проверьте колесо: Осмотрите колесо, чтобы убедиться, что выявлены все повреждения и спущен воздух. Если вы не можете найти повреждение, возможно, что проблема заключается в проколе или других неочевидных дефектах, и вам нужно обратиться к механику.\n   4. Замените колесо: Если у вас есть запасное колесо и инструменты, замените спущенное колесо на запасное. Если вы не знаете, как это делается, обратитесь к инструкции в руководстве по эксплуатации автомобиля.\n   5. Вызовите помощь: Если у вас нет запасного колеса, или вы не уверены, как его заменить, позвоните в аварийную службу или обратитесь к механику. Никогда не ездите на спущенном колесе, потому что это может привести к серьезным повреждениям и авариям.\n\nВ целом, если у вас спустило колесо, важно сохранять спокойствие и принимать необходимые меры для вашей безопасности и безопасности других участников дорожного движения.',
      author: 'Админ',
      authorImageUrl: 'assets/images/author.jpg',
      category: 'Неисправности',
      views: 1,
      imageUrl: 'assets/images/wheel.jpg',
      createdAt: DateTime(2023, 3, 14, 7, 40, 15),
    ));
  }
}

class Article {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final String author;
  final String authorImageUrl;
  final String category;
  final String imageUrl;
  final int views;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.author,
    required this.authorImageUrl,
    required this.category,
    required this.imageUrl,
    required this.views,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'author': author,
      'authorImageUrl': authorImageUrl,
      'category': category,
      'imageUrl': imageUrl,
      'views': views,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      body: map['body'],
      author: map['author'],
      authorImageUrl: map['authorImageUrl'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      views: map['views'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}