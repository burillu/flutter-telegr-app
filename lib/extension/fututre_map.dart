extension FutureMap<E> on List<E> {
  Future<List<T>> futureMap<T>(Future<T> Function(E e) f) async {
    final List<T> items = [];

    await Future.forEach<E>(this, (element) async {
      final o = await f(element);
      items.add(o);
    });
    return items;
  }
}
