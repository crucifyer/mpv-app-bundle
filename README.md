# mpv-app-bundle

* https://github.com/9beach/mpv-app-bundle 를 참조하여 제작했습니다.

## Installation

1. homebrew mpv 설치 후
2. mpv.app 폴더를 /Applications 에 복사해 넣으면 됩니다.
3. finder 에서 동영상 파일 > 정보 가져오기 > 다음으로 열기 에서 mpv 를 선택할 수 있습니다.
4. 브라우저에 mpv:// 로 링크가 걸리면 file:// 로 치환되어 실행됩니다.
5. mpv.conf input.conf 는 편의 설정이니 내용보고 적용할 지 판단하면 됩니다.

```bash
git clone https://github.com/crucifyer/mpv-app-bundle.git
cd mpv-app-bundle
cp -a mpv.app /Applications/
mkdir -p ~/.config/mpv
cp .config/mpv/* ~/.config/mpv/
cd ..
rm -rf mpv-app-bundle
```

