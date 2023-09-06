//
//  SearchVideoViewController.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/6.
//

import UIKit
import RxSwift

class SearchVideoViewController: BaseViewController {
    
    let viewModel: SearchVideoViewModel
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 30))
        textField.borderStyle = .roundedRect
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Search Video", attributes: attributes)
        return textField
    }()
    
    lazy var playListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 250
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlayListItemCell.self, forCellReuseIdentifier: PlayListItemCell.identifier)
        return tableView
    }()
    
    init(playItemList: [PlayItem]) {
        viewModel = SearchVideoViewModel(withPlayVideoItems: playItemList)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray242
        
        self.navigationItem.titleView = searchTextField
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        view.addSubview(playListTableView)
        playListTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottom)
        }
    }
    
    override func bind() {
        super.bind()
        
        searchTextField
            .rx
            .text
            .debounce(.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] text in
                guard let self = self else { return }
                self.viewModel.searchTerm.accept(text ?? "")
            }).disposed(by: disposeBag)
        
        viewModel.resultItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.playListTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe(onNext: {[weak self] args in
            let (title, msg) = args
            self?.presentAlert(title: title, message: msg, callback: nil)
        }).disposed(by: disposeBag)
        
        viewModel.resultItems.map { $0.isEmpty }
        .observe(on: MainScheduler.instance)
        .bind(to: playListTableView.rx.noDataLabelVisible)
        .disposed(by: disposeBag)
    }
}

extension SearchVideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultItems.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayListItemCell.identifier)
            as? PlayListItemCell ?? PlayListItemCell()
        
        cell.setData(viewModel.resultItems.value[indexPath.row])
        
        return cell
    }
}

extension SearchVideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.resultItems.value.count else { return }
        
        let rootController = self.navigationController?.viewControllers.first
        
        guard let rootController = rootController else { return }
        // arrange container
        self.navigationController?.setViewControllers([rootController,
                                                       PlayVideoViewController(viewModel.resultItems.value[indexPath.row])],
                                                      animated: true)
    }
}
