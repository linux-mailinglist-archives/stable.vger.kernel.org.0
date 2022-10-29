Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3896120CF
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 08:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ2G4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 02:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2G4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 02:56:07 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CB97B290
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 23:56:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 21so10786578edv.3
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 23:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jgDeNBSZQlv93+JZzxDcsUdFM1DjuKhSQlC8ZxGJsjw=;
        b=af/bSK46rGrdA/00qrPBKyNQcAoEJ1sjk128cBxb1c3vg4vMM5FkkVFhgAvAsWhA+L
         idOb43OQFtL18QYZglupH0Abbs43GtC/bwoMA0Zp5G8KacnlCjaG6+OoDm+TkxYSCTr5
         N/5hZI73ykbpiuQSG/TjHcBjghFjxpSymD7eZ5fHRDKCDScULTf90MH7ktjN/fetvFf+
         4YlCP9vrpdxT8689WoaVT4JOihQP1qsiNfC/3h/AEA36HC2Yy6onOWYppFAcnDgylA4d
         gujTnLi7BnTFxYb5TtyVS4p1RI1knRrs4D/ZvNX5HcKoc7rUmOVSWIWj0wwZ7d9V45Tu
         kDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgDeNBSZQlv93+JZzxDcsUdFM1DjuKhSQlC8ZxGJsjw=;
        b=LysC/cWVgOm8byOIzm2eVRPdIxOEOeMBDLXHDwvdB7HHug/jPTcIw+rrnWHu6X80V5
         b9M7tIrXdf6qRtOS+DZmmJAZ2iHvR7/eE3sI6ZGx4mhIAzzMsa8r9UlLERXM1XsS+vbw
         Ikjn1bZfOSGY0uEraUOGnTS8fvPHK0uxj3aXbXjdJmw1m6NFA7ibpLaPSd12TDhSVCpY
         yo5y+bUAzGlciJULjz3hGjU9Rsea3SsLT/YhZgsVLzwsFgqH7fx0j825PSwcQwkLEpXj
         reOZewPfwRPzo5h001tFSqewzt8Mm5KHUsdt5jcjByQFZmmUU2+zViPMBOENnSdYMsoy
         Ublw==
X-Gm-Message-State: ACrzQf3YG/nOYhIE091ephrzHbSKiMihVxnDoCIvuoy7K/qEvJt0PB8K
        yl5/ZeXcj9ZsfrD/4eJvZ7/4niXp/QaIB9J3gCWdWQ==
X-Google-Smtp-Source: AMsMyM6tDrG5GJxbw9ka7ABfSJ4a6/flhTN1qr4yNFTEPMRTGJdVeSpofKnpOIuUOtn4C9Z1RPgt+sgYj+Wj74EX1Mg=
X-Received: by 2002:aa7:d996:0:b0:461:88b8:c581 with SMTP id
 u22-20020aa7d996000000b0046188b8c581mr3073783eds.111.1667026561426; Fri, 28
 Oct 2022 23:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221028120232.344548477@linuxfoundation.org>
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 29 Oct 2022 12:25:49 +0530
Message-ID: <CA+G9fYvqrVD1XdVpgGQY+VNuK=VDDTgbS7BapQBH0CKXOHghSA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 28 Oct 2022 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.152-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.152-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 04a0124fa82b58226455ad4662246e6ff8c53bb0
* git describe: v5.10.150-80-g04a0124fa82b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.150-80-g04a0124fa82b

## No Test Regressions (compared to v5.10.149-391-gb4f4370de958)

## No Metric Regressions (compared to v5.10.149-391-gb4f4370de958)

## No Test Fixes (compared to v5.10.149-391-gb4f4370de958)

## No Metric Fixes (compared to v5.10.149-391-gb4f4370de958)

## Test result summary
total: 132774, pass: 112586, fail: 2626, skip: 17166, xfail: 396

## Build Summary
* arc: 4 total, 4 passed, 0 failed
* arm: 113 total, 112 passed, 1 failed
* arm64: 33 total, 31 passed, 2 failed
* i386: 26 total, 24 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 24 total, 20 passed, 4 failed
* riscv: 7 total, 7 passed, 0 failed
* s390: 5 total, 5 passed, 0 failed
* sh: 8 total, 8 passed, 0 failed
* sparc: 4 total, 4 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
* kselftest-breakpoints
* kselftest-capabilities
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
