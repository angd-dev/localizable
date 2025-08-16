import Foundation
import Localizable

extension String {
    @Localizable enum Login {
        private enum Strings {
            case welcome
            case title(String)
            case message(msg1: String, msg2: Int)
        }
    }
}

extension String {
    @Localizable(bundle: .main)
    enum Account {
        private enum Strings {
            case title
        }
    }
}

print(String.Login.welcome)
