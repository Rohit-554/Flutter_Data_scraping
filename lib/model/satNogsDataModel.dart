class Satellite {
  String? satId;
  num? noradCatId;
  dynamic noradFollowId;
  String? name;
  String? names;
  String? image;
  String? status;
  dynamic decayed;
  String? launched;
  dynamic deployed;
  String? website;
  String? operator;
  String? countries;
  List<dynamic>? telemetries;
  String? updated;
  String? citation;
  bool? isFrequencyViolator;
  List<dynamic>? associatedSatellites;

  Satellite({
    this.satId,
    this.noradCatId,
    this.noradFollowId,
    this.name,
    this.names,
    this.image,
    this.status,
    this.decayed,
    this.launched,
    this.deployed,
    this.website,
    this.operator,
    this.countries,
    this.telemetries,
    this.updated,
    this.citation,
    this.isFrequencyViolator,
    this.associatedSatellites,
  });

  factory Satellite.fromJson(Map<String, dynamic> json) => Satellite(
    satId: json['sat_id'],
    noradCatId: json['norad_cat_id'],
    noradFollowId: json['norad_follow_id'],
    name: json['name'],
    names: json['names'],
    image: json['image'],
    status: json['status'],
    decayed: json['decayed'],
    launched: json['launched'],
    deployed: json['deployed'],
    website: json['website'],
    operator: json['operator'],
    countries: json['countries'],
    telemetries: json['telemetries'],
    updated: json['updated'],
    citation: json['citation'],
    isFrequencyViolator: json['is_frequency_violator'],
    associatedSatellites: json['associated_satellites'],
  );

  Map<String, dynamic> toJson() => {
    'sat_id': satId,
    'norad_cat_id': noradCatId,
    'norad_follow_id': noradFollowId,
    'name': name,
    'names': names,
    'image': image,
    'status': status,
    'decayed': decayed,
    'launched': launched,
    'deployed': deployed,
    'website': website,
    'operator': operator,
    'countries': countries,
    'telemetries': telemetries,
    'updated': updated,
    'citation': citation,
    'is_frequency_violator': isFrequencyViolator,
    'associated_satellites': associatedSatellites,
  };
}