// Модель пользователя
class AppUser {
  final String uid;
  final String email;
  final String userId; // публичный идентификатор для поиска

  AppUser({required this.uid, required this.email, required this.userId});
}
