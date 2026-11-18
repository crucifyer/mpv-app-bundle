#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="$HERE/mpv-wrapper.applescript"
APP="/Applications/mpv.app"
PLIST="$APP/Contents/Info.plist"
PB=/usr/libexec/PlistBuddy
LSREG=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

setkey() {
  local key="$1" type="$2" value="$3"
  if "$PB" -c "Print $key" "$PLIST" >/dev/null 2>&1; then
    "$PB" -c "Set $key $value" "$PLIST"
  else
    "$PB" -c "Add $key $type $value" "$PLIST"
  fi
}

ensure() {
  local key="$1" type="$2"
  "$PB" -c "Print $key" "$PLIST" >/dev/null 2>&1 || "$PB" -c "Add $key $type" "$PLIST"
}

rm -rf "$APP"
osacompile -o "$APP" "$SRC"

"$PB" -c "Delete :CFBundleURLTypes" "$PLIST" 2>/dev/null || true
"$PB" -c "Delete :CFBundleDocumentTypes" "$PLIST" 2>/dev/null || true

setkey ":CFBundleIdentifier" string "com.local.mpv-wrapper"
setkey ":CFBundleName" string "mpv-wrapper"
setkey ":LSUIElement" bool "true"

ensure ":CFBundleURLTypes" array
ensure ":CFBundleURLTypes:0" dict
setkey ":CFBundleURLTypes:0:CFBundleURLName" string "mpv"
ensure ":CFBundleURLTypes:0:CFBundleURLSchemes" array
setkey ":CFBundleURLTypes:0:CFBundleURLSchemes:0" string "mpv"

ensure ":CFBundleDocumentTypes" array
ensure ":CFBundleDocumentTypes:0" dict
setkey ":CFBundleDocumentTypes:0:CFBundleTypeName" string "Video"
setkey ":CFBundleDocumentTypes:0:CFBundleTypeRole" string "Viewer"
setkey ":CFBundleDocumentTypes:0:LSHandlerRank" string "Alternate"
ensure ":CFBundleDocumentTypes:0:LSItemContentTypes" array
i=0
for uti in public.movie public.mpeg-4 com.apple.quicktime-movie public.avi; do
  setkey ":CFBundleDocumentTypes:0:LSItemContentTypes:$i" string "$uti"
  i=$((i+1))
done

xattr -cr "$APP"
codesign --force --deep --sign - "$APP"

"$LSREG" -f "$APP"

echo "빌드 완료: $APP"
echo "Finder 에서 동영상 우클릭 > 다음으로 열기 > mpv.app 선택 > '모두 변경'으로 기본 연결 설정"