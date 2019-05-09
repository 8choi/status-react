{ xcodeWrapper }:

let
  _xcodeToolsReportScript = ''
    export RED='\033[0;31m'
    export NC='\033[0m'
    echo -e "$RED- There are some required tools missing in the system:"
    if [ $xcode -eq 0 ]; then
      echo -e "$NC  - $RED[ ] Xcode"
    else
      echo -e "$NC  - $GREEN[x] Xcode$RED"
    fi
    if [ $iPhoneSDK -eq 0 ]; then
      echo -e "$NC  - $RED[ ] iPhone SDK"
    else
      echo -e "$NC  - $GREEN[x] iPhone SDK$RED"
    fi
  '';
  enforceXCodeAvailable = ''
    xcode=0
    iPhoneSDK=0
    export PATH=${xcodeWrapper}/bin:$PATH
    xcrun xcodebuild -version && xcode=1
    [ $xcode -eq 1 ] && xcrun --sdk iphoneos --show-sdk-version && iPhoneSDK=1
    if [ $xcode -eq 0 ]; then
      ${_xcodeToolsReportScript}
      echo -e "Please install Xcode from the App Store.$NC"
      exit 1
    fi
  '';
  enforceiPhoneSDKAvailable = ''
    xcode=0
    iPhoneSDK=0
    export PATH=${xcodeWrapper}/bin:$PATH
    xcrun xcodebuild -version && xcode=1
    [ $xcode -eq 1 ] && xcrun --sdk iphoneos --show-sdk-version && iPhoneSDK=1
    if [ $iPhoneSDK -eq 0 ]; then
      ${_xcodeToolsReportScript}
      if [ $xcode -eq 1 ]; then
        echo -e "Please install the iPhone SDK in Xcode.$NC""
      else
        echo -e "Please install Xcode from the App Store, and then the iPhone SDK.$NC""
      fi
      exit 1
    fi
  '';

in {
  inherit enforceXCodeAvailable
          enforceiPhoneSDKAvailable;
}