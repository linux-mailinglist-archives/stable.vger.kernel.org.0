Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF2622C67
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 14:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiKINbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 08:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiKINbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 08:31:33 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEFE2E6A3
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 05:31:32 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 7so16431799ybp.13
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 05:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aouj8d0RJ50aW/Vsd94vh5WZ038hUS4IE2hWYAidGmc=;
        b=oQlsBIixlmUIimrpVlQi8SjHpZjTmQ9qwf9leUmFVEkhcal/uKHuBZKYDUUZsREG/s
         9UVXHavUFcIsvUCRsRT8gtxWd4wcuBLmXeOfIBRuu5VTjEAICEg9+hPf9/gWxx4m3e4A
         teVzA/O5CMLiAB9kQY+pi267KIBN+1FTumTLYsabQ4ypNsl+QXskthrfXR8YcsWcW5p6
         20Im87jQH4PVyJ8x8QJJ35wR6rTlIRfmwDVs+IARh2oYGe3+LU4G4W7uFJ+VZNFGyGit
         EFdxCnRshMX9Wr9lqsavcCvgGCCyj/nfCf01xTYHy150XnaXZ+fwGKklQpF2LTQoqXHN
         NwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aouj8d0RJ50aW/Vsd94vh5WZ038hUS4IE2hWYAidGmc=;
        b=Ojty84NcTnRyCqM38Rij28Ez6lO2E+fUNKg4RNkjymmLGYJYeZjE/htz1JH3ZmAFxm
         PBU+KnL9rApssCTPkSupfqKqUTJxDFQ4Zyjzjiqonvfwey/RtU5GTpFP7jytVlu8C3dK
         5RTduq/WQW5uQMEaSfhHbjT9TTozmAew+3+vddaiodD02RJb85XCM3T2lRvFQ0a5kkIG
         JjxAZe3mPJmcepnDcAkxVY5lgQfMOta8npiG4C98czURb3pxtMN6wnjjNQZ7OINIWtur
         JaaPPZ5ww2oYKJtRl1QxCuoxfugB+G/6ybsW1ZMHq7hnHbm91qvSbmagZHvrLGK8Oxej
         qe4Q==
X-Gm-Message-State: ANoB5plrQbUjPofts1IPCzPFQKEMr58VhuDRgr3ElYfQoXANY0OGiidW
        l8AEvNVHjyaYxNtta4MoMVWLcxUPFkYjwDJ7vP5qtw==
X-Google-Smtp-Source: AA0mqf68Ln1lKgotZFyr3fzO9Mouxw8mfDxH3Vtst3AIQC8HW/kBWtipUDsYKITAOMekCTktLZZRfcAiOiQ+Nxiesb0=
X-Received: by 2002:a05:6902:120f:b0:6dc:3322:fd84 with SMTP id
 s15-20020a056902120f00b006dc3322fd84mr162371ybu.534.1668000691870; Wed, 09
 Nov 2022 05:31:31 -0800 (PST)
MIME-Version: 1.0
References: <20221108133333.659601604@linuxfoundation.org>
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Nov 2022 19:01:20 +0530
Message-ID: <CA+G9fYubT+C7KrKeHDTzXuc9nq-PpVV_7hoLgYDxb9Sp-FaKqw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
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

On Tue, 8 Nov 2022 at 19:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
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
* kernel: 5.4.224-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: dc8d80bb822aa0a393ccaa810d63be127d1bd864
* git describe: v5.4.223-75-gdc8d80bb822a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.223-75-gdc8d80bb822a

## Test Regressions (compared to v5.4.222)

## Metric Regressions (compared to v5.4.222)

## Test Fixes (compared to v5.4.222)

## Metric Fixes (compared to v5.4.222)

## Test result summary
total: 130360, pass: 110431, fail: 2196, skip: 17226, xfail: 507

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
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
