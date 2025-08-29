import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invennico_fbp/features/auth/data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitialState());
}
