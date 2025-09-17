import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

class PushNotificationsPage extends StatefulWidget {
  const PushNotificationsPage({super.key});

  @override
  State<PushNotificationsPage> createState() => _PushNotificationsPageState();
}

class _PushNotificationsPageState extends State<PushNotificationsPage> {
  final _formKey = GlobalKey<FormState>();

  // Audience
  String _audience = 'All Users'; // All Users, Topic, Token
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  // Message
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  // Data payload
  final List<MapEntry<TextEditingController, TextEditingController>> _dataRows = [];

  // Scheduling
  bool _scheduleLater = false;
  DateTime? _scheduledAt;

  @override
  void dispose() {
    _topicController.dispose();
    _tokenController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _imageUrlController.dispose();
    for (final row in _dataRows) {
      row.key.dispose();
      row.value.dispose();
    }
    super.dispose();
  }

  void _addDataRow() {
    setState(() {
      _dataRows.add(MapEntry(TextEditingController(), TextEditingController()));
    });
  }

  void _removeDataRow(int index) {
    setState(() {
      _dataRows[index].key.dispose();
      _dataRows[index].value.dispose();
      _dataRows.removeAt(index);
    });
  }

  Future<void> _pickScheduleDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;

    if (_audience == 'Topic' && _topicController.text.trim().isEmpty) {
      _showSnack('Please enter a topic name');
      return;
    }
    if (_audience == 'Token' && _tokenController.text.trim().isEmpty) {
      _showSnack('Please enter a device token');
      return;
    }
    if (_scheduleLater && _scheduledAt == null) {
      _showSnack('Please select a schedule date & time');
      return;
    }

    // Build payload (stub)
    final Map<String, dynamic> payload = {
      'audience': _audience,
      if (_audience == 'Topic') 'topic': _topicController.text.trim(),
      if (_audience == 'Token') 'token': _tokenController.text.trim(),
      'notification': {
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        if (_imageUrlController.text.trim().isNotEmpty) 'image': _imageUrlController.text.trim(),
      },
      'data': {
        for (final row in _dataRows)
          if (row.key.text.trim().isNotEmpty)
            row.key.text.trim(): row.value.text.trim(),
      },
      'schedule': _scheduleLater ? _scheduledAt?.toIso8601String() : null,
    };

    // Here you would call your backend service to send FCM
    // For now, just confirm
    _showSnack('Notification ${_scheduleLater ? 'scheduled' : 'sent'}');
    debugPrint('FCM payload => $payload');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Appcolors.appPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: Appcolors.appPrimaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Push Notifications',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.textPrimaryColor,
                      ),
                    ),
                    Text(
                      'Send targeted notifications similar to Firebase console',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Form + Preview
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Form
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Audience', style: _sectionTitleStyle()),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _audienceChip('All Users'),
                                _audienceChip('Topic'),
                                _audienceChip('Token'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (_audience == 'Topic')
                              _outlinedField(
                                label: 'Topic Name',
                                controller: _topicController,
                                hint: 'e.g. promotions',
                              ),
                            if (_audience == 'Token')
                              _outlinedField(
                                label: 'Device Token',
                                controller: _tokenController,
                                hint: 'ExponentPushToken... / FCM token',
                                maxLines: 2,
                              ),

                            const SizedBox(height: 24),
                            Text('Message', style: _sectionTitleStyle()),
                            const SizedBox(height: 12),
                            _outlinedField(
                              label: 'Title',
                              controller: _titleController,
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                            ),
                            const SizedBox(height: 12),
                            _outlinedField(
                              label: 'Body',
                              controller: _bodyController,
                              maxLines: 4,
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Body is required' : null,
                            ),
                            const SizedBox(height: 12),
                            _outlinedField(
                              label: 'Image URL (optional)',
                              controller: _imageUrlController,
                              hint: 'https://...',
                            ),

                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Data Payload', style: _sectionTitleStyle()),
                                TextButton.icon(
                                  onPressed: _addDataRow,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add key/value'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: [
                                if (_dataRows.isEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Text(
                                      'No data payload. Add optional key/value pairs to include with the notification.',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ),
                                ..._dataRows.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final keyCtrl = entry.value.key;
                                  final valCtrl = entry.value.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _outlinedField(
                                            label: 'Key',
                                            controller: keyCtrl,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _outlinedField(
                                            label: 'Value',
                                            controller: valCtrl,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        IconButton(
                                          tooltip: 'Remove',
                                          onPressed: () => _removeDataRow(idx),
                                          icon: const Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),

                            const SizedBox(height: 24),
                            Text('Delivery', style: _sectionTitleStyle()),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Switch(
                                  value: _scheduleLater,
                                  onChanged: (v) => setState(() => _scheduleLater = v),
                                ),
                                const SizedBox(width: 8),
                                Text(_scheduleLater ? 'Schedule for later' : 'Send immediately'),
                                const Spacer(),
                                if (_scheduleLater)
                                  OutlinedButton.icon(
                                    onPressed: _pickScheduleDateTime,
                                    icon: const Icon(Icons.calendar_today),
                                    label: Text(_scheduledAt == null
                                        ? 'Pick date & time'
                                        : _scheduledAt!.toLocal().toString().split('.').first),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _send,
                                icon: const Icon(Icons.send),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Appcolors.appPrimaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                label: const Text('Send Notification'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 24),

                // Right: Preview
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade100,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preview', style: _sectionTitleStyle()),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Appcolors.appPrimaryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.notifications, color: Appcolors.appPrimaryColor),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _titleController.text.isEmpty ? 'Notification title' : _titleController.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Appcolors.textPrimaryColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _bodyController.text.isEmpty ? 'Your message body will appear here.' : _bodyController.text,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (_imageUrlController.text.trim().isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _imageUrlController.text.trim(),
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stack) => Container(
                                            height: 120,
                                            color: Colors.white,
                                            alignment: Alignment.center,
                                            child: Text('Image preview failed', style: TextStyle(color: Colors.grey.shade500)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Audience: ${_audience}${_audience == 'Topic' ? ' (${_topicController.text})' : _audience == 'Token' ? ' (token...)' : ''}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                        ),
                        if (_scheduleLater)
                          Text(
                            'Scheduled at: ${_scheduledAt?.toLocal().toString().split('.').first ?? ''}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Appcolors.textPrimaryColor,
    );
  }

  Widget _audienceChip(String label) {
    final isSelected = _audience == label;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _audience = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Appcolors.appPrimaryColor.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Appcolors.appPrimaryColor : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              label == 'All Users' ? Icons.people : label == 'Topic' ? Icons.tag : Icons.smartphone,
              size: 16,
              color: isSelected ? Appcolors.appPrimaryColor : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Appcolors.appPrimaryColor : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Appcolors.appPrimaryColor, width: 1.5),
            ),
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}