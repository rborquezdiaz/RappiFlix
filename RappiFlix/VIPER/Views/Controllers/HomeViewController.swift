//
//  HomeViewController.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 02/06/21.
//

import UIKit

class HomeViewController: UIViewController, AnyView {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var rappiLogoImageView: UIImageView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var popcornImageView: UIImageView!
    
    var presenter: AnyPresenter?
    var movieListEntities : [MovieList]?
    
    func update(with entityArray : [AnyEntity]) {
        DispatchQueue.main.async {
            guard let movieListEntities = entityArray as? [MovieList] else { return }
            self.movieListEntities = movieListEntities
            self.homeTableView.reloadData()
        }
    }

    func update(with errorMessage: String) {
        print(errorMessage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupGesture()
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setInterfaceMode()
    }
    
    private func setupTableView() {
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        self.homeTableView.register(UINib(nibName: Identifiers.TableViewCells.HomeSectionTableViewCell, bundle: nil), forCellReuseIdentifier: Identifiers.TableViewCells.HomeSectionTableViewCell)
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handlePopcornTap(_:)))
        popcornImageView.addGestureRecognizer(tap)
    }
    
    @objc func handlePopcornTap(_ sender: UITapGestureRecognizer? = nil) {
        let darkMode = !UserDefaults.standard.bool(forKey: UserDefaultsKeys.DarkMode)
        UserDefaults.standard.set(darkMode, forKey: UserDefaultsKeys.DarkMode)
        setInterfaceMode()
    }
    
    func setInterfaceMode() {
        let darkMode = UserDefaults.standard.bool(forKey: UserDefaultsKeys.DarkMode)
        if darkMode {
            self.navigationController?.overrideUserInterfaceStyle = .dark
        } else {
            self.navigationController?.overrideUserInterfaceStyle = .light
        }
        
    }
}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.TableViewCells.HomeSectionTableViewCell) as? HomeSectionTableViewCell else { return UITableViewCell()}
        var movieList : MovieList?
        cell.selectionStyle = .none
        cell.delegate = self
        switch indexPath.section {
        case HomeSections.popular.rawValue:
            movieList = movieListEntities?.first(where: {$0.type == .popular})
        case HomeSections.topRated.rawValue:
            movieList = movieListEntities?.first(where: {$0.type == .topRated})
        case HomeSections.upcoming.rawValue:
            movieList = movieListEntities?.first(where: {$0.type == .upcoming})
        default:
            return UITableViewCell()
        }
        
        cell.setupCell(with: movieList ?? MovieList(), title: movieList?.type.rawValue.capitalized ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 292
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movieList : MovieList?
        switch indexPath.section {
        case HomeSections.popular.rawValue:
            guard let currentList = movieListEntities?.first(where: {$0.type == .popular}) else { return }
            movieList = currentList
        case HomeSections.topRated.rawValue:
            guard let currentList = movieListEntities?.first(where: {$0.type == .topRated}) else { return }
            movieList = currentList
        case HomeSections.upcoming.rawValue:
            guard let currentList = movieListEntities?.first(where: {$0.type == .upcoming}) else { return }
            movieList = currentList
        default:
            return
        }
        guard let validatedList = movieList else { return }
        let movieListRouter = MovieListRouter.start(with: validatedList)
        guard let view = movieListRouter.entry as? MovieListViewController else { return }
        view.movieList = validatedList
        self.navigationController?.pushViewController(view, animated: true)
//        self.present(view, animated: true, completion: nil)
    }
}

enum HomeSections : Int {
    case popular
    case topRated
    case upcoming
}

extension HomeViewController : MovieSelectionDelegate {
    func selectedMovieAt(index: Int, movieListType: MovieListType) {
        guard let movieList =  movieListEntities?.first(where: {$0.type == movieListType}), let movieDetail = movieList.results?[index], let id = movieDetail.id else { return }
        
        let movieDetailRouter = MovieDetailRouter.start(with: id)
        guard let view = movieDetailRouter.entry as? MovieDetailViewController else { return }
        view.movieDetail = movieDetail
        self.present(view, animated: true, completion: nil)
    }
    
}
