Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3E462C54
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 06:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbhK3FuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 00:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhK3FuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 00:50:01 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50AEC061714
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 21:46:42 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id l25so81624725eda.11
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 21:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LYTQe8+qt/B7HUNyS2m6Byeu+yTOhatNCx78l9wCK34=;
        b=H4CN7rmanFfOYdVnBHF2pV2ZExwYC2jncMha8GqCOkm9alZCvCtNWDu0UruxgXiGOh
         u7AzkhqM0PzqLvDh0TmSAtSxcrSDh0Z9Rk5Jq7STQPnb4TDqXOFuVkE+IA3vT2OFxdwe
         xAAc5zhKNT8mCLZ97Co1k/4aXhwSv0fiihYxcPD7SJdaeLWLBOJ+l7VGGvLqUiNxGNrr
         7UWd9EqRX4lxyQ+qzRvhNWHNBBWHX6OkFu4A551+LmezFQqT0ga2ZIPZGTmyH+Hok6MB
         PyzQM2fisXY8DQUZAaBqWSLC6wwMDa8jG7qG0yXobk0o7cLemN3hi42dSzz866wLm1y/
         JN/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LYTQe8+qt/B7HUNyS2m6Byeu+yTOhatNCx78l9wCK34=;
        b=nKBaiEQiL8c1cgCTs+EmxM4ok2VEEcjEgLOSpox+5K4DUHajzC+PvWvcyqBUDzYFJp
         1T51CuztTGs0kLoA+AtjtUGY01pmj9b+AE/F8pPFZlUMhzsmVm2HJyLG8ePO8zZa7OfF
         rgybVKPOXQ2q+emeqiqIei6KImnGbPmd79R3LogbqV2pCXVoyvJnvvmCryT8XEuAC9oF
         E2n3GWNpyMOfgHfaOy0Qu61VqdYTiNR06jEl1YDqxkZW375gfZjbs3B2/QZz+TYfIzFl
         IZNQckjPS8bf2RyfmhXul+t0FjiU1FPjJ4S+409/Gjf/fNfGKDKpUj1ubbHt/3SyuBxS
         /KsQ==
X-Gm-Message-State: AOAM530G9BhR/3R5owk248DbQOZagI7+8n3L+vhTZffEwwdelPTHK4RI
        38Kd62jt+ppRyzqwxFzPrpFKTd+XnZBlROHfxrlRaA==
X-Google-Smtp-Source: ABdhPJzHm1Qo9VcunwTeqllot7dsQ7vji1FaMI+dmnIsydXGOCiVWI+b/jmLe6vmdnbU4nnzkg9EJHnzNdhGHf4kAjc=
X-Received: by 2002:a05:6402:2813:: with SMTP id h19mr81036302ede.267.1638251201083;
 Mon, 29 Nov 2021 21:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20211129181718.913038547@linuxfoundation.org>
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Nov 2021 11:16:29 +0530
Message-ID: <CA+G9fYup_akNK-ttEuy3qfUNNb_-SMtuUNXXemkf=mHkuQ1T0Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
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

On Tue, 30 Nov 2021 at 00:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.6-rc1.gz
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
* kernel: 5.15.6-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: a6dab1fb6f7d0b0357301dcad771ff9d349fd6bc
* git describe: v5.15.5-180-ga6dab1fb6f7d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.5-180-ga6dab1fb6f7d

## No regressions (compared to v5.15.3)

## No fixes (compared to v5.15.3)


## Test result summary
total: 94184, pass: 79366, fail: 1087, skip: 12763, xfail: 968

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 37 total, 35 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 45 total, 42 passed, 3 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
