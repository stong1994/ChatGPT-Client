import 'package:tiktoken/tiktoken.dart';

int tokenCount(String text, String modelName) {
  // Load an encoding
  final encoding = encodingForModel(modelName);

  // Tokenize text
  final encodedTokens = encoding.encode(text);
  return encodedTokens.length;
}

/**
https://openai.com/pricing
GPT-3.5 Turbo
4K context	$0.0015 / 1K tokens	$0.002 / 1K tokens
16K context	$0.003 / 1K tokens	$0.004 / 1K tokens
 */
double? tokenValue(int? input, int? output) {
  if (input == null || output == null) {
    return null;
  }
  const double inputPrice4K = 0.0015;
  const double outputPrice4K = 0.002;
  const double inputPrice16K = 0.003;
  const double outputPrice16K = 0.004;

  double totalPrice = 0.0;

  if (input <= 4000 && output <= 4000) {
    totalPrice = (input * inputPrice4K) + (output * outputPrice4K);
  } else {
    totalPrice = (input * inputPrice16K) + (output * outputPrice16K);
    // int inputTokens4K = input > 4000 ? 4000 : input;
    // int outputTokens4K = output > 4000 ? 4000 : output;
    // int inputTokens16K = input - inputTokens4K;
    // int outputTokens16K = output - outputTokens4K;

    // totalPrice = (inputTokens4K * inputPrice4K) +
    //     (outputTokens4K * outputPrice4K) +
    //     (inputTokens16K * inputPrice16K) +
    //     (outputTokens16K * outputPrice16K);
  }

  return totalPrice / 1000;
}
