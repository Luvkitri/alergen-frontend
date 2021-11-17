import 'package:flutter/material.dart';
import 'package:frontend/models/dialog_model.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/ui/widgets/input_field.dart';

import '../locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  const DialogManager({Key? key, required this.child}) : super(key: key);
  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    var isInputDialog = request.inputLine != null;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(request.title),
              content: isInputDialog
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InputField(
                            controller: request.inputLine!, placeholder: ""),
                      ],
                    )
                  : Text(request.description),
              actions: <Widget>[
                if (isConfirmationDialog)
                  TextButton(
                    child: Text(request.cancelTitle!),
                    onPressed: () {
                      _dialogService
                          .dialogComplete(DialogResponse(confirmed: false));
                    },
                  ),
                TextButton(
                  child: Text(request.buttonTitle),
                  onPressed: () {
                    _dialogService
                        .dialogComplete(DialogResponse(confirmed: true));
                  },
                ),
              ],
            ));
  }
}
