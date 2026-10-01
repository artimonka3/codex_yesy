import XCTest
@testable import FinanceCore

final class FinanceCoreTests: XCTestCase {
    func testSummarySeparatesIncomeAndExpenses() {
        let entries = [
            FinanceTransaction(title: "Salary", amount: 100_000, category: "Income", kind: .income),
            FinanceTransaction(title: "Coffee", amount: 250, category: "Food", kind: .expense),
            FinanceTransaction(title: "Rent", amount: 30_000, category: "Home", kind: .expense)
        ]
        let summary = FinanceCalculator.summary(for: entries)
        XCTAssertEqual(summary.income, 100_000)
        XCTAssertEqual(summary.expenses, 30_250)
        XCTAssertEqual(summary.balance, 69_750)
    }

    func testBudgetProgressAndZeroLimit() {
        let food = Budget(category: "Food", limit: 1_000)
        let transactions = [FinanceTransaction(title: "Lunch", amount: 400, category: "Food", kind: .expense)]
        XCTAssertEqual(FinanceCalculator.budgetProgress(food, transactions: transactions), 0.4)
        XCTAssertEqual(FinanceCalculator.budgetProgress(Budget(category: "Food", limit: 0), transactions: transactions), 0)
    }
}
