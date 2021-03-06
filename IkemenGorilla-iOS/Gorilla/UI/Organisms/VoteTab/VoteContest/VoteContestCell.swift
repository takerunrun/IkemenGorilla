//
//  VoteContestCell.swift
//  Gorilla
//
//  Created by admin on 2020/06/27.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

final class VoteContestCell: UICollectionViewCell, View, ViewConstructor {
    
    struct Const {
        static let cellWidth: CGFloat = DeviceSize.screenWidth - 32
        static let cellHeight: CGFloat = 160
        static let itemSize: CGSize = CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Variables
    var disposeBag = DisposeBag()
    
    // MARK: - Views
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let sheet = UIView().then {
        $0.backgroundColor = Color.white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    let contestNameLabel = UILabel().then {
        $0.apply(fontStyle: .bold, size: 15)
        $0.textColor = Color.textGray
        $0.numberOfLines = 0
    }
    
    let durationLabel = UILabel().then {
        $0.apply(fontStyle: .bold, size: 10)
        $0.textColor = Color.textGray
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    func setupViews() {
        addSubview(sheet)
        addSubview(imageView)
        addSubview(contestNameLabel)
        addSubview(durationLabel)
        
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = Color.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
    }
    
    func setupViewConstraints() {
        imageView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.size.equalTo(160)
        }
        sheet.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.right.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(-16)
        }
        contestNameLabel.snp.makeConstraints {
            $0.top.right.equalTo(sheet).inset(16)
            $0.left.equalTo(imageView.snp.right).offset(16)
        }
        durationLabel.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Bind Method
    func bind(reactor: VoteContestCellReactor) {
        // Action
        
        // State
        reactor.state.map { $0.contest.imageUrl }
            .distinctUntilChanged()
            .bind { [weak self] imageUrl in
                self?.imageView.setImage(imageUrl: imageUrl)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.contest.name }
            .distinctUntilChanged()
            .bind(to: contestNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map {
                var durationString = "開催期間"
                durationString += formatter.string(from: $0.contest.start)
                durationString += " ~ "
                durationString += formatter.string(from: $0.contest.end)
                return durationString
            }
            .distinctUntilChanged()
            .bind(to: durationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
