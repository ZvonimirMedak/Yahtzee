//
//  ViewModel.swift
//  Yahtzee
//
//  Created by Zvonimir Medak on 16.03.2021..
//

import Foundation
import RxSwift
import RxCocoa

enum UserInteraction {
    case buttonSelected(at: Int)
    case rollDice
    case reset
}

class ViewModel {
    public var buttonStateRelay: BehaviorRelay<([Int], [Bool])>
    public var userInteractionSubject: PublishSubject<UserInteraction>
    public var rollCounterSubject: PublishSubject<Combination>
    private var rollCounter = 0
    
    public init (buttonStateRelay: BehaviorRelay<([Int], [Bool])>, userInteractionSubject: PublishSubject<UserInteraction>, rollCounterSubject: PublishSubject<Combination>) {
        self.buttonStateRelay = buttonStateRelay
        self.userInteractionSubject = userInteractionSubject
        self.rollCounterSubject = rollCounterSubject
    }
    
    public func initializeViewModel() -> Disposable {
        return initializeUserInteractionObservable(for: userInteractionSubject)
    }
}

private extension ViewModel {
    
    func initializeUserInteractionObservable(for subject: PublishSubject<UserInteraction>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: {[unowned self] (interactionType) in
                handleUserInteractionType(type: interactionType)
            })
    }
    
    func handleUserInteractionType(type: UserInteraction) {
        switch type {
        case .buttonSelected(let index):
            if rollCounter != 0{
                var currentValue = buttonStateRelay.value
                var buttonSelectionValue = currentValue.1
                buttonSelectionValue[index] = !buttonSelectionValue[index]
                currentValue.1 = buttonSelectionValue
                buttonStateRelay.accept(currentValue)
            }
        case .rollDice:
            buttonStateRelay.accept((rollDice(score: buttonStateRelay.value.0, selectedDice: buttonStateRelay.value.1), buttonStateRelay.value.1))
        case .reset:
            rollCounter = 0
            buttonStateRelay.accept(([1, 1, 1, 1, 1, 1], [false, false, false, false, false, false]))
        }
    }
    
    func rollDice(score: [Int], selectedDice: [Bool]) -> [Int] {
        rollCounter = rollCounter + 1
        var newScore: [Int] = []
        for (index, value) in score.enumerated() {
            if selectedDice[index]{
                newScore.append(value)
            }else {
                newScore.append(Int.random(in: 1...6))
            }
        }
        if rollCounter == 3 {
            rollCounterSubject.onNext(checkForCombinations(score: newScore))
        }
        return newScore
    }
}

private extension ViewModel {
    
    func checkForCombinations(score: [Int]) -> Combination {
        if checkForYahtzee(score: score) {
            print(Combination.yahtzee.rawValue)
            return .yahtzee
        }
        else if checkForPoker(score: score) {
            print(Combination.poker.rawValue)
            return .poker
        }
        else if checkForLargeStraight(score: score) {
            print(Combination.largeStraight.rawValue)
            return .largeStraight
        }
        else if checkForSmallStraight(score: score) {
            print(Combination.smallStrainght.rawValue)
            return .smallStrainght
        }
        return .none
        
    }
    
    func checkForLargeStraight(score: [Int]) -> Bool {
        var checkList: [Bool] = []
        if score.contains(2) {
            checkList.append(true)
        }
        if score.contains(3){
            checkList.append(true)
        }
        if score.contains(4) {
            checkList.append(true)
        }
        if score.contains(5){
            checkList.append(true)
        }
        if score.contains(6){
            checkList.append(true)
        }
        return checkList.count == 5
    }
    
    func checkForSmallStraight(score: [Int]) -> Bool {
        var checkList: [Bool] = []
        if score.contains(1){
            checkList.append(true)
        }
        if score.contains(2) {
            checkList.append(true)
        }
        if score.contains(3){
            checkList.append(true)
        }
        if score.contains(4) {
            checkList.append(true)
        }
        if score.contains(5){
            checkList.append(true)
        }
        return checkList.count == 5
    }
    
    func checkForYahtzee(score: [Int]) -> Bool {
        if score.filter({ (num) -> Bool in
            num == 1
        }).count == 5 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 2
        }).count == 5 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 3
        }).count == 5 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 4
        }).count == 5 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 5
        }).count == 5 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 6
        }).count == 5 {
            return true
        }
        return false
    }
    
    func checkForPoker(score: [Int]) -> Bool {
        if score.filter({ (num) -> Bool in
            num == 1
        }).count == 4 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 2
        }).count == 4 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 3
        }).count == 4 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 4
        }).count == 4 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 5
        }).count == 4 {
            return true
        }
        else if score.filter({ (num) -> Bool in
            num == 6
        }).count == 4 {
            return true
        }
        return false
    }
}
