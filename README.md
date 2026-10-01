# FinanceFlow

A polished SwiftUI personal-finance app concept for iOS 17+. It includes:

- At-a-glance balance, monthly income/expenses, recent activity, and a visual spending plan.
- Searchable and filterable transaction history plus a fast add-transaction workflow.
- Category budgets with live progress, overspend states, and simple budget creation.
- An Insights tab with a money score, expense chart, and proactive finance suggestions.
- A small, independently testable `FinanceCore` package containing transaction, budget, and calculation logic.

## Open in Xcode

This repository includes an [XcodeGen](https://github.com/yonaskolb/XcodeGen) manifest. With XcodeGen installed, run:

```bash
xcodegen generate
open FinanceFlow.xcodeproj
```

Then select an iOS 17+ simulator and run the `FinanceFlow` scheme. The project intentionally uses only Apple frameworks; no third-party dependencies are required.

## Test the domain logic

```bash
swift test
```
