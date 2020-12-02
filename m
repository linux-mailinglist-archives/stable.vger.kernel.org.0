Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAF02CB43C
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 06:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgLBFMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 00:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgLBFMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 00:12:36 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C830DC0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 21:11:50 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id f16so551295otl.11
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 21:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T6tK09CTMF8DpkdCu4eHvVSCjrhIKh1EGtQIJ5HMvFI=;
        b=N+fXQKTWhXfnFHo0kLh2BTfHeig2UuNuLOVya2mk+YpycQCXqhWTGDavk8piTdzpwV
         Nfdf9O98/U/+cAKkl6y+urAIMDIyXP/kHUQVfSMeO2sIxLKteaa1XNsX9+Hqzoq9Q8a4
         rznsDqzIhhZGeDyC5KFu0XHgmoxaGWPO32ZsfHYS88tlIRelFA6gt8dmfgyOlbfCwmkN
         8RkHdR0OS0CfFbrh7+cxMOT0S2OTfO7pP88UJovhw5k62kqDancJD2XjkCosIHuUGe5w
         +/xN9lCkqih0HxRJRvrjlvrhpz9Oh7kakJQrNQjynl3mQs7VDtQWsvgmT0RTvbBAyG1K
         h7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T6tK09CTMF8DpkdCu4eHvVSCjrhIKh1EGtQIJ5HMvFI=;
        b=ZS+BNAHOgX3Qt06wq/7IZOcvviHImpee1/F/UPSIQYPJRsAaOrcQz5eIPfnhRSplVE
         /cucJwOdPoS2buDhcIQ8vy+StKzoJb3oT8SYY2TWlUdp8KGnxrKjL+jLIwKf3ghpa7vN
         Zog8+cz4y1gyqwIwpm/SaE1piv2TGUzJ4b1ZmSfHnWXHiz/WMRm8CE6saNRliXVHkiJm
         KIjMnL2yzuuK/S+Rv1buU07p6D2gYyhrIUfgM2t1WdR80+OKNChEtmgKU6WGod1j4vaA
         2WKXvNdGbcqX0KRTY0BbJ4453CU9myxX8KN6Wh9dHpMwhh2G3ypXcJxkYWqnafeZXKm6
         Jmnw==
X-Gm-Message-State: AOAM532esIcdamc+wn/Dcru/09TSjRLspXm+BfC2VxAINBxaprkSywad
        gk7wPaiaoRW0yhbSxIanI6Mim7mM0koY1mM8+uunwQ==
X-Google-Smtp-Source: ABdhPJwfkY+m8eJBbpnNWZpTnReC5yYiV4sW6rUw5oG5NV4PFZXCGpZzUgJ3COv7IgN1whI5GvhXanZBbsP8EMVWYfY=
X-Received: by 2002:a05:6830:12d5:: with SMTP id a21mr640726otq.281.1606885910020;
 Tue, 01 Dec 2020 21:11:50 -0800 (PST)
MIME-Version: 1.0
References: <20201201084647.751612010@linuxfoundation.org>
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 10:41:38 +0530
Message-ID: <CA+G9fYuu+F0tGukW_SwHi7BUWoEe0bezWr9h2v2bwUpjNh+2vA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.161-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Dec 2020 at 14:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.161 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.161-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
While running CPU hotplug testing on arm64 db410c device the following
kernel warning was noticed on linux stable-rc 4.19 branch several times.
WARNING: kernel/workqueue.c:4762 workqueue_online_cpu+0x18c/0x428
https://lore.kernel.org/stable/CA+G9fYu+KK=3Dhm1AmQ78GCCgQTwsRCzyA6WHYR68oz=
ZBzp7USiA@mail.gmail.com/

Summary
------------------------------------------------------------------------

kernel: 4.19.161-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 8d3deb1adb93c5d5ff713e5cf5026cacd87a9404
git describe: v4.19.160-58-g8d3deb1adb93
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.160-58-g8d3deb1adb93

No regressions (compared to build v4.19.160)

No fixes (compared to build v4.19.160)

Ran 46759 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
