Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96282DF378
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgLTDwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLTDwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 22:52:35 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CF5C0617B0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 19:51:51 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id 6so8896486ejz.5
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 19:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WEt+jTrm0BdEnBPIQup/rX1s+V0mK53Gdb2FrPCFsYo=;
        b=Tf20zmccODfBV22C2IWo1MJveshVVoQX7gSlY6eh4elD8rgAMKWdVABLGnCdC434dk
         5NgWJ4vBI73VmBiWZPePG+0tqGHK+NuwOZ7K9+k52EkKhreb/Ex07crk9j9uM5mLJKZE
         xi3cySAQpY7vhaMILuGVgprhW5FPe0f1fAgZpkDXVHVuM9XYw95YHSGZ6vkmzXF1lg/8
         1GGK4Qgw56otpT8CqE4ahflb3bMIxyRDF2K0L6N0yjT32BsOS1uSFJ4r4zPOt2EqjjQw
         G7IJs+6PGKh2loB7XU4TLjqWbln2XUJPQS8o9yMx2ZWY9tNmMbpy3KLKMs4uOxV/EEr7
         A8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WEt+jTrm0BdEnBPIQup/rX1s+V0mK53Gdb2FrPCFsYo=;
        b=Dbdof7QamtQWfWii+K7V+2rulQLfeLasZFfY9f8AostUbqyzoMTVcDQQmQvmxGezOi
         IcNhLh6jKaHv6bJvt2YZ4nZBFV2UnRj43jq8L8VKgZ2BtOY9lrKvoqz1Mo5kg/GfGEH8
         LTLtz0rcwWs/ontOw6ygbGR+DDbYNtqr1A4cUZtfk721xkl1xgyg2A4qLnZIWlyCCL9m
         TdLol6UQArf7W/He1hTTQKHM9mpbd0jIftH3Qrj0DillILBF7hDbzx504hpNWJ8q62JV
         b3iHkFOdMsxiBSp2YWxC5QZZmig1ox6eBuzyNqlGChWBsyWjY7c4Z2gs0kLJetfFoOqU
         usEA==
X-Gm-Message-State: AOAM532O5AOzNi4JwxKFT0PorDQkGbJ/oioVcPPqnDKdgAogjo8OdxAS
        Dsj8gG3S7aYnBgMgHG6HFCy9nsqrjIyixPPpe8phtA==
X-Google-Smtp-Source: ABdhPJwAJ+XW0irEifTk3iKfKaOHbh43eetocpcWbMAxYd6LwiMKa8RtgneLvGCU8G2q46Q7C/WsWYikgUawHZ9obFU=
X-Received: by 2002:a17:906:4443:: with SMTP id i3mr8896466ejp.133.1608436310399;
 Sat, 19 Dec 2020 19:51:50 -0800 (PST)
MIME-Version: 1.0
References: <20201219125344.671832095@linuxfoundation.org>
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 20 Dec 2020 09:21:39 +0530
Message-ID: <CA+G9fYusU=a==UJKY5ZFq16SCR_XJ6u4rYORr7hvyVCZpmkPVA@mail.gmail.com>
Subject: Re: [PATCH 5.9 00/49] 5.9.16-rc1 review
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

On Sat, 19 Dec 2020 at 18:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> ------------------
> Note, I would like to make this the past, or next-to-last 5.9.y kernel
> to be released.  If anyone knows of any reason they can not move to the
> 5.10.y kernel now, please let me know!
> ------------------
>
> This is the start of the stable review cycle for the 5.9.16 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.16-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.9.16-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-5.9.y
git commit: 345f3d037fc5bdbbc65a33c917192261fdd58393
git describe: v5.9.14-156-g345f3d037fc5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.14-156-g345f3d037fc5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.15-50-g345f3d037fc5

No regressions (compared to build v5.9.14-106-g609d95a95925)

No fixes (compared to build v5.9.14-106-g609d95a95925)

Ran 57227 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- parisc
- powerpc
- qemu_arm
- qemu_arm64
- qemu-arm64-clang
- qemu_arm64-compat
- qemu-arm64-kasan
- qemu-arm-clang
- qemu_i386
- qemu-i386-clang
- qemu_x86_64
- qemu-x86_64-clang
- qemu_x86_64-compat
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* kunit
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fs-tests
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
* ltp-tracing-tests
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance


--
Linaro LKFT
https://lkft.linaro.org
