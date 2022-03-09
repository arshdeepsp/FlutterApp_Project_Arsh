class UserProfile {
  String? username;
  String? firstName;
  String? lastName;
  String? bio;
  String? email;
  String? website;

  var profilePic;

  UserProfile(
      {this.username,
      this.firstName,
      this.lastName,
      this.bio,
      this.email,
      this.profilePic,
      this.website});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        username: json['username'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        bio: json['bio'],
        email: json['email'],
        profilePic: json['profilePic']);
  }
}
