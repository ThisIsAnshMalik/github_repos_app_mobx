import 'package:github/github.dart';
import 'package:mobx/mobx.dart';

part 'github_store.g.dart';

// ignore: library_private_types_in_public_api
class GithubStore = _GithubStore with _$GithubStore;

abstract class _GithubStore with Store {
  final GitHub client = GitHub();
  List<Repository> repositories = [];
  @observable
  ObservableFuture<List<Repository>> fetchReposFuture = emptyResponse;

  @observable
  String user = '';

  @observable
  bool loading = false;
  @computed
  bool get hasResults =>
      fetchReposFuture != emptyResponse &&
      fetchReposFuture.status == FutureStatus.fulfilled;

  static ObservableFuture<List<Repository>> emptyResponse =
      ObservableFuture.value([]);

  @action
  Future<List<Repository>> fetchRepos() async {
    repositories = [];
    final future = client.repositories.listUserRepositories(user).toList();
    fetchReposFuture = ObservableFuture(future);

    return repositories = await future;
  }

  @action
  void setLoading(bool value) {
    loading = value;
  }

  @action
  void setUser(String text) {
    fetchReposFuture = emptyResponse;
    user = text;
  }
}
