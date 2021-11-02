Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C595F44276E
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 08:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhKBHIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 03:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBHIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 03:08:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A2CC061764
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 00:05:41 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f4so14206242edx.12
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 00:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VaCMksvFtE0EnGB6kRonNUJMQ4iRy0D6ljvvHKCGuqI=;
        b=X7DdlnrzAn8FatDLSsVp26XJ38mRH44c/M7WFMWR1qUrHiN0BbNNeTWkaRTiyZ9fJy
         AVSmUYSfAgoaQ2N1lU3/HAnrLuq4oYiERRKtjT88DvRHFzWSFDZsKcTGAHPzohfhEG+N
         2PMhaH85PINScZElkuqrps11y8GNj4OaWQOnnTFNo8lzwGwbphpC1nbMwlMP9Aj2tXBt
         wuAZ7QsBp9WVtNHZ3ae5QAcwsod2qT8QTcjWkDDFELQCJgAuy3MPOFH3Kh7XQ4jPks7S
         Ct/i/XRHaHldRnp66RXBwGkQjrA6rtRSqfnKAUVmos5pD0fWZEcvYwCx+/48W2G7JIT4
         QvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VaCMksvFtE0EnGB6kRonNUJMQ4iRy0D6ljvvHKCGuqI=;
        b=b94M+3h++1Of7B3xVew+FHo+Pgee5Cz3bFFLbZ8D8jh/7hNatV2zTVcOP71TuVu5WB
         NyWKzCmCTsKJ0poXP6AjzLTYUKPxxoejqUqKKa2r+suyM3so3lN8CAut9os46aB+N6Zf
         h2uHY7U4A0aLL5BLn6PcVqpWJX0ea+CjfZ05YTExvMN4yvOjE9ufrqqSjPjPZxO1tK3b
         mqJTDuzGKA9W0O0H9P97M4kFv4yhlukCz6oOTxifdpbUlrcr7R3ZOml+p45XG+L9+Gmf
         sAPvs4u94bYXihc08xYJk6KfoJ/ULkhxL7V7kquOpOigpNqavnz0OxRwaDODhtlhFkMn
         etpQ==
X-Gm-Message-State: AOAM530l5kEeGoFH68m5OWvXjZkzLnzK4O6YSSe9oN6VnnuFGMPAoL5b
        RVlAPIghaFA/419fMHaVA/oH08KBNle5rxZ/Qp6IkA==
X-Google-Smtp-Source: ABdhPJw3Bw71ZiokbNdrYiCQKOk+NYKR+Z0DrbbUjUfv9vJ0NS9HAaplAziMvsin1JKn3PgFRR5B2VqRvpnUTmFnTUU=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr42838785ejc.69.1635836739258;
 Tue, 02 Nov 2021 00:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211101082511.254155853@linuxfoundation.org>
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Nov 2021 12:35:27 +0530
Message-ID: <CA+G9fYuhSXxDvtfK3rCVdSZ2S8ACe4fuqb0nrX0+_eKnO=sqgA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/77] 5.10.77-rc1 review
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

On Mon, 1 Nov 2021 at 14:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.77 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Nov 2021 08:24:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.77-rc1.gz
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

NOTE:
With new gcc-11 toolchain arm builds failed.
The fix patch is under review [1].
Due to this reason not considering it as a kernel regression.
* arm, build
    - gcc-11-defconfig

[1]
ARM: drop cc-option fallbacks for architecture selection
https://lore.kernel.org/linux-arm-kernel/20211018140735.3714254-1-arnd@kern=
el.org/

## Build
* kernel: 5.10.77-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 18363fa5f60b61ec6d80beddfbf38ef05f99f68b
* git describe: v5.10.76-78-g18363fa5f60b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.76-78-g18363fa5f60b

## No regressions (compared to v5.10.76)

## No fixes (compared to v5.10.76)

## Test result summary
total: 83370, pass: 70690, fail: 558, skip: 11347, xfail: 775

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 422 total, 370 passed, 52 failed
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
