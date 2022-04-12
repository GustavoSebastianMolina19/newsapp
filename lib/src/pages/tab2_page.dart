import 'package:flutter/material.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/services/news_services.dart';
import 'package:newsapp/src/theme/tema.dart';
import 'package:newsapp/src/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';

class Tap2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsServices = Provider.of<NewsServices>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _ListaCategoria(),
            if (!newsServices.isLoading)
              Expanded(
                  child: ListaNoticias(
                      newsServices.getAriticulosCatgoriaSeleccionado)),
            if (newsServices.isLoading)
              Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}

class _ListaCategoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categorias = Provider.of<NewsServices>(context);
    final categories = categorias.categories;

    return Container(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final cName = categories[index].name;
          return Container(
            width: 105,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  _CategoryButton(categoria: categories[index]),
                  SizedBox(height: 5),
                  Text(
                    '${cName[0].toUpperCase()}${cName.substring(1)}',
                    style: TextStyle(
                        color: (categorias.selectedCategory == cName)
                            ? miTema.primaryColor
                            : Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Category categoria;

  const _CategoryButton({required this.categoria});

  @override
  Widget build(BuildContext context) {
    final newsServices = Provider.of<NewsServices>(context);

    return GestureDetector(
      onTap: () {
        final newsServices = Provider.of<NewsServices>(context, listen: false);
        newsServices.selectedCategory = categoria.name;
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          categoria.icon,
          color: (newsServices.selectedCategory == this.categoria.name)
              ? miTema.primaryColor
              : Colors.black54,
        ),
      ),
    );
  }
}
