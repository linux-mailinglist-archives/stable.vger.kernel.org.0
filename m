Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A9C4429E7
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 09:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhKBI4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 04:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBI4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 04:56:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AC4C061764
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 01:53:46 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w1so19417133edd.10
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 01:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZYpbgwwXidzFx0y6l+ahI48wcTllx690dVnhP3hPQCY=;
        b=N1InVPcy/osORKJc6HUfNsI0hxFMHR9zvERLiMyzxeAyR4jes4RW/QckqJUPASH4Ub
         ggHMahNzJ8HZsiQhQr+NaoRnnTAPKJ9Q+EaLExrbXXs2z6lxpXE2Wt9gaGsax8iwPvT1
         VUBzWA9pE6KHUQgbo1YxDP1ltxsul8umP6Bvq9v1P+hvqNRNSrs47zOtYvyLkitanV3O
         4CvC7k5tWxCvCXPwxz3i04RohYrZ77TdPVCv503X4ZVS2jKim1kv0Sn2gplGvfuekmpe
         +hVScM9AAKNIMjjFs0t5B42flnN6tv7jkiKi1iSJz/cIqVAY11Gr3AKl9QPvvy3zLBWu
         9OZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZYpbgwwXidzFx0y6l+ahI48wcTllx690dVnhP3hPQCY=;
        b=0jXqtxc5sgbCvqI0CZ13qpwS4Yc/tA7xVBHMQbTS8wfTMkfZT5uphpMiqmUGUaz886
         mbauYR3j9aicvyvAnwVCQ9dAZPRbdAunyC6lgBGsu+4TwLaxFxhq0+bcOOx/+iCZSasz
         oTpCNQLG9Rl/qTbbm2e7/4+/4z+CbwLGSzsrEgGsVvQhlbYYe7TH7i0p0x9uqQqCq+R7
         Z3+OQ7vXm0QU75H7+PAAjo38yRWVb5MhZhHS8UKxqq4Kys+TSZKlI//MeZl44hesFKsO
         ORUUi5/6ZqOXLFuPbduedtkX2BQjM1gfbi8cgC9s7B+9QebXUDAp5H15Ej30IKyfLymn
         D/QA==
X-Gm-Message-State: AOAM532tkR8pTSt0D7nKmIzx6u+scK5xnry4bOlDlcGvSAct6QGONare
        rJfYZfXoSmPNp3sF+OYcd2aF1c89oga+hkIjkhS2EA==
X-Google-Smtp-Source: ABdhPJy5bxDfJQ3NlKIxYEVBptUMzEqfXhfHlyF1Ft+a1bSlRfde4E6waZWprBFd/eFOAaxghiseDcpHQrUzKz67Hlc=
X-Received: by 2002:a50:e184:: with SMTP id k4mr49192077edl.217.1635843225229;
 Tue, 02 Nov 2021 01:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082440.664392327@linuxfoundation.org>
In-Reply-To: <20211101082440.664392327@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Nov 2021 14:23:33 +0530
Message-ID: <CA+G9fYt3vv5wP4-oEUZ=rdnR2ROfthYa635UE1V_HB=akX5ACQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/17] 4.4.291-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 1 Nov 2021 at 14:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.291 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.291-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
With new gcc-11 toolchain arm builds failed.
The fix patch is under review [1].
Due to this reason not considering it as a kernel regression.
* arm, build
    - gcc-11-defconfig FAILED

[1]
ARM: drop cc-option fallbacks for architecture selection
https://lore.kernel.org/linux-arm-kernel/20211018140735.3714254-1-arnd@kern=
el.org/

## Build
* kernel: 4.4.291-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: d0c0f8a764f8c71b396535e71f1d3bd792f4b34d
* git describe: v4.4.290-18-gd0c0f8a764f8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
90-18-gd0c0f8a764f8

## No regressions (compared to v4.4.290)

## No fixes (compared to v4.4.290)

## Test result summary
total: 45115, pass: 36135, fail: 217, skip: 7755, xfail: 1008

## Build Summary
* arm: 258 total, 207 passed, 51 failed
* arm64: 34 total, 34 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
