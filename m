Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3303A4B66EF
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 10:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiBOJEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 04:04:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiBOJEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 04:04:52 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40891160D5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:04:42 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id c6so54015522ybk.3
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LXyU3TMYJOTYLwfoTA9DPkdeJqji2Meoteuh0Ak6tJI=;
        b=vK8HB+w+227qiYy9jQ0o/EUJrbJWJ3IxR8YLUp45GrBNUkgRrIoBQaprNkclJ3UVLC
         d07Wuj3xHr+Jgd1ROTq22iJSqltqQ7W6oy+hxD8uh7EJoq0WLq1AJ4968clZ9FIxMqB+
         hk4kCS3/mTAjls4AGJczDrIR/cetgsbyMNFiED0uzS22JuRCIGTBetyYsd6XD1Hz24cx
         Xpojx4yfkc9EhxLQG+4qvBOjSCwjta3aJ99KHM/oCR6utxofQiHl1YUSqRcLks2EEt7J
         vzRbCV6XjBOogNBN9NBhVdrOD1YLc5b9M/cJiqyjGuLwfidXNqOxhIFhIyI9dPRuO/85
         gBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LXyU3TMYJOTYLwfoTA9DPkdeJqji2Meoteuh0Ak6tJI=;
        b=tmili1m74YZUCAsWJqY+XR4y1d1APid0zuyq9WuyStyjETXhJJTChhW9wOD/xwvP1b
         jSrmC7OPIHWv+d6QfvTIkbFeEOytemiuE8V3lSxKhhVp4LeYHG8XfecgPgsRSRLcc/RN
         ugZXcyovKp2z1TWf5Mqno8+EYaSB9YG4nrUgPRlV0wo56G/9wmsz2SlLspmxmDbWc6dX
         //JaksJj9QEVZIe4m+eCbri76YWzCuq0why81D6I9StzmRVATwI4rSx5UvNX5ZdBoMSy
         2JkxWFL1rTpBJB4crLveVG+y7sxQRzV8OmNhMx6Mxcip5Me7ZPTNrdRD6l7yNAd5hlME
         zG9A==
X-Gm-Message-State: AOAM532+L1jnK87yAmQIvRVOBXjCGZZB66/AwPld7U6KyOI/b0jZoSYY
        Q4jOZM39/s7s4OCgrAIfTWGGl8UzATo3QfN4GcVElzYPHj+6Bg==
X-Google-Smtp-Source: ABdhPJx4A8t0cA0oOLKHs+nQ1VCfgcbCCv3Mbf0JNfrzPCLBbWfsyI+1WNFHsI28VLH0Mjv8kIaKrLVbYLb/+hAQlUA=
X-Received: by 2002:a05:6902:1201:: with SMTP id s1mr3081406ybu.704.1644915881755;
 Tue, 15 Feb 2022 01:04:41 -0800 (PST)
MIME-Version: 1.0
References: <20220214092458.668376521@linuxfoundation.org>
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 14:34:30 +0530
Message-ID: <CA+G9fYvFCWaz_8L6fbud46RLgkrVTgj9EZM_OfUn=6nXwYs_5w@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/116] 5.10.101-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 at 15:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.101 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.101-rc1.gz
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

## Build
* kernel: 5.10.101-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 8d15f8eda4b30d50abb1c58be6a175f2ec07888c
* git describe: v5.10.100-117-g8d15f8eda4b3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.100-117-g8d15f8eda4b3

## Test Regressions (compared to v5.10.100-117-gb184da91385d)
No test regressions found.

## Metric Regressions (compared to v5.10.100-117-gb184da91385d)
No metric regressions found.

## Test Fixes (compared to v5.10.100-117-gb184da91385d)
No test fixes found.

## Metric Fixes (compared to v5.10.100-117-gb184da91385d)
No metric fixes found.

## Test result summary
total: 94250, pass: 80953, fail: 542, skip: 11915, xfail: 840

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 35 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 37 passed, 15 failed
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
