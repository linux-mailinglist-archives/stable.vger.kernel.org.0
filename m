Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC34D93A3
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 06:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiCOFPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 01:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiCOFPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 01:15:08 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D201186EA
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 22:13:57 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id h126so35136944ybc.1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 22:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lc1nf94W/TLnN7k8lllOm1GaracYb8kbi0+aQJW5wnI=;
        b=z3RoeVw7Bp5VB2AoMwf4OP/c8IrVaH+TXzQHAmXJxEN1PxY3S22zbE8+23GJalGxdi
         BW+5s+s98pEROs36nBMRZGnsoJGPsqsh+SEgHHM5I1+1u5EbIZB482K0lNR8DALayuSu
         qdNFnPdzPc6IXP2WOZ4MIIMs0IPxxiUrS3R4XW45IZgZvUuTnV2tnz3yGeZjNbsLpAxV
         M2JK437McA89Y1wGaTl+ZbTRlvszaGFAvr6w4ZPcTWveRbSe3cEco1iSEpH0qIY+S2jv
         qniUhXuXUJzLknlFf/OhjDqezE2sW2ulAB2nlDluGvdaY0SOz4/vV+sWcDRQUkEkdAxb
         lG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lc1nf94W/TLnN7k8lllOm1GaracYb8kbi0+aQJW5wnI=;
        b=SvZb3NbwzJTnu2D32xJXbL4Bdeftc4s6QG48slSwguM9zsGsLsRR6jp+Wg0mZ2p+K6
         UuwkrS/5IZzT8relKGwphHgJmCFRtllCRI1FN6p6A5AkMvcDpY8DR3vdOJSH8o5Ht2NZ
         5Lf2pcdXPP+IiXMaDr69D2U7RxM3yoOM6tpzWl8ZeHF+o8NM/vXUssKludzTr8YZuRN3
         GSyJq19AZnFf5gKUw1EEiVjoZdnh721soTbLRfGzN4uDvZ2o4IuRchkOjP52XsZ4mmiB
         BJfIGT/9J5lMSLxtTRuWK0gqGpq4TP1r7euY+TWk8D6MEmy+1CE+9CgVe/60Guqivglh
         dvyg==
X-Gm-Message-State: AOAM530O3/NcI0zicUezPXFRu6+yv/xKNLD3Lckh6/N96T9hA9S38rnp
        7aihlEAKZQTusUjagyrL3Ld90KS3/+OU1PnLpTqoRw==
X-Google-Smtp-Source: ABdhPJyuVoU/6qj8X+qwLmQatTi35YRBySZ8AMB/W0s8Igi4DVjVWbkxFIgId8BrAmWcqWtv6/dsEoMyNyX0wKTO/0s=
X-Received: by 2002:a25:338b:0:b0:610:a221:af23 with SMTP id
 z133-20020a25338b000000b00610a221af23mr22249848ybz.474.1647321236157; Mon, 14
 Mar 2022 22:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220314112743.029192918@linuxfoundation.org>
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 10:43:44 +0530
Message-ID: <CA+G9fYvEFbGsrz-tXo_sqxC6E5MjKPYjxU6BpiGdfA+hKnzBag@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/110] 5.15.29-rc1 review
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

On Mon, 14 Mar 2022 at 17:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.29 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.29-rc1.gz
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
* kernel: 5.15.29-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: b411815a8fd9cedbb6922e7601165c67d7abfa43
* git describe: v5.15.28-111-gb411815a8fd9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.28-111-gb411815a8fd9

## Test Regressions (compared to v5.15.28)
No test regressions found.

## Metric Regressions (compared to v5.15.28)
No metric regressions found.

## Test Fixes (compared to v5.15.28)
No test fixes found.

## Metric Fixes (compared to v5.15.28)
No metric fixes found.

## Test result summary
total: 101285, pass: 86989, fail: 747, skip: 12609, xfail: 940

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselft[
* kselftest-
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
