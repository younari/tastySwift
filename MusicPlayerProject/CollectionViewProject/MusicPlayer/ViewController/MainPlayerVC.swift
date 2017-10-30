import UIKit
import AVFoundation
private let reuseIdentifier = "AlbumCoverCell"

class MainPlayerVC: UIViewController {
    
    /*Song DATA*/
    var albumList:[AlbumDataModel] = DataCenter.main.albumList
    var currentPageIndex = 0
    
    /*UI Property*/
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var lyricsView: LyricsView!
    
    
    /*AV Property*/
    var isPlaying: Bool = false
    var player:AVPlayer = AVPlayer()
    
    /*CollectionView Size Property*/
    var cellWidth: CGFloat {
        return collectionView.bounds.width*0.5
    }
    var cellHeight: CGFloat {
        return collectionView.bounds.width*0.5
    }
    var viewWidth: CGFloat {
        return collectionView!.bounds.width
    }
    var viewHeight: CGFloat {
        return collectionView!.bounds.height
    }

    /*Life Cycle*/
    override func viewDidLoad() {
        super.viewDidLoad()
        playWithCurrentIndex()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnAlbumCover(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
}

/*tapOnAlbumCover*/
extension MainPlayerVC {
    @IBAction func exitLyricsView(_ sender: UIButton) {
        self.lyricsView.isHidden = true
    }
    
    @objc func tapOnAlbumCover(_ sender: UITapGestureRecognizer) {
        //album 커버 선택시 가사뷰 띄우기
        lyricsView.isHidden = false
        lyricsView!.data = albumList[currentPageIndex]
    }
}


/*UIScrollViewDelegate*/
extension MainPlayerVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageIndex = targetContentOffset.pointee.x/cellWidth
        currentPageIndex = Int(pageIndex)
        playWithCurrentIndex()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        playWithCurrentIndex()
    }
}

/*AVPlayer Handler*/
extension MainPlayerVC {
    
    @IBAction func nextSongAction(_ sender: UIButton) {
        if currentPageIndex < albumList.count {
            currentPageIndex += 1
            setContentOffset()
        }
    }
    
    @IBAction func prevSongAction(_ sender: UIButton) {
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            setContentOffset()
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "Play"), for: UIControlState.normal)
            isPlaying = false
            player.pause()
        }else {
            playButton.setImage(#imageLiteral(resourceName: "Pause"), for: UIControlState.normal)
            isPlaying = true
            playWithCurrentIndex()
        }
    }
    
    private func playWithCurrentIndex() {
        let currentSong = albumList[currentPageIndex]
        self.titleLabel.text = currentSong.title
        self.artistLabel.text = currentSong.artist
        if let url = currentSong.songURL
        {
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: nil)
            player.replaceCurrentItem(with: playerItem)
            if isPlaying {
                player.play()
                isPlaying = true
            }
        }
    }
    
    private func setContentOffset() {
        //let newOffset = CGPoint(x: collectionView.contentOffset.x + cellWidth, y: collectionView.contentOffset.y)
        collectionView.contentOffset.x = CGFloat(currentPageIndex)*cellWidth
        // -> scrollViewDidEndScrollingAnimation
    }
    
}

/*Extension Collection Data Source*/
extension MainPlayerVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*numberOfItemsInSection*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    /*cellForItemAt*/
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCoverCell
        cell.data = albumList[indexPath.item]
        return cell
    }
    
    /*sizeForItemAt*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (viewWidth-cellWidth)/2, bottom: 0, right: (viewWidth-cellWidth)/2)
    }
    
}
