//
//  SetupTimerView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

protocol ButtonActions: AnyObject {
    func startNextButtonAction(with data: (workTime: String,
                                           restTime: String,
                                           repeats: Int,
                                           cycles: Int)?)
    func addMusicButtonAction()
}

enum TextFieldType {
    case work
    case rest
    case none
}

final class SetupTimerView: UIView {
    
    
    weak var buttonActionsDelegate: ButtonActions?
    private var activeTF: UITextField?
    
    private var isFieldsCorrect = false {
        didSet {
            setStartButtonAppearance(for: isFieldsCorrect)
        }
    }
    
    private var isUniqueCycles = false
 
    public var getActiveTFType: TextFieldType {
        if activeTF == workTF {
            return .work
        } else if activeTF == restTF {
            return .rest
        }
        return .none
    }
    
    private let backward = UIImage(systemName: "chevron.backward")!
    private let forward = UIImage(systemName: "chevron.forward")!
    private let workPicker = UIPickerView()
    private let restPicker = UIPickerView()
    private let workTF = UITextField(text: "00:00", width: 70)
    private let restTF = UITextField(text: "00:00", width: 70)
    private let repeatTF = UITextField(text: "0", width: 70, isEnabled: false)
    private let cyclesTF = UITextField(text: "1", width: 70, isEnabled: false)
    private let workTimeLabel = UILabel(text: "Work time", fontSize: 22)
    private let restTimeLabel = UILabel(text: "Rest time", fontSize: 22)
    private let repeatCountLabel = UILabel(text: "Repeat count", fontSize: 22)
    private let cyclesCountLabel = UILabel(text: "Cycles count", fontSize: 22)
    private let isUniqueCyclesLabel = UILabel(text: "Unique cycles?", fontSize: 22)
    private lazy var repeatDownButton = UIButton(backgroundImage: backward, width: 20)
    private lazy var repeatUpButton = UIButton(backgroundImage: forward, width: 20)
    private lazy var cyclesDownButton = UIButton(backgroundImage: backward, width: 20)
    private lazy var cyclesUpButton = UIButton(backgroundImage: forward, width: 20)
    
    private lazy var workStackView = UIStackView(arrangedSubviews: [workTimeLabel,
                                                                    workTF,
                                                                    spacer],
                                                 spacing: 8,
                                                 axis: .horizontal)
    
    private lazy var restStackView = UIStackView(arrangedSubviews: [restTimeLabel,
                                                                    restTF,
                                                                    spacer],
                                                 spacing: 8,
                                                 axis: .horizontal)
    
    private lazy var repeatStackView = UIStackView(arrangedSubviews: [repeatCountLabel,
                                                                      repeatDownButton,
                                                                      repeatTF,
                                                                      repeatUpButton],
                                                   spacing: 8,
                                                   axis: .horizontal)
    
    private lazy var cyclesStackView = UIStackView(arrangedSubviews: [cyclesCountLabel,
                                                                      cyclesDownButton,
                                                                      cyclesTF,
                                                                      cyclesUpButton],
                                                   spacing: 8,
                                                   axis: .horizontal)
    
    private lazy var mainStackView = UIStackView( arrangedSubviews: [workStackView,
                                                                     restStackView,
                                                                     repeatStackView,
                                                                     cyclesStackView],
                                                  spacing: 20,
                                                  axis: .vertical)
    private lazy var isUniqueStackView = UIStackView(arrangedSubviews: [isUniqueCyclesLabel,
                                                                        isUniqueSwitcher],
                                                     spacing: 20,
                                                     axis: .horizontal)
    
