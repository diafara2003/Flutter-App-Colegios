import 'package:autraliano/helper/utilities.dart';
import 'package:autraliano/models/adjunto_models.dart';
import 'package:autraliano/providers/API/document_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

// ignore: must_be_immutable
class DownLoadFilePages extends StatefulWidget {
  Adjunto _file = new Adjunto();
  bool _readOnly = true;
  DownLoadFilePages({Key? key, required Adjunto file, required bool readOnly})
      : super(key: key) {
    _file = file;
    _readOnly = readOnly;
  }

  @override
  _DownLoadFilePagesState createState() => _DownLoadFilePagesState();
}

class _DownLoadFilePagesState extends State<DownLoadFilePages> {
  Adjunto _document = new Adjunto();

  @override
  void initState() {
    super.initState();
    _document = this.widget._file;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (this._document.downloaded) return;
        setState(() {
          this._document.downloaded = true;
        });
        String name = await DocumentProvider.downloadDocument(_document);

        await OpenFile.open(name);
        setState(() {
          this._document.downloaded = false;
        });
      },
      child: Container(
        height: 50,
        // color: Colors.white,
        margin: EdgeInsets.all(0),
        padding: this.widget._readOnly ? EdgeInsets.all(10) : EdgeInsets.all(0),
        decoration: BoxDecoration(
            border: this.widget._readOnly
                ? Border.all(color: Utilities.hexToColor('#ebebeb'))
                : Border.all(color: Colors.white),
            // color: Utilities.hexToColor('#ebebeb'),
            borderRadius: this.widget._readOnly
                ? BorderRadius.circular(5)
                : BorderRadius.circular(0)),
        child: Row(
          children: [
            _document.downloaded
                ? SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                    height: 17.0,
                    width: 17.0,
                  )
                : Icon(
                    Icons.file_download_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 10.0, top: 0.0),
                padding: EdgeInsets.all(0.0),
                child: Text(
                  _document.adjNombre!,
                  maxLines: 1,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
