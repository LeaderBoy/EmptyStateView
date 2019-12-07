---
tags:
  - iOS
  - Swift
note: 空视图状态
---



# 空视图状态UI组件 -- EmptyStateView

为了改进用户体验,当视图为空的时候我们需要提供占位信息来帮助用户理解当前App的状态.

## 有哪些情况可能导致视图为空?

1. 数据为空 
2. 无网络
3. 请求超时
4. 请求失败(原因太多)

使用枚举来表示这几种状态

```swift
enum EmptyError {
    case networkUnReachable
    case timeout
    case failed
}

enum EmptyState : Equatable {
    case loading
    case error(_ error : EmptyError)
    case emptyData
    case custom
    case success

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

除了定义上述几种状态以外还定义了success状态和custom状态
* custom : 展示你自己想展示的其他的状态.
* success :目的是移除状态的显示,也就是说在将要有数据的时候调用,后续会讲的更详细.

由于枚举中增加了参数`EmptyError`,因此此时枚举无法再进行`==`的比较,此时需要让`EmptyState`遵循`Equatable`协议,实现协议的方法,重写`==`运算符,告诉Xcode `EmptyState`在比较的时候什么时候是相等的.

## 视图为空的时候都要显示哪些数据?

我们常见的视图为空的时候比如没有网络了显示
* 无网络连接.jpg
* 请检查网络状态
* 点击重试

无数据显示
* 无数据.jpg
* 暂无数据

无评论的时候显示
* 沙发.jpg

![design_1](design_1.gif)

加载中显示
* 菊花
or
* 自定义的加载动画

![design_2](design_2.png)

因此需要显示的控件为`UIImageView` `UILabel` `UIButton`,加载中要显示的控件都放到`UIView`上,所以,需要放置这四种控件来满足需求.
另外从上面的分析来看,不同的状态下需要显示隐藏不同的控件,如果单纯的使用`Autolayout`来控制控件的显示和隐藏后的布局的话会非常的麻烦,因此使用自动调整布局的控件`UIStackView`,`UIStackView`可以根据控件的显示和隐藏自动的调整布局,Apple Document中也推荐更多的使用`UIStackView`.将这个控件命名为 `EmptyStateView`


## 如何根据不同的状态显示不同的数据?

模仿`UITableView`的使用方式,定义一个DataSource的数据源协议来提供数据

```swift
protocol EmptyStateDatasource : class {
    func emptyImage(for state : EmptyState) -> UIImage?
    func emptyTitle(for state : EmptyState) -> String?
    func emptyButtonTitle(for state: EmptyState) -> String?
    func emptyCustomView(for state: EmptyState) -> UIView?
    func emptyViewLayout(stackView : UIStackView,containerView : UIView, for state: EmptyState) -> EmptyStateLayout?
}
```


**注**: 当然,上面只是五个主要的协议[图,文,按钮,自定义,布局],实际上会增加比如文字的颜色/字体;按钮的/颜色/字体;布局的方式等等多种协议.

模仿`UITableView`的使用方式,定义一个Delegate的协议来用于点击事件调用

```swift
protocol EmptyStateDelegate : class {
    func emptyButtonClicked(for state: EmptyState)
}
```


模仿  `UITableView`给`UIView`添加属性 `dataSource`和`delegate`,同时添加一个私有的`EmptyStateView`用于显示数据


```swift
extension UIView {
    
