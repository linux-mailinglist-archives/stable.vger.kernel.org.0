Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1663A5272D1
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 18:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiENQKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 12:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiENQKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 12:10:31 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB6910FCC
        for <stable@vger.kernel.org>; Sat, 14 May 2022 09:10:29 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a3so1220242ybg.5
        for <stable@vger.kernel.org>; Sat, 14 May 2022 09:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gE6MkiEEeLCD45NUwOwjJ66HAqwYJPy4L3Othuorgfg=;
        b=T+Kz6ULiQwTEEx35wwUENkM5czt1bdXmIdlzyQoyPUhU4wODz+mFKLE1XtqyNhj6Wk
         hq26xKmLxVTp/7swNDxKA+jmvDBYZ+asLXYVPLpl1bpFgzWfTKqS3/i7GKpg3DeJP7F3
         vPfvrz+XlidBs+AsogX/hfEMUPGbTcqs/lnFln6zvUPn8Ylzh8AYG8M0yuFMtd8Umt3s
         Jt3qRjd75RawjcVLjnktvZ7S7DO/lWty0LLXUeagnYNO4+prmZgElOk3cH2IklSVmpgI
         wOfhJ8rBFftGyWpQve+agGq4J1UkPLax6/aZ0LNmzLMzdjf62lrxgyywiPfRvHSKb5EA
         Ocrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gE6MkiEEeLCD45NUwOwjJ66HAqwYJPy4L3Othuorgfg=;
        b=K7eRQAVKKqUNU4bWi+01mYAOafvbajdMS3XVwHbuPFFUEitvt8N6KcJaOrgfkOBrpZ
         1nya+zyVznYDKCtYrGvsxl8mSnlYZeyeT8gKy0uQlasse7pofcLI3piYQRe4pEVvu8IG
         xvxly8KFikyZPv18JtGzLALFNuEblod7aNBdmWgttJDoL1f1CNYP6o99hR4Zndgxlr3l
         hc2dBFip059JniRlnQ3WuxhyNi76VtNVMbJ58PkH5pmVQAxZn3+GNKK9fqrbKCVlf6jh
         QGb2tF9HR5ES2mGLiv5vwlvpAl4/FN4q+xbsV0dO2u9ofSjGFsF/b3dLl4/UUKZAB+MY
         1bJg==
X-Gm-Message-State: AOAM533dAks9z7bwPZfPBzMkkfyPl7u2oFQ5/uw1Bj+WaS7ZReigoE21
        yTpFXbSR0PjTDJbcI39Xj8AaN2PLg9qm7K80rLxhUw==
X-Google-Smtp-Source: ABdhPJwtRs+Y1Hioc9z2KVg0VNt1BsSNO0GqyEgof4XeeQ6yrifdMuUXCbryL4ZutsX4DIlbHACLRGlDvUJOiI8V3T8=
X-Received: by 2002:a05:6902:704:b0:649:cadc:bcf0 with SMTP id
 k4-20020a056902070400b00649cadcbcf0mr10091833ybt.537.1652544628987; Sat, 14
 May 2022 09:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142225.909697091@linuxfoundation.org>
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 May 2022 21:40:17 +0530
Message-ID: <CA+G9fYuZz_sCMz1UYqx+JigsUDtn5Ub-g3k0icm0yf40wcbM+w@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/7] 4.9.314-rc1 review
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

On Fri, 13 May 2022 at 19:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.314 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.314-rc1.gz
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
* kernel: 4.9.314-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 0d0d580b3778c2a438b6315b8f80b87835d1f3e1
* git describe: v4.9.313-8-g0d0d580b3778
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
13-8-g0d0d580b3778

## Test Regressions (compared to v4.9.312-67-gbc7a724ac0ce)
No test regressions found.

## Metric Regressions (compared to v4.9.312-67-gbc7a724ac0ce)
No metric regressions found.

## Test Fixes (compared to v4.9.312-67-gbc7a724ac0ce)
No test fixes found.

## Metric Fixes (compared to v4.9.312-67-gbc7a724ac0ce)
No metric fixes found.

## Test result summary
total: 64906, pass: 51271, fail: 739, skip: 11179, xfail: 1717

## Build Summary
* arm: 238 total, 238 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
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
* kselftest-zram[
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
