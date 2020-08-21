import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class PeliculasProvider{

  String _apikey   = 'edb5e12f1cf21a4f6a6c39ca5bcbb8e8';
  String _url      = 'api.themoviedb.org';
  String _language = 'pt-BR';

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Pelicula> _popularesFilmes = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  void disposeStream(){
    _popularesStreamController?.close();
  }

  Function( List<Pelicula> ) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  
  Future <List<Pelicula>> _generaList (Uri url) async{
  
    final resp = await http.get(url);
    final decodeDatos = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeDatos['results']);
    return peliculas.items;

  }
  
  Future <List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'language' : _language
    });
    return _generaList(url);
  }


  Future <List<Pelicula>> getPopulares() async{

    if ( _cargando ) return[];

    _cargando = true;
    _popularesPage++;


    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });

    final respuesta = await _generaList(url);
    _popularesFilmes.addAll(respuesta);
    popularesSink(_popularesFilmes);
    _cargando = false;
    return respuesta;
  }

  Future <List<Actor>> getCast( String peliculaId) async{

    final url = Uri.https(_url, '3/movie/$peliculaId/credits',{
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);
    return cast.actores;

  }


Future <List<Pelicula>> getBuscar( query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });
    return _generaList(url);
  }

}
