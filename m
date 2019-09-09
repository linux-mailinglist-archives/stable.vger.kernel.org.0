Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85693AD9DA
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbfIINTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 09:19:20 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37619 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730142AbfIINTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 09:19:19 -0400
Received: by mail-lj1-f194.google.com with SMTP id y5so1894568lji.4
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 06:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZGgBEktDuEpp437eI+l0oc8mQy/q7e53dFVNJhuHdZA=;
        b=Kz4YOqP7hIoJolzb/cciYYVNzLGH6bJKibJMDqWRs02yTaESM889lgQOhuIIzfM4KS
         S3/TG+Y9b6xRzM1CyHzYksvFI/u2uozMcGeWh0iSGlXKRoZ84Yo1ctmRx85eAmuUXnzR
         3CgAin4gVpzhGvEjnY3HymYHP7muHFs3AYLcbc1cX+ZiorsnVr3B/RjG/lQgeGEXAAw7
         kVlS1oEzQu2hgGaS7xw/XZRStllfVJPm0zKeSYJmalrv4zXgF+e1K8P+r8V58jbUuJQg
         Wj5ZS+B6EEVini1g7LRSAqoca8bwd/hpBJRahzTq9Q0stsovMNNCQOfavqBdJV72zSvC
         kzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZGgBEktDuEpp437eI+l0oc8mQy/q7e53dFVNJhuHdZA=;
        b=EOQFPkLHi7XGvUaQR4Vgi56qNm/eU8catz8tK7FQKpCUUXQEzW6OACIqz2i4YDqa2R
         8QvaKHvVBg95IIbdbWyzkpnQujYHMg0R6L//ewW2Qw6+VSudzhHQrW9cKnW5alM6yHPu
         dPIU1fogMFkW4AKuRKK3IuwsjWNl+Oa+8KEec+ME5jOsO1nkYqMVr1mP3rzhtjLvSFPI
         vx7vgDluy/PiaTLJyiOjP39Wbt3n2TtVx/XznLhlKn7dKM02KD/7blWobncrrUmbJ3KH
         1CWWqe+FGUPzNQFoKfQvBpuez3iPgj3A8i8RSbEFEJaQNtjMSmjY/z6px9BVqpbyGhuj
         D6qw==
X-Gm-Message-State: APjAAAVbuExjbsmDCd5JkojaxsRPoz26eAuEXoWRCRcI7gbl7P28GNET
        nHB3lQJZbfJRblIAzs1soH6/NSs5OGQCprrXu1D+Jg==
X-Google-Smtp-Source: APXvYqwycdIBfJUQfKG6M1oZLvzuKTW+SyPB5bL2yKCH/1F0PrVqCy2vDB4TxpNS1NyR5YCvLNjmJuxi37mVTELLD6M=
X-Received: by 2002:a2e:890d:: with SMTP id d13mr15918289lji.224.1568035157113;
 Mon, 09 Sep 2019 06:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190908121052.898169328@linuxfoundation.org>
In-Reply-To: <20190908121052.898169328@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 9 Sep 2019 18:49:06 +0530
Message-ID: <CA+G9fYuYNaCsfFFXmyv2OK0KycC29cw7OuX0eEWK=Vmv1Xe9tQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/23] 4.4.192-stable review
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

On Sun, 8 Sep 2019 at 18:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.192 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.192-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.192-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: fbce796fcbec98dc9e077846a5b7ba9c0f42d0cc
git describe: v4.4.191-24-gfbce796fcbec
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.191-24-gfbce796fcbec


No regressions (compared to build v4.4.191)


No fixes (compared to build v4.4.191)

Ran 18270 total tests in the following environments and test suites.

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

kernel: 4.4.192-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.192-rc1-hikey-20190908-552
git commit: 2bbf7053f847783ad819ce5cdbc4e30b361cf11a
git describe: 4.4.192-rc1-hikey-20190908-552
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.192-rc1-hikey-20190908-552


No regressions (compared to build 4.4.192-rc1-hikey-20190908-551)


No fixes (compared to build 4.4.192-rc1-hikey-20190908-551)

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
