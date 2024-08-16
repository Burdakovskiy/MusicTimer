//
//  TimerView.swift
//  MusicIntervalTimer
//
//  Created by Дмитрий on 03.08.2024.
//

import UIKit

protocol AudioButtonActions: AnyObject {
    func shuffleButtonAction()
    func repeatButtonAction()
    func stopPlayButtonAction()
    func backwardButtonAction()
    func forwardButtonAction()
}

final class TimerView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    private var timerAnimationDuration = 0
    private var isAudioViewExpanded = false
    private var audioViewHeightConstraint: NSLayoutConstraint!
    private var tableViewTopConstraint: NSLayoutConstraint!
    weak var audioButtonActionsDelegate: AudioButtonActions?
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 72, weight: .bold)
        label.text = "3"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let audioNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let audioView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let audioViewShrinkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let circularImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "oval")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stopPlayButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shuffleButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "shuffle"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let repeatButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timerTableView: UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var audioPlayerBarStackView = UIStackView(arrangedSubviews: [backwardButton,
                                                                      stopPlayButton,
                                                                      forwardButton],
                                                   spacing: 30,
                                                   axis: .horizontal,
                                                   distribution: .fillEqually)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        setConstraints()
        setupActions()
    }
    
    private func setupActions() {
        audioViewShrinkButton.addTarget(self, action: #selector(didTapShrinkButton), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(shuffleButtonPressed), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(repeatButtonPressed), for: .touchUpInside)
        stopPlayButton.addTarget(self, action: #selector(stopPlayButtonPressed), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(backwardButtonPressed), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonPressed), for: .touchUpInside)
    }
    
    @objc private func repeatButtonPressed() {
        audioButtonActionsDelegate?.repeatButtonAction()
    }
    
    @objc private func shuffleButtonPressed() {
        audioButtonActionsDelegate?.shuffleButtonAction()
    }
    
    @objc private func stopPlayButtonPressed() {
        audioButtonActionsDelegate?.stopPlayButtonAction()
    }
    
    @objc private func backwardButtonPressed() {
        audioButtonActionsDelegate?.backwardButtonAction()
    }
    
    @objc private func forwardButtonPressed() {
        audioButtonActionsDelegate?.forwardButtonAction()
    }
    
    public func configureTrackInfo(with track: String) {
        audioNameLabel.text = track
    }
    
    public func updateIsShufflingButtonAppearence(with state: Bool) {
        if state {
            shuffleButton.tintColor = .purple
        } else {
            shuffleButton.tintColor = .black
        }
    }
    
    public func updateIsPlayingButtonAppearence(with state: Bool) {
        if state {
            stopPlayButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            stopPlayButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    public func updateIsRepeatingButtonAppearence(with state: Bool) {
        if state {
            repeatButton.tintColor = .purple
        } else {
            repeatButton.tintColor = .black
        }
    }
    
    public func hideAudioView() {
        audioView.isHidden = true
        audioViewHeightConstraint.constant = 0
        tableViewTopConstraint = timerTableView.topAnchor.constraint(equalTo: circularImage.bottomAnchor)
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapShrinkButton() {
        toggleAudioView()
    }
    
    private func toggleAudioView() {
        isAudioViewExpanded.toggle()
        audioViewHeightConstraint.constant = isAudioViewExpanded ? 90 : 40
        
        updateIsHiddenAudioBar(with: isAudioViewExpanded)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func addViews() {
        addSubview(circularImage)
        addSubview(audioView)
        addSubview(timerTableView)
        addSubview(timerLabel)
        addSubview(audioNameLabel)
        audioView.addSubview(audioPlayerBarStackView)
        audioView.addSubview(shuffleButton)
        audioView.addSubview(repeatButton)
        audioView.addSubview(audioViewShrinkButton)
        
        updateIsHiddenAudioBar(with: isAudioViewExpanded)
    }
    
    private func updateIsHiddenAudioBar(with state: Bool) {
        audioPlayerBarStackView.isHidden = !state
        shuffleButton.isHidden = !state
        repeatButton.isHidden = !state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        circularAnimation()
    }
    
    private func circularAnimation() {
        
        let center = CGPoint(x: circularImage.frame.width / 2,
                             y: circularImage.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 116,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 13.5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = AppColors.mainPurple.cgColor
        circularImage.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 0
        animation.duration = CFTimeInterval(timerAnimationDuration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
    
    public func updateTimerLabel(with time: Int, and color: UIColor = .red) {
        timerLabel.text = String(time)
        timerLabel.textColor = color
    }
    
    public func startBasicAnimation() {
        basicAnimation()
    }
    
    public func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        timerTableView.delegate = delegate
    }
    
    public func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        timerTableView.dataSource = dataSource
    }
    
    public func reloadData() {
        timerTableView.reloadData()
    }
    
    public func scrollTo(row: IndexPath) {
        timerTableView.scrollToRow(at: row, at: .bottom, animated: true)
    }
    
    public func setTimerAnimation(duration: Int) {
        timerAnimationDuration = duration
    }
    
    private func setConstraints() {
        audioPlayerBarStackView.translatesAutoresizingMaskIntoConstraints = false
        audioViewHeightConstraint = audioView.heightAnchor.constraint(equalToConstant: 40)
        tableViewTopConstraint = timerTableView.topAnchor.constraint(equalTo: audioView.bottomAnchor, constant: 16)
        NSLayoutConstraint.activate([
            circularImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circularImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            circularImage.heightAnchor.constraint(equalToConstant: 250),
            circularImage.widthAnchor.constraint(equalToConstant: 250),
            
            timerLabel.centerXAnchor.constraint(equalTo: circularImage.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: circularImage.centerYAnchor),
            
            audioView.topAnchor.constraint(equalTo: circularImage.bottomAnchor, constant: 16),
            audioView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            audioView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            audioViewHeightConstraint,
            
            audioNameLabel.topAnchor.constraint(equalTo: audioView.topAnchor, constant: 5),
            audioNameLabel.leftAnchor.constraint(equalTo: audioView.leftAnchor, constant: 16),
            audioNameLabel.rightAnchor.constraint(equalTo: audioViewShrinkButton.leftAnchor, constant: -16),
            audioNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            audioViewShrinkButton.centerYAnchor.constraint(equalTo: audioNameLabel.centerYAnchor),
            audioViewShrinkButton.rightAnchor.constraint(equalTo: audioView.rightAnchor, constant: -16),
            audioViewShrinkButton.widthAnchor.constraint(equalToConstant: 25),
            audioViewShrinkButton.heightAnchor.constraint(equalToConstant: 25),
            
            audioPlayerBarStackView.topAnchor.constraint(equalTo: audioNameLabel.bottomAnchor, constant: 2),
            audioPlayerBarStackView.leftAnchor.constraint(equalTo: audioView.leftAnchor, constant: 90),
            audioPlayerBarStackView.rightAnchor.constraint(equalTo: audioView.rightAnchor, constant: -90),
            audioPlayerBarStackView.bottomAnchor.constraint(equalTo: audioView.bottomAnchor, constant: -5),
            
            shuffleButton.centerYAnchor.constraint(equalTo: audioPlayerBarStackView.centerYAnchor),
            shuffleButton.rightAnchor.constraint(equalTo: audioPlayerBarStackView.leftAnchor, constant: -16),
            shuffleButton.widthAnchor.constraint(equalToConstant: 35),
            shuffleButton.heightAnchor.constraint(equalToConstant: 35),
            
            repeatButton.centerYAnchor.constraint(equalTo: audioPlayerBarStackView.centerYAnchor),
            repeatButton.leftAnchor.constraint(equalTo: audioPlayerBarStackView.rightAnchor, constant: 16),
            repeatButton.widthAnchor.constraint(equalToConstant: 35),
            repeatButton.heightAnchor.constraint(equalToConstant: 35),
            
            tableViewTopConstraint,
            timerTableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 32),
            timerTableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -32),
            timerTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
