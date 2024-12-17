abstract class EmailLocalRepository {
  Future<void> saveEmail(String name);
  Future<String?> getEmail();
  Future<void> deleteEmail();
}
