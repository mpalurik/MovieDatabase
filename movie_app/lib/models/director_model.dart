class Director {
  String? id;
  String firstName;
  String lastName;
  DateTime bornDate;
  String nationality;
  List<String> nationalityCode;
  String? imageFaceUrl;

  Director({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.bornDate,
    required this.nationality,
    required this.nationalityCode,
    this.imageFaceUrl
  });
  
  factory Director.fromJson(Map<String, dynamic> json) {
    return Director(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bornDate: DateTime.parse(json['bornDate']),
      nationality: json['nationality'],
      nationalityCode: List<String>.from(json['nationalityCode']),
      imageFaceUrl: json['imageFaceUrl'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'bornDate': bornDate.toIso8601String(),
      'nationality': nationality,
      'nationalityCode': nationalityCode,
      'imageFaceUrl': imageFaceUrl,
    };
  }
}