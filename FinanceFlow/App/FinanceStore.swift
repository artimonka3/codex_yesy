import Foundation
import SwiftUI

final class FinanceStore: ObservableObject {
    @Published var transactions: [FinanceTransaction] = DemoData.transactions
    @Published var budgets: [Budget] = DemoData.budgets
    @Published var selectedPeriod = "This month"

    var summary: FinanceSummary { FinanceCalculator.summary(for: transactions) }
    func add(_ transaction: FinanceTransaction) { transactions.insert(transaction, at: 0) }
    func addBudget(category: String, limit: Decimal) { budgets.append(Budget(category: category, limit: limit)) }
}

enum DemoData {
    static let transactions = [
        FinanceTransaction(title: "Salary", amount: 145_000, date: .now.addingTimeInterval(-86_400 * 2), category: "Income", kind: .income),
        FinanceTransaction(title: "Groceries", amount: 3_840, date: .now.addingTimeInterval(-86_400), category: "Food", kind: .expense),
        FinanceTransaction(title: "Netflix", amount: 799, date: .now.addingTimeInterval(-86_400 * 3), category: "Subscriptions", kind: .expense),
        FinanceTransaction(title: "Taxi", amount: 620, date: .now.addingTimeInterval(-86_400 * 4), category: "Transport", kind: .expense),
        FinanceTransaction(title: "Freelance", amount: 18_500, date: .now.addingTimeInterval(-86_400 * 5), category: "Income", kind: .income)
    ]
    static let budgets = [Budget(category: "Food", limit: 18_000), Budget(category: "Transport", limit: 6_000), Budget(category: "Fun", limit: 8_000)]
}
