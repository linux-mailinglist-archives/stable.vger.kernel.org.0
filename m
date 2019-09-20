Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DDBB92CF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392278AbfITOfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:35:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37337 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392245AbfITOfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:35:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id l21so7336566lje.4
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 07:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eG22Ig92s9S2RpEdkwbdrlgv61I8kOdAsevuATPJuW0=;
        b=M+dIEX1A1BUBkYJA1NaxJ/Dk2bIogH7/IXqkD+bsjRIAP5Q/NfQY+4ioQzsks3M50H
         dOei4m7tZlMlbOys6pa4LtIZG3xCYxjpVRABHzjhWsZZZ2XCJbPhXCr9NcLVDGEprgFY
         871TvpCmF/jn5UlvAU/vABDPyngphH4JAR52q4N5yynRqZiH1irAoTsWcApL8KjpM5dt
         MFAjnJuBGvM8o9Ran1MsxZmqxJx51GXg+Z6r0g5QEqpYn3wEyU32Jmp3e9J0eEJIX0/3
         uXl0Qht/UJ1DBjSRq5Xs2teffcUbd2MWTrLzgp5ZMJyQnaudaOj4OgRUI0nxzh5w2HoL
         qq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eG22Ig92s9S2RpEdkwbdrlgv61I8kOdAsevuATPJuW0=;
        b=Bp8USMH1jp0WaQ/AhyKwwM5HaMUUeRYTcZ+Hn4CP0T0/jCmW7iccFIdtLoQR35gMrZ
         Pjjax7+qzV6AVe3+yZrrunS7Oeqxwn8RKeM8YJXycdH2Ub8zgV88MNmnhodxKM13pZmO
         r8KxSogqpuQj9d8nIVOKwZcQjwTWG9T5hY///jDkxSgMHKHy6AbcnUtNRTFqrU2Ol7Vu
         l7KLGASaZNekoegBnJOOTFO4AAWp8ID2XNsxosxGMu4322PMlxzy0AjjxuiUDMlFkBAe
         ZjIKZkPB5qv3KOZj9+MAbNsPaOJUnnzDcjPXQQYZs716WejvsgeckFI7xN6OIDzBeRAm
         GN2w==
X-Gm-Message-State: APjAAAWd1BFWbnytYN7HidLojlkvaO2AJvp/keVJPR+iqEGsQM7B50yg
        wYdN0LV7ZUFEyP16N2lUIfTEXFoaHRmmw9/H+8qYhg==
X-Google-Smtp-Source: APXvYqxjZdaEJHiesNudzb/xRj2ojfaKoLXXiZW/EaP49yDX6YJ7yd0ufgwj155iS+tSV73tLx10YthVy1iTsH2UVqI=
X-Received: by 2002:a05:651c:150:: with SMTP id c16mr9382369ljd.224.1568990135917;
 Fri, 20 Sep 2019 07:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190919214742.483643642@linuxfoundation.org>
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Sep 2019 20:05:24 +0530
Message-ID: <CA+G9fYstC9ffib=UGGtKPA7HVgSo4m6C6-fLk68cnmZwtC81vg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/56] 4.4.194-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Sep 2019 at 03:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.194 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.194-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.194-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 7b679e1a966bc6ac22d75cae76b97a9fded9367d
git describe: v4.4.193-57-g7b679e1a966b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.193-57-g7b679e1a966b

No regressions (compared to build v4.4.193)

No fixes (compared to build v4.4.193)

Ran 19960 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.194-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.194-rc1-hikey-20190919-563
git commit: 8d201bfa44c8dc5d61d57c89ac925d6e1fefaeae
git describe: 4.4.194-rc1-hikey-20190919-563
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.194-rc1-hikey-20190919-563


No regressions (compared to build 4.4.194-rc1-hikey-20190918-561)


No fixes (compared to build 4.4.194-rc1-hikey-20190918-561)

Ran 1536 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
