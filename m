Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7312EEB2A
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 03:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbhAHCDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 21:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbhAHCDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 21:03:47 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE4C0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 18:03:07 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p22so9594438edu.11
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 18:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=glGt0bFSUxWM/LIDzMdu6xWSHp5ndzP980X6Ft5EpL4=;
        b=In0E+qvExLVMNEJVxTY/O5EJ/1tDwnQeO2jWF2JKCzoT80IWtMaCxsL7jmX52fz3Ea
         gAEiwJV2t3rzG0r9Ny+p3hu+PgqXWStujXFYvdcttYpO8FmOd5Mg98HUNQ2fGcwxnenh
         IPjPYi+/rMSf8lEW+1DfcFEQhpFV01czhvl+/jYTiIGUSsmE+ljsv1NjOer6oRZ7AOp8
         8QxgoOoYRKxJ29y80tFRyX6cfSBmwx8eMcI4IfCQh4tgDRvS+2shJe8ZjoRTkgjyEYmJ
         0KKXdFI30mk1xrBgPJoc7hYMaRlTw7UjoYxejgfozzwEHA4zNO1xAWG+yq3eNWZ5Bath
         j8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=glGt0bFSUxWM/LIDzMdu6xWSHp5ndzP980X6Ft5EpL4=;
        b=stjHpa0t1+GYuqOS7T8uZDsQUwfx3pd3BEojO1M0VMKyh+bkkz8ZdYGknVdUi+wgaG
         q9Rft1Zeoy/xhZXcjb86wtiOIuUciNyxuyZ1chAZiwR7jhzdEDfuUTsIUt0qF6VXlX1a
         c9imqAUSgHzbSpvTdJO0+I7tdlwL71cV4eltOsvVwQCcuyTdsf/sxlsMmLajUCQaxUYY
         Sr0wKQe4cJHgtXV8+QEB0pGpvk6VCEGbVtzpAHato/rkjWrDRhTZwV8Kbxu0LFJ3+GKm
         GQ7RBUz3OdOhK6l3l3nqqtoY1flqFlbHFRObuEynfxNnWh2GFV/hKAL7nAEPQMhjraW/
         mlbw==
X-Gm-Message-State: AOAM532Rev+Xr9BzauJho/AbFWHpdpxYEFPo15ScgEJlmISFvVLLdQtd
        UdGGq3YvKxYCOPDHYHXTy2Q2xktQrGRcsjC+47uODw==
X-Google-Smtp-Source: ABdhPJwRR9+w7IVHJM8B8EEE4B3csvxxjkJaXPAOhzYgq3AAzeFcBd8tKGXqALxC3RbMf0msHZ/xmdi4VzrzbNQI2XE=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr3618220edw.52.1610071385905;
 Thu, 07 Jan 2021 18:03:05 -0800 (PST)
MIME-Version: 1.0
References: <20210107143052.392839477@linuxfoundation.org>
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 Jan 2021 07:32:54 +0530
Message-ID: <CA+G9fYv9tTkAUk-0+y1r5ug=w3Ma-CPgg7nEF4ZoRKEs1pe1fQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
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

On Thu, 7 Jan 2021 at 20:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.6 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.10.6-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 208f314c03c52f01c09eaff3018fd704c2f8fbe2
git describe: v5.10.5-21-g208f314c03c5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.5-21-g208f314c03c5

No regressions (compared to build v5.10.5)

No fixes (compared to build v5.10.5)


Ran 56928 total tests in the following environments and test suites.

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

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-commands-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-io-tests
* network-basic-tests
* perf
* ltp-controllers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
