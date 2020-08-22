class Series{

  List<Serie> items = new List();

  Series();

  Series.fromJsonList (List<dynamic> jsonList) {

    for (final item in jsonList){

      if (jsonList == null) return;

      final serie = Serie.fromJsonMap(item);
      items.add(serie);
      
    }
  }
}


class Serie {
  String originalName;
  List<int> genreIds;
  String name;
  double popularity;
  List<String> originCountry;
  int voteCount;
  String firstAirDate;
  String backdropPath;
  String originalLanguage;
  int id;
  double voteAverage;
  String overview;
  String posterPath;

  Serie({
    this.originalName,
    this.genreIds,
    this.name,
    this.popularity,
    this.originCountry,
    this.voteCount,
    this.firstAirDate,
    this.backdropPath,
    this.originalLanguage,
    this.id,
    this.voteAverage,
    this.overview,
    this.posterPath,
  });

  Serie.fromJsonMap(Map <String,dynamic> json) {

    popularity        = json['popularity'] / 1;
    originalName      = json['original_name'];
    genreIds          = json['genre_ids'].cast<int>();
    name              = json['name'];
    originCountry     = json['origin_country'];
    voteCount         = json['vote_count'];
    firstAirDate      = json['first_air_date'];
    backdropPath      = json['backdrop_path'];
    originalLanguage  = json['original_language'];
    id                = json['id'];
    voteAverage       = json['vote_average'] / 1;
    overview          = json['overview'];
    posterPath        = json['poster_path'];

  }

  //Retorna la imagen de la pelicula para la pantalla principal
  getRetornarImagenSerie() {
    if (posterPath == null){
      return 'https://www.redcomingenieria.cl/images/no-imagen.jpg';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }  
  }

  //Retorna la imagen de la pelicula para el SilverAppBar en el detalle de la pelicula
  getBackgroundImagenSerie() {
    if (posterPath == null){
      return 'https://www.redcomingenieria.cl/images/no-imagen.jpg';
    }else{
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    }  
  }

}

