import 'dart:convert';
import 'dart:io';

class Terminal {
  // Run a simple command
  static Future<String> runCommand(String command, List<String> args) async {
    try {
      Process process = await Process.start(command, args);
      StringBuffer outputBuffer = StringBuffer();
      StringBuffer errorBuffer = StringBuffer();

      // Capture stdout
      await process.stdout.transform(utf8.decoder).forEach((data) {
        outputBuffer.write(data);
      });

      // Capture stderr
      await process.stderr.transform(utf8.decoder).forEach((data) {
        errorBuffer.write(data);
      });

      // Wait for process to complete
      int exitCode = await process.exitCode;

      String fullOutput = outputBuffer.toString();
      fullOutput += '\nExit code: $exitCode';

      if (errorBuffer.isNotEmpty) {
        fullOutput += '\nErrors:\n${errorBuffer.toString()}';
      }

      return fullOutput.trim();
    } catch (e) {
      throw Exception('Error running command: $e');
    }
  }

  static Future<String> uptime() async {
    // Run a command and wait for it to complete
    ProcessResult result = await Process.run('uptime', ['-p']);

    print('Exit code: ${result.exitCode}');
    print('stdout: ${result.stdout}');
    print('stderr: ${result.stderr}');

    return result.stdout.toString().trim();
  }

  static Future<String> pingGoogle() async {
    Process process = await Process.start('ping', ['-c', '3', 'google.com']);

    StringBuffer outputBuffer = StringBuffer();
    StringBuffer errorBuffer = StringBuffer();

    // Capture stdout
    await process.stdout.transform(utf8.decoder).forEach((data) {
      outputBuffer.write(data);
    });

    // Capture stderr
    await process.stderr.transform(utf8.decoder).forEach((data) {
      errorBuffer.write(data);
    });

    // Wait for process to complete
    int exitCode = await process.exitCode;

    String fullOutput = outputBuffer.toString();
    fullOutput += '\nExit code: $exitCode';

    if (errorBuffer.isNotEmpty) {
      fullOutput += '\nErrors:\n${errorBuffer.toString()}';
    }

    return fullOutput.trim();
  }
}
