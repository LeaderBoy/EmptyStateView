> **!important**
> 当需要显示真正的数据的时候一定要调用`reloadState(.success)`.

## 如何使用这个库?

1. 通过cocoapods安装这个库 `pod 'ANDEmptyState'`
2. 提供默认的数据源比如断网的描述等等,可参考[Demo中ExampleDefault的实现](https://github.com/LeaderBoy/EmptyStateView)
3. 让需要显示的view遵循协议`view.emptyDataSource = self`
4. 需要显示什么状态显示什么状态`view.reloadState(.loading)`
