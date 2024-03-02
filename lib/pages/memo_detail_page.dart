import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/memo.dart';

class MemoDetailPage extends StatelessWidget {
  final Memo memo;

  const MemoDetailPage(this.memo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモの詳細'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("fafaf",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text(memo.title),
          ],
        ),
      ),
    );
  }
}
