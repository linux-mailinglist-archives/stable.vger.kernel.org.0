Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1155FEA8E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJNIbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJNIbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:31:22 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B08C1C25DD
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:31:21 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id a13so5934117edj.0
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NOlDUExQFlQZADy0R0NpNHjOCTyy68gwL/uV8DAk8Ws=;
        b=uGn7R00Gjfnuai7g73/hlFa4qVZNM4MJidi4x+WfZgmy/3+ozH4y/WksCkSyQ8K/wJ
         9d02UsaBn34meWmwBMox7CQExussKt1MJeLfelXgvh5ycAQckDJGbCq4hOKwwWTwWzAQ
         I6WkpCHDJ/SZNo4lkVrri+kffQMP9xTyz95OrY7Dj8D3CS9ju9FBnbfWrEAwE/S6kkmJ
         XeKxh1wsbRdbxx6rgBxZWPwli2bv1xhnMhSzttbCigYRu/ijEcl5picbURvKlC37QS/n
         IVfuh5zd32c8RfuKVaXeBfu57Y1ewbcSZcgc7knZZFP5b3Eyxn7WhdpLgvYayuXj47GI
         90JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOlDUExQFlQZADy0R0NpNHjOCTyy68gwL/uV8DAk8Ws=;
        b=iGepTYR9RUq6Q5QRz9ZvlxP9FAgBglHkkVLyhpf0Rp8xNPsK7E2ITWxkzu1awjdR+l
         1XCgdGh4X43WTWfbzbLJbwFZl2Y+ovvYaOqL1q70lgWv2yDW1TZ2rzp4uFT7A2jUjtAa
         ln6eC4myASbrBhjR4KSR3h1POKWMEu2JIiH4HPli8EUO5hypbHSTwhUSuWSa3dbfwWUK
         pZXsEkSH3o2I6Twm0/bF6JG2NHOml4gFehfff3hexhfXO+T8seu9gThGxlDPne2MVZnF
         M+kZCHEnDRIM3YbVhxKomAfJ27ntO84UYfv/V0Zn9qcLgaal3ZhpB4v0gec1Qc582PeF
         Tnxw==
X-Gm-Message-State: ACrzQf2qjO2yjf4Z/LXDLtH/zPu5uXs1gOn6aC3pMXy1RzoVkzkyV1k5
        sRmDZiiWTAnggzBhXMprp29gOAssYEjtx/6aMJz3AQ==
X-Google-Smtp-Source: AMsMyM4TauReU7wpefiGp7R3XKJ3ze4GczME6+kxx84Up0EEeg1BXTdDi0mGLYLZ4D3mtCpQPa2kvolyvxAPH+G5JIY=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr3317194edb.110.1665736279436; Fri, 14
 Oct 2022 01:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175146.507746257@linuxfoundation.org>
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Oct 2022 14:01:07 +0530
Message-ID: <CA+G9fYudoodFn2sZC1fbFz8efRytjz5nciLODsMufA1z58u=4w@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
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

On Thu, 13 Oct 2022 at 23:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 2640a427a92bc725b6a7ecd72f6499bd90ed3981
* git describe: v6.0.1-35-g2640a427a92b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1-35-g2640a427a92b

## No Test Regressions (compared to v6.0.1)

## No Metric Regressions (compared to v6.0.1)

## No Test Fixes (compared to v6.0.1)

## No Metric Fixes (compared to v6.0.1)


## Test result summary
total: 128530, pass: 111552, fail: 3700, skip: 12938, xfail: 340

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 329 passed, 4 failed
* arm64: 65 total, 65 passed, 0 failed
* i386: 55 total, 55 passed, 0 failed
* mips: 56 total, 55 passed, 1 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 58 passed, 0 failed

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
* ltp-ip
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
