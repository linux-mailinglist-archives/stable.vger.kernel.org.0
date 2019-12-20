Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD712766E
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 08:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfLTHXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 02:23:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45407 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfLTHXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 02:23:10 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so6198040lfa.12
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 23:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rola18/NrFdJZewc5vu51EWvXO4VwEoKDPAbPVAT1mM=;
        b=Xj9kQjuZ2M59HRg/FQrsvfp48n4qROD5ZIqQt6F3fwXyFmyeYOyLHaStEfXc1X3kHY
         DN1jf5O/ee/Dak3LtRUu10bz+Vrp1/16m08XnG16G8jHiXwcHTFii0Pbkx9A0rRUlwrd
         /bVso1MvWt3eO0N4wfZ78qv+pedBorKgG4zr31wP5cbUHfe6dHVfBf3XwxJ1c6Q/lv5o
         VTycGvb8bR8QLpXZAS5pXHMPSVxFO+4VrX5PAAFtgZJef1L2iaZLjAUJO+Vfw/r1+WPx
         S+MN43HqQo+IzlF8bGCSbrBLDFnyOUA8TsfAG3z4sWQ/5WhRcdlNZx5avippvhh1P8IU
         xUhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rola18/NrFdJZewc5vu51EWvXO4VwEoKDPAbPVAT1mM=;
        b=l2cjm0L3XCfDSbdZY/o5DQjYijUT0SngxhF2WHaXyPiiG99GOFDp/0yRKK45WQ6oMn
         jgdqVRo8wmOeXd40X9G+vDRZ85ShPtYwN13t9dnR6xXCSw9BAbVDWsFKD9n9Xmrdd4Kh
         1drxU8UJ/xESCi7QgWAMHfipuFlT+eFZcU/Xm1NhUP9DZb3pSZlOg7jka3zv8tcpSiIG
         yB482Vc2Ng1Nf5C15O/C0LXdMPhUi22oNZV77tA3e4wGm/CG0NQSz0kKSlWf9W++4dlT
         lI41W+amhYuCGOJ/4i7j6Ul9VxVsk/KHG/Llag0C7loKOCcZvFvk+6Y9yv6P0kNJPJFD
         +KRg==
X-Gm-Message-State: APjAAAXnqNH0/eijsxM0bUJLOdsudgSJEeVy4wceMM5KVzXGcWr4OAfT
        D/C3JpQ/loShQYAuARQPUncX08FEYqCVBKmCRJSH0w==
X-Google-Smtp-Source: APXvYqwU200PuZWOY1N7qZ+qxPbbDgWRMaEGaQ0S0rLSvBxL1aKQrvkhcX7mZm/5S5BVpZbmKG5QX2593mU+gbFilik=
X-Received: by 2002:ac2:54b4:: with SMTP id w20mr8072025lfk.67.1576826588235;
 Thu, 19 Dec 2019 23:23:08 -0800 (PST)
MIME-Version: 1.0
References: <20191219183031.278083125@linuxfoundation.org>
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Dec 2019 12:52:56 +0530
Message-ID: <CA+G9fYtsFr-tmw5jAfYgrrjzo794YaouEBXXj1fE_UH3U9MaxQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Dec 2019 at 00:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.6 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.6-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 2929dbca18dbbf1701d1865564362a9c342b71d1
git describe: v5.4.5-81-g2929dbca18db
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.5-81-g2929dbca18db

No regressions (compared to build v5.4.5)

No fixes (compared to build v5.4.5)

Ran 23063 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
