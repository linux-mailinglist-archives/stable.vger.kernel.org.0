Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B1F6007AF
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 09:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJQH00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 03:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiJQH0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 03:26:25 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732615A3F5
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 00:26:23 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z97so14727785ede.8
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 00:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3AShFYsitghTbnIyrMsfWrl8lnbvZv+qNsyw3iHZCMA=;
        b=KqIY9rAQqeIOd56ST1972cUNpPXCyorscPr7T04Hp+F48MCVQePvDf0nolaB0QMWHs
         0azWgOh5G96gEZPIFtqIWaaZKZVzcrqkeni0gsY/FWB6vG0MXEz4nXjs8x00EnJCy1x9
         lAdxaGLNXbY3vMWUNIF/7ADfwhgnpPbvx7fKfMzhn1ZRj51NiFxIkiKjco5QeDg2LOUM
         DyquyX0+oW4uIo8O5jCZUIZ5Yl0QmzpvrwQ4DGS9ufHC7yWPidthP/RW/5KNTBUouigB
         vJrDYIJlv4iI+kf1vWA+kv/VWUDa/DN8bmYij1D9TYkt2D5ei3BdDiCTTlXWbE/cM4f7
         p18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3AShFYsitghTbnIyrMsfWrl8lnbvZv+qNsyw3iHZCMA=;
        b=5Ymrf/0LcqBfHqrB2p3ayLcfATsPZgVB4TwRqpDXbOiSsELqX0hHbGvHV1Af67muda
         qhze4KQ2jfvV3ojhdMT1N8WH6bHxJY60+baH+COXt14pkBqqRspFgACa8fnppXXRTHam
         eDwasU5SSWm+qk1+xDwgNv2XkHejg27e/UFi3BKlkH3HYmzes/2RxVKASuJaGRFfIJ79
         TO2E+zkO2alVhwVqXqUIw20XCjuZKZkaw73l4Eg7fRk90mmvOBgBhLOAArGIedmFequr
         sP3gArxPq3i44IorxYZvdln5y6lfSOXicJu8himXAfIoBmAmr2acBXya7nhWwUEtLVGG
         flZQ==
X-Gm-Message-State: ACrzQf30fmi9WMRFqypaJC2nu8d+gPH/OMRTnqEj5nR9Qcj7u6JNl/oP
        VfnSIZkHAdAEbB2FTPw4In57AhpswJzB3sE6RDk2kg==
X-Google-Smtp-Source: AMsMyM5gbWhSDqqqPHexjLAdyKKwd8cORrpaVtporiBlFjTkUcSPRQZzEne28z+gUaBpSo9hOMRqT3EvrQ+6+fUBAQs=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr8963701edb.110.1665991581839; Mon, 17
 Oct 2022 00:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221016064454.382206984@linuxfoundation.org>
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 17 Oct 2022 12:56:10 +0530
Message-ID: <CA+G9fYvtuumt+EapAwHia8ZSiK0oyadpSMiRrrmQO79n6Tw3qg@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 16 Oct 2022 at 12:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.149-rc1.gz
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
* kernel: 5.10.149-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: ac0fb49345eeba8af1ef393f8921b7fbe4e3f99f
* git describe: v5.10.148-5-gac0fb49345ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.148-5-gac0fb49345ee

## No Test Regressions (compared to v5.10.147-55-g4ff6e9bba3ff)

## No Metric Regressions (compared to v5.10.147-55-g4ff6e9bba3ff)

## No Test Fixes (compared to v5.10.147-55-g4ff6e9bba3ff)

## No Metric Fixes (compared to v5.10.147-55-g4ff6e9bba3ff)


## Test result summary
total: 108684, pass: 93951, fail: 1340, skip: 13134, xfail: 259

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 55 passed, 5 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

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
