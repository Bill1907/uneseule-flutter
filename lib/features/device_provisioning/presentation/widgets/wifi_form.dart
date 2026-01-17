import 'package:flutter/material.dart';

/// WiFi 인증 정보 입력 폼 위젯
class WifiForm extends StatefulWidget {
  final Function(String ssid, String password) onSubmit;
  final bool isLoading;

  const WifiForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<WifiForm> createState() => _WifiFormState();
}

class _WifiFormState extends State<WifiForm> {
  final _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SSID 입력
          TextFormField(
            controller: _ssidController,
            decoration: const InputDecoration(
              labelText: 'WiFi 이름 (SSID)',
              hintText: '연결할 WiFi 네트워크 이름',
              prefixIcon: Icon(Icons.wifi),
            ),
            textInputAction: TextInputAction.next,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'WiFi 이름을 입력해주세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 비밀번호 입력
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: '비밀번호',
              hintText: 'WiFi 비밀번호',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            textInputAction: TextInputAction.done,
            enabled: !widget.isLoading,
            onFieldSubmitted: (_) => _submit(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              if (value.length < 8) {
                return '비밀번호는 8자 이상이어야 합니다';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // 도움말
          Text(
            '2.4GHz WiFi 네트워크만 지원됩니다',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
          const SizedBox(height: 32),

          // 연결 버튼
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('WiFi 연결'),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _ssidController.text.trim(),
        _passwordController.text,
      );
    }
  }
}
