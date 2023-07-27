import Foundation

// MARK: - StudentInfo
struct StudentInfo: Codable {
    let iupSid, title, documentURL, academicYearID: String
    let academicYear: String
    let semesters: [Semester]

    enum CodingKeys: String, CodingKey {
        case iupSid = "IUPSid"
        case title = "Title"
        case documentURL = "DocumentURL"
        case academicYearID = "AcademicYearId"
        case academicYear = "AcademicYear"
        case semesters = "Semesters"
    }
}

// MARK: - Semester
struct Semester: Codable {
    let number: String
    let disciplines: [DisciplineTest]

    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case disciplines = "Disciplines"
    }
}

// MARK: - Discipline
struct DisciplineTest: Codable {
    let disciplineID: String
    let disciplineName: DisciplineName
    let lesson: [Lesson]

    enum CodingKeys: String, CodingKey {
        case disciplineID = "DisciplineId"
        case disciplineName = "DisciplineName"
        case lesson = "Lesson"
    }
}

// MARK: - DisciplineName
struct DisciplineName: Codable {
    let nameKk, nameRu, nameEn: String
}

// MARK: - Lesson
struct Lesson: Codable {
    let lessonTypeID, hours, realHours: String

    enum CodingKeys: String, CodingKey {
        case lessonTypeID = "LessonTypeId"
        case hours = "Hours"
        case realHours = "RealHours"
    }
}
