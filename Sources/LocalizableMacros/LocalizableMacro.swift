import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct LocalizableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = enumDecl(of: declaration) else {
            let diagnostic = Diagnostic(
                node: Syntax(node),
                message: LocalizableDiagnostic.enumRequired
            )
            context.diagnose(diagnostic)
            return []
        }
        
        let type = typeName(of: declaration) ?? "Localizable"
        let cases = enumCases(of: enumDecl)
        let bundle = bundleArgument(of: node)
        let access = accessLevel(of: declaration)
        
        return cases.compactMap { element in
            if element.parameterClause == nil {
                makeField(from: element, type: type, access: access, bundle: bundle)
            } else {
                makeFunction(from: element, type: type, access: access, bundle: bundle)
            }
        }
    }
}

private extension LocalizableMacro {
    static func enumDecl(of declaration: some DeclGroupSyntax) -> EnumDeclSyntax? {
        declaration.memberBlock.members.compactMap {
            $0.decl.as(EnumDeclSyntax.self)
        }.first
    }
    
    static func typeName(of decl: some DeclGroupSyntax) -> String? {
        if let s = decl.as(StructDeclSyntax.self) { return s.name.text }
        if let c = decl.as(ClassDeclSyntax.self) { return c.name.text }
        if let e = decl.as(EnumDeclSyntax.self) { return e.name.text }
        if let a = decl.as(ActorDeclSyntax.self) { return a.name.text }
        if let ext = decl.as(ExtensionDeclSyntax.self) {
            let parts = ext.extendedType.trimmedDescription.split(separator: ".")
            return parts.last.map(String.init)
        }
        return nil
    }
    
    static func accessLevel(of decl: some DeclGroupSyntax) -> String? {
        for modifier in decl.modifiers {
            switch modifier.name.text {
            case "open": return "public"
            case "public": return "public"
            case "private": return "private"
            case "fileprivate": return "fileprivate"
            default: break
            }
        }
        return nil
    }
    
    static func enumCases(of enumDecl: EnumDeclSyntax) -> [EnumCaseElementSyntax] {
        enumDecl.memberBlock.members.flatMap {
            Array($0.decl.as(EnumCaseDeclSyntax.self)?.elements ?? [])
        }
    }
    
    static func bundleArgument(of node: AttributeSyntax) -> String? {
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self),
              let bundle = arguments.first(where: { $0.label?.text == "bundle" })
        else { return nil }
        return bundle.expression.trimmedDescription
    }
    
    static func makeField(from element: EnumCaseElementSyntax, type: String, access: String?, bundle: String?) -> DeclSyntax {
        let accessArg = access.map { "\($0) "} ?? ""
        let bundleArg = bundle.map { ", bundle: \($0)" } ?? ""
        return """
        \(raw: accessArg)static let \(element.name) = String(localized: "\(raw: type).\(element.name)"\(raw: bundleArg))
        """
    }
    
    static func makeFunction(from element: EnumCaseElementSyntax, type: String, access: String?, bundle: String?) -> DeclSyntax {
        let parameterList = element.parameterClause?.parameters ?? []
        let accessArg = access.map { "\($0) "} ?? ""
        let bundleArg = bundle.map { ", bundle: \($0)" } ?? ""
        
        let parameters = makeFunctionParameters(parameterList)
        let arguments  = makeFunctionArguments(parameterList)
        
        return """
        \(raw: accessArg)static func \(element.name)(\(raw: parameters)) -> String {
            String(localized: "\(raw: type).\(element.name) \(raw: arguments)"\(raw: bundleArg))
        }
        """
    }
    
    static func makeFunctionParameters(_ list: EnumCaseParameterListSyntax) -> String {
        list.enumerated().map { idx, p in
            let name = p.firstName?.text ?? "_ value\(idx)"
            let type = p.type.trimmedDescription
            return "\(name): \(type)"
        }.joined(separator: ", ")
    }
    
    static func makeFunctionArguments(_ list: EnumCaseParameterListSyntax) -> String {
        list.enumerated().map { idx, p in
            let name = p.firstName?.text ?? "value\(idx)"
            return "\\(\(name))"
        }.joined(separator: " ")
    }
}

@main
struct LocalizablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [LocalizableMacro.self]
}
