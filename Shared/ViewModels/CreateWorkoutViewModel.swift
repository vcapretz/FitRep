//
//  CreateChallengeViewModel.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-09.
//

import SwiftUI
import Combine

typealias UserId = String

final class CreateWorkoutViewModel: ObservableObject {
    @Published var exercises: [ExerciseViewModel] = [
        .init(),
        .init(),
        .init(),
    ]
    
    @Published var error: FitRepError?
    @Published var isLoading: Bool = false
    
    enum Action {
        case moveExercise(from: IndexSet, to: Int)
        case deleteExercise(at: IndexSet)
        case createWorkout
    }
    
    private let userService: UserServiceProtocol
    private let workoutService: WorkoutServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    static let exerciseOptions = ExerciseOption.allCases.map { $0.toDropdownOption }
    
    init(
        userService: UserServiceProtocol = UserService(),
        workoutService: WorkoutServiceProtocol = WorkoutService()
    ) {
        self.userService = userService
        self.workoutService = workoutService
    }
    
    func send(action: Action) {
        switch action {
        case let .moveExercise(from, to):
            moveExercise(from: from, to: to)
        case let .deleteExercise(at):
            deleteExercise(at: at)
        case .createWorkout:
            isLoading = true
            
            currentUserId()
                .flatMap { userId -> AnyPublisher<Void, FitRepError> in
                    return self.createWorkoutTemplate(userId: userId)
                }
                .sink { completion in
                    self.isLoading = false
                    
                    switch completion {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    print("created new template")
                }
                .store(in: &cancellables)
        }
    }
    
    private func createWorkoutTemplate(userId: UserId) -> AnyPublisher<Void, FitRepError> {
        guard !exercises.isEmpty else {
            return Fail(error: .default(description: "Parsing error"))
                .eraseToAnyPublisher()
        }
        
        let template = WorkoutTemplate(
            exercises: exercises.map { $0.selectedOption },
            userId: userId
        )
        
        return workoutService
            .createTemplate(template)
            .eraseToAnyPublisher()
    }
    
    private func currentUserId() -> AnyPublisher<UserId, FitRepError> {
        return userService.currentUser().flatMap { user -> AnyPublisher<UserId, FitRepError> in
            if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: FitRepError.self)
                    .eraseToAnyPublisher()
            }
            
            return self.userService
                .signInAnonymously()
                .map { $0.uid }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
}

extension CreateWorkoutViewModel {
    enum ExerciseOption: String, CaseIterable {
        case pullups
        case pushups
        case situps
        case squats
        case deadlifts
        
        var toDropdownOption: Exercise {
            .init(name: rawValue.capitalized)
        }
    }
    
    struct ExerciseViewModel: DropdownItemProtocol {
        var selectedOption: Exercise
        
        var dropdownTitle: String {
            selectedOption.name
        }
        
        init() {
            self.selectedOption = exerciseOptions.randomElement()!
        }
        
        init(selectedOption: Exercise) {
            self.selectedOption = selectedOption
        }
    }
}
