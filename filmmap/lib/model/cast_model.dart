class Cast {
  final String name;
  final String character;
  final String profilePath;

  Cast({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'] ?? 'Ad bilgisi mevcut değil',
      character: json['character'] ?? 'Karakter bilgisi mevcut değil',
      profilePath: json['profile_path'] ?? '',
    );
  }
}