    /// delegate for view
    var emptyDelegate: EmptyStateDelegate? {
        get {
            return objc_getAssociatedObject(self, &EmptyStateDelegateKey) as? EmptyStateDelegate
        }
        set {
            objc_setAssociatedObject(self, &EmptyStateDelegateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// datasource for view
    var emptyDataSource: EmptyStateDatasource? {
        get {
            return objc_getAssociatedObject(self, &EmptyDataSourceKey) as? EmptyStateDatasource
        }
        set {
            objc_setAssociatedObject(self, &EmptyDataSourceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
        
    private var emptyStateView : EmptyStateView? {
        get {
            return objc_getAssociatedObject(self, &EmptyStateViewKey) as? EmptyStateView
        }
        set {
            objc_setAssociatedObject(self, &EmptyStateViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
```

**注**:列表类型的界面经常使用这个功能,所以原打算给UIScrollView添加分类来实现这个功能,但是想想很多时候非列表界面,也就是普通的UIView也适用,因此决定扩展UIView而不是UIScrollView.

这样 `UIView`有了数据源,就可以根据不同的协议在`EmptyStateView`上显示不同的数据,而`EmptyStateView`是显示在调用的`UIView`上的.

接下来模仿`UITableView`的`reloadData`方法给`UIView`也添加一个类似的方法用于刷新不同的状态.

```swift
extension UIView : EmptyStateDatasource {
    /// refresh with current state
    /// - Parameter state: current state
    func reloadState(_ state: EmptyState = .success) {
        // prevent main thread checker error
        DispatchQueue.main.async {
            if self.emptyDataSource != nil {
                if state == .success || (self.isScrollView() && self.items() != 0) {
                    self.remove(for: state)
                }else {
                    self.emptyLayout(for: state)
                }
            }else {
                fatalError("\(self) emptyDataSource must not be nil")
            }
        }
    }
}
```

当你调用`reloadState(.success)`的时候会移除`EmptyStateView`的显示,也就意味着此时应该显示真正的数据了.或者当调用的视图为UITableView或者UICollectionView的时候会先查看数据源是否有数据,有的话也会移除`EmptyStateView`的显示.

**!important**
当需要显示真正的数据的时候一定要调用`reloadState(.success)`.

## 如何使用这个库?

非常简单

1.  给`EmptyStateDatasource`提供一个默认的实现,[Demo中的EmptyStateDefault.swift](https://github.com/LeaderBoy/EmptyStateView)文件演示了这一点.
2. 让需要显示的view遵循协议`view.emptyDataSource = self`
3. 需要显示什么状态显示什么状态`view.reloadState(.loading)`


####  提供默认实现什么意思,为什么没有提供默认实现?

* 首先由于Swift的协议默认都是`required`的,这点和OC不同,因为OC有关键词`@required`和`@optional`.
* 比如无网络,不同的App就会显示不同的图和不同的描述,这样提供默认就没有了意义.

## 这个库有什么好处?

如果你用过OC版本的库比如[DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet),首先它没有各种状态的切换,其次它需要为每个界面配置数据源,也就是每个界面遵循协议实现协议方法(这太麻烦了),更重要的是比如没有网络,你可能需要显示的图/描述/按钮都是一样的,但是需要在很多界面写很多相同的代码.

但是当你使用这个库的时候,首先是实现`EmptyStateDatasource`协议,配置许多默认的数据源,比如没有网络的描述等.比如这样配置默认的描述

```swift
extension EmptyStateDatasource {
    func emptyTitle(for state: EmptyState) -> String? {
        switch state {
        case .error(let e) :
            switch e {
            case .networkUnReachable:
                return "当前网络不可用,请检查网络设置"
            case .timeout:
                return "请求超时"
            case .failed:
                return "加载失败"
            }
        case .emptyData:
            return "暂无数据"
        case .custom,.loading,.success:
            return nil
        }
    }
}
```


当任意一个界面想要显示这个数据源的时候,你需要做的就是遵循协议
```swift
extension ViewController : EmptyStateDatasource {}
```
`view.emptyDataSource = self`,
刷新当前状态
`view.reloadState(.error(.networkUnReachable))`
就这么简单.

为了更简单我提供了一个便利方法
```swift
// convenience method for reloadState(.error)
func errorReload( _ error : Error) {
    if error.isNotConnectedToInternet() {
        reloadState(.error(.networkUnReachable))
    }else if error.isTimeout() {
        reloadState(.error(.timeout))
    }else {
        reloadState(.error(.failed))
    }
}
```

只需调用`view.errorReload(error)`,会根据error自行判断类型.


更开心的是当某个界面需要显示自定义的描述的时候,比如大部分都显示的是**暂无数据**但是这个界面想要显示**暂无收藏**,那么你需要做的就只是在这个界面实现如下协议方法,此时`emptyTitle`不会执行默认的数据源,会执行你实现的数据源

```swift
extension ViewController : EmptyStateDatasource {
    func emptyTitle(for state: EmptyState) -> String? {
        switch state {
        case .error(let e) :
            switch e {
            case .networkUnReachable:
                return "当前网络不可用,请检查网络设置"
            case .timeout:
                return "请求超时"
            case .failed:
                return "加载失败"
            }
        case .emptyData:
            return "暂无收藏"
        case .custom,.loading,.success:
            return nil
        }
    }
}
```

因此这个库既具备默认功能又具备自定义功能,它能满足你的大部分需求,更多功能可以查看其他的协议方法.

#### 如何判断无网络?
其实为什么单独讲这个,首先我的实现是将Error 转成NSError,如下

```swift
extension NSError { 
    func isNotConnectedToInternet() -> Bool {
        return self.code == NSURLErrorNotConnectedToInternet
    }
}
```

但是当我使用[Moya](https://github.com/Moya/Moya)这个网络请求库的时候,`isNotConnectedToInternet`不再正确,但是没有关系,其实很简单你需要做的就是提供一个对Error的扩展,意思就是当传递的Error为MoyaError类型的时候走如下的实现.
```swift
extension Error where Self == MoyaError {
    func isTimeout() -> Bool {
        switch self {
        case .underlying(let error as NSError, _):
            return error.isTimeout()
        default:
            return false
        }
    }
    
    func isNotConnectedToInternet() -> Bool {
        switch self {
        case .underlying(let error as NSError, _):
            return error.isNotConnectedToInternet()
        default:
            return false
        }
    }
}
```


#### 还有更多的好处吗?
有,这个库是我从真实项目中抽离出来的,因此可以满足不同种类的需求
比如列表的加载我们想显示成如下这样,但是其他界面加载显示菊花

![list_loading@2x 2](list_loading@2x%202.png)

假设默认情况下`emptyCustomView`为显示菊花,我们只需定义一个新的协议

```swift
extension EmptyStateDatasource where Self : ListLoading {
    func emptyCustomView(for state: EmptyState) -> UIView? {
        if state == .loading {
            // 骨架占位图
            let image = UIImage(named: "list_loading")!
            let imageView = UIImageView(image: image)
            let loading = DetailLoading()
            loading.show()
            let superView = UIView()
            superView.addSubview(imageView)
            superView.addSubview(loading)
            imageView.edges(to: superView)
            loading.center(to: superView)
            superView.backgroundColor = .clear
            return superView
        }
        return nil
    }
}

protocol  ListLoading : class {}
```

谁想显示这个占位图,除了遵循`EmptyStateDatasource`协议,只需再遵循`ListLoading`协议,谁遵循谁就会显示成上图样式,谁不遵循谁就会显示成菊花样式,就这么简单.无论有多少界面,你需要做的就只是遵循协议.

## 说了那么多它可以长什么样?

![屏幕录制](%E5%B1%8F%E5%B9%95%E5%BD%95%E5%88%B62019-11-17%E4%B8%8B%E5%8D%8811.18.54.2019-11-17%2023_39_11.gif)


Enjoy 