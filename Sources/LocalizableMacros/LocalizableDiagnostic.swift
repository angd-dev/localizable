import SwiftSyntax
import SwiftDiagnostics

enum LocalizableDiagnostic {
    case enumRequired
}

extension LocalizableDiagnostic: DiagnosticMessage {
    var message: String {
        switch self {
        case .enumRequired:
            "The @Localizable macro requires a nested enum with localization keys."
        }
    }
    
    var diagnosticID: MessageID {
        .init(domain: "LocalizableMacro", id: "\(self)")
    }
    
    var severity: DiagnosticSeverity {
        .error
    }
}
