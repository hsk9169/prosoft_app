class UserInfo {
  final String? name;
  final String? password;
  final String? phoneNumber;
  final String? fcmToken;

  UserInfo({
    this.name,
    this.password,
    this.phoneNumber,
    this.fcmToken,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data']['userInfo'];
    return UserInfo(
      name: data['MOBILE_NAME'] ?? '',
      password: data['MOBILE_PWD'] ?? '',
      phoneNumber: data['MOBILE_ID'] ?? '',
      fcmToken: data['TOKEN'] ?? '',
    );
  }

  // For debugging
  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'phoneNumber': phoneNumber,
        'fcmToken': fcmToken,
      };
}
