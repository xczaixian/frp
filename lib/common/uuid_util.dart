import 'package:uuid/uuid.dart';

String getUUid() {
  return const Uuid().v4().replaceAll('-', '');
}
