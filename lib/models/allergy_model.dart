import 'package:flutter/cupertino.dart';

class Allergy {
  int id;
  String description;
  String name;
  String type;

  Allergy(
    this.id,
    this.description,
    this.name,
    this.type,
  );

  Allergy.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        type = data['type'],
        description = data['description'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) => other is Allergy && id == other.id;

  @override
  int get hashCode => hashValues(name.hashCode, id.hashCode);
}
