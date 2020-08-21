import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;
  
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        siguientePagina();
      }
     });

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        controller: _pageController,
        pageSnapping: false,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, i) => _tarjeta(context, peliculas[i]),
      ),
    );
  }

  //Tarjeta creada para usar con el PageView.builder
  Widget _tarjeta(BuildContext context, Pelicula pelicula){

  pelicula.uniqueId = '${pelicula.id}-poster';

    //Creo todo lo que va a tener la tarjeta de la pelicula a visualizar en el PageView
    final tarjeta =  Container(
      padding: EdgeInsets.only(right: 5.0),
      child: Column(
        children: <Widget>[
        Hero(
          tag: pelicula.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                placeholder: AssetImage('assets/img/loading.gif'),
                image: NetworkImage(pelicula.getRetornarImagen()),
                fit: BoxFit.cover,
                height: 160.0,
            ),
          ),
        ),
        SizedBox(height: 5.0,),
        Text(
          pelicula.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        ),
        ],
      ),
    );

    //Detecto cuando se selecciona una tarjeta/pelicula para visualizar la informacion
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        //Navego hasta la pagina detalle_pelicula pasando como argumentos la pelicula seleccionada
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );   
  }
  
  
  //Tarjeta creada para utilizar con el PageView
  // List<Widget> _tarjetas(BuildContext context){

  //   return peliculas.map((peli) {

  //      return Container(
  //        padding: EdgeInsets.only(right: 5.0),
  //        child: Column(
  //          children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20.0),
  //             child: FadeInImage(
  //                 placeholder: AssetImage('assets/img/loading.gif'),
  //                 image: NetworkImage(peli.getRetornarImagen()),
  //                 fit: BoxFit.cover,
  //                 height: 160.0,
  //             ),
  //           ),
  //           SizedBox(height: 5.0,),
  //           Text(
  //             peli.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           ),
  //          ],
  //        ),
  //      );  
  //   }).toList();
  // }

}