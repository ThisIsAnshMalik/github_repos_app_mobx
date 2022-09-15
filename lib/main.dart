import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:github_repos_app_mobx/github_store.dart';
import 'package:mobx/mobx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GitHub Repos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GitHub Repos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GithubStore store = GithubStore();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              autocorrect: false,
              onSubmitted: (String user) {
                store.setUser(user);
                store.fetchRepos();
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "search",
                  border: OutlineInputBorder()),
            ),
          ),
          Observer(
              builder: (_) =>
                  store.fetchReposFuture.status == FutureStatus.pending
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        )
                      : Container()),
          Expanded(
            child: Observer(builder: (_) {
              if (!store.hasResults) {
                return Container();
              } else {
                return ListView.builder(
                    itemCount: store.repositories.length,
                    itemBuilder: (_, int index) {
                      final repo = store.repositories[index];
                      return ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                repo.name,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(' (${repo.stargazersCount} ⭐️)'),
                          ],
                        ),
                        subtitle: Text(
                          repo.description,
                          overflow: TextOverflow.fade,
                        ),
                      );
                    });
              }
            }),
          ),
        ],
      ),
    );
  }
}
