import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/series_model.dart';

class SeriesProviders {

  String _apikey   = 'edb5e12f1cf21a4f6a6c39ca5bcbb8e8';
  String _url      = 'api.themoviedb.org';
  String _language = 'pt-BR';

  int _popularesPageSerie = 0;
  bool _cargandoSerie     = false;

  List<Serie> _popularesSeries = new List();

  final _popularesSeriesStreamController = StreamController<List<Serie>>.broadcast();

  void disposeStream(){
    _popularesSeriesStreamController?.close();
  }

  Function( List<Serie> ) get popularesSeriesSink => _popularesSeriesStreamController.sink.add;

  Stream<List<Serie>> get popularesSeriesStream => _popularesSeriesStreamController.stream;


  
  Future <List<Serie>> _generaList (Uri url) async{
  
    final resp = await http.get(url);
    final decodeDatos = json.decode(resp.body);
    final series = new Series.fromJsonList(decodeDatos['results']);
    return series.items;

  }
  
  Future <List<Serie>> getSeriesEnAire(String language) async {

    final url = Uri.https(_url, '3/tv/on_the_air', {
      'api_key'  : _apikey,
      'language' : language
    });
    return _generaList(url);
  }


  Future <List<Serie>> getSeriesPopulares(String language) async{

    if ( _cargandoSerie ) return[];

    _cargandoSerie = true;
    _popularesPageSerie++;


    final url = Uri.https(_url, '3/tv/popular', {
      'api_key'  : _apikey,
      'language' : language,
      'page'     : _popularesPageSerie.toString()
    });

    final respuesta = await _generaList(url);
    _popularesSeries.addAll(respuesta);
    popularesSeriesSink(_popularesSeries);
    _cargandoSerie = false;
    return respuesta;
  }

  Future <List<Actor>> getCast( String serieId) async{

    final url = Uri.https(_url, '3/tv/$serieId/credits',{
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);
    return cast.actores;

  }


Future <List<Serie>> getBuscar( query ) async {

    final url = Uri.https(_url, '3/search/tv', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });
    return _generaList(url);
  }
  


}