---
tags:
  - iOS
  - Swift
note: 空视图状态
---

# 空视图状态UI组件 -- EmptyStateView

为了改进用户体验,当视图为空的时候我们需要提供占位信息来帮助用户理解当前App的状态.

1.有哪些情况可能导致视图为空?

1. 数据为空 
2. 无网络
3. 请求超时
4. 请求失败(原因太多)

使用枚举来表示这几种状态

```
enum EmptyState : Equatable {
    case loading
    case error(_ error : EmptyError)
    case success
    case emptyData
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading)       : return true
        case (.success, .success)       : return true
        case (.emptyData, .emptyData)   : return true
        case (.error(let l), .error(let r)) where l == r: return true
        case (.custom,.custom):return true
            case _: return false
        }
    }
}
```

![无网络连接](Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%202019-11-15%20at%2018.34.31.png)

这个库是我从真实项目中抽离出来的,因此可以满足不同种类的需求
