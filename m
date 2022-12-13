Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27DA64B22E
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 10:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiLMJVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 04:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbiLMJUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 04:20:35 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A29FCE
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 01:20:33 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id 124so14015693vsv.4
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 01:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99UAZJTrfKiJofFWBM4NXTM8EodixIF3J6Az3rrCy4A=;
        b=FlVsUZujxyAO6a2fFPG8cg5ZrM7kqbzA4NeT1MAaJ7gyIpdUf8S5IMC0Rjc0rpBNr/
         xDRJy3ZBT7J8Utk2cJqRjjHu+/DrjqD8DqV6C68cqEQsbUEUif5rcbLVtRv1Z8+B2rRm
         Fdif/Vd812iGnHF+QaWHPtJMlQhgQm47cLB7r0N06OTC4D6B81Mc2AFOh4tzuJAd9Ax1
         rTRaAi7WqDnEN4l+ZsElDwV2bkJejq3C9MYCobvCxfxqNGipvrbS2+JRzkiRD+Eeh22F
         6dUe9CDqDAEmYMjmhIPQNWp9fSVvbTb4M04kgg8dDx4qqqRDluY+C2G9CgwWk4YuqIJ9
         lPiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=99UAZJTrfKiJofFWBM4NXTM8EodixIF3J6Az3rrCy4A=;
        b=lVrTjy2/AXqFnoxsSNNdY6muHuRoc7lix3Zyr71NPO/59kvK470SqBnG8RKkiJ6BUr
         oU+eSM/B65btRhEvf14NVPUy0PjFwuljmgf/qd2F3Gl19+ke+csIKGqgIaKDer7/+ZN0
         MU3afmo9mhqeIwkaE+0adF2jdrd5a5bFXV3HDZ0pRqljdtxkzdqi0TYMwdFXcKXE/wxT
         BuE5RnSkNdoRlD+WQQEkxRrjgmsUEFEomsM5p2wfwSFSBn8THrd14lPI8qtLCEIECbXb
         NmhlKYEGZk4YXNTXvENTsqWLcYQJ78j8NNa7dwoGTYLMbyd8sLVX3ZZ5rMeV5qPCe/fI
         M6Fw==
X-Gm-Message-State: ANoB5plLFl1iILhkD7dVnf5HB6AxQHS7JwrIO66lb97NeTRe++piYIsr
        yoQ0M9WxuAGORQWGebNexJhUd8PrcdbhiuL6Jj6JcQ==
X-Google-Smtp-Source: AA0mqf6uFnKRk2QSUJ0KAvYnKeLU2GkehLzganp6e8uKVPnodOU7S355ViySWjngXw2uINdpr0CuVM9+oq7tgqW6sAM=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr607213vsv.9.1670923232845; Tue, 13 Dec
 2022 01:20:32 -0800 (PST)
MIME-Version: 1.0
References: <20221212130917.599345531@linuxfoundation.org>
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Dec 2022 14:50:21 +0530
Message-ID: <CA+G9fYtdgLx0hrtGk7G8Jvt2GhY-FoCTp0KtF8ngGix289G2QQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Dec 2022 at 18:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.227-rc1.gz
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

NOTE:
Following build warning found,

mm/hugetlb.c: In function 'follow_huge_pmd_pte':
mm/hugetlb.c:5191:1: warning: label 'out' defined but not used [-Wunused-la=
bel]
 5191 | out:
      | ^~~

details of commit causing this build warning.
   mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
   commit fac35ba763ed07ba93154c95ffc0c4a55023707f upstream.

## Build
* kernel: 5.4.227-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 8c05f5e0777d154e70c3ab34e0fb0e1778b7e23c
* git describe: v5.4.226-68-g8c05f5e0777d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
26-68-g8c05f5e0777d

## Test Regressions (compared to v5.4.226)

## Metric Regressions (compared to v5.4.226)

## Test Fixes (compared to v5.4.226)

## Metric Fixes (compared to v5.4.226)

## Test result summary
total: 114898, pass: 99995, fail: 1941, skip: 12727, xfail: 235

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
