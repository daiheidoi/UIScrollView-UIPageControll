//
//  PageItemCell.swift
//  UIScrollView+UIPageControll
//
//  Created by doi on 2019/07/26.
//  Copyright © 2019 doi. All rights reserved.
//

import Lottie
import Reusable
import RxSwift
import UIKit

final class PageItemCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var animationView: AnimationView! {
        willSet {
            newValue.loopMode = .loop
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animationView.stop()
    }
    
    func setData(lottieFile: String) {
        animationView.animation = Animation.named(lottieFile)
        animationView.play()
    }
}
