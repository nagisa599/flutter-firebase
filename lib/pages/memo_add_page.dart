import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/memo.dart';

class MemoAddPage extends StatefulWidget {
  final Memo? currentMemo;
  const MemoAddPage({super.key, this.currentMemo});

  @override
  State<MemoAddPage> createState() => _MemoAddPageState();
}

class _MemoAddPageState extends State<MemoAddPage> {
  @override
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<void> addMemo() async {
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    await memoCollection.add({
      'title': titleController.text,
      'detail': detailController.text,
      'createdDate': Timestamp.now(),
    });
  }

  Future<void> updateMemo() async {
    final memoCollection = FirebaseFirestore.instance.collection('memo');
    await memoCollection.doc(widget.currentMemo!.id).update({
      'title': titleController.text,
      'detail': detailController.text,
      'updatedDate': Timestamp.now(),
    });
  }

  @override
  void initState() {
    if (widget.currentMemo != null) {
      titleController.text = widget.currentMemo!.title;
      detailController.text = widget.currentMemo!.detail;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentMemo == null ? 'メモの追加' : 'メモの編集'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("タイトル",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10)),
                )),
            const Text("詳細",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: detailController,
                  decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10)),
                )),
            const SizedBox(height: 20),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      if (widget.currentMemo == null) {
                        await addMemo();
                      } else {
                        await updateMemo();
                      }

                      Navigator.pop(context);
                    },
                    child: Text(widget.currentMemo == null ? "追加" : "更新"))),
          ],
        ),
      ),
    );
  }
}
