//
//  NetworkManager.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 01/06/21.
//

import Foundation

public enum URLType {
    case endpoint
    case images
}

public enum HTTPMethod: String {
    case post   = "POST"
    case put    = "PUT"
    case get    = "GET"
    case delete = "DELETE"
    case patch  = "PATCH"
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public protocol Request {
    
    var path        : String                { get }
    var method      : HTTPMethod            { get }
    var parameters  : RequestParams?        { get }
    var headers     : [String: Any]?        { get }
    var urlType     : URLType               { get }
}

public enum ServerRequest: Request {

    case movieGenres
    case popularMovies(Int)
    case topRatedMovies(Int)
    case upcomingMovies(Int)
    case movieDetail(Int)
    case poster(String)
    case backdrop(String)
    case movieVideos(Int)
    
    public var path: String {
        switch self {
        case .movieGenres:
            return "/genre/movie/list"
        case .popularMovies(_):
            return "/movie/popular"
        case .topRatedMovies(_):
            return "/movie/top_rated"
        case .upcomingMovies(_):
            return "/movie/upcoming"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .poster(let poster):
            return "\(poster)"
        case .backdrop(let backdrop):
            return "\(backdrop)"
        case .movieVideos(let id):
            return "/movie/\(id)/videos"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .movieGenres:
            return .get
        case .popularMovies(_):
            return .get
        case .topRatedMovies(_):
            return .get
        case .upcomingMovies(_):
            return .get
        case .movieDetail(_):
            return .get
        case .poster(_):
            return .get
        case .backdrop(_):
            return .get
        case .movieVideos(_):
            return .get
        }
    }
    
    public var parameters: RequestParams? {
        switch self {
        case .movieGenres:
            return nil
        case .popularMovies(let page):
            return .url(["page" : page])
        case .topRatedMovies(let page):
            return .url(["page" : page])
        case .upcomingMovies(let page):
            return .url(["page" : page])
        case .movieDetail(_):
            return nil
        case .poster(_):
            return nil
        case .backdrop(_):
            return nil
        case .movieVideos(_):
            return nil
        }
    }

    public var headers: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    public var urlType : URLType {
        switch self {
        case .movieGenres:
            return .endpoint
        case .popularMovies(_):
            return .endpoint
        case .topRatedMovies(_):
            return .endpoint
        case .upcomingMovies(_):
            return .endpoint
        case .movieDetail(_):
            return .endpoint
        case .poster(_):
            return .images
        case .backdrop(_):
            return .images
        case .movieVideos(_):
            return .endpoint
        }
    }
}

public class NetworkManager {
    
    private static var sharedInstance: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()
    
    private let baseURL = "https://api.themoviedb.org/"
    private let imagesURL = "https://image.tmdb.org/t/p/original/"
    private let apiVersion = 3
    private var baseRequestURL : String {
        return baseURL + "\(apiVersion)"
    }
    public var session = URLSession.shared
    
    private init() { }

    // MARK: - Accessors

    public class func shared() -> NetworkManager {
        return sharedInstance
    }
    
    private func getAPIKey() -> String {
        return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNTcwMmQ2MjdjMjEzMWRlODE5NWVmZmMyYzNjOGEwOCIsInN1YiI6IjYwYjNmMzVlM2UwOWYzMDAyYWNkODY4YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Qt3KizvEdRaCKtCklgiYYFvP4YRf0KTB8iIRgGCs27c"
    }
    
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        
        let requestURL = request.urlType == .endpoint ? baseRequestURL + request.path : imagesURL
        guard let url =  URL(string: requestURL) else {
            throw NetworkError.badInput
        }
        
        var urlRequest = URLRequest(url: url)
        
        switch request.parameters {
        case .body(let params):
            // Parameters are part of the body
            guard let params = params else { throw NetworkError.badInput}
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
        case .url(let params):
            // Parameters are part of the url
            guard let params = params else { throw NetworkError.badInput }
            let queryParams = params.map({ (element) -> URLQueryItem in
                return URLQueryItem(name: element.key, value: "\(element.value)")
            })
            guard var components = URLComponents(string: requestURL) else {
                throw NetworkError.badInput
            }
            components.queryItems = queryParams
            urlRequest.url = components.url

        case .none:
            break
        }
        
        // Headers for request
        urlRequest.addValue("Bearer \(getAPIKey())", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // HTTP method for request
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
    
    public func urlRequest(for request: ServerRequest) -> URLRequest? {
        return try? prepareURLRequest(for: request)
    }
    
    public func responseResult(statusCode : Int) -> (Result<Bool, NetworkError>) {
        switch statusCode {
        case 200...299:
            return .success(true)
        default:
            return .failure(ErrorHandler.requestErrorFrom(statusCode: statusCode))
        }
    }
}

extension URLResponse {

    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

extension Data {
    
     func getDecodedObject<T>(from object : T.Type)->T? where T : Decodable {
        
        do {
            
            return try JSONDecoder().decode(object, from: self)
            
        } catch let error {
            
            print("Manually parsed  ", (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) ?? "nil")
            
            print("Error in Decoding OBject ", error)
            return nil
        }
        
    }
    
} 
