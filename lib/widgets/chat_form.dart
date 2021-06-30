import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ChatForm extends StatefulWidget {
  File image;
  String imageUrl;

  String contactId;
  final void Function({
    BuildContext context,
    String text,
    File image,
    String imageUrl,
    String receiverId,
  }) submitChatMessage;

  ChatForm({
    this.submitChatMessage,
    this.contactId,
  });

  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  var _chatController = TextEditingController();
  var _imageUrlController = TextEditingController();

  String _type;
  bool _sendEnabled = false;

  @override
  void dispose() {
    this._chatController.dispose();
    this._imageUrlController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (this.widget.image == null &&
        this.widget.imageUrl == null &&
        this._chatController.text.trim().length == 0) {
      return;
    }
    this.widget.submitChatMessage(
          context: context,
          image: this.widget.image,
          imageUrl: this.widget.imageUrl,
          text: this._chatController.text,
          receiverId: this.widget.contactId,
        );
    setState(() {
      this.widget.image = null;
      this.widget.imageUrl = null;
    });
    this._chatController.clear();
  }

  void _mediaType() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    this._type = 'image';
                    this._setMedia();
                  });
                },
                child: Text(
                  'Take from camera',
                  style: TextStyle(color: Colors.blue),
                )),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  this._type = 'gallery';
                  this._setMedia();
                });
              },
              child: Text(
                'Choose from gallery',
                style: TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                this._setImageUrl();
              },
              child: Text(
                'provide URL',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // FlatButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     setState(() {
            //       this._type = 'video';
            //       this._setMedia();
            //     });
            //   },
            //   child: Text(
            //     'Capture video',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _setMedia() async {
    final picker = ImagePicker();
    var imageFile;

    switch (this._type) {
      case 'image':
        imageFile = await picker.getImage(
          source: ImageSource.camera,
          maxWidth: 600,
        );
        break;
      case 'gallery':
        imageFile = await picker.getImage(
          source: ImageSource.gallery,
          maxWidth: 600,
        );
        break;
      // case 'video':
      //   return;
      default:
        return;
    }

    setState(() {
      this.widget.image = File(imageFile.path);
    });

    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    setState(() {
      this.widget.imageUrl = savedImage.path;
    });

    if (this.widget.image != null) {
      setState(() {
        this._sendEnabled = true;
      });
    } else {
      setState(() {
        this._sendEnabled = false;
      });
    }
  }

  void _setImageUrl() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: this._imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Enter Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black, width: .5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    this.widget.imageUrl = this._imageUrlController.text;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('add URL',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );

    if (this._imageUrlController != null && this._imageUrlController.text.isNotEmpty) {
      setState(() {
        this._sendEnabled = true;
      });
    } else {
      setState(() {
        this._sendEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Container(
              child: this.widget.image == null
                  ? (this.widget.imageUrl == null ||
                          this.widget.imageUrl.isEmpty)
                      ? IconButton(
                          onPressed: this._mediaType,
                          icon: Icon(Icons.camera_alt),
                          iconSize: 40,
                          color: Colors.black,
                        )
                      : GestureDetector(
                          onTap: this._mediaType,
                          child: Container(
                            height: 50,
                            width: 30,
                            decoration: BoxDecoration(
                              border: Border.all(width: .2),
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight,
                                colors: [
                                  Colors.white,
                                  Colors.black54,
                                ],
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                this.widget.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        )
                  : GestureDetector(
                      onTap: this._mediaType,
                      child: Container(
                        height: 50,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(width: .2),
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.black54,
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            this.widget.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (this.widget.image != null || this.widget.imageUrl != null)
            SizedBox(
              width: 10,
            ),
          Flexible(
            fit: FlexFit.tight,
            flex: 7,
            child: TextField(
              controller: this._chatController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black)),
                focusColor: Colors.black,
                hintText: 'Enter Your Message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                if (value.trim().length == 0 && this.widget.image == null && this.widget.imageUrl == null) {
                  setState(() {
                    this._sendEnabled = false;
                  });
                } else {
                  setState(() {
                    this._sendEnabled = true;
                  });
                }
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: FlatButton(
              onPressed: this._sendEnabled ? this._sendMessage : null,
              child: Text(
                'send',
              ),
              textColor: Colors.blue,
              disabledTextColor: Colors.blue[200],
            ),
          ),
        ],
      ),
    );
  }
}
