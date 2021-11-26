Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9496F45EEEA
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 14:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbhKZNPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 08:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhKZNNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 08:13:42 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33C9C07E5DF
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 04:32:05 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v1so38334811edx.2
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 04:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7Gg+XXVZNrLBBVntnTolw3hvoN478VyLwPpdFxyOmu0=;
        b=PTIP0akFlP40ZrW8RxgMNXc8MM/G8IAYZ0BswprolylFnVUGRNNhO4RZ6ie+WxD4sA
         scdyGMdEKibTw4cA9jHUsW9tXxKlb2JQJXbh1i8bekgSaHtTg5YZiJAHk7T1ntYNIQp7
         XbI5sTE1S5fIoNqqyZUgqVWodmf7ttxzI8H/qQMPWyEdqvQ6wpcO5UxGPy4ryR/CRQ/2
         QooP//+MNh08GkqwmXzSVjFLYuOd59qPZxAkWtgxdBpqEG7lh+Ki+RSI50f+G1kvYmAI
         LM7/KMzj4aTGhwgjy1+CAHtl9Wdd77Ucn53dff2XggduzBiMkTA0IdSXFAkGpoOgApHy
         AOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7Gg+XXVZNrLBBVntnTolw3hvoN478VyLwPpdFxyOmu0=;
        b=lpycSf8Hkjq4unVGU3ZhJVSnSLyYdQg1AJ/8GWTMDQ9nuAR3+zhdB0UagikYpopncw
         2VNFLDX+DlvkUUCxlPS+8AURrMYfgVSHRzOAPuM4vo1at19J11QJHlA6cKpZzEhMY4pB
         OxQoxXhhedqhqAJDQWF6nZegVWtZCVJX/t5bwGoapFOPbduUiBgA8+JYnnreFg8/BI/a
         /gWdwWL9+Rf30ZEFv/dJmjdXKmCpx4KQajhjcQa7wQq8Mf3qX7a5vFtPR8zbhI9tqGB3
         6WbP1aAJKxxt9gAG23sZd5Xc6AkJJtCfW0PSYgErE6w/k24SqmYPIjHb1mMp97qemjzs
         kW6A==
X-Gm-Message-State: AOAM532XN3TpWSjitaNhBr5ry8g9ogEZnWN/VXPEgJXmmrBzTtLdon0n
        BCnx36ay3Bu2NH9WlNgghF+IoZBmoTvPq+OU03lgWQ==
X-Google-Smtp-Source: ABdhPJzTydUvGDpiE1q1Robn1euHf4qffYyCTSqMkuO23VlfxCbqJt1HB2mXf/yR2HI94W2QBuFfab7tspfrdMKnvUw=
X-Received: by 2002:a05:6402:14f:: with SMTP id s15mr3109391edu.118.1637929924230;
 Fri, 26 Nov 2021 04:32:04 -0800 (PST)
MIME-Version: 1.0
References: <20211125160515.184659981@linuxfoundation.org>
In-Reply-To: <20211125160515.184659981@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Nov 2021 18:01:52 +0530
Message-ID: <CA+G9fYvRKt_0-N1t2FarojBEOwNhwJMxnqsKBzk5TEy9SKwipg@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/204] 4.9.291-rc3 review
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

On Thu, 25 Nov 2021 at 21:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Nov 2021 16:04:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.291-rc3.gz
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
* kernel: 4.9.291-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 54bc9d253e82bcebc83659627f196a0a8890a558
* git describe: v4.9.290-205-g54bc9d253e82
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
90-205-g54bc9d253e82

## No regressions (compared to v4.9.290-205-gd6aa2271168c)

## No fixes (compared to v4.9.290-205-gd6aa2271168c)


## Test result summary
total: 77977, pass: 61660, fail: 627, skip: 13435, xfail: 2255

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 19 total, 19 passed, 0 failed

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
