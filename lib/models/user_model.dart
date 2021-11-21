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
        birthday = json['birthday'],
        name = json['name'],
        email = json['email'],
        sex = json['sex'],
        phoneNumber = json['phoneNumber'];
}
