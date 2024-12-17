abstract class NameLocalRepository {
  Future<void> saveName(String name);
  Future<String?> getName();
  Future<void> deleteName();
}
