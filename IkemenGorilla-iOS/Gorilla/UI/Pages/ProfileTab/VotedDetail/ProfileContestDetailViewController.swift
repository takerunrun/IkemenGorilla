//
//  ProfileContestDetailViewController.swift
//  Gorilla
//
//  Created by admin on 2020/06/04.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SegementSlide
import ReactorKit
import RxSwift

final class ProfileContestDetailViewController: SegementSlideDefaultViewController, View {
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    private let profileContestDetailHeader = ProfileContestDetailHeader()
    
    // MARK: - Segement Settings
    
    override var titlesInSwitcher: [String] {
        return ["情報", "エントリー", "投稿", "結果"]
    }
    
    override func segementSlideHeaderView() -> UIView? {
        return profileContestDetailHeader
    }
    
    override var switcherConfig: SegementSlideDefaultSwitcherConfig {
        var config = super.switcherConfig
        config.normalTitleFont = TextStyle.font(.normalBold)()
        config.selectedTitleFont = TextStyle.font(.normalBold)()
        config.horizontalMargin = 24
        config.horizontalSpace = 24
        return config
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        switch index {
        case 0:
            return ProfileContestDetailInfoViewController().then {
                $0.reactor = reactor?.createProfileContestDetailInfoReactor()
            }
        case 1:
            return ProfileContestDetailEntryViewController().then {
                $0.reactor = reactor?.createProfileContestDetailEntryReactor()
        }
        case 2:
            return ProfileContestDetailPostViewController().then {
                $0.reactor = reactor?.createProfileContestDetailPostReactor()
        }
        case 3:
            return ProfileContestDetailResultViewController().then {
                $0.reactor = reactor?.createProfileContestDetailResultReactor()
        }
        default:
            return ProfileContestDetailInfoViewController().then {
                $0.reactor = reactor?.createProfileContestDetailInfoReactor()
            }
        }
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSelectedIndex = 0
        reloadData()
    }
    
    // MARK: - Bind Method
    func bind(reactor: ProfileContestDetailReactor) {
        profileContestDetailHeader.reactor = reactor
        
        // Action
        
        // State
    }
}
