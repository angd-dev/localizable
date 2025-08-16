import Foundation

/// Generates type-safe localized strings from enum cases.
///
/// - Parameter bundle:
///   Optional `Bundle` used to resolve localized strings.
///
/// Enum cases without associated values become `static let`
/// constants. Cases with associated values become `static func`
/// methods that interpolate arguments. If a String Catalog is
/// used, each key is automatically added to the catalog. By
/// default, the main bundle is used to resolve strings.
///
/// ```swift
/// import Localizable
///
/// extension String {
///     @Localizable enum Login {
///         private enum Strings {
///             case welcome
///             case title(String)
///             case message(msg1: String, msg2: Int)
///         }
///     }
/// }
/// ```
///
/// Expands to members of `String.Login`:
///
/// ```swift
/// static let welcome = String(localized: "Login.welcome")
///
/// static func title(_ value0: String) -> String {
///     String(localized: "Login.title \(value0)")
/// }
///
/// static func message(msg1: String, msg2: Int) -> String {
///     String(localized: "Login.message \(msg1) \(msg2)")
/// }
/// ```
@attached(member, names: arbitrary)
public macro Localizable(bundle: Bundle? = nil) = #externalMacro(
    module: "LocalizableMacros",
    type: "LocalizableMacro"
)
