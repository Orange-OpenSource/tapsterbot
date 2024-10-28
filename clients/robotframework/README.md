# robotframework folder

Here are elements defining [Robot Framework](http://robotframework.org/ "Robot Framework homepage") keywords to integrate into test cases.

## List of files
  - _config.robot_ The configuration file used in the one containing keywords
  - *tapster_keywords.robot* The file containing the keywords to integrate in your test cases, using the configuration file
  - *tapster_wrapper.robot* The wrapper using Tapster and Appium keywords to bring more abstraction for tests
  - *demo/tapster_demo.robot* Just a file with test cases using the keywords and the configuration defined in the other files.

## How to use the client
  1. Thirst you need to install on your computer these libraries so send HTTP requests (for the keywords) and use Appium (for the wrapper)
  ```shell
    pip install -U requests
    pip install -U robotframework-requests
    pip install robotframework-appiumlibrary 
  ```

## Note
 1. Here a the Robot Framework [user guide](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html "User guide")
 2. You may need to get the [robotframework-requests library](https://github.com/bulkan/robotframework-requests "GitHub of robotframework-requests")
 3. The installed version of _robotframework_requests_ library is **0.4.7**
 4. You will need also the [Appium library](https://github.com/serhatbolsu/robotframework-appiumlibrary "GitHub of AppiumLibrary for Robot Framework")
 5. The installed version of _Appium_ library for _Robot Framework_ is **1.4.3**
