


class User {
  String? name;
  String? jwtToken;

  User({this.name, this.jwtToken});

  factory User.fromJson(dynamic json) {
    return User(
      name: json['user_info']['fullName'] as String?,
      jwtToken: json['access_token']
    );
  }

}