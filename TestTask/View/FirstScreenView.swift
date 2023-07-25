import UIKit
import SnapKit
import Combine

class FirstScreenViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let nextScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next Screen", for: .normal)
        button.addTarget(self, action: #selector(nextScreenButtonTapped), for: .touchUpInside)
        return button
    }()

    private let languageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Language", for: .normal)
        return button
    }()

    private let viewModel: FirstViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: FirstViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(languageButton)
        view.addSubview(nextScreenButton)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        languageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        nextScreenButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(languageButton.snp.bottom).offset(20)
        }

        languageButton.addTarget(self, action: #selector(languageButtonTapped), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
    }
    
    @objc private func nextScreenButtonTapped() {
        let secondViewController = SecondScreenView()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    @objc private func languageButtonTapped() {
        let alertController = UIAlertController(title: "Change Language", message: "Please select a language", preferredStyle: .actionSheet)

        let englishAction = UIAlertAction(title: "English", style: .default) { [weak self] _ in
            self?.viewModel.selectedLanguage = .english
            self?.viewModel.updateTitle()
        }

        let russianAction = UIAlertAction(title: "Russian", style: .default) { [weak self] _ in
            self?.viewModel.selectedLanguage = .russian
            self?.viewModel.updateTitle()
        }

        let kazakhAction = UIAlertAction(title: "Kazakh", style: .default) { [weak self] _ in
            self?.viewModel.selectedLanguage = .kazakh
            self?.viewModel.updateTitle()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(englishAction)
        alertController.addAction(russianAction)
        alertController.addAction(kazakhAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }
}

