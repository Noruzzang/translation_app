import 'package:flutter/material.dart';
import 'dart:convert';
import 'memo.dart';
import 'memo_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'I Fell Into',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemoHomePage(),
    );
}

class MemoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('I Fell Into'),
      ),
      body: Center(
        child: Text('안녕하세요'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemoListScreen(),
            ),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}

class MemoListScreen extends StatefulWidget {
  @override
  _MemoListScreenState createState() => _MemoListScreenState();
}

class _MemoListScreenState extends State<MemoListScreen> {
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? memoList = prefs.getStringList('memos');

    if (memoList != null) {
      setState(() {
        memos = memoList.map((memo) {
          final Map<String, dynamic> json = jsonDecode(memo);
          return Memo.fromJson(json);
        }).toList();
      });
    }
  }

  void onAddMemo(Memo memo) {
    setState(() {
      memos.add(memo);
    });
    _saveMemos();
  }

  Future<void> _saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> memoList = memos.map((memo) => jsonEncode(memo.toJson())).toList();
    await prefs.setStringList('memos', memoList);
  }

  void onDeleteMemo(int index) {
    setState(() {
      memos.removeAt(index);
    });
    _saveMemos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoDetailScreen(
                    memo: Memo(title: '', content: ''),
                    onUpdate: (updatedMemo) {
                      onAddMemo(updatedMemo);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(memos[index].title),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              onDeleteMemo(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('메모가 삭제되었습니다.')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(memos[index].title),
              subtitle: Text(memos[index].content),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoDetailScreen(
                      memo: memos[index],
                      onUpdate: (updatedMemo) {
                        setState(() {
                          memos[index] = updatedMemo;
                        });
                        _saveMemos();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
