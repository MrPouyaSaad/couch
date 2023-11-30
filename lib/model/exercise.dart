// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExerciseModel {
  String name;
  String imagePath;
  ExerciseModel({
    required this.name,
    required this.imagePath,
  });

  @override
  String toString() {
    return name;
  }
}
