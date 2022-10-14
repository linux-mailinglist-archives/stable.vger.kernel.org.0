Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F255FEAC9
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJNIrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiJNIrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:47:24 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF66D1BF873
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:47:20 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id y14so8980011ejd.9
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v+nwaiWY6zSfU+xLEqg+14Jd622ScVnn73UpC5VAoXo=;
        b=F4RjQt2LjNB8fmFBBpD7rsT7t6OIG3s/HPpOrhIip9gxXXvmdF4PBBv++31I0g9rpQ
         JqxoEx4+pNiSNe4/9tvqgDQ7VGf1QouXCe/Hnmb/vFTbciMQJqXz0GPYJk2mn7/bnOjq
         bRdnYFBzZwJH8YI+LMWZxK9E69z4sxkQLSf0Pxrn3gvl6VdKSAjbz44gTYW6yHchH7gM
         yIcDp1IXQUKepE1zOf2YQid/hDdbGF2efP1Qtr2LR/ye9afEZkBzaef5YJXf9hBzaJ51
         NSdCFCBShIN/+RhCZ0/DWbxlOMNuHskjUTsxGSOFG26eeVtRz8JUJPj9+n3mVctEcUkQ
         MHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v+nwaiWY6zSfU+xLEqg+14Jd622ScVnn73UpC5VAoXo=;
        b=OCtnPfr/gRPxCaGqH5RxXv8gnMP3T6yaEa9AVtQfgNwO3pP1PUh8PXDelMstcOJ+mP
         EZy7gvQRH+alzAP1HKYHANnu8i1Mxnbo2wRxFqflCN2jBjtqNREqVeUHCPy5h6XqmeRu
         KP/+xMGPbW2qFqKHd7A4I4auqic7sHn9sPl+0RcBkLjE1zavdvX356srGNQ2SKCVFXvN
         xJrvpxtXAcSX1hXpWcJojE0KeXrVIoCXfU6cReviju49LEiq3hXqDvA1yVwXKLQrukVT
         bGsR9S2QnPhWqRL9q8M56BSLTD5CzEAASzoiL95USUIHg+0MvUXI6Wp3c+YHTkyCDJkI
         Z1Gw==
X-Gm-Message-State: ACrzQf3rNDZJbiGn/5pdLVF9OjAyLDqcAv3DTR1lVGzRD3duOqoPswO9
        7qU0Zoso5wq1q/YcXmLKiy8sYYLlTIcMlFYKuxuPTg==
X-Google-Smtp-Source: AMsMyM64JLA37TXX3MTh5xyePk9rVVnPGMwTgj4ts22u/bWs/MRybaDSoDR7FuKrB7tJVRLEXyW3Dbg6keMu9azFqHw=
X-Received: by 2002:a17:907:3188:b0:741:4bf7:ec1a with SMTP id
 xe8-20020a170907318800b007414bf7ec1amr2836888ejb.448.1665737238507; Fri, 14
 Oct 2022 01:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175145.236739253@linuxfoundation.org>
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Oct 2022 14:17:06 +0530
Message-ID: <CA+G9fYvmJJvAnjeuTtCEngvFv+USnoARZYjX8isgae2k8YFK2A@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
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

On Thu, 13 Oct 2022 at 23:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.19.16-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 72d24eaf389a3b283cecc3b515cbddf4fceb6634
* git describe: v5.19.15-34-g72d24eaf389a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.15-34-g72d24eaf389a

## No Test Regressions (compared to v5.19.15)

## No Metric Regressions (compared to v5.19.15)

## No Test Fixes (compared to v5.19.15)

## No Metric Fixes (compared to v5.19.15)


## Test result summary
total: 120753, pass: 105985, fail: 1743, skip: 12664, xfail: 361

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
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
* ltp-fs_perms_simpl
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
