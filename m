Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CE83705EC
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 08:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhEAGnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 02:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhEAGnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 02:43:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3FDC06138B
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 23:42:12 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id n25so555095edr.5
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 23:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4/HAzDClSV9cd3IA4IU82EbSzswcxIt5d30z8c58+Jo=;
        b=sRrfFuH3W0uM3lMr1sMIYdJ8vyCJv8Jb9202SCa3T9brUHetxXhVFmB0a1zlbKp0ii
         Jc6AQ0BGEMV2IJxiucqezUoCzDIboAiGP0kFzhcgNC+yreuUcww3WLFwtKa4oTTExmeM
         2BEXXms4BOr8khwqifOWUsGsQxiP9nPSNf5IsPCkNtV67cY22wd7tNASVJb+ptBBom/t
         X1ADV+flvzVQ/xxUIDPbhk1TfQb+R+GdmG3PDnATJ1XQKVJRqGOwXOcdtVOKw8AtP6tl
         NZQMfa4+OpvwJq19n9S/YKoxbowx8mS7VQv2V/+co3lNZlid5tBqYJsGb3Prm+c9j2Uj
         OA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4/HAzDClSV9cd3IA4IU82EbSzswcxIt5d30z8c58+Jo=;
        b=DsNN9+cfUnrWu3SxuyDagdLQH89nCSi3gE+XC8AjWknkQYRiFJWUZTpvILCjPHlUsz
         R1H8GVX+P/NmdSCjTsMR8qqGHqO+5wzhK9fhHyICsTKrgFu5L6fNJ9uhRPK0WLvsU0a4
         Fnvtj7WQkD6pKiAzkf1asMcEpFkNV2bqsuqwNcEFgx2FyfWGICOrFTUMOzBMNc2a1gQt
         lQl+HV2lcpf58kqqeGCgFpxknncRQctVDI2McH06xONXxmVSsN/LM45/iHF3lEmSZbLG
         XfgZK3K1sK9+geeWgJDZcbPVkAXbcy4xDTSkcGpLgZRPda4IHwfHLYxc2akXJFLttvRB
         8NGg==
X-Gm-Message-State: AOAM533HuabIFZFBdoEg11TPgECC+XdmxrBvt2BlNC7J5M/Cj8mtgF2W
        VQ/Xb08QQFa66L+5TdmCnfvnVLhwd1dy+/qk3DsAtg==
X-Google-Smtp-Source: ABdhPJxCKVf2mC1n6u2xeUQW5MBS96S9pSrkm+0QjeSM1UPZYNO+mXs0av/LXMM9KUg4EZyJZV/1qWx0QqOnGmPXWN8=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr10199228edd.78.1619851330902;
 Fri, 30 Apr 2021 23:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210430141910.899518186@linuxfoundation.org>
In-Reply-To: <20210430141910.899518186@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 1 May 2021 12:11:59 +0530
Message-ID: <CA+G9fYt6AATtvdPjGrRVYOXPOMk=jRQE+Q=0u5kj6=2VU__-7w@mail.gmail.com>
Subject: Re: [PATCH 5.12 0/5] 5.12.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Apr 2021 at 19:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.12.y
* git commit: 94990849b4da1a85c0e8aaed7cb3285a6ecff018
* git describe: v5.12-6-g94990849b4da
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
-6-g94990849b4da

## No regressions (compared to v5.12)

## No fixes (compared to v5.12)

## Test result summary
 total: 72055, pass: 60456, fail: 1438, skip: 10161, xfail: 0,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
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
* kselftest-zram
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
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
