abstract class AuthReposirory {
  // This class will handle the authentication logic
  // For example, it can interact with a remote API or local database
  // to manage user authentication state, login, logout, etc.

  Future<void> login(String username, String password);
  Future<void> register(String username, String password);
  Future<bool> isAuthenticated();
  Future<void> logout();
}
