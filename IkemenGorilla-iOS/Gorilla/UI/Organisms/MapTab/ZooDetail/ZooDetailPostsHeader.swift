//
//  ZooDetailPostsHeader.swift
//  Gorilla
//
//  Created by admin on 2020/06/18.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

final class ZooDetailPostsHeader: UIView, ViewConstructor {
    private struct Const {
        static let height: CGFloat = 56
    }
    
    // MARK: - Variables
    override var intrinsicContentSize: CGSize {
        return CGSize(width: DeviceSize.screenWidth, height: Const.height)
    }
    
    // MARK: - Views
    private let label = UILabel().then {
        $0.apply(fontStyle: .medium, size: 20)
        $0.textColor = Color.black
        $0.text = "投稿"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(label)
    }
    
    func setupViewConstraints() {
        label.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
