abstract class TasksRepository {
  Future<void> save({required DateTime date, required String description});
}
