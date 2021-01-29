Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2B9308C57
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA2SX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2SXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:23:18 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067A4C061786
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 10:22:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c6so11670569ede.0
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 10:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yydDbWUrUCUc2SuLXW0t2ZS66XnZim8TSvbUvtgjmGs=;
        b=prGfYOTWAK3zfDxkV10M8YJtif936l29M1ra68oUZ/WRUdQI1DzUXuunKpBs4mm/9r
         X0xlYYuCxPUNQh09M+qAXxIL1LRpaYEBxJK+1mixfjV3Iym4nQq5Zrya40dyVrzYfEMx
         dQmvEn8UERengg2mbS5H4dWZgilV3TDIHr5R2uEN9IDCSf3c2IHjEHwoohEWhAMqgcmE
         XZG7BGy2RcWv3ewy0gtrW442AG89X/NUeJ7cNpWxF6gTcJvLeYeNkNQP2APpsO664wJ9
         CB+96UbzcenadY47WdoA7X3+ay9Az1Ue5DVy+HoLZrn6e3W/aOme4k35vKENGZRidk3g
         TdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yydDbWUrUCUc2SuLXW0t2ZS66XnZim8TSvbUvtgjmGs=;
        b=hLudq7rh6Tq9siWvnz2sChiJag4TG/Avz/FPuIFJC0gQyG/lkLuvD9lmth45krh2ia
         K7ndsBSvA3TD5fr3GoHDAQSusfcRkouX+FC2i2iOMXbH5bPHmttvZdWGkkWE2M89S/Fo
         umEwYjknpRKJA9FkDJeMhuI2It28OOiXZRUr0rPMwYAocUbo+6FyCgpbGHGSwY516IRu
         2kr56lPiCovje1AzwK5ByhNhE5VKVibeFusDoEmPODXM/Fe+P2+Nd861DV/gTBwauSW9
         h6fSWCNS3p5yLgjDjE9bztijzOmzN3Mn9tKtMrjDDHDmpu7Suwbn4u9tLem/KWhRkb9T
         zuiw==
X-Gm-Message-State: AOAM531fjgzfCj3uNbZPclmoTiZNvpXZhiJtEkaUxl2q2nnMkwAkypbd
        46vAopJufKbIYVoB2X33EZQ7AtBInMlBF2l48aJh4Q==
X-Google-Smtp-Source: ABdhPJzT4k42zBXoGj+ncyFRJ/Sp9KZXZjx6L64F9/wDyc9ssdpjcURKr6/LGdv3HuqsPm9OMMnQsWESBGZaIUKK5Kk=
X-Received: by 2002:aa7:c384:: with SMTP id k4mr6581333edq.23.1611944535594;
 Fri, 29 Jan 2021 10:22:15 -0800 (PST)
MIME-Version: 1.0
References: <20210129105912.628174874@linuxfoundation.org>
In-Reply-To: <20210129105912.628174874@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 29 Jan 2021 23:52:04 +0530
Message-ID: <CA+G9fYsEseDKySENMfSiRMgh-CTefpCtsQsBFbJ6tfmRoBPxwA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/32] 5.10.12-rc1 review
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

On Fri, 29 Jan 2021 at 16:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.12 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
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

kernel: 5.10.12-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 324e71045b28705e935d8136fac983c6aa808e06
git describe: v5.10.11-33-g324e71045b28
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.11-33-g324e71045b28

No regressions (compared to build v5.10.11)

No fixes (compared to build v5.10.11)

Ran 54244 total tests in the following environments and test suites.

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
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* ltp-containers-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* kselftest
* network-basic-tests
* perf
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kvm-unit-tests
* fwts
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
