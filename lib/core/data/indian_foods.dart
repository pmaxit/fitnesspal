class IndianFood {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const IndianFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

const List<IndianFood> indianFoodsDatabase = [
  IndianFood(name: 'Paneer Butter Masala', calories: 350, protein: 12, carbs: 10, fat: 28),
  IndianFood(name: 'Chicken Biryani', calories: 450, protein: 25, carbs: 55, fat: 15),
  IndianFood(name: 'Masala Dosa', calories: 300, protein: 6, carbs: 45, fat: 12),
  IndianFood(name: 'Chole Bhature', calories: 600, protein: 15, carbs: 75, fat: 30),
  IndianFood(name: 'Palak Paneer', calories: 250, protein: 10, carbs: 8, fat: 20),
  IndianFood(name: 'Dal Makhani', calories: 320, protein: 12, carbs: 35, fat: 15),
  IndianFood(name: 'Butter Chicken', calories: 400, protein: 22, carbs: 12, fat: 30),
  IndianFood(name: 'Aloo Gobi', calories: 150, protein: 4, carbs: 20, fat: 8),
  IndianFood(name: 'Samosa (1 piece)', calories: 250, protein: 4, carbs: 25, fat: 15),
  IndianFood(name: 'Gulab Jamun (1 piece)', calories: 150, protein: 2, carbs: 25, fat: 6),
  IndianFood(name: 'Idli (2 pieces)', calories: 120, protein: 4, carbs: 25, fat: 1),
  IndianFood(name: 'Rajma Chawal', calories: 400, protein: 15, carbs: 65, fat: 10),
  IndianFood(name: 'Tandoori Chicken', calories: 280, protein: 35, carbs: 5, fat: 12),
  IndianFood(name: 'Vada Pav', calories: 300, protein: 6, carbs: 40, fat: 14),
  IndianFood(name: 'Rogan Josh', calories: 380, protein: 28, carbs: 10, fat: 25),
];
