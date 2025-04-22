//
//  FavoriteViewModel.swift
//  CurrencyCalculator_BY
//
//  Created by iOS study on 4/22/25.
//  즐겨찾기 버튼 동작 로직

import Foundation
import UIKit
import CoreData

class BookmarkViewModel: ViewModelProtocol {
    enum Action {
        case updateBookmarks
    }
    
    struct State {
        var Bookmarks: [String] = []
    }
    
    var action: ((Action) -> Void)?
    var state: State = State()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // ===== LV 7. 즐겨찾기 상태 업데이트 =====
    func toggleBookmark(currencyCode: String) {
        if state.Bookmarks.contains(currencyCode) {
            removeBookmarks(currencyCode: currencyCode)
        } else {
            addBookmarks(currencyCode: currencyCode)
        }
        fetchBookmarks()
        action?(.updateBookmarks)
    }
    
    // ===== 즐겨찾기 추가 =====
    func addBookmarks(currencyCode: String) {
        let bookmark = BookmarkCurrency(context: context)
        bookmark.currencyCode = currencyCode
        saveContext()
    }
    
    // ===== 즐겨찾기 제거 =====
    func removeBookmarks(currencyCode: String) {
        let request: NSFetchRequest<BookmarkCurrency> = BookmarkCurrency.fetchRequest()
        request.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            let bookmarkes = try context.fetch(request)
            for bookmarke in bookmarkes {
                context.delete(bookmarke)
            }
            saveContext()
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
    
    // ===== 코어 데이터 저장 =====
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Faild to save context: \(error)")
        }
    }
    
    func fetchBookmarks() {
        let request: NSFetchRequest<BookmarkCurrency> = BookmarkCurrency.fetchRequest()
        
        do {
            let bookmarks = try context.fetch(request)
            state.Bookmarks = bookmarks.map { $0.currencyCode ?? "" }
            action?(.updateBookmarks)
        } catch {
            print("Failed to fetch bookmarks: \(error)")
        }
    }
}
