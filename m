Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7924C9090
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbiCAQqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiCAQqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:46:32 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596F73FBFC
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:45:51 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id f5so4580005ybg.9
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5wLbSz00Zs3F7EeJLFQDe8FIgTXEIryvRGYUMeIMSPM=;
        b=MPh7lShqRR0cdAgt2zAunAzN6CGZ2B+zREDomF/U1WLNIEfUskM4m7lzwPXO2re1+h
         z9hcn2QjJbHZdUxk0QTaILOhtklICBO8dO7u+weMxNlkvavbUNXl1yg/MuAB3V5VZd8U
         Kq5DCtULJH20gADjuzC6NOH6zfIoUcPZLHCdQRoxlPqE7IdE65i1To8w8QsqJL2dCXE+
         kNYDrVJn4DvQ+1qPWMD1FTkeh5eU+b1anoHin3rioOUzIJz7jMePpR1o6GEPWTsRQr68
         nqanbDlNyMCAEIS9NKVEWd23v4lGbV8a3ngOsHehRANBsPt9aLG79PmYef7ENfOxOczd
         OcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5wLbSz00Zs3F7EeJLFQDe8FIgTXEIryvRGYUMeIMSPM=;
        b=ZuD3nq+uPTnuLSKcCzsYnJIsE3arzDt10Biz1BrqmQKS2OmPdorH94vskexoG+CCQ8
         1ixPLDQTrKeHp1KddFYMlYayTyUiW5ATgv8cn/puUBTN0MIS2Mk1GtbNBERjg/GlPjEa
         mv18xWtZp4tYcPAJpjwpysvZ8Vd6Uus69k1fk5vEZWBrloy4s5zag0G5/+VBkTly/gYm
         pVZYb8LOGuYpThDnmVeY4ImPRntZC4KSHD0RO9URXpAzzl8/P8Uix+om0udq2zi+eDiS
         Wax3GlybSL75SgWlBUIyrvxhbY06rTXbKNTc6Aik8mBahre+BkWhywjWlJfM7Anbknr5
         mSZQ==
X-Gm-Message-State: AOAM533ELPbhQhkmJxzYAvpWDIucW8YV1JOKCkoGl6u980MebmBlz53m
        O1cy0kMm2TaPvyDsf/VlxCYUBNj/sq6kNRZlH0lxaA==
X-Google-Smtp-Source: ABdhPJxg+1RbDPSzUc4zkl04ldH2EcQ/Y0kvklzXyMRlsFoCGSM6bxxpk9S4hXO/fIErTDzz352OrwI4G635LxVExbc=
X-Received: by 2002:a25:d0c5:0:b0:621:c44b:b219 with SMTP id
 h188-20020a25d0c5000000b00621c44bb219mr23986911ybg.88.1646153150413; Tue, 01
 Mar 2022 08:45:50 -0800 (PST)
MIME-Version: 1.0
References: <20220228172248.232273337@linuxfoundation.org>
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Mar 2022 22:15:39 +0530
Message-ID: <CA+G9fYtxrrxtbNtA_u4Ro5BBaOJvXVzA7EbhphpZLkLLJK6T7w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/53] 5.4.182-rc1 review
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

On Mon, 28 Feb 2022 at 23:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.182 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.182-rc1.gz
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
* kernel: 5.4.182-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: aa9d24e3c1088399a4cd2b031c4c6abee5d58a60
* git describe: v5.4.181-54-gaa9d24e3c108
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
81-54-gaa9d24e3c108

## Test Regressions (compared to v5.4.181)
No test regressions found.

## Metric Regressions (compared to v5.4.181)
No metric regressions found.

## Test Fixes (compared to v5.4.181)
No test fixes found.

## Metric Fixes (compared to v5.4.181)
No metric fixes found.

## Test result summary
total: 94463, pass: 80146, fail: 534, skip: 12639, xfail: 1144

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 41 total, 32 passed, 9 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
