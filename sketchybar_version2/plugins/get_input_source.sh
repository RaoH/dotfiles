_SSDF_SB_INPUT_SOURCE=$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID)
case "${_SSDF_SB_INPUT_SOURCE}" in
  "com.apple.keylayout.Swedish-Pro") _SSDF_SB_KEYBOARD_LAYOUT="SE"
  ;;
  "com.apple.keylayout.US") _SSDF_SB_KEYBOARD_LAYOUT="US"
  ;;
  *) _SSDF_SB_KEYBOARD_LAYOUT="AZ"
esac

sketchybar --set "$NAME" label="${_SSDF_SB_KEYBOARD_LAYOUT}"
