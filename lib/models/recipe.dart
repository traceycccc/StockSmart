class Recipe {
  final String label;
  final String source;
  final String url;
  final List<String> ingredientLines;

  Recipe({
    required this.label,
    required this.source,
    required this.url,
    required this.ingredientLines,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['label'],
      source: json['source'],
      url: json['url'],
      ingredientLines: List<String>.from(json['ingredientLines']),
    );
  }
}
