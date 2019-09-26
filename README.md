# fuxi（伏羲）
[![Build Status](https://drone.storezhang.imyserver.com:20443/api/badges/ruijc/fuxi/status.svg)](https://drone.storezhang.imyserver.com:20443/ruijc/fuxi)
统一账号中心，提供对外的账号服务


# 文档
[文档在这里](https://bookstack.storezhang.imyserver.com:20443/books/%E8%B4%A6%E5%8F%B7%E4%B8%AD%E5%BF%83)


# 目标
[![百度用户中心](https://bookstack.storezhang.imyserver.com:20443/uploads/images/gallery/2019-09/scaled-1680-/image-1567665244830.png)](https://bookstack.storezhang.imyserver.com:20443/uploads/images/gallery/2019-09/image-1567665244830.png)

上面这个图是[**百度用户中心**](https://passport.baidu.com/v2/?login)的截图，基本上这就是我们的用户中心的目标


# 基本需求
## 统一的用户中心
不用解释了，就是所有的用户都会跳到我们做的登录界面去登录（简单理解成OAuth，QQ那种）

## 支持用户注册
必须支持新用户的注册，注册可以使用邮件，也可以使用手机（手机可以后面面，但是预留扩展）

## 支持用户激活
默认注册的用户是未激活状态，只有通过激活后才能继续使用（待沟通）

## 支持邮箱登录
邮箱登录是第一登录顺序

## 支持绑定手机
方便用户后面的操作，比如忘记密码重置什么的

## 第三方登录

- **支持QQ登录**
- **支持微信登录**

## 支持网页跳转
类似QQ登录或者微信登录时的redirectUrl，通过url传递加密串，客户端完成跨域cookie写入等

## 支持其它方式登录
其它登录方式可以只留下接口（Restful或者其它类型皆可），我们这几号人搞不过来

- Android
- iOS
- 桌面