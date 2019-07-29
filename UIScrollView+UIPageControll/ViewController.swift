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
    
    @IBOutlet private weak var nextButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Observable.just(Const.lotties.count)                    // ページ数
            .bind(to: pageControll.rx.numberOfPages)            // ページコントロールにbind
            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll                             // スクロール位置変更を流す
            .withLatestFrom(collectionView.rx.contentOffset)    // 最新値contentOffset
            .map { Int($0.x / UIScreen.main.bounds.width) }     // ページ番号に加工
            .bind(to: pageControll.rx.currentPage)              // ページコントロールの現在ページにバインド
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .filter { [unowned self] in
                self.pageControll.currentPage < (Const.lotties.count - 1) // ページ数超えないようfilter
            }
            .subscribe(onNext: { [unowned self] _ in
                self.collectionView.setContentOffset(CGPoint(x: self.collectionView.contentOffset.x + UIScreen.main.bounds.width, y: 0), animated: true)  // スクロール移動
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController {
    
    struct Const {
        static let lotties = [
            "test0",
            "test1",
            "test2"
        ]
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Const.lotties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PageItemCell =  collectionView.dequeueReusableCell(for: indexPath)
        cell.setData(lottieFile: Const.lotties[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
