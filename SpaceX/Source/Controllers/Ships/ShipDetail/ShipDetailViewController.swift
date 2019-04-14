//
//  ShipDetailViewController.swift
//  SpaceX
//
//  Created by Philip Engberg on 08/09/2018.
//  Copyright © 2018 Simple Sense. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ShipDetailViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = ShipDetailView()
    private let viewModel: ShipDetailViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)

    // MARK: - Inits

    init(viewModel: ShipDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func loadView() {
        view = _view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view.tableView.registerCell(ImageCell.self)
        
        viewModel.object.asObservable().unwrap().take(1).subscribe(onNext: { (ship) in
            Analytics.trackShipDetailShown(for: ship)
        }).disposed(by: bag)

        viewModel.object.asObservable().unwrap().map { $0.shipName }.bind(to: self.rx.title).disposed(by: bag)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = dataState
        }).disposed(by: bag)
        
        viewModel.sections.asObservable().subscribe(onNext: { [weak self] (_) in
            self?._view.tableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = _view.tableView.indexPathForSelectedRow {
            _view.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension ShipDetailViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension ShipDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value[section].properties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let property = viewModel.sections.value[indexPath.section].properties[indexPath.row]
        
        if let imageUrl = property.imageUrl {
            let cell = tableView.dequeueCell(ImageCell.self, indexPath: indexPath)
            cell.configure(with: imageUrl)
            return cell
        }
        
        let cell = UITableViewCell(style: property.longValueText ? .subtitle : .value1, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = property.propertyName
        cell.detailTextLabel?.text = property.propertyValue
        cell.accessoryType = property.detail == nil ? .none : .disclosureIndicator
        cell.selectionStyle = property.detail == nil ? .none : .default
        
        if property.longValueText {
            cell.detailTextLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections.value[section].sectionName
    }
}

extension ShipDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destination = viewModel.sections.value[indexPath.section].properties[indexPath.row].detail else { return }
        Router.route(to: destination)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ShipDetailViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCell.SeparatorStyle {
        return .singleLine
    }
}
