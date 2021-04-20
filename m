Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893E236540E
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 10:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhDTI1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 04:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhDTI1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 04:27:13 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4259C06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 01:26:40 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id n140so38177286oig.9
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 01:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=25CrNnJfupDuDkhDpTH6FQ9OCQRJmgGhTqglddUZ5D0=;
        b=SzOs5BPHVO0k2VWujRAoL9dMKOeqM2G5EaMxcumnoMHULTaMysn7ynzNeATTvXRg5u
         Y/2wI5HBEnJktVlaEsB4+wJlWdbkhDnRMY3sZr1flbrTYmC+fyL4NttmjCw0eMO18ee4
         kpobfekJiZNOZvE+Kdu2I9r6mimwUujI7cJh8lRwg/0qZ3qEZRxjfVkIQSsyzX1cWoxy
         MfsV+87dUYHcsVrjzV7sjp7A5zOVKsdalowjLT7z4QlwO3lYnjwKy6hsQoPvqZXutWlM
         VT7VKJMfxAtylCx1Fy+8L8vz/riz2ftf5mM9vryyNB2UDM5gzZSHlOlbvkhs8JSqR0pE
         AXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=25CrNnJfupDuDkhDpTH6FQ9OCQRJmgGhTqglddUZ5D0=;
        b=BmxG3ERFagldWXqvgiWhOjkA4qEXL1xPHij5peew9kdtJDgr0zMOiPvlZ+YEHvdvWI
         461+Ma92uiwsVw7H00e/BNZZ4ftNhVycG/CWMnwbt5kYLa6cTS0/PCn3FAHy9NSWeh8I
         mEF+s5scqXd64/0/0giO62y0FR46EXu6Ux8uVYiWXCax2e+QIgmQHLvItoqnToxdNmVa
         zBi42lKi4VEE8PI/la6eLNhaOTFFqb8S3n+7s27XgKol8GOCAvCNsVwkAACbihaehGDb
         68bs6HJ3XGgv2Zo02SZddWTkiSJK3Vv7H0LnifL5PpLkPnZwTFr90r/MR2wPyX3E0i6q
         6veg==
X-Gm-Message-State: AOAM533Ea0HuAIsWmVQsr02jCeAyrB7qILZewLRUmWgx9Xt4VLNqqCYZ
        lcWhkxFkYgGE10hMXSfsebnI3u19CanAKQ3rLVKRVw==
X-Google-Smtp-Source: ABdhPJwZ7lbMR2tJlHZiVxH72CVZU1yZkzdYpJNAzP6BDgbeyU9DqDxEu4XX3K0/bMRmNMmr2LFTNLESwbhGB+oD634=
X-Received: by 2002:aca:ed50:: with SMTP id l77mr2258020oih.13.1618907199970;
 Tue, 20 Apr 2021 01:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210419130523.802169214@linuxfoundation.org>
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Apr 2021 13:56:28 +0530
Message-ID: <CA+G9fYuVJ4cvkBaRxL2Mm0BJvAEqge9TdBRyA=LdVwX8bfYX7Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/73] 5.4.114-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Apr 2021 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.114 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.114-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:

The following kernel crash reported on arm64 hikey device running stable-rc
5.4.114-rc1 kernel and testing LTP thp04 test case.
but not reproducible. please find more details in the below link,
So this is not considered as real regression.

thp04: page allocation failure: order:0,
mode:0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), nodemask=3D(null)
Unable to handle kernel paging request at virtual address 0000000000001540
,cpuset=3D/,mems_allowed=3D0
Unable to handle kernel paging request at virtual address 0000000000001540

https://lore.kernel.org/stable/CA+G9fYtujdEqdGE_3dDpAecLMAmUfwZEm5EmPEGTNdL=
QgXtYYw@mail.gmail.com/T/#u

## Build
* kernel: 5.4.114-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: c509b45704fd663fc59405e98d29d7f06eaae4b5
* git describe: v5.4.113-74-gc509b45704fd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
13-74-gc509b45704fd

## No regressions (compared to v5.4.113-49-g56028094045b)

## No fixes (compared to v5.4.113-49-g56028094045b)

## Test result summary
 total: 64147, pass: 53600, fail: 638, skip: 9689, xfail: 220,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 191 total, 191 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-tc-testing
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
