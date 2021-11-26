Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A79945E8A3
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 08:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359376AbhKZHqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 02:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359267AbhKZHoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 02:44:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049B6C061763
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 23:41:01 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so35000808eda.12
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 23:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h6lcrRKDmFjPs1+f9KwgLLZePVGc9EcC4As5PUh0URM=;
        b=uP2YHov+kO2Gx8u+1VrSqSyjPSc9WRktRkNn0Rvn7iLn+w+ZODdUBmaau9Byzq8KRK
         vU3apB1SblLdz5Yk9KL6GU7H4OvHeZfWLycrps8csqQ3+KtLYpe90viwJsHMNrvFxP80
         P8uKJ4XtteN2RMNReCnvBYQS9GTn/ct0ZK4SLEJ2flC2r7t5vaa8NdNg57tJmwy9yEmo
         DrmdKami71b0xMvCC/krfUzqH6TQU4L51WdCCAuuHqBOfI+5LpRAg+ng4e/v7BO5W+ME
         8q31Huak5zeBfeJJka1No6DaXEKnzRhlYuWO8utX5+1L2qqExo94QE29iMZkf4AWSNXY
         ycVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h6lcrRKDmFjPs1+f9KwgLLZePVGc9EcC4As5PUh0URM=;
        b=wOHsLT+bvSHFAtpDtbVu3JvmF4TgZ7+MEXgrZtdAJDWwQPoI8Fgzq1oJKszM2iI8Ia
         rpMMVxT7lyp5us2jR+Fc4Z4WULFT0uA8O01bmY0XBHEgil/Lu1XtsgcNLpS24zZIY29q
         DIERMyXuU6g0nsdp4aeFQbjWifKHYzUETWLUH5vgctVJghxaTtyEWx+yM0sCT2UvMppy
         bDLRcHn3AIwMbH5s+O3wa1pGCrPNPZ3DlCRzuEGGrnN83sNa0D2YCvpHzEdmvK1TlaHX
         laBrTcg2FCfDL7Nvm+h0Whe1fQo61P80lFrMpckgaAnxlk9wAgp9rd4yMeZc+SG8KzJL
         LRcQ==
X-Gm-Message-State: AOAM530MjQTO/H1uFRI+yNlHv6DKnuZp8/jyy64qYRv3/V3oJEN22U82
        Kuc6aaaY9ytLla0HtdBAV3FkiZ6izGemkqbBhLWFtg==
X-Google-Smtp-Source: ABdhPJxH3dIgYhr97uDn0zv2XQdV7H+F7wxnIoOoN9olmK4bxsvc0XZwTNRyodGjD031/9IVC97EUO//MIsMPzASluU=
X-Received: by 2002:a50:e003:: with SMTP id e3mr45901399edl.374.1637912459014;
 Thu, 25 Nov 2021 23:40:59 -0800 (PST)
MIME-Version: 1.0
References: <20211125160530.072182872@linuxfoundation.org>
In-Reply-To: <20211125160530.072182872@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 26 Nov 2021 13:10:47 +0530
Message-ID: <CA+G9fYuHAF_OLEOqWYgrsxbTq7xqgXNXhEd_3KQOq0fO4+D5PA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/248] 4.14.256-rc3 review
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
> This is the start of the stable review cycle for the 4.14.256 release.
> There are 248 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Nov 2021 16:04:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.256-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.256-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 84f842ef3cc15ea9ea46cab24c9c76fbb20a30e3
* git describe: v4.14.255-249-g84f842ef3cc1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.255-249-g84f842ef3cc1

## No regressions (compared to v4.14.255-251-g2f2090beb462)

## No fixes (compared to v4.14.255-251-g2f2090beb462)

## Test result summary
total: 78547, pass: 62884, fail: 737, skip: 12758, xfail: 2168

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
