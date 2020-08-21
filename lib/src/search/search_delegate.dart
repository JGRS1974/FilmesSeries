import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculasProvider = new PeliculasProvider();
  //final pelicula = new Peliculas();

  @override
  List<Widget> buildActions(BuildContext context) {
      // Acciones que va a implementar el AppBar - Boton cerrar o Icono X
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icono a la izquierda del AppBar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation
        ),
        onPressed: () {
          close(context, null);
        });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Crea los resultados que se van a mostrar
      return Container();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando se escribe en la caja de texto

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.getBuscar(query),
      builder: (BuildContext context, AsyncSnapshot <List<Pelicula>> snapshot) {
        
        if (snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((peli) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  image: NetworkImage(peli.getRetornarImagen()),
                  fit: BoxFit.cover,
                  width: 50.0,
                ),
                title: Text(peli.title),
                subtitle: Text(peli.originalTitle),
                onTap: () {
                  close(context, null);
                  peli.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: peli);
                },
              );
            }).toList(),
            
          );

        }else{

          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


    // final listaSugerida = (query.isEmpty) ? peliculasRecientes
    //                                       : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: () {
            
    //       },
    //     );
    //   }
    // );
  }


}