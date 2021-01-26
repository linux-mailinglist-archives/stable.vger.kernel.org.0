Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE38D304BE1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbhAZV4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389998AbhAZRru (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 12:47:50 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46869C0613D6
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 09:46:56 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id d22so20830300edy.1
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 09:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mXB337YdK4IoZ5DxwneF4YucLGz7gHAsDlI9WdfF+Xs=;
        b=XVgXeP3Zpj0gHS7wcEIekmC5q6fS2qubWSqIJ/tXf3u8/4O9cztKYG0q5vt83lwym6
         4B3/EOWRk/0Di+vK867cmPMR/X+1n3odZ1dPHH2OE9Nee0ay15s8Gk27UkN8otq8+qj7
         eP0FLvGokV3P7NVHCKAlFbxNuRMTIJ5kQNHBULgCK16U8m0lagPjFPbhV5WwrcgPmovm
         Wk3oUpZ5P3dyTtYKQWC+W4lB9sgIrZCBnaVZOi+Oee12xKl8zZ8Vaet2FcXZZr8Jyhx6
         ksW3Mg5lJvdyRX0JnnoHvVVfs5uTY5MWm49p7fMH2KSCjbrtZTs34NhhHVwBb2Fziv24
         NAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mXB337YdK4IoZ5DxwneF4YucLGz7gHAsDlI9WdfF+Xs=;
        b=cM7QKhQ9U70+D+ofIuZ1Id0NrAh9dfJjmlZFP+iCidw/BzbK1TkX1NGqVhqr5jthx8
         kgXIp2PYvwhD55RjVudbK2iSXV85R2KSuYII3ZBbgJDesj6dUZunnYp/sb9yaBRVxloP
         MW4oKbpw7VvUbqKROP3ELuHFyTYKxj8c8IrgHKbQAsEAo+ueIQ7QOVzmnvOSAh+On6eR
         /rg0aGj7Y558YN6z55nEB+QdUQFAjaRi31dpxU8gNmdOmn73IJYZVVoNgRR0mLR6+yTS
         V2SYx0yZesr9sgo5zVzq/rsBMlf9LbuXhariWA0P6EVksQhPcA42Us1D3fwphnEeyrQh
         bajA==
X-Gm-Message-State: AOAM5307TBPkSEbZTn4HtIBDtKLwOAdO4cVpRovxCVZZwi7WDFw83N+k
        BBD0fM9wG5jefDHcolY9Hclo9DJYm4QDjU77vQYyHg==
X-Google-Smtp-Source: ABdhPJz6nAEmn2QE7WVksOPb+TUUaBRyPeexFhgY6Q05ooWC3FMV+f0zMBq0XC7DjIZ893pPqjRDdQUMM4CxXicDhNQ=
X-Received: by 2002:aa7:d905:: with SMTP id a5mr5701870edr.78.1611683214629;
 Tue, 26 Jan 2021 09:46:54 -0800 (PST)
MIME-Version: 1.0
References: <20210126094313.589480033@linuxfoundation.org>
In-Reply-To: <20210126094313.589480033@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Jan 2021 23:16:43 +0530
Message-ID: <CA+G9fYvWxoK=hOdvVUcB1n7Nk5vmWdh-4GzyaaFFyRijHLrnyA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
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

On Tue, 26 Jan 2021 at 15:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.11 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.11-rc2.gz
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

kernel: 5.10.11-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.10.y
git commit: 460ab443f340e551b97897f77ba6d1dfd6dfbd32
git describe: v5.10.10-204-g460ab443f340
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10=
.y/build/v5.10.10-204-g460ab443f340

No regressions (compared to build v5.10.10)

No fixes (compared to build v5.10.10)

Ran 57016 total tests in the following environments and test suites.

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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* ltp-controllers-tests
* ltp-open-posix-tests
* network-basic-tests
* fwts
* kunit
* rcutorture
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
