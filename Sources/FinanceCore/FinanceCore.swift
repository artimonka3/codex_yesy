import Foundation

public enum TransactionKind: String, Codable, CaseIterable, Sendable {
    case expense, income
}

public struct FinanceTransaction: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var amount: Decimal
    public var date: Date
    public var category: String
    public var kind: TransactionKind
    public var note: String?

    public init(id: UUID = UUID(), title: String, amount: Decimal, date: Date = .now, category: String, kind: TransactionKind, note: String? = nil) {
        self.id = id; self.title = title; self.amount = amount; self.date = date
        self.category = category; self.kind = kind; self.note = note
    }
}

public struct Budget: Identifiable, Codable, Hashable, Sendable {
    public let id: UUID
    public var category: String
    public var limit: Decimal
    public init(id: UUID = UUID(), category: String, limit: Decimal) { self.id = id; self.category = category; self.limit = limit }
}

public struct FinanceSummary: Sendable {
    public let income: Decimal
    public let expenses: Decimal
    public var balance: Decimal { income - expenses }
    public var savingsRate: Decimal { income == 0 ? 0 : (income - expenses) / income }
}

public enum FinanceCalculator {
    public static func summary(for transactions: [FinanceTransaction]) -> FinanceSummary {
        FinanceSummary(
            income: transactions.filter { $0.kind == .income }.reduce(0) { $0 + $1.amount },
            expenses: transactions.filter { $0.kind == .expense }.reduce(0) { $0 + $1.amount }
        )
    }

    public static func spent(in category: String, transactions: [FinanceTransaction]) -> Decimal {
        transactions.filter { $0.kind == .expense && $0.category == category }.reduce(0) { $0 + $1.amount }
    }

    public static func budgetProgress(_ budget: Budget, transactions: [FinanceTransaction]) -> Decimal {
        guard budget.limit > 0 else { return 0 }
        return spent(in: budget.category, transactions: transactions) / budget.limit
    }
}
