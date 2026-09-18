//
//  CacheManager.swift
//  AdapfitV2
//
//  Created by PhamHai Dang on 6/6/26.
//  Copyright © 2026 Bru. All rights reserved.
//
import Foundation
public enum CacheType: Sendable {
    case keychain, userDefaults
}

public enum CacheExpiration: Sendable {
    case seconds(TimeInterval)
    case minutes(Double)
    case hours(Double)
    case days(Double)
    
    var timeInterval: TimeInterval {
        switch self {
        case .seconds(let s): return s
        case .minutes(let m): return m * 60
        case .hours(let h): return h * 3600
        case .days(let d): return d * 86400
        }
    }
}

public final class CacheManager: @unchecked Sendable {
    public static let shared = CacheManager()
    public let service = "com.bru.adapfit.cache"
    
    private let concurrentQueue = DispatchQueue(label: "com.bru.adapfit.queue", qos: .userInitiated, attributes: .concurrent)
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let memoryCache = NSCache<NSString, MemoryWrapper>()

    private init() {
    }
    
    public func set<T: Codable>(forType typeCache: CacheType = .userDefaults, value: T, forKey key: String, expiration: CacheExpiration) {
        let expirationDate = Date().addingTimeInterval(expiration.timeInterval)
      
        if typeCache != .keychain {
            let memoryWrapper = MemoryWrapper(value: value, expirationDate: expirationDate)
            memoryCache.setObject(memoryWrapper, forKey: key as NSString)
        }
        
        let expirableData = ExpirableData(value: value, expirationDate: expirationDate)
   
        guard let encoded = try? encoder.encode(expirableData) else { return }
        
      
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            switch typeCache {
            case .keychain:
                try? Keychain.save(encoded, key: key, service: self.service)
            case .userDefaults:
                self.defaults.set(encoded, forKey: key)
            }
        }
    }
  
    public func get<T: Codable>(forType typeCache: CacheType = .userDefaults, forKey key: String, type: T.Type) -> T? {
    
        if typeCache != .keychain {
            if let cachedWrapper = memoryCache.object(forKey: key as NSString) {
                if cachedWrapper.isExpired {
                    memoryCache.removeObject(forKey: key as NSString)
                } else if let validValue = cachedWrapper.value as? T {
                    return validValue 
                }
            }
        }
        
        let data: Data? = concurrentQueue.sync {
            switch typeCache {
            case .keychain:
                return try? Keychain.load(key: key, service: service)
            case .userDefaults:
                return defaults.data(forKey: key)
            }
        }
       
        guard let validData = data,
              let expirableData = try? decoder.decode(ExpirableData<T>.self, from: validData) else {
            return nil
        }
  
        if expirableData.isExpired {
            remove(forType: typeCache, forKey: key)
            return nil
        }
       
        if typeCache != .keychain {
            let wrapperToRestore = MemoryWrapper(value: expirableData.value, expirationDate: expirableData.expirationDate)
            memoryCache.setObject(wrapperToRestore, forKey: key as NSString)
        }
        
        return expirableData.value
    }
    
    public func remove(forType typeCache: CacheType = .userDefaults, forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
       
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            switch typeCache {
            case .keychain:
                try? Keychain.delete(key: key, service: self.service)
            case .userDefaults:
                self.defaults.removeObject(forKey: key)
            }
        }
    }
}
