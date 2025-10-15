/// Helper class to handle backend validation error messages
/// Replaces Laravel-style placeholders like :attribute with actual field names
class ErrorMessageHelper {
  /// Replace :attribute placeholder with actual field name (case-insensitive)
  /// Also replaces other common placeholders like :max, :min, :size, etc.
  /// 
  /// Example:
  /// - "The :attribute field is required" -> "The email field is required"
  /// - "The :Attribute must be a number" -> "The card number must be a number"
  /// - "The :attribute may not be greater than :max kilobytes" -> "The photo may not be greater than 10 kilobytes"
  static String replaceAttributePlaceholder(
    String message, 
    String fieldName, {
    Map<String, String>? additionalReplacements,
  }) {
    if (message.isEmpty) return message;
    
    // Replace all variations of :attribute placeholder
    String result = message;
    
    // Replace :attribute (lowercase)
    result = result.replaceAll(':attribute', fieldName.toLowerCase());
    
    // Replace :Attribute (capital A)
    result = result.replaceAll(':Attribute', fieldName);
    
    // Replace :ATTRIBUTE (all caps)
    result = result.replaceAll(':ATTRIBUTE', fieldName.toUpperCase());
    
    // Replace additional placeholders if provided (e.g., :max, :min, :size)
    if (additionalReplacements != null) {
      additionalReplacements.forEach((placeholder, value) {
        result = result.replaceAll(placeholder, value);
      });
    }
    
    return result;
  }

  /// Get formatted error message for a field
  /// 
  /// @param validationMessages - Map of validation message templates from backend
  /// @param validationType - Type of validation (e.g., 'required', 'numeric', 'regex', 'min', 'max', 'max.file')
  /// @param fieldName - Display name for the field
  /// @param fallbackMessage - Message to use if template is not found
  /// @param additionalReplacements - Map of additional placeholder replacements (e.g., {':max': '10'})
  static String getErrorMessage({
    required Map validationMessages,
    required String validationType,
    required String fieldName,
    String? fallbackMessage,
    Map<String, String>? additionalReplacements,
  }) {
    var message = validationMessages[validationType];
    
    if (message != null && message.toString().isNotEmpty) {
      return replaceAttributePlaceholder(
        message.toString(), 
        fieldName,
        additionalReplacements: additionalReplacements,
      );
    }
    
    // Return fallback or default message
    if (fallbackMessage != null) {
      return fallbackMessage;
    }
    
    // Generate default message based on validation type
    switch (validationType) {
      case 'required':
        return 'The $fieldName field is required';
      case 'numeric':
        return 'The $fieldName must be a number';
      case 'email':
        return 'The $fieldName must be a valid email address';
      case 'min':
        return 'The $fieldName is too short';
      case 'max':
      case 'max.file':
        return 'The $fieldName is too large';
      case 'regex':
        return 'The $fieldName format is invalid';
      case 'confirmed':
        return 'The $fieldName confirmation does not match';
      case 'date':
        return 'The $fieldName must be a valid date';
      case 'date_format':
        return 'The $fieldName does not match the required format';
      case 'max_words':
        return 'The $fieldName has too many words';
      default:
        return 'The $fieldName is invalid';
    }
  }

  /// Extract field name from backend error key
  /// Converts snake_case to readable format
  /// 
  /// Example: "card_number" -> "card number"
  static String formatFieldName(String fieldKey) {
    return fieldKey.replaceAll('_', ' ');
  }

  /// Process backend validation errors and return formatted messages
  /// 
  /// @param errors - Error object from backend response
  /// @param validationMessages - Validation message templates
  /// @param fieldLabels - Optional custom labels for fields
  static List<String> processBackendErrors({
    required Map errors,
    required Map validationMessages,
    Map<String, String>? fieldLabels,
  }) {
    List<String> errorMessages = [];
    
    errors.forEach((field, messages) {
      String fieldName = fieldLabels?[field] ?? formatFieldName(field);
      
      if (messages is List) {
        for (var message in messages) {
          errorMessages.add(replaceAttributePlaceholder(message.toString(), fieldName));
        }
      } else {
        errorMessages.add(replaceAttributePlaceholder(messages.toString(), fieldName));
      }
    });
    
    return errorMessages;
  }
}

