import UIKit

final class RentalViewController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let rentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5.0
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()

    private let stateMachine: RentalStateMachineType

    init(stateMachine: RentalStateMachineType) {
        self.stateMachine = stateMachine
        super.init(nibName: nil, bundle: nil)
        stateMachine.updateHandler = self
        stateMachine.activate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(label)

        rentButton.addTarget(self, action: #selector(rentButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(rentButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),

            rentButton.heightAnchor.constraint(equalToConstant: 30),
            rentButton.widthAnchor.constraint(equalToConstant: 100),
            rentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            rentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc
    private func rentButtonTapped(_ sender: UIControl) {
        stateMachine.handle(.rentalButtonTap)
    }
}

// MARK: State Machine UI Update Handlers
extension RentalViewController: RentalUIUpdateHandlerType {
    func apply(_ update: RentalUIUpdate) {
        switch update {
        case .rentalStatusText(let text):
            updateLabel(text: text)
        case .buttonTitle(let title):
            updateButton(title: title)
        }
    }

    private func updateLabel(text: String) {
        label.text = text
    }

    private func updateButton(title: String) {
        rentButton.setTitle(title, for: .normal)
    }
}
