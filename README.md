# IOSMediaFileUtils
An IOS tool class that contains several operations on video and image.

---
###Functions:(consistently updated)
* `+ (void) SaveFileAtCurrentTime:(NSURL *)fromUrl`
*This function allows you to remove a file to a new file named with the current time(you can change the extend name .mp4)

* `+ (NSURL*) SaveImageAtCurrentTime:(UIImage*)image`
*Save a image named with the current time

* `+ (void) mergeTwoVideo:(NSURL *)url1 anotherURL:(NSURL *)url2 toURL:(NSURL *)tourl`
*You can merge two videos to one (url1 is the earlier video, and url2 is the later one in the merged video)

* `+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL;`
*You can change the video's quality using this function

* `+ (void)convertToMp4:(NSURL*)inputURL outputURL:(NSURL*)outputURL`
*Convert the `.mov` to `.mp4`
