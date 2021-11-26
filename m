Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCC145E7EC
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 07:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhKZGls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 01:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346595AbhKZGjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 01:39:48 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938BBC061574
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 22:36:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o20so34266470eds.10
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 22:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sR4bE0NaEJT8kqnrkcq81SC0Zzpxt+IY9PP0eL34kP0=;
        b=CbVrXOzvxxbfv3qbIYKpd2IeswV/mFYdKTexoGdslGPvY0oB3Lws06WiYtyX+Pyia2
         p8y9vypuJJVBMCcenxKQwmXPj1WAKlgk+9/zzxRzK6XuBgdnUuwNggw2kW9UtOqAnNPt
         L5oYo9eGFWIql0KpDwIc0Y/lfrTMZvWb0NydPQSMoJrEp5pIiYwECrmiIgoyDa4yY9YH
         74uPJRVtA74jJxbaar7bK9Oi1ShuJyGDpnQhRVqmsdAK7mF1fpAgBsXgd1yE+E7O5GR8
         G08vVH7Am/NIpXTkcKcqRaT8IZBFvs9UJpI8//xhD6diw17XnJL4MM6yQsnJc3sRkwMo
         fiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sR4bE0NaEJT8kqnrkcq81SC0Zzpxt+IY9PP0eL34kP0=;
        b=GhWrR7mM/ya4JabImgZOmpt1NOv6+fEK0i9pzPfXjeMBqTtl1NtS/9hkz/bvfdcP9I
         DrXGlNxJFCWIOJaIT9j0hTw9ca+PIiGrEcLs+QfTuSbD/QJ2xbB3Se1DxfB+8LyfRueX
         iZWiUxBYTvnXfAkWFx81OiRNlqn5c9DyheEASbAdHxwt510t+X2RR7yyO7dW+4Cx+Xi4
         a/PMbHJNmnrjGgd/2lXZ6dpSwkgU0ngLNB5UgqF5VExGb6obo47dVXVBGPwGUnSD+EX7
         145dggxh6w9R+s2KaAEuFhXxXlCrGLsRppWKen7MTZ3pw/UoDHUitsW4zXk3Fol15hpm
         Y1dg==
X-Gm-Message-State: AOAM531jm97tJvwpzTwjdnQ+P9mOT8+RoD+uVxcCmuZpW+uGACrsX3rp
        8Z1/aCm516+ExKiA7Gda5JpnArPREgCX6tT7pzN7vA==
X-Google-Smtp-Source: ABdhPJx5456zm9hyuonDqN4j9teCoM9TaP9W4TcPkO2Rw2VGMkjLzMjboBm0zq6eesKgRUlHlqerUKYN/fFy90zALAU=
X-Received: by 2002:a50:e003:: with SMTP id e3mr45648822edl.374.1637908593998;
 Thu, 25 Nov 2021 22:36:33 -0800 (PST)
MIME-Version: 1.0
References: <20211125092028.153766171@linuxfoundation.org>
In-Reply-To: <20211125092028.153766171@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Nov 2021 12:06:22 +0530
Message-ID: <CA+G9fYv4vrno=g9aEtodD26=6wHAjoGuHNbzeo9dSwRNz+pJ+w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/100] 5.4.162-rc2 review
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

On Thu, 25 Nov 2021 at 15:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.162 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Nov 2021 09:20:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.162-rc2.gz
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

## Build
* kernel: 5.4.162-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 79d16e9015f9481842007405bc120a66d77cf1f1
* git describe: v5.4.161-101-g79d16e9015f9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
61-101-g79d16e9015f9

## No regressions (compared to v5.4.161-99-g60345e6d23ca)

## No fixes (compared to v5.4.161-99-g60345e6d23ca)


## Test result summary
total: 90948, pass: 75346, fail: 766, skip: 13680, xfail: 1156

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 48 passed, 6 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
