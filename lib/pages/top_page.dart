import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/memo.dart';
import 'package:flutter_firebase/pages/memo_add_page.dart';
import 'package:flutter_firebase/pages/memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});

  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _counter = 0;
  List<Memo> memoList = [];
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  // Future<void> fetchMemoList() async {
  //   final fetchedMemoList =
  //       await FirebaseFirestore.instance.collection('memo').get();
  //   final docs = fetchedMemoList.docs;
  //   for (final doc in docs) {
  //     Memo memo = Memo(
  //       title: doc.data()['title'],
  //       detail: doc.data()['detail'],
  //       createdDate: doc.data()['createdDate'],
  //     );
  //     memoList.add(memo);
  //   }
  //   setState(() {});
  // }
  Future<void> deleteMemo(String id) async {
    await memoCollection.doc(id).delete();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter-firebase"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: memoCollection
              .orderBy('createdDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('データがありません'));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    docs[index].data() as Map<String, dynamic>;
                final Memo fetchMemo = Memo(
                  id: docs[index].id,
                  title: data['title'],
                  detail: data['detail'],
                  createdDate: data['createdDate'],
                );
                return ListTile(
                    title: Text(fetchMemo.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('編集'),
                                      onTap: (() {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MemoAddPage(
                                            currentMemo: fetchMemo,
                                          );
                                        }));
                                      }),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('削除'),
                                      onTap: (() async {
                                        await deleteMemo(fetchMemo.id);
                                        setState(() {});
                                      }),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MemoDetailPage(fetchMemo);
                      }));
                    });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MemoAddPage();
          }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
