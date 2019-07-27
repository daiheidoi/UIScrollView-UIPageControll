//
//  ViewController.swift
//  UIScrollView+UIPageControll
//
//  Created by doi on 2019/07/26.
//  Copyright © 2019 doi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var pageControll: UIPageControl!
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        willSet {
            newValue.register(cellType: PageItemCell.self)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.rx.didEndDecelerating
            .withLatestFrom(collectionView.rx.contentOffset)
            .map { Int($0.x / UIScreen.main.bounds.width) }
            .bind(to: pageControll.rx.currentPage)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PageItemCell =  collectionView.dequeueReusableCell(for: indexPath)
        cell.setData(lottieFile: "test\(indexPath.row)")
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
