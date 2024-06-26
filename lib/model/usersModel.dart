import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String UsersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? level;
  DateTime? createdAt;
  DateTime? updatedAt;

  Users({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.level,
    this.createdAt,
    this.updatedAt,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        uid: json["uid"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        level: json["level"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "level": level,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
