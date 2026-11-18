property candidates : {"/opt/homebrew/bin/mpv", "/usr/local/bin/mpv"}

on open location theURL
	set target to theURL
	if target starts with "mpv://" then
		set target to "file:///" & (text 7 thru -1 of target)
	end if
	my playItem(target)
end open location

on open theItems
	repeat with f in theItems
		my playItem(POSIX path of f)
	end repeat
end open

on playItem(target)
	set mpvBin to my findMpv()
	if mpvBin is missing value then
		display alert "mpv 를 찾을 수 없습니다" message "brew install mpv 로 설치하세요."
		return
	end if
	set cmd to "nohup -- " & quoted form of mpvBin & " --player-operation-mode=pseudo-gui " & quoted form of target & " > /dev/null 2>&1 &"
	do shell script cmd
end playItem

on findMpv()
	repeat with p in candidates
		set pth to contents of p
		if (do shell script "test -x " & quoted form of pth & " && echo 1 || echo 0") is "1" then return pth
	end repeat
	return missing value
end findMpv
