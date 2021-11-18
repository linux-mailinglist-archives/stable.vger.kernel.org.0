Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D9B455D70
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhKROKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 09:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhKROKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 09:10:11 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D8DC061764
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:07:11 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w1so27451794edd.10
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 06:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ggxXWX2QXeKOHI2GNezcaKGfjTo3F0HumEDmucHbcKU=;
        b=x4UsDYCNm07fWhdiSnaJNeGdj9SbHCAi970jvIb6RPQCs9zv6ocXrLsrfuTUgbNrnG
         qVlj5Likyz6ltR4p4GLS2UsxBy2kAIKlWQdPdx2WY+5peHOP173BkiIppxBJDcCf6siY
         8oLw7BkRBxp82JDoqXqw+rRIFXsVmYj1qNgies7WpdLstzs06rXhEh3UkusYItbLYoM1
         8Vq35hkVIjVUY1pzrKYrPn1QRGGJLqdyyq6Dr4+smRMN5JgGfqRANB9MndnPcVJ2cNAo
         bIlbpPxfnuFVrj958q/tNzlXenYZVyGuVrpQ1jl+AMvRwuaSJnO//EYYqOYaBIsnFcCy
         RToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ggxXWX2QXeKOHI2GNezcaKGfjTo3F0HumEDmucHbcKU=;
        b=UZZCyrx4uMr1l4X+EyNO0c2smL+daF2z96psZfyRvbmek8iYn56D1VeoXhEUffPHL7
         Inf/01u3hGyPqiVassCJKZJOINsHeRjEK6mQ8gwBWV9EuyLM1jlGJMoY1J/pwxBKvSR8
         pN+4eIfbRloZwnVlwoRXTyFCS8GmR27mLB7iysujBTkoKMHCpg8cfsod51K6/LvRgKSm
         leWlNI4LPCWKDr0w2A1SReUaT8fusyuTYPPptvs9Y1nRTVP8u7fEyNHZKgye+vKRRcTA
         snPPig4turotYic5RzyLoO6dQWoAyHSXyqMajgFTZZC2oes+p1XlwzDkF6mSqAwNuljP
         Z2Gw==
X-Gm-Message-State: AOAM533iVmE2waJrx1MQUOFB8XGJOZuF9bb/lbuv4lt4F6vwzq9Ey9cY
        6g8mvuApyVuKT/Xhn42q5lHOa4JKkx8iRSsEtSLZVQ==
X-Google-Smtp-Source: ABdhPJyFYLg0pY5A3vHpb3QVG3rSrMn/8dfgfNJ49HdkutPZCssyf+r2LjSlfLaBQxtbcQlhygynUITYe4rplCbH6wc=
X-Received: by 2002:a17:906:4791:: with SMTP id cw17mr34367375ejc.493.1637244429743;
 Thu, 18 Nov 2021 06:07:09 -0800 (PST)
MIME-Version: 1.0
References: <20211118081919.507743013@linuxfoundation.org>
In-Reply-To: <20211118081919.507743013@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 18 Nov 2021 19:36:58 +0530
Message-ID: <CA+G9fYuVuu2xffq33+x3CCpR1MW+U+kgaM5g6u=0sSFzbWOkAg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/920] 5.15.3-rc4 review
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

On Thu, 18 Nov 2021 at 13:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 920 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Nov 2021 08:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.3-rc4.gz
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
* kernel: 5.15.3-rc4
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 6e3a56cbc9a1219bf26666c48c1270c344463a8c
* git describe: v5.15.2-921-g6e3a56cbc9a1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.2-921-g6e3a56cbc9a1

## No regressions (compared to v5.15.2-924-g7c10b031cbb7)

## No fixes (compared to v5.15.2-924-g7c10b031cbb7)

## Test result summary
total: 91324, pass: 77350, fail: 650, skip: 12475, xfail: 849

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 45 total, 42 passed, 3 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
