import 'package:app4_receitas/di/service_locator.dart';
import 'package:app4_receitas/utils/app_error.dart';
import 'package:either_dart/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// sera usado para tudo relacionado a autenticacao
class AuthService {
  final SupabaseClient _supabaseClient = getIt<SupabaseClient>();

  // Retorna o usuario atual da aplicacao
  User? get currentUser => _supabaseClient.auth.currentUser;

  // Stream para ouvir mudanças na autenticacao
  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  // Sign in com email e senha
  Future<Either<AppError, AuthResponse>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // Right: sucesso no retorno de dados
      // Left: tipo de erro, usa AppErro
      return Right(response);
    } on AuthException catch (e) {
      switch (e.message) {
        case 'Invalid login credentials':
          return Left(
            AppError('Usuário não cadastrado ou credenciais inválidas'),
          );
        case 'Email not confirmed':
          return Left(AppError('E-mail não confirmado'));
        default:
          return Left(AppError('Erro ao fazer login', e));
      }
    }
  }

  // Retorna os valores da tabela profile do usuario conectado
  Future<Either<AppError, Map<String, dynamic>?>> fetchUserProfile(
    String userId,
  ) async {
    try {
      final profile = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return Right(profile);
    } catch (e) {
      return Left(AppError('Erro ao carregar a tabela profile'));
    }
  }

  Future<Either<AppError, AuthResponse>> signUp({
    required String email,
    required String password,
    required String username,
    required String avatarUrl,
  }) async {
    try {
      // Verificar se o username esta disponivel (nao foi usado)
      final existingUsername = await _supabaseClient
          .from('profiles')
          .select()
          .eq('username', username)
          .maybeSingle();

      if (existingUsername != null) {
        return Left(AppError('Username já existe, não está disponível'));
      }

      final result = await insertUser(email: email, password: password);
      return result.fold((left) => Left(left), (right) async {
        await _supabaseClient.from('profiles').insert({
          'id': result.right.user!.id,
          'username': username,
          'avatar_url': avatarUrl,
        });
        return Right(right);
      });
    } on PostgrestException catch (e) {
      switch(e.code) {
        case '23505':
          return Left(AppError('E-mail já registrado'));
        default:
          return Left(AppError('Erro ao registrar usuário', e));
      }
    } catch (e) {
      //error relacionado ao banco de dados no geral
      return Left(AppError('Erro inesperado ao registrar usuário', e));
    }
  }

  Future<Either<AppError, AuthResponse>> insertUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      return Right(response);
    } on AuthException catch (e) {
      switch (e.message) {
        case 'Email not confirmed':
          return Left(
            AppError('E-mail não confirmado. Verifique sua caixa de entrada 📩'),
          );
        default:
          return Left(AppError('Erro ao fazer cadastro ❌', e));
      }
    }
  }

  Future<Either<AppError, void>> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      return Right(null);
    } on AuthException catch (e) {
      return Left(AppError('Erro ao sair', e));
    } catch (e) {
      return Left(AppError('Erro inesperado ao sair', e));
    }
  }

}