Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AAB47687A
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 04:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhLPDJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 22:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbhLPDJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 22:09:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CA6C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 19:09:08 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id b7so22377348edd.6
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 19:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lje1M8fEo6DqmEjhXATqFrYTjHDX9JBJwkV0ixZ0v6E=;
        b=FAUv9zoKznXIp7awZ/uqRKrLIRSM8nur5nQRTRyRFx8ZmquDKh/nEX60ONsbGorfmx
         pX2ZUz3Rka/cfIHYor3Vsv11i/wpAw/S2ZvfoyduHMz+XZYi2ZvjeBdpR7RiTaLPehcd
         23fDLdkjeYQgWjDvILCv3VgRccaH7/pu5txhn637qqCdKlBH+xchTQ5LTOHmebUE6zzr
         DDFOJMnWk95UnHYzihj7scHnGDDAh8WTTv/91IpYepbkbEnhUXY+wPb8Y2T8DxllysSF
         fndMqhSisvC0+ewZT04HCqFl+5mmc8f2WA6b19WSVqUBbbSaoV8bqhcOj9EkQX1Icr0b
         xkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lje1M8fEo6DqmEjhXATqFrYTjHDX9JBJwkV0ixZ0v6E=;
        b=sr1n+lqoImu0yfzrvep2MDqGa9IMZXuMEiLTJ7aWNG3Cc6X6HN9SGBGky6P91jyN7+
         HaDOTMeKQxyT7CofXXRMw7gxnSYgTrYdOjwSZnRl0QhOkrsGamSgrVmg0Bnv5inC12rX
         Zhh/hGNFWUF6TipYGY49kRjXqIEydzGofmXHEiumwKQ7DfdARCPS3j4/jPpoT7YN3m1W
         pbb+LZkU4lWHzl8cpzpT1WuLUDg+AIT39oBcVw1pzHFTp9+V+JxVkH6o0iqqFZYkSgYU
         VKBbo04z6tnnR6aM10NdenHRCbMFJrt9XIrzRJ+4OG58PEg2ANfJ53FUik/fuum4BSYe
         WhnA==
X-Gm-Message-State: AOAM531TpzZPhaZ3zWDw82uavmqeOkGUoE4rIv1wrmByB9o4kUX5LPpC
        0oNx9rCboAWGdhzRoCGCPDutBSrzaSOlVgPLTrkcLw==
X-Google-Smtp-Source: ABdhPJyfHFoXy1YWOa3VK2Y8/3+RovqmxRBexdslZV2/xHao/xtCdqp2Ds3ZXOjZu77elDmPSipWcLmstLo43Keh+2M=
X-Received: by 2002:a17:906:9b92:: with SMTP id dd18mr14227394ejc.425.1639624146472;
 Wed, 15 Dec 2021 19:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20211215172026.641863587@linuxfoundation.org>
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Dec 2021 08:38:55 +0530
Message-ID: <CA+G9fYt79R7iH6YCZpc=UcFXWJD4xZU4mY6Cq=UPi-gLFVxuhQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/42] 5.15.9-rc1 review
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

On Wed, 15 Dec 2021 at 22:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 1388dadc57b7c1ac72c57901d99babdf578e5e73
* git describe: v5.15.8-43-g1388dadc57b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.8-43-g1388dadc57b7

## No Test Regressions (compared to v5.15.7-171-ge18bff95c819)

## No Test Fixes (compared to v5.15.7-171-ge18bff95c819)

## Test result summary
total: 99807, pass: 84746, fail: 1229, skip: 12858, xfail: 974

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* kselftest-
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
