//
//  InfoView.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/4.
//

import UIKit

class InfoView: UIView {
    lazy var ownerImgView: UIImageView = {
        let ownerImg = UIImageView()
        ownerImg.layer.cornerRadius = ownerImg.frame.size.width / 2
        ownerImg.clipsToBounds = true
        return ownerImg
    }()
    
    lazy var videoTitleLabel = createTitleLabel("video title")
    lazy var ownerTitleLabel = createTitleLabel("owner title")
    lazy var uploadDatetimeLabel = createTitleLabel("upload datetime")
    
    private func createTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = .dinPro(14)
        label.text = text
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    init() {
        super.init(frame: .zero)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(ownerImageUrl: String,
                 videoTitle: String,
                 ownerTitle: String,
                 uploadDateTime: String) {
        let placeholderImage = UIImage(named: "ImgPlaceHolder")
        ownerImgView.kf.setImage(with: URL(string: ownerImageUrl), placeholder: placeholderImage)
        
        videoTitleLabel.text = videoTitle
        ownerTitleLabel.text = ownerTitle
        uploadDatetimeLabel.text = uploadDateTime
    }
    
    func initSubviews() {
        addSubview(ownerImgView)
        ownerImgView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.width.height.equalTo(50)
        }
        
        addSubview(videoTitleLabel)
        videoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerImgView)
            make.leading.equalTo(ownerImgView.snp.trailing).offset(3)
            make.trailing.lessThanOrEqualToSuperview().offset(-5)
        }
        
        addSubview(ownerTitleLabel)
        ownerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(videoTitleLabel.snp.bottom).offset(5)
            make.leading.equalTo(videoTitleLabel)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        addSubview(uploadDatetimeLabel)
        uploadDatetimeLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(ownerTitleLabel)
            make.leading.equalTo(ownerTitleLabel.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualToSuperview().offset(-5)
        }
    }
}
