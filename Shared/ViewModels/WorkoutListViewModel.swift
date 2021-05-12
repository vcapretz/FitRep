//
//  WorkoutListViewModel.swift
//  Drilly
//
//  Created by Vitor Capretz on 2021-05-11.
//

import Combine

final class WorkoutListViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    private let workoutService: WorkoutServiceProtocol
    
    private var cancellables: [AnyCancellable] = []
    
    let title = "Workout routines"
    
    @Published private(set) var itemViewModels: [TemplateItemViewModel] = []
    @Published private(set) var error: FitRepError?
    @Published private(set) var isLoading = false
    @Published var showingCreateModal = false
    
    enum Action {
        case retry
        case createRoutine
    }
    
    init(userService: UserServiceProtocol = UserService(), workoutService: WorkoutServiceProtocol = WorkoutService()) {
        self.userService = userService
        self.workoutService = workoutService
        
        observeTemplates()
    }
    
    func send(action: Action) {
        switch action {
        case .retry:
            observeTemplates()
        case .createRoutine:
            showingCreateModal = true
        }
    }

    private func observeTemplates() {
        isLoading = true
        
        userService
            .currentUser()
            .compactMap {
                $0?.uid
            }
            .flatMap { [weak self] userId -> AnyPublisher<[WorkoutTemplate], FitRepError> in
                guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher() }
                
                return self.workoutService.observeTemplates(userId: userId)
            }
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("finished observing templates")
                }
            } receiveValue: { [weak self] templates in
                guard let self = self else { return }
                
                self.itemViewModels = templates.map { .init(template: $0) }
                self.error = nil
                self.isLoading = false
                self.showingCreateModal = false
            }
            .store(in: &cancellables)

    }
}
