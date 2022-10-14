Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF135FED0E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJNLPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJNLPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:15:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A3FDBBE8
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:15:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id sc25so9701955ejc.12
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oVVzJrTrR2jAqDtrkcw8xefnkSNW+0F8qbJOJG9T+30=;
        b=iJ7TO8g7KeXQByM1J5Us6aK4ezZwLryxfL2aEc8dCKZlDiJiDN9wvCaY1XgUbH5W1q
         AD3WzzPRNXddJDwIem/b6ejHnbCf0mhi0hO05lwlbBZtvCMjOaSRqydvfEfBH7Wa6dSC
         QMenWZpkUTdfhS27w3dpv6psQZUajf8291cLsUZ+tKf8IhMAVGoUsJWf2+qPDTfhC6eI
         zukcwvntkcMzxd9hF1yY6f6eeKZcACc2Ny1vI9k7vkIEiZj+MMVS2m9/YZybb9Ed83Kt
         wSX70AUazhffCdPT834sjeGFvXHAWLoSo4naupVesK/hQHllgJe4IsoyW4TJ/JnaEnfb
         ihzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVVzJrTrR2jAqDtrkcw8xefnkSNW+0F8qbJOJG9T+30=;
        b=7aSyEIa2H9TLTCZYtK5hm2pAhptUHxVbIxX0TNzUnKcnHS4VTqOZ5DQx48qyO+t7sb
         oU4P3gcYi+nSH6i3bNxTpvgsPzV01wSHcGoX9Kgs80ON0glfgFe/HgR4QfLbj1X1r8oI
         JplKOIdvENOhYpSInfBIT5eWjrfVpHkmdWHwFehRlc3/014FXPcs+WRj+U35PE4U1UcF
         TEZFIGRbzGAMlpYO61FEt5vFMl7Kw+xdMssevIATcRZxAsr3lpMFSCTHHoytkYpf74OJ
         LR8PQ7ATiKICgHe1+VpxnNTb8RFwV+EiA1Hk+VfK5NBTtuqY0pGHYpFWU8INCW0OA1BA
         bINg==
X-Gm-Message-State: ACrzQf2MY7KSfW3HYI27RRQxM+ZsiaJYWpCN0k2XCmxolF36mcIkqNvV
        5ezp1lESrrkzI3/F+0+MFHf6dDSEL0lv4B0vtuuURQ==
X-Google-Smtp-Source: AMsMyM5hPSxR3HNaRh3Y3wBbpqB077aPe/z2/umrNSEpYbNS630rjFDztT23dc/HvBc1HdN2JwvQZ/G81MWLiEUSGH4=
X-Received: by 2002:a17:907:948e:b0:783:91cf:c35a with SMTP id
 dm14-20020a170907948e00b0078391cfc35amr3167522ejc.366.1665746149744; Fri, 14
 Oct 2022 04:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175144.245431424@linuxfoundation.org>
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Oct 2022 16:45:38 +0530
Message-ID: <CA+G9fYv9c+RVC15Ncg3kCezkerbTS=dvvM-01BmbmKFVz1y39A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/38] 5.4.218-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Oct 2022 at 23:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.218 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.218-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.218-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 34b618a713e70b364e2d7e784cfb1a79c36bddc7
* git describe: v5.4.217-39-g34b618a713e7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.217-39-g34b618a713e7

## No Test Regressions (compared to v5.4.217)

## No Metric Regressions (compared to v5.4.217)

## No Test Fixes (compared to v5.4.217)

## No Metric Fixes (compared to v5.4.217)

## Test result summary
total: 72725, pass: 63087, fail: 850, skip: 8400, xfail: 388

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 334 total, 334 passed, 0 failed
* arm64: 64 total, 59 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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
