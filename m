Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5182A5E9A
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 08:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgKDHNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 02:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgKDHNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 02:13:00 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60E2C0401C1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 23:12:59 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id i19so17263228ejx.9
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 23:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wg60tjtctfZ7oqTIPXWuKb6lWF4Baeks51n8od47Pnw=;
        b=pRCeEDGnR7R7WoV3ZYdcEYzFRLXNolNjWW/Uz+57n2xAdCvARc+lrTI2SpZ4Q8wXVd
         L9vwfTUnuqLYkrubxpbwtlsMms6ZM0Q0q/d0sG+UcR3gu39wdh/yAv53ljBV+BWuYxCx
         BxoaQ75I9qtR103fcBjnbfm/Vwx0dI8JqvHnBLkK2jl262ocOagZ+177ntG2s7ZKZa7K
         BAcCb2wampldFclG++67O8LQ7LZChO0jZTkLR4QOax/idOg+FhIeoShmUTV+lxNTycVj
         Ad0fZQ4sveTpYYp0o8eMtEr9b0iEW6iws7FikWThOO/NsyBXmsZDQ1hifEB1CgfAu98c
         rMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wg60tjtctfZ7oqTIPXWuKb6lWF4Baeks51n8od47Pnw=;
        b=DZ4JkJH7SRJkgexgoA5uq3EJQKmx36tTsijhc7ylSm+CeMyReozjoRKtme2sViAIX0
         d5Hd+/gFavAedR6m0Aue2f7NUaeJIanNIVmOmvVJV0JfZZwnL40cWUt69l7H1clik9pd
         W+45OPw/XBpXYMIzLLR48qkIKvIydIAZuP4KpbmZ5QvoNfUgLhM1julL/ZqdRCOg2o4C
         TUS9IiVtEE5GbJdJEaLakt/0dzL3PqrsuC2ymablN4UgOh/SdcBEjAyqD9nfX4VXcrcc
         O5KjAUNQHoOW2kBmRbWNk1BIhCmYL0na0Q3XyesnVCuARelGBmGQExokeesmvGtFZgUc
         f8Pg==
X-Gm-Message-State: AOAM532TOg7lEYyYhHmLiPDwJZsNAheGMY7I/gExeLRGJxC5HDWoPQ81
        Vmuuofq/udi4Kh/6RmGRlerPu+E8YZLYZzRMD0HFBg==
X-Google-Smtp-Source: ABdhPJw6RY7vKNkQZdXTzjZ53SbW21NoUI5ZzfB0PL8rVbdo6HSI+V7sGQfAGhKgfMuj7WsTMoLKb6qfbQTtxvSHRO0=
X-Received: by 2002:a17:906:39ce:: with SMTP id i14mr24553978eje.170.1604473978081;
 Tue, 03 Nov 2020 23:12:58 -0800 (PST)
MIME-Version: 1.0
References: <20201103203348.153465465@linuxfoundation.org>
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Nov 2020 12:42:46 +0530
Message-ID: <CA+G9fYsrppNwC0S4vkrS8jGW4k2fgmbAzy=oMLV6X9=DHkznpw@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Nov 2020 at 02:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.4 release.
> There are 391 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The kernel warning noticed on arm64 nxp ls2088 device with KASAN config
enabled while booting the device. We are not considering this as regression
because this is the first arm64 KASAN config enabled on nxp ls2088 device.

[    3.301882] dwc3 3100000.usb3: Failed to get clk 'ref': -2
[    3.307433] ------------[ cut here ]------------
[    3.312048] dwc3 3100000.usb3: request value same as default, ignoring
[    3.318596] WARNING: CPU: 3 PID: 1 at
/home/jenkins/ci/lsdk/master/all/packages/linux/linux/drivers/usb/dwc3/core=
.c:347
dwc3_core_init+0xd14/0xd70
[    3.331716] Modules linked in:
[    3.334766] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 4.19.46 #1
[    3.340765] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[    3.347111] pstate: 40000005 (nZcv daif -PAN -UAO)
[    3.351895] pc : dwc3_core_init+0xd14/0xd70
[    3.356070] lr : dwc3_core_init+0xd14/0xd70
[    3.360243] sp : ffff000008063b00
[    3.363550] x29: ffff000008063b00 x28: 0000000000000007
[    3.368855] x27: ffff000009624068 x26: ffff000009532768
[    3.374160] x25: ffff8082cd5ea1a0 x24: ffff000008f27000
[    3.379465] x23: ffff8082ef45a410 x22: ffff0000096ca000
[    3.384770] x21: 0000000000000041 x20: 0000000030c11004
[    3.390075] x19: ffff8082ef6f9080 x18: ffffffffffffffff
[    3.395380] x17: 0000000000000000 x16: 0000000000000000
[    3.400685] x15: ffff0000096ca708 x14: ffff0000898776ff
[    3.405991] x13: ffff00000987770d x12: ffff0000096ca980
[    3.411297] x11: ffff000008707260 x10: ffff0000080637d0
[    3.416603] x9 : 0000000000000016 x8 : 6769202c746c7561
[    3.421908] x7 : 6665642073612065 x6 : 0000000000000163
[    3.427213] x5 : 0000000000000000 x4 : 0000000000000000
[    3.432517] x3 : ffffffffffffffff x2 : ffff0000096e3cf8
[    3.437823] x1 : 4d579be806451100 x0 : 0000000000000000
[    3.443129] Call trace:
[    3.445568]  dwc3_core_init+0xd14/0xd70
[    3.449395]  dwc3_probe+0x8b0/0xd30
[    3.452877]  platform_drv_probe+0x50/0xa0
[    3.456878]  really_probe+0x1b8/0x288
[    3.460531]  driver_probe_device+0x58/0x100
[    3.464705]  __driver_attach+0xd4/0xd8
[    3.468446]  bus_for_each_dev+0x74/0xc8
[    3.472273]  driver_attach+0x20/0x28
[    3.475840]  bus_add_driver+0x1ac/0x218
[    3.479667]  driver_register+0x60/0x110
[    3.483494]  __platform_driver_register+0x40/0x48
[    3.488192]  dwc3_driver_init+0x18/0x20
[    3.492020]  do_one_initcall+0x5c/0x178
[    3.495848]  kernel_init_freeable+0x198/0x244
[    3.500197]  kernel_init+0x10/0x108
[    3.503677]  ret_from_fork+0x10/0x18
[    3.507245] ---[ end trace 13f260065c84085c ]---
[    3.512196] dwc3 3110000.usb3: Failed to get clk 'ref': -2

full boot log:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.3=
-392-g53574a4c558e/testrun/3391440/suite/linux-log-parser/test/check-kernel=
-warning-121687/log

Summary
------------------------------------------------------------------------

kernel: 5.9.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 53574a4c558e8da7cfde86a77fe760ba375394b8
git describe: v5.9.3-392-g53574a4c558e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.3-392-g53574a4c558e

No regressions (compared to build v5.9.3)

No fixes (compared to build v5.9.3)

Ran 38015 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- nxp-ls2088
- nxp-ls2088-kasan
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* ltp-commands-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-math-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest
* ltp-cve-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-native

--=20
Linaro LKFT
https://lkft.linaro.org
