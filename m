Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DD04B67AC
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 10:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbiBOJeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 04:34:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiBOJeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 04:34:23 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C82B65FD
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:34:13 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id bt13so54276205ybb.2
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RF7hs9hKJBm03X0ReYCknuAjGAC1I8IaxNBksYlqjvA=;
        b=NafvuE5wb9VO0YfpQJAmhcj57AnK3lScTcTv4Oeprb434fMH4a+nvDJzniZ5pDcliR
         L4ZNClSGUsldD6jiiklGZkZN6XqrDu6hQf8Xx0pxhJx+s02mwRYJlXWL4mvuC+FqkTKt
         VOa4FNfBdhTe+Yx31ukfQRWwkUSGvKz/c3vpMTDhTqDVaQCS6IrqiZct19uMXlx+cVxw
         cZSnmXDYVKFgZlEbgW2Wzn0KbHFZIyCGXh2zLJfPLUILzCxlp3nHK8IgZ46/03kbVzfG
         R0gcUiwl9wcd364tJ8jI8eZaXW+KQ5dVQWrc7VqO9nXiTensDESLWCXnS/CPD9v5sQy6
         2N/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RF7hs9hKJBm03X0ReYCknuAjGAC1I8IaxNBksYlqjvA=;
        b=cMFqXzi90ko9Eb9so7KMwBRZ2DrUyPpXj+rN0BNwhssTbjZMzFOlRMu2fVht1gdi9h
         yP35taxE2wQmd0LvQluhpVdPlHwr5oOd0LFvHpc5Af4Eq6j6q1Idk9xz2lafir8U0h9H
         sJNsRwYl+mSGoZkh9Mp9GoetsYqNZktwJEuAD62bQzUix2/xMVWcbPe8xkZ04ieP6N0p
         NP3kpkGsFY2nZosEWeucSfYBfIGF6PaY3ovuVv1Ga0sCo8FRR7H+Fvw4u70DtTTk7zFb
         wQ2KXiKt6l0cgv3c3vBzRPuFe4tDD39ggLfLzvS5HyXOwNpokt4vqDta2wgC4bDzdqZ4
         /AIQ==
X-Gm-Message-State: AOAM531YsMbproPtnUOXerHQIcXhlCpDQrBbFRJzJLOCiww0hftb8f58
        PXKgnR3UVDslx04YmhBEERR9/ON7DtfYKYpTeVir4g==
X-Google-Smtp-Source: ABdhPJw0Dm9KzEA7SDMhUASVBNE5a/v+TkV/1mqXS7Zy45mFbuJ5tdQ+sDY4kRooxpmZSCJoYVituF+QbBKH5VkVdbs=
X-Received: by 2002:a25:bc81:: with SMTP id e1mr2909570ybk.553.1644917652436;
 Tue, 15 Feb 2022 01:34:12 -0800 (PST)
MIME-Version: 1.0
References: <20220214092447.897544753@linuxfoundation.org>
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 15:04:01 +0530
Message-ID: <CA+G9fYvMfijwfy+zUT9ekj0xeSzb7b=GyZH8-gz-MonNdftkgg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/44] 4.14.267-rc1 review
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

On Mon, 14 Feb 2022 at 15:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.267 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.267-rc1.gz
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
* kernel: 4.14.267-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: ce409501ca5fc4f5e9e69e85655f25f01fe1ae3f
* git describe: v4.14.266-45-gce409501ca5f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.266-45-gce409501ca5f

## Test Regressions (compared to v4.14.266-45-gf7ca1925a437)
No test regressions found.

## Metric Regressions (compared to v4.14.266-45-gf7ca1925a437)
No metric regressions found.

## Test Fixes (compared to v4.14.266-45-gf7ca1925a437)
No test fixes found.

## Metric Fixes (compared to v4.14.266-45-gf7ca1925a437)
No metric fixes found.

## Test result summary
total: 64375, pass: 53031, fail: 449, skip: 9624, xfail: 1271

## Build Summary
* arm: 250 total, 242 passed, 8 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
