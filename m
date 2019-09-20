Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC12B8D2A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 10:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437863AbfITIsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 04:48:10 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43190 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437842AbfITIsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 04:48:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id u3so4441860lfl.10
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 01:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y/7i9K1tZS5+xr3+87PO17jvbv8mp/z4CCj1C0Jer/E=;
        b=DL25HkGw30/QdUJSaONkYA3IiIPMRsK8VIXze33GRtzdx5ic9pgUWjS7S+Iy1u+vNg
         0dsAvHBNzkLnLZ1mfzepD3JbjD1Maf18ESWm/0oNiA5WbtabT5EaUSzTnG9n6qPRD5ii
         icpuLqjvcNUThrcHrGQmQaGgFYIEFcAY9e321E1aKeYePjqTEdEk5JlKCJoUawNJVgtg
         ctLM6dVctZuZao8FHPSSQHmlJiUe8Vz1Npqu4HIO/cRU1T9mnUF28hgTrKLEIZe9mZw1
         9e5L6s43EkLcYagg4D9DuoodSefCFra158M3efUpKlJ5YgcB26QQHmFWMHLCpoO03gsf
         FfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y/7i9K1tZS5+xr3+87PO17jvbv8mp/z4CCj1C0Jer/E=;
        b=scRnOWERcuIhafwbJca5s/qtejrNUIywJBJIFICLrQh9IKfsX5VN+Xdy4nJFSH7O4t
         DB7jLn2Ov5YWvZMXv6SzWAKmAiPlwQhC0whprfL3ywGX0LUIVOfvbkGH62ZSjjB3kgeR
         siQsJz+dRhtnV05anjfSLeMnuDk2v8mV5OBr8W0OOOQCuKdSWyCXHCUhyMRTDLFpE8Dw
         Anf0nFbPO3WaeZjhtlcRYi7Y6fe4zin6UOzlktNZvGKT9rIPTnT6wDTCXcULB0SHPQBv
         JVLQGqC+WRIZZeXAuUYeG95idCFITrzR7mIih5qZEMIaDm4UUh626w52ZLHFX1cxe4iU
         dDuA==
X-Gm-Message-State: APjAAAWACwu+lfchMeBI1A9dSEXi0WRqKrK1V28hPoyL0+Jjws3zQXwM
        xt/fCqG7AhOrMkx61wKkYkXuZnO4wHFby2ZSS3vmGg==
X-Google-Smtp-Source: APXvYqwe+a1FVpGMIWST9JzUjmF86QIdKlSPk4QG0AYKcfw7Sf9H8TPMOzMivwscYxYRgFf/3qquHXeg8NBXCZ+VsmQ=
X-Received: by 2002:ac2:48af:: with SMTP id u15mr8303701lfg.75.1568969286980;
 Fri, 20 Sep 2019 01:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190919214755.852282682@linuxfoundation.org>
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Sep 2019 14:17:55 +0530
Message-ID: <CA+G9fYue5nON3nWM25PZGPC9UQfRPHoo5qnY5H1VORPQCFPF=g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/59] 4.14.146-stable review
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

On Fri, 20 Sep 2019 at 03:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.146 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 21 Sep 2019 09:44:25 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.146-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.146-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 981030d9563ce66bc738ff8fee0ed8c81922904b
git describe: v4.14.145-60-g981030d9563c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.145-60-g981030d9563c


No regressions (compared to build v4.14.145)


No fixes (compared to build v4.14.145)

Ran 22586 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* ltp-fs-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