    private let isUniqueSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.tintColor = .systemGreen
        return switcher
    }()
    
    private var spacer: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }
    
    private let startNextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addMusicButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("Add music", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        setConstraints()
        addActions()
        setupDelegates()
        
    }
    
    private func setupDelegates() {
        workPicker.dataSource = self
        restPicker.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(startNextButton)
        addSubview(addMusicButton)
        addSubview(mainStackView)
        addSubview(isUniqueStackView)
    }
    
    private func addActions() {
        startNextButton.addTarget(self,
                                  action: #selector(startNextButtonPressed),
                                  for: .touchUpInside)
        addMusicButton.addTarget(self,
                                 action: #selector(addMusicButtonPressed),
                                 for: .touchUpInside)
        repeatDownButton.addTarget(self,
                                   action: #selector(repeatDownButtonPressed),
                                   for: .touchUpInside)
        repeatUpButton.addTarget(self,
                                   action: #selector(repeatUpButtonPressed),
                                   for: .touchUpInside)
        cyclesDownButton.addTarget(self,
                                   action: #selector(cyclesDownButtonPressed),
                                   for: .touchUpInside)
        cyclesUpButton.addTarget(self,
                                   action: #selector(cyclesUpButtonPressed),
                                   for: .touchUpInside)
        isUniqueSwitcher.addTarget(self,
                                   action: #selector(isUniqueSwitcherChanged),
                                   for: .valueChanged)
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(viewDidTap))
        self.addGestureRecognizer(recognizer)
        
        workTF.inputView = workPicker
        workTF.delegate = self
        restTF.inputView = restPicker
        restTF.delegate = self
    }
    
    @objc func viewDidTap() {
        self.endEditing(true)
    }
    
    public func setPickerViewDelegate(_ delegate: UIPickerViewDelegate) {
        workPicker.delegate = delegate
        restPicker.delegate = delegate
    }
    
    public func setWork(time: String) {
        workTF.text = time
    }
    
    public func setRest(time: String) {
        restTF.text = time
    }
    
    public func checkCorrectFields(isCorrect: Bool) {
        isFieldsCorrect = isCorrect
    }
    
    @objc private func isUniqueSwitcherChanged() {
        isUniqueCycles = isUniqueSwitcher.isOn
    }
    
    @objc private func repeatDownButtonPressed() {
        guard let text = repeatTF.text, let count = Int(text), count > 0 else { return }
        let newCount = count - 1
        repeatTF.text = String(newCount)
    }
    
    @objc private func repeatUpButtonPressed() {
        guard let text = repeatTF.text, let count = Int(text), count < 60 else { return }
        let newCount = count + 1
        repeatTF.text = String(newCount)
    }
    
    @objc private func cyclesDownButtonPressed() {
        guard let text = cyclesTF.text, let count = Int(text), count > 1 else { return }
        let newCount = count - 1
        cyclesTF.text = String(newCount)
    }
    
    @objc private func cyclesUpButtonPressed() {
        guard let text = cyclesTF.text, let count = Int(text), count < 60 else { return }
        let newCount = count + 1
        cyclesTF.text = String(newCount)
    }
    
    private func getDataFromFields() -> (workTime: String,
                                         restTime: String,
                                         repeats: Int,
                                         cycles: Int)? {
        guard let workTime = workTF.text else {
            print("Error while getting workTime in SetupTimerView.getDataFromFields")
            return nil
        }
        guard let restTime = restTF.text else {
            print("Error while getting restTime in SetupTimerView.getDataFromFields")
            return nil
        }
        guard let text = repeatTF.text, let repeats = Int(text) else {
            print("Error while getting repeat count in SetupTimerView.getDataFromFields")
            return nil
        }
        guard let text = cyclesTF.text, let cycles = Int(text) else {
            print("Error while getting cycles count in SetupTimerView.getDataFromFields")
            return nil
        }
        return (workTime: workTime,
                restTime: restTime,
                repeats: repeats,
                cycles: cycles)
    }
    
    @objc private func startNextButtonPressed() {
        buttonActionsDelegate?.startNextButtonAction(with: getDataFromFields())
    }
    
    @objc private func addMusicButtonPressed() {
        buttonActionsDelegate?.addMusicButtonAction()
    }
    
    private func setStartButtonAppearance(for state: Bool) {
        if state {
            startNextButton.backgroundColor = .systemGreen
            startNextButton.setTitleColor(.white, for: .normal)
        } else {
            startNextButton.backgroundColor = .white
            startNextButton.setTitleColor(.lightGray, for: .normal)
        }
        startNextButton.isEnabled = state
    }
    
    private func setConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        isUniqueStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            mainStackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            
            isUniqueStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 32),
            isUniqueStackView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor, constant: 32),
            isUniqueStackView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor, constant: -32),
            
            addMusicButton.bottomAnchor.constraint(equalTo: startNextButton.topAnchor, constant: -16),
            addMusicButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            addMusicButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            addMusicButton.heightAnchor.constraint(equalToConstant: 50),
            
            startNextButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            startNextButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            startNextButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            startNextButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
}

extension SetupTimerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
}

extension SetupTimerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTF = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTF == textField {
            activeTF = nil
        }
    }
}
