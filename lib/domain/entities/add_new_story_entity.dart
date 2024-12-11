import 'package:equatable/equatable.dart';

// *Entitas untuk menambahkan cerita baru di layer domain
class AddNewStoryEntity extends Equatable {
  final bool error;
  final String message;

  const AddNewStoryEntity({
    required this.error,
    required this.message,
  });

  @override
  List<Object> get props => [error, message];
}
