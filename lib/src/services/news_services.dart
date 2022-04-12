import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = 'aa497064502e4dd7b405175abc2e7ba8';

class NewsServices with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  bool _isLoading = true;

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.solidFutbol, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArtucles = {};

  NewsServices() {
    this.getTopHeadLines();

    categories.forEach((item) {
      this.categoryArtucles[item.name] = [];
    });

    this.getArticulesByCategory(this._selectedCategory);
  }

  bool get isLoading => this._isLoading;

  String get selectedCategory => _selectedCategory;

  set selectedCategory(String valor) {
    this._selectedCategory = valor;

    this._isLoading = true;
    this.getArticulesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getAriticulosCatgoriaSeleccionado =>
      this.categoryArtucles[this.selectedCategory]!;

  getTopHeadLines() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us';

    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles!);
    notifyListeners();
  }

  getArticulesByCategory(String catgory) async {
    if (this.categoryArtucles[catgory]!.length > 0) {
      this._isLoading = false;
      notifyListeners();
      return this.categoryArtucles[catgory];
    }

    final url =
        '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=us&category=$catgory';

    final resp = await http.get(Uri.parse(url));

    final newsResponse = newsResponseFromJson(resp.body);
    this.categoryArtucles[catgory]!.addAll(newsResponse.articles!);

    this._isLoading = false;
    notifyListeners();
  }
}
