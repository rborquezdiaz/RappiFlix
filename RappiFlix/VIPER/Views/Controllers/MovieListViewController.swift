//
//  MovieListViewController.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 04/06/21.
//

import UIKit

class MovieListViewController: UIViewController, AnyView {
    func setInterfaceMode() {
        let darkMode = UserDefaults.standard.bool(forKey: UserDefaultsKeys.DarkMode)
        if darkMode {
            self.navigationController?.overrideUserInterfaceStyle = .dark
        } else {
            self.navigationController?.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var presenter: AnyPresenter?
    
    struct MovieListCell {
        static let freeSpace : CGFloat = 10
        static let numberOfRows : CGFloat = 2
        static let aspectRatio : CGFloat = 1.3
    }
    
    var movieList : MovieList?
    var isPageRefreshing:Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.loader.isHidden = !self.isPageRefreshing
                self.isPageRefreshing ?  self.loader.startAnimating() : self.loader.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setInterfaceMode()
    }
    
    func setupNavController() {
        self.title = (self.movieList?.type.rawValue ?? "").capitalized
        navigationController?.navigationBar.barTintColor = UIColor(named: "RappiOrange")
        guard let font = UIFont(name: "NunitoSans-Bold", size: 19.0) else { return }
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font : font]
        navigationController?.navigationBar.tintColor = .white
    }

    func update(with entity: AnyEntity) {
        DispatchQueue.main.async {
            guard let movieListEntity = entity as? MovieList, let results = movieListEntity.results, let currentPage = movieListEntity.page else { return }
            self.movieList?.results?.append(contentsOf: results)
            self.movieList?.page = currentPage
            self.movieList?.type = movieListEntity.type
            self.isPageRefreshing = false
            self.movieListCollectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        self.movieListCollectionView.delegate = self
        self.movieListCollectionView.dataSource = self
        self.movieListCollectionView.register(UINib(nibName: Identifiers.CollectionViewCells.MovieCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CollectionViewCells.MovieCollectionViewCell)
    }
}

extension MovieListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionViewCells.MovieCollectionViewCell, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell()}
        guard let movie = movieList?.results?[indexPath.row] else { return UICollectionViewCell()}
        cell.setupCell(with: movie.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.bounds.width / MovieListCell.numberOfRows) - (MovieListCell.freeSpace * MovieListCell.numberOfRows)
        let height = width * MovieListCell.aspectRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = (self.view.bounds.width / MovieListCell.numberOfRows) - (MovieListCell.freeSpace * MovieListCell.numberOfRows)
        let numberOfCells = floor(collectionView.frame.size.width / totalCellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * totalCellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movieList?.results?[indexPath.row], let id = movie.id else { return }
        
        let movieDetailRouter = MovieDetailRouter.start(with: id)
        guard let view = movieDetailRouter.entry as? MovieDetailViewController else { return }
        view.movieDetail =  movie
        self.present(view, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.movieListCollectionView.contentOffset.y >= (self.movieListCollectionView.contentSize.height - self.movieListCollectionView.bounds.size.height)) {
            if !isPageRefreshing && (movieList?.page ?? 0) < (movieList?.total_pages ?? 0) {
                isPageRefreshing = true
                print(movieList?.page ?? 0)
                // Message presenter to get info from interactor
                guard let presenter = presenter as? MovieListPresenter, let currentPage = movieList?.page else { return }
                presenter.requestListUpdate(currentPage: currentPage, movieListType: movieList?.type ?? .generic)
            }
        }
    }
       
}
