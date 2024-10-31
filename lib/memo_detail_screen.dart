import 'package:flutter/material.dart';
import 'memo.dart';

class MemoDetailScreen extends StatefulWidget {
  final Memo memo;
  final Function(Memo) onUpdate;

  MemoDetailScreen({required this.memo, required this.onUpdate});

  @override
  _MemoDetailScreenState createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends State<MemoDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    // Memo의 제목과 내용을 컨트롤러에 설정
    _titleController = TextEditingController(text: widget.memo.title);
    _contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  void dispose() {
    // 메모리 누수를 방지하기 위해 컨트롤러를 해제
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('제목과 내용을 입력하세요.')),
                );
              } else {
                widget.onUpdate(
                  Memo(
                    title: _titleController.text,
                    content: _contentController.text,
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '메모를 입력하세요'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
