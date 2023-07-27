import UIKit
import SnapKit
import Combine

class FirstScreenViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let testTaskLabel = UILabel()
    private let nextScreenButton = UIButton(type: .system)
    private let languageButton = UIButton(type: .system)
    
    private let viewModel: LanguageViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LanguageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUIComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUIComponents() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        testTaskLabel.textAlignment = .center
        testTaskLabel.text = "Table TeskTask"
        testTaskLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        nextScreenButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextScreenButton.tintColor = .white
        nextScreenButton.backgroundColor = .black
        nextScreenButton.layer.cornerRadius = 25
        nextScreenButton.addTarget(self, action: #selector(nextScreenButtonTapped), for: .touchUpInside)
        
        languageButton.setTitle("Change Language", for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        view.addSubview(titleLabel)
        view.addSubview(testTaskLabel)
        view.addSubview(languageButton)
        view.addSubview(nextScreenButton)
        
        layoutUIComponents()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "a.square.fill"), style: .plain, target: self, action: #selector(languageButtonTapped))
    }
    
    private func layoutUIComponents() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        testTaskLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
        
        nextScreenButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func bindViewModel() {
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
        
        viewModel.$nextButtonTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nextButtonTitle in
                self?.nextScreenButton.setTitle(nextButtonTitle, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc private func nextScreenButtonTapped() {
        let secondViewController = SecondScreenView()
        secondViewController.languageViewModel = viewModel
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @objc private func languageButtonTapped() {
        let alertController = UIAlertController(title: "Change Language", message: "Please select a language", preferredStyle: .actionSheet)
        
        alertController.addAction(createAlertAction(title: "English", language: .english))
        alertController.addAction(createAlertAction(title: "Русский", language: .russian))
        alertController.addAction(createAlertAction(title: "Қазақ", language: .kazakh))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    private func createAlertAction(title: String, language: Language) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            self?.viewModel.selectedLanguage = language
            self?.viewModel.updateTitle()
        }
    }
}
