//
//  PlayListItemCell.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/4.
//

import UIKit

class PlayListItemCell: UITableViewCell {
    
    static let identifier = "PlayListItemCell"
    
    let thumbnailImgView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.contentMode = .scaleToFill
        return thumbnail
    }()
    
    var infoView = InfoView()
    
    private let baseView: UIView = {
        let base = UIView()
        base.backgroundColor = .white
        base.layer.shadowColor = UIColor.black.cgColor
        base.layer.cornerRadius = 16
        base.layer.shadowOpacity = 0.1
        base.layer.shadowRadius = 4
        base.layer.shadowOffset = CGSize(width: 0, height: 1)
        return base
    }()
    
    func setData(_ info: PlayItem) {
        let placeholderImage = UIImage(named: "ImgPlaceHolder")
        thumbnailImgView.kf.setImage(with: URL(string: info.snippet.thumbnails.medium.url), placeholder: placeholderImage)
        infoView.setData(ownerImageUrl: info.ownerThumbnails?.high.url ?? "",
                         videoTitle: info.snippet.title,
                         ownerTitle: info.snippet.channelTitle,
                         uploadDateTime: info.snippet.publishedAt.yyyyMMddhhmmss)
    }

    private func initSubviews() {
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }

        baseView.addSubview(thumbnailImgView)
        thumbnailImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(180)
        }
        
        baseView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImgView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
