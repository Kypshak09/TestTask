import UIKit
import SnapKit
import Combine

class SecondScreenView: UIViewController {
    let appearance = UINavigationBarAppearance()
    let viewModel = StudentInfoViewModel()
    var segmentedControl: UISegmentedControl?
    let staticLabel = UILabel.createLabel(name: "", fontSize: 18, font: "Arial Bold")
    var labelYear = UILabel.createLabel(name: "", fontSize: 18, font: "Arial Bold")
    var cancellables = Set<AnyCancellable>()
    let myTableView = MyTableView()
    var languageViewModel: LanguageViewModel?
    var semesterText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraint()
        configureNavigationBar()
        bindingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupSegmentedControl()
        bindLanguageViewModel()
        
        if let language = languageViewModel?.selectedLanguage {
            updateTexts(language: language)
        }
        
        if let studentInfo = viewModel.studentInfo {
            self.labelYear.text = "\(studentInfo.academicYear )"
            self.updateSegmentedControl(with: studentInfo.semesters)
            guard let firstSemester = studentInfo.semesters.first else { return }
            self.myTableView.lessonType = firstSemester.disciplines[0].lesson
            self.myTableView.disciplines = firstSemester.disciplines
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
    }
    
    private func configureConstraint() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = .white
        self.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"), style: .plain, target: self, action: #selector(downloadFile))

        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.addSubview(staticLabel)
        containerView.addSubview(labelYear)

        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(90)
            make.width.equalToSuperview()
        }

        staticLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(15)
            make.centerX.equalToSuperview()
        }

        labelYear.snp.makeConstraints { make in
            make.top.equalTo(staticLabel.snp_bottomMargin).offset(5)
            make.centerX.equalToSuperview()
        }

        view.addSubview(myTableView)
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalToSuperview()
        }
    }


    private func configureNavigationBar() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.navigationController?.navigationBar.bounds.height ?? 0)
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            appearance.backgroundImage = image
        }
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
    }
    
    @objc private func downloadFile() {
        guard let documentUrl = viewModel.studentInfo?.documentURL else { return }
        
        let alertController = UIAlertController(title: "Скачать", message: "Хотите скачать файл?", preferredStyle: .alert)
        
        let downloadAction = UIAlertAction(title: "Download", style: .default) { [weak self] _ in
            self?.viewModel.downloadFile(from: documentUrl) { (fileLocation, error) in
                guard let fileLocation = fileLocation, error == nil else {
                    print("Error downloading file: \(error!)")
                    return
                }
                
                
                print("File downloaded to : \(fileLocation)")
            }
        }
        alertController.addAction(downloadAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    private func bindLanguageViewModel() {
        guard let languageViewModel = languageViewModel else { return }
        
        languageViewModel.$selectedLanguage
            .sink { [weak self] language in
                self?.myTableView.language = language
                self?.updateTexts(language: language)
            }
            .store(in: &cancellables)
    }
    
    
    
    private func bindingData() {
        viewModel.$studentInfo
            .sink { studentInfo in
                self.labelYear.text = "\(studentInfo?.academicYear ?? "")"
                self.updateSegmentedControl(with: studentInfo?.semesters)
                guard let firstSemester = studentInfo?.semesters.first else { return }
                self.myTableView.lessonType = firstSemester.disciplines[0].lesson
                self.myTableView.disciplines = firstSemester.disciplines
            }
            .store(in: &cancellables)
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl()
        guard let segmentedControl = segmentedControl else { return }
        segmentedControl.addTarget(self, action: #selector(semesterChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(labelYear.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(40)
        }
        
        segmentedControl.isEnabled = true

    }
    
    private func updateSegmentedControl(with semesters: [Semester]?) {
        guard let segmentedControl = segmentedControl, let semesters = semesters else { return }
        
        segmentedControl.removeAllSegments()
        
        for (index, semester) in semesters.enumerated() {
            segmentedControl.insertSegment(withTitle: "\(semesterText) \(semester.number)", at: index, animated: false)
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func updateTexts(language: Language) {
        let transitionOptions: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction]
        UIView.transition(with: self.view, duration: 0.5, options: transitionOptions, animations: {
            self.title = Localization.shared.localizedText(for: "Индивидуальный учебный план", language: language)
            self.staticLabel.text = Localization.shared.localizedText(for: "Индивидуальный учебный план", language: language)
            self.semesterText = Localization.shared.localizedText(for: "Семестр", language: language)
            if let segments = self.segmentedControl?.numberOfSegments {
                for i in 0..<segments {
                    let segmentTitle = self.segmentedControl?.titleForSegment(at: i) ?? ""
                    let translatedTitle = Localization.shared.localizedText(for: segmentTitle, language: language)
                    self.segmentedControl?.setTitle(translatedTitle, forSegmentAt: i)
                }
            }
        })
    }


    
    @objc func semesterChanged(_ sender: UISegmentedControl) {
        let selectedSemesterIndex = sender.selectedSegmentIndex
        guard let studentInfo = viewModel.studentInfo else { return }
        
        
        guard selectedSemesterIndex < studentInfo.semesters.count else { return }
        
        let selectedSemester = studentInfo.semesters[selectedSemesterIndex]
        self.myTableView.lessonType = selectedSemester.disciplines[0].lesson
        self.myTableView.disciplines = selectedSemester.disciplines
    }
}
