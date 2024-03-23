class SatelliteInfo {
  String satId;
  int? noradCatId;
  int? noradFollowId;
  String name;
  String names;
  String image;
  Status status;
  DateTime? decayed;
  DateTime? launched;
  DateTime? deployed;
  String website;
  Operator satelliteInfoOperator;
  String countries;
  DateTime updated;
  String citation;
  bool isFrequencyViolator;
  List<String> associatedSatellites;

  SatelliteInfo({
    required this.satId,
    required this.noradCatId,
    required this.noradFollowId,
    required this.name,
    required this.names,
    required this.image,
    required this.status,
    required this.decayed,
    required this.launched,
    required this.deployed,
    required this.website,
    required this.satelliteInfoOperator,
    required this.countries,
    required this.updated,
    required this.citation,
    required this.isFrequencyViolator,
    required this.associatedSatellites,
  });

  factory SatelliteInfo.fromJson(Map<String, dynamic> json) {
    return SatelliteInfo(
      satId: json['satId'],
      noradCatId: json['noradCatId'],
      noradFollowId: json['noradFollowId'],
      name: json['name'],
      names: json['names'],
      image: json['image'],
      status: Status.values.firstWhere((e) => e.toString() == 'Status.${json['status']}'),
      decayed: json['decayed'] != null ? DateTime.parse(json['decayed']) : null,
      launched: json['launched'] != null ? DateTime.parse(json['launched']) : null,
      deployed: json['deployed'] != null ? DateTime.parse(json['deployed']) : null,
      website: json['website'],
      satelliteInfoOperator: Operator.values.firstWhere((e) => e.toString() == 'Operator.${json['satelliteInfoOperator']}'),
      countries: json['countries'],
      updated: DateTime.parse(json['updated']),
      citation: json['citation'],
      isFrequencyViolator: json['isFrequencyViolator'],
      associatedSatellites: List<String>.from(json['associatedSatellites']),
    );
  }
}

enum Operator {
  CIOMP,
  ESA,
  ISRO,
  LSF,
  NONE,
  TU_BERLIN,
  UVG
}

enum Status {
  ALIVE,
  DEAD,
  FUTURE,
  RE_ENTERED
}
