Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42C9AD19B
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 03:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbfIIBgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 21:36:11 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36249 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732086AbfIIBgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 21:36:11 -0400
Received: by mail-lf1-f67.google.com with SMTP id x80so9158675lff.3
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 18:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AUXPSryoR9Ovge+Ogqou3wj2iUO5bdBHn/e+HxdquHM=;
        b=BeXc/NQAwWsboL6AaYcFD95VvsgcWGn69i2Gk83rE5OOZ2/jaMFMVaKoVb0ZwVp3wQ
         HmH4UQJv2eaKZhByY+KiAj4vNVUTUasJ8Va9rDgkJCpQOlPSenjhcOwABtuvxw2HlASa
         3RoPfrcMWcEUEQ/RrGyyzpTXc5Ph8pfMtI9i676AmyAyyK7W0aG4boIO7RSUqIlWl07g
         V7cSqrEmth9REUXM7vPbjmHYHtZEpSeOyyKd1y4gR6ETKKwGQ4SdXCPVLKvloSWZlyoE
         aoYDIYcG6H5qWkNG/4oz/osCqrZ47Esdsd8gQvqgpdtO/A/7b3ONEnA9hOC3lZIzqv5S
         e40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AUXPSryoR9Ovge+Ogqou3wj2iUO5bdBHn/e+HxdquHM=;
        b=mmP+qdeMX8Zx15Z+qJSlvo84oL8xP7vzTaL3AHy2ltbO+MmFJttei/dgs92leGcjEo
         4V2ntf55PFIdBEWq7wXDCYjBli2wNt0NPawCY8J4FNvcYz+riWdhET4UWg9AKR4g0UKQ
         Jg+WpSlGx1Dg4XL8uIIF0eAGXzj2OYjFf36ZnRC6uh2jFr9HZ7WPm4ULe4bF7W3rO+hN
         xyGjvnciFaErt6azPmFOr8IT3Be+Fa8d1pNYnAWtt6Y1lHqqYodhc0Y3pS1/eHx0JjpS
         47zVs4YDX+wdy7AtyyzKp1f3GMCE0tw2KliseHCy7iXCLBx8nuPmujXxmjqw59jlcZub
         jZ9w==
X-Gm-Message-State: APjAAAWUrFOWSRV3pGb9N7+eC/1ZsBp0ZgaVGQ6uusRPr8LUZ1UVeKhr
        4YuTrup9ij77UIP2aS+HNcvEGc+4pbfjLpS9lv5FJQ==
X-Google-Smtp-Source: APXvYqxK/6TBTJJ7cJRWJn5rk/X0VyG+u13J1NT3d9dYaIXhI025xpA/wDFjPYHBBNiOtNil/ml9ZKkupaSBBnBbSQM=
X-Received: by 2002:ac2:54aa:: with SMTP id w10mr15017549lfk.67.1567992969802;
 Sun, 08 Sep 2019 18:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190908121114.260662089@linuxfoundation.org>
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 9 Sep 2019 07:05:58 +0530
Message-ID: <CA+G9fYtH-sTYXXLOiPcqy834+rPQTy83XWcSbX1FzKwj48SQ1w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/40] 4.14.143-stable review
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

On Sun, 8 Sep 2019 at 18:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.143 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.143-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.143-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 9ea9c62091b32680f7e107f593241ab0edd80f81
git describe: v4.14.142-41-g9ea9c62091b3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.142-41-g9ea9c62091b3

No regressions (compared to build v4.14.142)

No fixes (compared to build v4.14.142)

Ran 23700 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
