//
//  ViewController.swift
//  Yahtzee
//
//  Created by Zvonimir Medak on 16.03.2021..
//

import SnapKit
import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel: ViewModel
    
    let firstDie: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "one"), for: .normal)
        return button
    }()
    
    let secondDie: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "one"), for: .normal)
        return button
    }()
    
    let thirdDie: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "one"), for: .normal)
        return button
    }()
    
    let fourthDie: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "one"), for: .normal)
        return button
    }()
    
    let fifthDie: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "one"), for: .normal)
        return button
    }()
    
    let sixthDie: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "one"), for: .normal)
        return button
    }()
    
    let rollButton: UIButton = {
        let button = UIButton()
        button.setTitle("ROLL", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupInteraction()
        initializeVM()
    }
}

private extension ViewController {
    
    func setupUI() {
        view.addSubviews(firstDie, secondDie, thirdDie, fourthDie, fifthDie, sixthDie, rollButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        fifthDie.snp.makeConstraints { (maker) in
            maker.top.equalTo(firstDie.snp.bottom).inset(-10)
            maker.height.width.equalTo(40)
            maker.centerX.equalToSuperview()
        }
        
        firstDie.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(view.snp.centerY).inset(-10)
            maker.trailing.equalTo(secondDie.snp.leading).inset(-10)
            maker.height.width.equalTo(40)
        }
        
        secondDie.snp.makeConstraints { (maker) in
            maker.top.equalTo(firstDie)
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(40)
        }
        
        thirdDie.snp.makeConstraints { (maker) in
            maker.leading.equalTo(secondDie.snp.trailing).inset(-10)
            maker.top.equalTo(firstDie)
            maker.height.width.equalTo(40)
        }
        
        fourthDie.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(fifthDie.snp.leading).inset(-10)
            maker.top.equalTo(fifthDie)
            maker.height.width.equalTo(40)
        }
        
        sixthDie.snp.makeConstraints { (maker) in
            maker.leading.equalTo(fifthDie.snp.trailing).inset(-10)
            maker.width.height.equalTo(40)
            maker.top.equalTo(fifthDie)
        }
        
        rollButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(fifthDie.snp.bottom).inset(-10)
        }
    }
    
    func initializeVM() {
        viewModel.initializeViewModel().disposed(by: disposeBag)
        initializeButtonStateObservable(for: viewModel.buttonStateRelay).disposed(by: disposeBag)
        initializeRollCounterObservable(for: viewModel.rollCounterSubject).disposed(by: disposeBag)
    }
    
    func initializeButtonStateObservable(for subject: BehaviorRelay<([Int], [Bool])>) -> Disposable {
        return subject
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] (items) in
                self.changeImagesForScore(score: items.0, isSelected: items.1)
            })
    }
    
    func initializeRollCounterObservable(for subject: PublishSubject<Combination>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: {[unowned self] (type) in
                showWhatWasWon(combination: type)
            })
    }
    
    func setupInteraction() {
        
        firstDie.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.buttonSelected(at: 0))
            })
            .disposed(by: disposeBag)
        secondDie.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.buttonSelected(at: 1))
            })
            .disposed(by: disposeBag)
        thirdDie.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.buttonSelected(at: 2))
            })
            .disposed(by: disposeBag)
        fourthDie.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.buttonSelected(at: 3))
            })
            .disposed(by: disposeBag)
        fifthDie.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.buttonSelected(at: 4))
            })
            .disposed(by: disposeBag)
        sixthDie.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.buttonSelected(at: 5))
            })
            .disposed(by: disposeBag)
        rollButton.rx.tap
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.rollDice)
            })
            .disposed(by: disposeBag)
    }
}

private extension ViewController {
    func showWhatWasWon(combination: Combination) {
        var wonTitle = "You got: "
        switch combination {
        case .yahtzee:
            wonTitle.append("YAHTZEE!!!")
        case .largeStraight:
            wonTitle.append("Large Straight")
        case .smallStrainght:
            wonTitle.append("Small Straight")
        case .poker:
            wonTitle.append("Poker")
        case .none:
            wonTitle.append("NOTHING")
        }
        let handler: ((UIAlertAction) -> Void) = { [unowned self] (_) in
            viewModel.userInteractionSubject.onNext(.reset)
        }
        showAlertController(message: wonTitle, handler: handler)
    }
    
    func changeImagesForScore(score: [Int], isSelected: [Bool]) {
        for (index, number) in score.enumerated() {
            let die = getDie(index: index)
            switch number {
            case 1:
                if isSelected[index] {
                    die.setBackgroundImage(UIImage(named: "one_selected"), for: .normal)
                }else {
                    die.setBackgroundImage(UIImage(named: "one"), for: .normal)
                }
                
            case 2:
                if isSelected[index] {
                    die.setBackgroundImage(UIImage(named: "two_selected"), for: .normal)
                }else {
                    die.setBackgroundImage(UIImage(named: "two"), for: .normal)
                }
            case 3:
                if isSelected[index] {
                    die.setBackgroundImage(UIImage(named: "three_selected"), for: .normal)
                }else {
                    die.setBackgroundImage(UIImage(named: "three"), for: .normal)
                }
                
            case 4:
                if isSelected[index] {
                    die.setBackgroundImage(UIImage(named: "four_selected"), for: .normal)
                }else {
                    die.setBackgroundImage(UIImage(named: "four"), for: .normal)
                }
                
            case 5:
                if isSelected[index] {
                    die.setBackgroundImage(UIImage(named: "five_selected"), for: .normal)
                }else {
                    die.setBackgroundImage(UIImage(named: "five"), for: .normal)
                }
                
            default:
                if isSelected[index] {
                    die.setBackgroundImage(UIImage(named: "six_selected"), for: .normal)
                }else {
                    die.setBackgroundImage(UIImage(named: "six"), for: .normal)
                }
                
            }
        }
        
    }
    
    func getDie(index: Int) -> UIButton {
        switch index {
        case 0:
            return firstDie
        case 1:
            return secondDie
        case 2:
            return thirdDie
        case 3:
            return fourthDie
        case 4:
            return fifthDie
        default:
            return sixthDie
        }
    }
}
