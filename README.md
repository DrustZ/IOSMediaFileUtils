# IOSMediaFileUtils
An IOS tool class that contains several operations on video and image.

---
###Functions:(consistently updated)
1. `+ (void) SaveFileAtCurrentTime:(NSURL *)fromUrl`
<br>This function allows you to remove a file to a new file named with the current time(you can change the extend name .mp4)

2. `+ (NSURL*) SaveImageAtCurrentTime:(UIImage*)image`
<br>Save a image named with the current time

3. `+ (void) mergeTwoVideo:(NSURL *)url1 anotherURL:(NSURL *)url2 toURL:(NSURL *)tourl`
<br>You can merge two videos to one (url1 is the earlier video, and url2 is the later one in the merged video)

4. `+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL;`
<br> You can change the video's quality using this function

5. `+ (void)convertToMp4:(NSURL*)inputURL outputURL:(NSURL*)outputURL`
<br> Convert the `.mov` to `.mp4`

6. `+ (UIImage *) imageWithView:(UIView *)view`
<br> Convert `UIView` to `UIImage` and maintains the transparency of the `UIView`'s background setting.

7. `+ (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage`
<br> Overlay the second Image on the first one.
