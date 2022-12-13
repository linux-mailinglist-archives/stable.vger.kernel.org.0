Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763EA64B01E
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 08:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiLMHAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 02:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiLMHAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 02:00:44 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9440714D17
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:00:43 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id f189so13730611vsc.11
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jD0TEPiT0O5ndbPBWe7291iaK3/qwh0ScrkryadniPM=;
        b=nxp+eWseW0Ql1PhtfIWRkDtCHsw07bIZBK5iUUEzPwRpUu9FXlaexlKvmNdE9cJWr4
         mkRRqvjBWF0d7+TRsmp8o2sjehrAwa5DZduIUtKXJKA5+ofJwTwSz1eoAj/1d70r7o6a
         HdbQaqwgXEQv4nMyoS2EH2Wkmgt3E3KFGP/1hQW09rQQodifueomyaFKRaAYa+hS+loi
         QQY98XTmjjyn9TN/hvcmrQi/qjftcZp7i79xzfn/qF4Ua9wIugO6co/zF7tIu5G/iXQY
         0utmUgkRxb6rsFO61vTdcKp236X7wJsVv9ic7/TZTKQgH6pWNEZNz+jz00VZ8RbAiYZA
         6kwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jD0TEPiT0O5ndbPBWe7291iaK3/qwh0ScrkryadniPM=;
        b=PGLQbqXZ40iikxHur8daUuiYQqkloAKtfw1tss75iGYmiX77dUD2OCdubJVFGbfk07
         a+o8qIQIdEJKUONijRRMvubB1h4+X5It2MWskujU0J+843v7NZqf+nvmHDJmH+yr2EG8
         zieHtudUSlF/ADdIh0g/Kh5yL4HP59L5Xmqg/UgJbO4+sV91Erxnolk9JDWBv/xzDHnr
         67cX4x3lLAmfCxPYrp/hm5By5AiVmncH0s/aH0ZUZDB2LdHq4Bvpgok5o91wwduN9RAn
         FVq61Wi6/rLzhbEgQzPi60tOa4h0oOCTi28ALAqjRZt7+eFECgH3I9q4uJhDOV31LnIE
         Sb5A==
X-Gm-Message-State: ANoB5pkUoh0+pb3lEYPD9YW6Kbo7Xi5oaFcVFRGQ9o86IV2Bd48VTfw0
        CbhkrvIR7JaqXVFmeiHHkz3no/mranllHIN/sHnEVg==
X-Google-Smtp-Source: AA0mqf5Y4PJM+7m4exb7HnMZWnwJZSAKEvc/ILw64rfqmzdup4nKQR10T/XHIXSlhkcfef0UGSW2fmeeA2AoGLt0C20=
X-Received: by 2002:a05:6102:3590:b0:3aa:eee:5bc9 with SMTP id
 h16-20020a056102359000b003aa0eee5bc9mr43972880vsu.24.1670914842510; Mon, 12
 Dec 2022 23:00:42 -0800 (PST)
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org>
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 12:30:31 +0530
Message-ID: <CA+G9fYuCQBpAz8z0orqesA=n9nfuB6HgBHDz_VNLEL22iaatSw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        llvm@lists.linux.dev
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Dec 2022 at 18:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.83-rc1.gz
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

NOTE:
Same build failures noticed on stable-rc linux-6.0.y
* x86_64, build failures.
  - clang-nightly-allnoconfig
  - clang-nightly-lkftconfig
  - clang-nightly-tinyconfig
  - clang-nightly-x86_64_defconfig

## Build
* kernel: 5.15.83-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: d731c63c25d167aac504bec579352a3f0c3e14ce
* git describe: v5.15.82-124-gd731c63c25d1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.82-124-gd731c63c25d1

## Test Regressions (compared to v5.15.82)

## Metric Regressions (compared to v5.15.82)

## Test Fixes (compared to v5.15.82)

## Metric Fixes (compared to v5.15.82)

## Test result summary
total: 144331, pass: 124830, fail: 3201, skip: 15737, xfail: 563

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 35 passed, 7 failed

## Test suites summary
* boot
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
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
