//
//  ProfileViewController.swift
//  Gorilla
//
//  Created by admin on 2020/06/04.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class ProfileViewController: UIViewController, View, ViewConstructor, TransitionPresentable {
    
    struct Const {
        static let scrollViewContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 24, right: 0)
    }
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    private lazy var profileVotedContestListCallback = ProfileVotedContestListView.Callback(itemSelected: { contest in
        guard let reactor = self.reactor else { return }
        self.showVotedDetailPage(votedContestReactor: reactor.createVotedContestReactor())
    })
    
    private lazy var profileFanAnimalListCallback = ProfileFanAnimalListView.Callback(itemSelected: { animal in
        guard let reactor = self.reactor else { return }
        self.showFanAnimalPage(fanAnimalReactor: reactor.createFanAnimalReactor())
    })
    
    // MARK: - Views
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let profileInfoHeader = ProfileInfoHeader()
    
    private lazy var profileInfoListView = ProfileInfoListView().then {
        $0.reactor = reactor?.createProfileInfoListReactor()
    }
    
    private let profileFanAnimalHeader = ProfileFanAnimalHeader()
    
    private lazy var profileFanAnimalListView = ProfileFanAnimalListView(callback: profileFanAnimalListCallback).then {
        $0.reactor = reactor?.createProfileFanAnimalListReactor()
    }
    
    private let profileVotedContestHeader = ProfileVotedContestHeader()
    
    private lazy var profileVotedContestListView = ProfileVotedContestListView(callback: profileVotedContestListCallback).then {
        $0.reactor = reactor?.createProfileVotedContestListReactor()
    }
    
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewConstraints()
    }
    
    // MARK: - Setup Methods
    
    func setupViews() {
        scrollView.contentInset = Const.scrollViewContentInset
        view.addSubview(stackView)
        stackView.addArrangedSubview(profileInfoHeader)
        stackView.addArrangedSubview(profileInfoListView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(profileFanAnimalHeader)
        stackView.addArrangedSubview(profileFanAnimalListView)
        stackView.setCustomSpacing(36, after: profileFanAnimalListView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(profileVotedContestHeader)
        stackView.addArrangedSubview(profileVotedContestListView)
        stackView.setCustomSpacing(36, after: profileVotedContestListView)

    }
    
    func setupViewConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
        }
    }
    
    // MARK: - Bind Method
   func bind(reactor: ProfileReactor) {
       // Action
       
       // State
   }
}