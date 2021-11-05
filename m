Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034A24462AD
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 12:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhKELcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 07:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhKELcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 07:32:22 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC11C061203
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 04:29:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f8so32109153edy.4
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 04:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nJ4IMjZvcUgkYa7y1stcZyUMCuomkLUa0D2FVp+QakQ=;
        b=Rz9mLIMA2UFiXw0lGbGm6HVMfuQ/cXelQee/vjJTqMJJxXIG57VM7vPOyvfjkFxRLN
         fAwsDY9+UTnz0uaycCwlCzBj8hws73SgTCToMxprcCiuc2XHgWE9whAhO6f/a1CKskLO
         nrKkVeasRFX6iCOsGJ0kqZml01uXIMVIgVtuhsUC0YClALW6OavL0Fe6Z1nROHA3XPY1
         YXwM9T8dM5CPvwHgUd2y1/8ky5a+DM5sb9Rwi/9nFCh87WSQ704kd09nSQSWB9Elz0Da
         jQABYH7BiyzixOJn8zpSebFmWzk36Me0X3MZa4Eg2rTkui33xu6rQatZcWir4MGafoz7
         oJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nJ4IMjZvcUgkYa7y1stcZyUMCuomkLUa0D2FVp+QakQ=;
        b=qdwAII60CaiVWsNuQyWo6prCOEGGsXciur119czk3rXexP5cmmv2eFe2KFU1S5Tduq
         ttkTaBLilQCC6zwSOD68uyOpZQor93t9sX/Y/iWRT18Kj6MBPU9b+IlFiPtyiC9VWjMI
         TYOGBtxtKH4db5sVU17fkWozOHLfhg67iEA1v+Q1URUgk95KxPw8fHqDEFbZz3yyQoVC
         cmjXGyCEaqpMAZxQm4lTDzECmKR1lA2/GckrZ+Lw20VjMelJ+mCiHWi9fZAnvqy3dJeM
         JiJPAgt2OXp2bX3JaoH0aBCZvB1MlXsBviEwVBKqc80/pC1AH/cYDZQfSjwC9o0333Fn
         87zw==
X-Gm-Message-State: AOAM533Oykd2vgyKxPKGnD2FlTPWluta413q+J+XOPXifAiYTxuI0HII
        xY0/uBuctFfE3JtYoBI6/NtC05J3lQqPaQcW5B1BVw==
X-Google-Smtp-Source: ABdhPJzH4IKZs9buleIYN4ypGN1mgN1Jtlonl6/C4n0JXh1zqkVKNRARMPaHzOFIt/7V6c6/TFKBQj+1AFInQg0zt1c=
X-Received: by 2002:a05:6402:3492:: with SMTP id v18mr27849623edc.398.1636111781499;
 Fri, 05 Nov 2021 04:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211104170112.899181800@linuxfoundation.org>
In-Reply-To: <20211104170112.899181800@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 5 Nov 2021 16:59:28 +0530
Message-ID: <CA+G9fYtZveFaBLBedMRaV+iiHOc9G93aDyH917nEGe7frU+u2w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/14] 5.10.78-rc2 review
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

On Thu, 4 Nov 2021 at 22:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.78 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Nov 2021 17:01:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.78-rc2.gz
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

## Build
* kernel: 5.10.78-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 2bb5f9ae86fa10a6cfe99fbf64a5165e711c37ad
* git describe: v5.10.77-15-g2bb5f9ae86fa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.77-15-g2bb5f9ae86fa

## No regressions (compared to v5.10.77)

## No fixes (compared to v5.10.77)

## Test result summary
total: 91230, pass: 77387, fail: 603, skip: 12234, xfail: 1006

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 268 passed, 22 failed
* arm64: 40 total, 40 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-bpf
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
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
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
* kunit
* kvm-unit-tests
* libgpiod
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
