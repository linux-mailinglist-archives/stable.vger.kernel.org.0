Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C697C43B7D1
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbhJZRF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 13:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237672AbhJZRF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 13:05:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2983C061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:03:33 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so16641982edj.1
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 10:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KlJCwudW4JdAfxlVj1A+Q4eygw6OupcvnPw6G6wlIss=;
        b=Hvfdng1IAEXdt1+uohC+HDlOrI+r3/1Mys/XuA1eh9k/Xbpb3TMdWOXRL9gqDpPwFa
         6MxinqxgrEa2jINr09R5M+p8cXKSg2cES3iANvTnyw8VmKkYn/STBjyYdFWWKERxdPFB
         ljBobesnLwDseEkx+8wRe967d54PwImokwCQ/4jYRjx4NzVG2c1kgRMdnuWBknYyFqqg
         YEuMAWnrvdWbj1tztg+yktEjRfOgZ5cUC3Kl4IdsMnp3u3ixLxLnuc4aAhuVxHDWAF1w
         eQdoj4LaBB5lG0kXvSkNfpQnohg0WshIb0LmC7N2cljeeOB8bk3W2Wd7i7SNZIK8DP7a
         7/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KlJCwudW4JdAfxlVj1A+Q4eygw6OupcvnPw6G6wlIss=;
        b=F5QgqOmXTzU205HyLvLV56a3EH73bec7YbCPnO+LWFmE6KPoNyENogPh4xg+ClZNIK
         2DRT/7uRAxFRSsCprdodwsrpKeGUQkdeOARRKoOu+a6Hl80kFIY/LFp/7BjFH+bI2csG
         EKmRaazHw4F6Mpff4urZ2EwdqYA3cjR0eg/IcmiZTJnE1vk8Vv0aJfDt0V3tVHZO7T+4
         WgH0VvqZ4IpfyZYuLzcqB8fDh9toqjtoJr4m1vBgsfGpB7RhhZOC1JrHw5J4Sk1445+K
         whykOVMUMErTvK0UzVS0M8Rm3BBEDBC6r+IDp2EW61CXhrKWKyYdbR3fZoN2MWhVUAyA
         MMLA==
X-Gm-Message-State: AOAM532OKD5M5ZOq+YBMEEEeW6y2v3P8eqOht+28ZAE2EdkMwEKCZtn2
        50a2aMnZcbVymnH8noIFerWuPzMV4XFieAXOf1Cp4Q==
X-Google-Smtp-Source: ABdhPJyHDvq0iyB6XzDK2HyQKxjgoBUggApKU0XBA3zTBCgBdRut2sQ8FOXuUJugLF1nU3Cg1t8w0+5s+2dO7JhqKqo=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr32213219ejc.69.1635267759574;
 Tue, 26 Oct 2021 10:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211025190932.542632625@linuxfoundation.org>
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Oct 2021 22:32:27 +0530
Message-ID: <CA+G9fYuMX6nTTWNMLMi8Fw6KG+kisynrZ_98o4TPaoMd_gKbLA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/50] 4.9.288-rc1 review
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

On Tue, 26 Oct 2021 at 00:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.288 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.288-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.288-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 668dc542cb3809809a8ed643f9c717f8f5146890
* git describe: v4.9.287-51-g668dc542cb38
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
87-51-g668dc542cb38

## No regressions (compared to v4.9.287-47-g0e4a453b84fe)

## No fixes (compared to v4.9.287-47-g0e4a453b84fe)

## Test result summary
total: 66578, pass: 52090, fail: 593, skip: 11947, xfail: 1948

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

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
* kselftest-net
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
