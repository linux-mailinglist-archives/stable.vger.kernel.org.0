Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425053FEAC9
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 10:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244677AbhIBIp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 04:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhIBIp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 04:45:28 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759B5C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 01:44:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id mf2so2557211ejb.9
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 01:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yzOHG6SN6+upJZKmTuNNZXM7KtfVu2O7f5QxyJFtCq4=;
        b=VV7ZGxPhvUr1RjfnvWP1/suuOVXykPP+Zos/jeKbE4xxCm57zckLUOgCX2bSfhDw9Y
         fMY8IB28iIBoYunBJ2+ySqMjZnr9LLDGRXF1pO9C+NTegz/LtrkvciKeJFNf28O8RE/8
         sF8u81rKrhOERQB29n9jVYjCzRKnJCe8FIgfJdWrGb+Jk8y1ldK26gx68jTXckijBryI
         MC9odn5QmR5fPATTPGD06IbBKGQi2XtD2GDUVujLKp017xwrZlzWbI06turNQ8XR7EBC
         m77plw50fHzEToeAKbxuaCszSXnWKf950wQuxnPe4gcD614oBWo6rWkD2jsegw8Vq5+1
         /DAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yzOHG6SN6+upJZKmTuNNZXM7KtfVu2O7f5QxyJFtCq4=;
        b=Iud9rkc4kyfdMmqhdAjLwTj9u/0K8Yc+bLvhTpAKCnSMiQxS7xKupZKOiT1swhG9IC
         U8gJZCtvTwOxXCMQ/U0FAQ/lRFNqK7qZQ0x6geXSIL6RgAZTdX/Z2mEKsm59VkxVyA5y
         D9b22X9KYAZP7t22NE4teKstzg3M0Abuh/aJMyVLKNEIIUsGxkdeJU/3lCbShfiCxMd+
         akymJ5cBCD7UJOTcg8FVMW9FR1sZhnyMM41s79YO7+O/jlwERS9P4g9IiT5LL2sUSsXP
         N4epoXrvSnWvZ2/sicChzMVs5sFI79XG1Q/24Mugr/r1FWaM082ph9r/qEt1LCTpYyHV
         N9Lw==
X-Gm-Message-State: AOAM532SVDLBvVGrI/tXi6+CiVy+OUt4kgDBtfwxq+lc06ePCZ4gdXmA
        kv5EUsSJw/INxYXwgKUGrzyOU5D7LkdwHdq2ISZtIg==
X-Google-Smtp-Source: ABdhPJzKCDhlgrC3TO4OIATM10Y4DstavLR7Kz0nQhNvT4CmjQEmXR5B4uzs/XCcV4yY0g7DAwDI7qJhZ86E3Ge9vk8=
X-Received: by 2002:a17:906:802:: with SMTP id e2mr2537074ejd.133.1630572268852;
 Thu, 02 Sep 2021 01:44:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122249.520249736@linuxfoundation.org>
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 14:14:17 +0530
Message-ID: <CA+G9fYvOA7Rv3XMisM_LXLK2Kr54WivZUWsqtN+AwDjhgUSCcw@mail.gmail.com>
Subject: Re: [PATCH 5.14 00/11] 5.14.1-rc1 review
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

On Wed, 1 Sept 2021 at 18:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 95dc72bb9c032093e79e628a98c927b3db73a6c3
* git describe: v5.14-rc6-389-g95dc72bb9c03
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
-rc6-389-g95dc72bb9c03

## No regressions (compared to v5.14)

## No fixes (compared to v5.14)

## Test result summary
total: 87243, pass: 73125, fail: 1909, skip: 12209, xfail: 931

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
