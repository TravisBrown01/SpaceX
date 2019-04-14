
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit

class LaunchesViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = LaunchesView()
    private let viewModel: LaunchesViewModel
    private let bag = DisposeBag()
    private lazy var listManager: ListDataManager = ListDataManager(tableView: self._view.tableView, dataPresenter: self, emptyData: self)
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Inits

    init(viewModel: LaunchesViewModel = LaunchesViewModel()) {
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
        
        let lol = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-starman").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        lol.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.present(UINavigationController(rootViewController: RoadsterViewController(viewModel: RoadsterViewModel(api: SpaceXAPI))), animated: true, completion: nil)
        }).disposed(by: bag)
        navigationItem.rightBarButtonItem = lol
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchController.searchBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "Mission search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        _view.segmentedControl.rx.selectedSegmentIndex.asObservable().map { LaunchesViewModel.Scope(rawValue: $0) }.unwrap().bind(to: viewModel.scope).disposed(by: bag)
        _view.segmentedControl.selectedSegmentIndex = 0
        
        _view.tableView.registerCell(LaunchOverviewCell.self)
        
        viewModel.dataState.asObservable().subscribe(onNext: { [weak self] (dataState) in
            self?.listManager.state = dataState
        }).disposed(by: bag)
        
        viewModel.filteredLaunches.asObservable().subscribe(onNext: { [weak self] _ in
            self?._view.tableView.reloadData()
        }).disposed(by: bag)
        
        _view.refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] (_) in
            self?.viewModel.reloadData()
        }).disposed(by: bag)
        
        viewModel.object.asObservable().subscribe(onNext: { [weak self] _ in
            self?._view.refreshControl.endRefreshing()
        }).disposed(by: bag)
        
        viewModel.object.asObservable().skip(1).take(1).subscribe(onNext: { [weak self] (_) in
            self?.viewModel.scope.value = .past
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.view.setNeedsLayout() // force update layout...
        navigationController?.view.layoutIfNeeded() // ... to fix height of the navigation bar
        
        if let selectedIndexPath = _view.tableView.indexPathForSelectedRow {
            _view.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.view.setNeedsLayout() // force update layout...
        navigationController?.view.layoutIfNeeded() // ... to fix height of the navigation bar
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension LaunchesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText.value = searchController.searchBar.text ?? ""
    }
}

extension LaunchesViewController: EmptyDataType {
    var placeholderSubtitle: String { return "No data" }
}

extension LaunchesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredLaunches.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LaunchOverviewCell.self, indexPath: indexPath)
        cell.configure(with: LaunchOverviewCellViewModel(launch: viewModel.filteredLaunches.value[indexPath.row]))
        cell.selectionStyle = .none
        return cell
    }
}

extension LaunchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.route(to: .launchDetail(flightNumber: viewModel.filteredLaunches.value[indexPath.row].flightNumber))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
}

extension LaunchesViewController: ListDataManagerDelegate {
    func separatorStyle() -> UITableViewCell.SeparatorStyle {
        return .none
    }
}
