import Foundation
import Combine


class LanguageViewModel: ObservableObject {
    @Published var title: String = "Қош келдіңіз"
    @Published var nextButtonTitle: String = "Келесі бет"
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
    

    func getCurrentLanguage() -> Language {
        return selectedLanguage
    }
    
    func updateTitle() {
        switch selectedLanguage {
        case .english:
            title = "Welcome"
            nextButtonTitle = "Next screen"
        case .russian:
            title = "Добро пожаловать"
            nextButtonTitle = "Следующая страница"
        case .kazakh:
            title = "Қош келдіңіздер"
            nextButtonTitle = "Келесі бет"
        }
    }
}


enum Language {
    case english, russian, kazakh
}

struct Localization {
    
    static let shared = Localization()

    private let englishTexts: [String: String] = [
        "Наименование дисциплины": "Course title",
        "Семестр": "Semester",
        "Индивидуальный учебный план": "Individual curriculum"
    ]

    private let russianTexts: [String: String] = [
        "Наименование дисциплины": "Наименование дисциплины",
        "Семестр": "Семестр",
        "Индивидуальный учебный план": "Индивидуальный учебный план"
    ]

    private let kazakhTexts: [String: String] = [
        "Наименование дисциплины": "Пән атауы",
        "Семестр": "Семестр",
        "Индивидуальный учебный план": "Жеке оқу жоспары"
    ]

    private init() {}

    func localizedText(for key: String, language: Language) -> String {
        switch language {
        case .english:
            return englishTexts[key] ?? key
        case .russian:
            return russianTexts[key] ?? key
        case .kazakh:
            return kazakhTexts[key] ?? key
        }
    }
}
