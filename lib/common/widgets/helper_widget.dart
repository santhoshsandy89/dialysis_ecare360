import 'package:flutter/material.dart';

Widget sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

Widget rowInput(String label, {TextEditingController? controller, bool readOnly = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    ),
  );
}

Widget sectionCard(
    {required String title,
    required List<Widget> children,
    IconData? icon,
    Color? color}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color ?? Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 22,
              ),
            if (icon != null) const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

Widget actionButtons(BuildContext context, {VoidCallback? onSave, VoidCallback? onComplete, VoidCallback? onNext, VoidCallback? onCancel, bool readOnly = false}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 40),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel, // Use the provided onCancel callback
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: readOnly ? null : onSave, // Disable if readOnly
            child: const Text("Save Progress"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: readOnly ? null : onComplete, // Disable if readOnly
            child: const Text("Complete Session"),
          ),
        ),
        if (!readOnly) // Only show 'Next' button if not readOnly
          const SizedBox(width: 16),
        if (!readOnly) // Only show 'Next' button if not readOnly
          Expanded(
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text("Next"),
            ),
          ),
      ],
    ),
  );
}

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes"),
            ),
          ],
        ),
      ) ??
      false;
}
