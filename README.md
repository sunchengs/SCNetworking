# SCNetworking
##NSURLSession简单封装网络请求框架 
1.使用Block进行回调

2.不支持文件的上传和下载

##用法
```
[[SCNetwork sharedSCNetwork] requestV2withParam:@{@"id":@"280552"} completionBlock:^(NSDictionary *dic){
        
        NSError *error;
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
            self.textview.text = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        });
    } failureBlock:^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity stopAnimating];
        });

        NSLog(@"%@",error.localizedDescription);
    }];
    ```
