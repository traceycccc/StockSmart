//food item model
class FoodItem {
  final String id;
  final String name;
  //final String imageUrl;
  final String categoryId;
  final DateTime buyDate;
  final DateTime expiryDate;

  FoodItem({
    required this.id,
    required this.name,
    //required this.imageUrl,
    required this.categoryId,
    required this.buyDate,
    required this.expiryDate,
  });
}