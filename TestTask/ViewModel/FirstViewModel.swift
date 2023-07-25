import Foundation
import Combine


class FirstViewModel: ObservableObject {
    @Published var title: String = "Қош келдіңіз"
    @Published var selectedLanguage: Language = .kazakh

    func toggleLanguage() {
        switch selectedLanguage {
        case .english:
            selectedLanguage = .russian
        case .russian:
            selectedLanguage = .kazakh
        case .kazakh:
            selectedLanguage = .english
        }
        updateTitle()
    }

    func updateTitle() {
        switch selectedLanguage {
        case .english:
            title = "Welcome"
        case .russian:
            title = "Добро пожаловать"
        case .kazakh:
            title = "Қош келдіңіздер"
        }
    }
}


enum Language {
    case english, russian, kazakh
}
