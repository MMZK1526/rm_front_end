class Prelude {
  static S? liftNull<T, S>(S Function(T) f, T? x) {
    if (x == null) {
      return null;
    }
    return f(x);
  }
}
