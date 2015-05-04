# uexScrollPicture 轮播图接口文档







##API
***
### 1.新建一个轮播图


```
createNewScrollPicture(param)
var param={
	interval;//自动滚动的间隔时间，单位为毫秒，默认3000
	anchor;//float数对[X,Y] 轮播图的左上角锚点的坐标
	height;//轮播图高度
	width;//轮播图宽度
	urls;//List<String> 的json字符串
	viewId;//轮播图id
};


```

### 2.开始图片轮播

```
startAutoScroll(param);
var param={
	viewId;//轮播图id
};
```


### 3.停止图片轮播
```
stopAutoScroll(param);
var param={
	viewId;//轮播图id
};
```

### 4.删除view
```
removeView(param)
var param={
	viewId://轮播图id
}
```

### 5.轮播图点击事件

```
onPicItemClick(param)
var param={
	index:,//第几个图片被点击，从0开始
	viewId://轮播图id
}
```