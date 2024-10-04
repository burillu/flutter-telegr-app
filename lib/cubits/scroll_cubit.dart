import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollCubit extends Cubit<bool> {
  ScrollCubit() : super(false);

  void start() => emit(true);

  void end() => emit(false);

  @override
  Future<void> close() {
    // TODO: implement close

    return super.close();
  }
}
