Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60C146B799
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhLGJm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbhLGJm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 04:42:57 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1553C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 01:39:26 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id t5so54500301edd.0
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 01:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WGo/QVbK/TSIpI3qUR7eBM4qHBvmukUGZVBWwo9E1no=;
        b=R6OuklbcmZyHv1geiPJ4yZ0zlMj2O91GGCed7xLBbCHxBte7tedpAG7O2XSVJ8t/P7
         uMNN8z6pM9ZgRw3/1e3G6m8alXke++4WQasihIxgnCUmDpR1j9fO2hCHUE6B7iwqReqV
         ZSmqVW+ufEeqqREEk3ZheFBGM6m/HZd8/LTIJAr8mCU8SU0s5WZpGieSfI/luikjyH5a
         NHCs6aSi01zGinuaZY72i7u+A70VuFoq5SL0NarTdn/ZRfmGfHg6Od2lvyQdywksogS/
         j6B/6in/NYMxcrsCkSB5CmzyvKUIRGHHKfJ/wiKbbLQ43wYItANb1Qz9csWGkoMfgcjW
         Ee9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WGo/QVbK/TSIpI3qUR7eBM4qHBvmukUGZVBWwo9E1no=;
        b=n+GSwantt/TJJxBbCc2gY1V4yHm2flqQVJ2ck3XnVDiEWJABMKw5e+67Q5pbTn7zaf
         MkFlp1cPIJ+jWInK6mnKW7vYJwB9iw6vPOISRchK+o81pAEKbJEQY8Y4AixJRkjNcONl
         UJn2FN3yfHj4fbg/GPr4gVP4GlBoJ97nZrREsJeVQ0ico2qwtfpNo/O6GAxTz/gJt2Mu
         i97QXLDzMP6oWBQGZf40dF85ntxslG13ibsScMjfKmuG+vJ9k/6+9crlyFQXKNBLfo05
         g+qCwJRilgYR2GenNEqhGgHs8ykaqaFBEPbvPSIB+HDdOUiX2E+hKcvbJ+1sOEZqZJwk
         nCFg==
X-Gm-Message-State: AOAM531is7mNOXOsbKJT7NtFlqwXnAcd3uvNBxuoILlbEI1kcJaFSTPA
        Re2uedq4gfrAJZBXmZbEPToT8BDpHJHi5wpfg3bRtg==
X-Google-Smtp-Source: ABdhPJzxk/AiNNNQ0ba0Rd+Jl0oay16fwIJuoNE7YFINmW3Qig3bDeQeYreGkjGFxV1IwVTVgWrCd0iSs97jrr5qX/A=
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr50862790ejq.567.1638869965113;
 Tue, 07 Dec 2021 01:39:25 -0800 (PST)
MIME-Version: 1.0
References: <20211206145548.859182340@linuxfoundation.org>
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Dec 2021 15:09:13 +0530
Message-ID: <CA+G9fYuAAdeYThitRaYTnQtj9v3Geiw6ZdWHXeAX2JpLZirCaw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/48] 4.19.220-rc1 review
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

On Mon, 6 Dec 2021 at 20:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.220 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.220-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.220-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 36bf297d873717a14e37c015e0e4947bd5a0b6fe
* git describe: v4.19.219-49-g36bf297d8737
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.219-49-g36bf297d8737

## No Test Regressions (compared to v4.19.219-37-ge0e7c50a944b)

## No Test Fixes (compared to v4.19.219-37-ge0e7c50a944b)

## Test result summary
total: 72689, pass: 58828, fail: 638, skip: 11613, xfail: 1610

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 22 total, 22 passed, 0 failed

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
