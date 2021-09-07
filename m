Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA0D402391
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 08:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhIGGpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 02:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhIGGpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 02:45:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180DAC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 23:44:01 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ia27so17595505ejc.10
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 23:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+0yV73yugHctKc1JNqIqYe9mfeeNW+P1D/CDrX11Wl0=;
        b=f2RYl4pIpf0smXekMD5ZlYtxCjbS/DeYjhHevg9IzHBvmV8f4o3lms+du7GQmFmOvf
         NVgxno8Lb/R/nccaWMoOPpRs+ONw+ftzB13/2ADVcvZLLsUnsiWFillu/nScNe6ZcIxC
         CZuzTBrDRrsfYS1TrkU9ulm34DnYX+Psjf9A5xooQX7odF8kK9ZudHozV6Ks0NtWj3ln
         e8DJvmKudtx+NcGSUYhsGpOaJ/eyxx/cCZYOEqPMS0Htn3LIfxBuvHExVwzrNsSGY6x+
         zOUlYAaECZXnQGYy2pWtnv2XfCofVNXs9gBfQKX6Ac5yvxav/INPpguU222w3DSenFi9
         9FpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+0yV73yugHctKc1JNqIqYe9mfeeNW+P1D/CDrX11Wl0=;
        b=ri/vWQWcpClz9n7YCbJHt8XNpx6YFaUTn+QVPv17Ecfg897By03l5sQ4/TW8HhzlA8
         c3o/WNxtJnTBar2DWoCL74mrpdgpE91IL34fOZTsdw6RDE/avV9JmtiAbhfDg4+Qxr6x
         90g4sonbGdT6D/howFhQzR+2a9zDq0NONXnAZJyG/7AUzOULsVbsFtucRG1C0hR62EGC
         /3E+b2KVtcjxsXEx4/hJGlS+h+xjX5gwzcGNuCmGd1jbZRXDrnIQQKuzBJjyRcmw5g0M
         r5IjFi8XAzIOWLp2I4bNoG8sCQ+jDplKLYt+gA3lM8l0nMLa7SsJ8g3w2guHYPvKKQ4Q
         ifDw==
X-Gm-Message-State: AOAM530JesEuQf+c9+CBgialVmScqLswS/6R5paZKyD4YfK/IKVy4rA0
        yNijW/CGRMeil1WxDTWrkLWETSh6fXznDhxoFg3QZg==
X-Google-Smtp-Source: ABdhPJzTow8KcEgZWZfSUFNUklXrpg3XO5CLfU20EPKuRc6BggrkrVhmqm9/ZmMrludlHNZFbq4GGZjWmUsG0MYqv0M=
X-Received: by 2002:a17:906:681:: with SMTP id u1mr16884095ejb.499.1630997039539;
 Mon, 06 Sep 2021 23:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210906125449.112564040@linuxfoundation.org>
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Sep 2021 12:13:47 +0530
Message-ID: <CA+G9fYtHN5rMWxEYaacmWp2uw2AX6i6K7_ft807fpH6BKPSfqA@mail.gmail.com>
Subject: Re: [PATCH 5.13 00/24] 5.13.15-rc1 review
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

On Mon, 6 Sept 2021 at 18:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.13.y
* git commit: 6fcc0c5f7322a449824de7f2641dd0b551ae68f2
* git describe: v5.13.14-25-g6fcc0c5f7322
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.14-25-g6fcc0c5f7322

## No regressions (compared to v5.13.14)

## No fixes (compared to v5.13.14)

## Test result summary
total: 89974, pass: 74993, fail: 1122, skip: 12954, xfail: 905

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 27 total, 27 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

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
* ltp-ca[
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
