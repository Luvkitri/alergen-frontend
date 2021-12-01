class User {
  String id;
  DateTime? birthday;
  String? name;
  String? email;
  String? sex;
  String? phoneNumber;

  User(this.id,
      {this.birthday, this.name, this.email, this.sex, this.phoneNumber});

  User.fromData(Map<String, dynamic> json)
      : id = json['id'],
        birthday = json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
        name = json['name'],
        email = json['email'],
        sex = json['sex'],
        phoneNumber = json['phone_number'];

  Map<String, dynamic> toJson() {
    return {
      'birthday': birthday?.toString(),
      'name': name,
      'email': email,
      'sex': sex,
      'phone_number': phoneNumber,
    };
  }
}
