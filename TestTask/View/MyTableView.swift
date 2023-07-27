import UIKit
import SnapKit

class MyTableView: UIStackView {
    var language: Language? {
        didSet {
            updateLabels()
            updateDisciplineLabels()
            updateFirstLabel()
        }
    }
    
    var lessonType: [Lesson]? = [] {
        didSet {
            updateLabels()
        }
    }
    
    var disciplines: [DisciplineTest]? = [] {
        didSet {
            updateDisciplineLabels()
            updateDisciplineLabelsCells()
        }
    }
    
    private var lessonLabels: [UILabel] = []
    private var disciplineLabels: [UILabel] = []
    private var disciplineGridLabels: [[UILabel]] = []
    private var firstLabel: UILabel? = nil
    private var lessonHourLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.axis = .vertical
        
        let backgroundView = UIView()
        self.addArrangedSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        backgroundView.backgroundColor = .systemGray6
        
        
        backgroundView.addSubview(lessonHourLabel)
        lessonHourLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        
        // 1x4 Table
        let table1x4 = UIView()
        let ratios = [0.4, 0.2, 0.2, 0.2]
        for i in 0..<4 {
            let label = UILabel()
            label.backgroundColor = .white
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = .lightGray
            label.backgroundColor = .systemGray6
            table1x4.addSubview(label)
            applyBorder(to: label)
            label.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(ratios[i])
                if i == 0 {
                    make.leading.equalToSuperview()
                    label.text = "Наименование дисциплинны"
                    firstLabel = label
                } else {
                    make.leading.equalTo(table1x4.subviews[i - 1].snp.trailing)
                    lessonLabels.append(label)
                    label.numberOfLines = 1
                }
            }
        }
        
        
        
        self.addArrangedSubview(table1x4)
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        self.addArrangedSubview(horizontalStackView)
        
        // 3x1 Table
        let table3x1 = UIView()
        for i in 0..<3 {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.backgroundColor = .systemGray6
            label.textColor = .black
            table3x1.addSubview(label)
            disciplineLabels.append(label)
            applyBorder(to: label)
            label.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalToSuperview().dividedBy(3)
                
                if i == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(table3x1.subviews[i - 1].snp.bottom)
                }
            }
        }
        horizontalStackView.addArrangedSubview(table3x1)
        
        table3x1.snp.makeConstraints { (make) in
                make.width.equalTo(firstLabel!.snp.width)
            }
        
        // 3x3 Table
        let table3x3 = UIView()
        for i in 0..<3 {
            var rowLabels: [UILabel] = []
            for j in 0..<3 {
                let label = UILabel()
                label.backgroundColor = .white
                label.textAlignment = .center
                label.backgroundColor = .systemGray6
                table3x3.addSubview(label)
                rowLabels.append(label)
                applyBorder(to: label)
                label.snp.makeConstraints { (make) in
                    make.width.equalToSuperview().dividedBy(3)
                    make.height.equalToSuperview().dividedBy(3)
                    if j == 0 {
                        make.leading.equalToSuperview()
                    } else {
                        make.leading.equalTo(table3x3.subviews[j - 1].snp.trailing)
                    }
                    if i == 0 {
                        make.top.equalToSuperview()
                    } else {
                        make.top.equalTo(table3x3.subviews[(i - 1) * 3 + j].snp.bottom)
                    }
                }
            }
            disciplineGridLabels.append(rowLabels)
        }
        horizontalStackView.addArrangedSubview(table3x3)
    }
    
    private func updateLabels() {
        guard let lessonType = lessonType else { return }
        for (index, lesson) in lessonType.enumerated() {
            if index < lessonLabels.count {
                lessonLabels[index].text = lessonTypeName(lessonTypeID: lesson.lessonTypeID)
            }
        }
    }
    
    private func lessonTypeName(lessonTypeID: String) -> String {
        switch lessonTypeID {
        case "1":
            switch language {
            case .russian:
                return "Лекция"
            case .english:
                return "Lecture"
            case .kazakh:
                return "Дәріс"
            default:
                return "Lecture"
            }
        case "2":
            switch language {
            case .russian:
                return "Семинар"
            case .english:
                return "Seminar"
            case .kazakh:
                return "Семинар"
            default:
                return "Seminar"
            }
        case "3":
            switch language {
            case .russian:
                return "Лаборатория"
            case .english:
                return "Lab"
            case .kazakh:
                return "Зерт"
            default:
                return "Lab"
            }
        default:
            return "Unknown"
        }
    }
    
    func updateFirstLabel() {
        switch language {
        case .russian:
            firstLabel?.text = "Наименование дисциплинны"
            lessonHourLabel.text = "Аудитория занятия в часах"
        case .english:
            firstLabel?.text = "Discipline Name"
            lessonHourLabel.text = "Classroom classes(in hours)"
        case .kazakh:
            firstLabel?.text = "Пән атауы"
            lessonHourLabel.text = "Аудиториялық сабақтар(сағат)"
        default:
            break
        }
    }

    
    private func updateDisciplineLabels() {
            guard let disciplines = disciplines else { return }
            for (index, discipline) in disciplines.enumerated() {
                if index < disciplineLabels.count {
                    switch language {
                    case .russian:
                        disciplineLabels[index].text = discipline.disciplineName.nameRu
                    case .english:
                        disciplineLabels[index].text = discipline.disciplineName.nameEn
                    case .kazakh:
                        disciplineLabels[index].text = discipline.disciplineName.nameKk
                    default:
                        break
                    }
                    
                }
            }
        }
    
    private func applyBorder(to label: UILabel) {
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.clipsToBounds = true
    }
    
    private func updateDisciplineLabelsCells() {
        guard let disciplines = disciplines else { return }
        for (i, discipline) in disciplines.enumerated() {
            for (j, lesson) in discipline.lesson.enumerated() {
                if i < disciplineGridLabels.count && j < disciplineGridLabels[i].count {
                    let label = disciplineGridLabels[i][j]
                    if lesson.realHours.isEmpty {
                        label.text = ""
                    } else {
                        let realHoursPart = NSMutableAttributedString(string: lesson.realHours, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
                        let hoursPart = NSMutableAttributedString(string: "/" + lesson.hours, attributes: [NSAttributedString.Key.foregroundColor: lesson.hours == lesson.realHours ? UIColor.systemGreen : UIColor.systemRed])
                        realHoursPart.append(hoursPart)
                        label.attributedText = realHoursPart
                    }
                }
            }
        }
    }
}
