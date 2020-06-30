//
//  AnimalDetailReactor.swift
//  Gorilla
//
//  Created by admin on 2020/06/25.
//  Copyright © 2020 admin. All rights reserved.
//

import ReactorKit
import RxSwift

final class AnimalDetailReactor: Reactor {
    enum Action {
        case loadAnimal
        case loadCurrentContest
        case loadPastContests
        case loadPost
    }
    enum Mutation {
        case setAnimal(Animal)
        case setCurrentContest(Contest)
        case setPastContestCellReactors([Contest])
        case setPosts([Post])
    }
    
    struct State {
        let zooAnimal: ZooAnimal
        var animal: Animal?
        let zooName: String = "東山動物園"
        var currentContest: Contest?
        let numberOfVoted: Int = 312
        var pastContestCellReactors: [AnimalDetailPastContestCellReactor] = []
        var posts: [Post] = []
        
        init(zooAnimal: ZooAnimal) {
            self.zooAnimal = zooAnimal
        }
    }
    
    let initialState: State
    private let provider: ServiceProviderType
    
    init(provider: ServiceProviderType, zooAnimal: ZooAnimal) {
        self.provider = provider
        initialState = State(zooAnimal: zooAnimal)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnimal:
            return loadAnimal().map(Mutation.setAnimal)
        case .loadCurrentContest:
            return loadCurrentContest().map(Mutation.setCurrentContest)
        case .loadPastContests:
            return loadPastContests().map(Mutation.setPastContestCellReactors)
        case .loadPost:
            return loadPosts().map(Mutation.setPosts)
        }
    }
    
    private func loadAnimal() -> Observable<Animal> {
        logger.warning("no user id from AnimalDetailReactor")
        return provider.animalService.getAnimal(animalId: currentState.zooAnimal.id, userId: "user01").asObservable()
    }
    
    private func loadCurrentContest() -> Observable<Contest> {
        return .just(TestData.contest())
    }
    
    private func loadPastContests() -> Observable<[Contest]> {
        return .just(TestData.contests(count: 5))
    }
    
    private func loadPosts() -> Observable<[Post]> {
        return .just(TestData.posts(count: 12))
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setAnimal(let animal):
            state.animal = animal
        case .setCurrentContest(let contest):
            state.currentContest = contest
        case .setPastContestCellReactors(let contests):
            state.pastContestCellReactors = contests.map { AnimalDetailPastContestCellReactor(contest: $0) }
        case .setPosts(let posts):
            state.posts = posts
        }
        return state
    }
    
    func createPostPhotoCollectionReactor() -> PostPhotoCollectionReactor {
        return PostPhotoCollectionReactor()
    }
}
