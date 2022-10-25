Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2CD60D014
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiJYPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 11:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiJYPMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 11:12:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B935C10AC30
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 08:12:51 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sc25so13263570ejc.12
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 08:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cfTgwcPBLwbZKDDAhKxlN0uuVa2x+7yfa+Nsh5SRev0=;
        b=e8LPGaGhf75Q2EthCG38ILMvOQTQvfmTwyeYtWlXTtv0FnapDgYXE/OszEShowrpyp
         w/G/rYG+TVezIljsfPIyc5nVvtZ+9VWW/ywq6sGcEtVzn3PuWEEayMhSN1lHO5vQDUOO
         fDJPg+V0JGEHeNXb6uDIpY4rTDpTgmebyjr1woJ0zuny2cqQRwxGgYgj/gstydPRVrNL
         VeN8OZPZXUx+l97fzofL7f7pWl7ZzDxYF5SltwDrxIkf3oqp/ScZ1ip6CQ8n60rIn5/b
         c9KBEmrLJt6wfkWRFkB2ToOr6/Uly/hpaQfVrQm50MmuMerwThygc3xkFd1ENAuUspPs
         /vMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cfTgwcPBLwbZKDDAhKxlN0uuVa2x+7yfa+Nsh5SRev0=;
        b=iLl6W2IU1dPl5K9occuzkN/L7xz1pBHXBXeu1jhON8SkffurWqXYRI8+5uh9ryP3rJ
         o82Fx9BbXtg5vGWtflRyHXEnF1OAdLm1oxm1P+UXAweR5ZFV1cJR65NNQMmPKGfLwXCW
         pyAbkFDW34/w0GdXAxiii1PSD4OrtWkWBHnbywaDntQAEaeoYGHTdMx+NwD9Q0Q7E8Zq
         qrRpEQiH2EJYRIOKGbnCa4GkXEh2u7oWoB8FiXBl1iv/Q82Qcwi2C7CNc9DLmvb34uab
         O9HEYc1Cg0T1NJKEexhCLmEgohKa7VAT0D6tLWiR3Vqj0c6wjAr0/D//XHDeBFYYCtgF
         iCMg==
X-Gm-Message-State: ACrzQf02s/psWFHIdG+PId1tUBOLL6Onu4x0LXevuXWAqGjhj7qhfs2H
        2fH8LRoB7zqbiLeQBft52Tkm9de2dWHiiul6lzNhCA==
X-Google-Smtp-Source: AMsMyM7wsIg6S7EZ/iGsv2e4/4pImQKgLdeqCG6cYZQlUNCkFd1t4pPaFzbXz9huRtlfmKP8rr7XmJ9Dh9vT62EdWW0=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr33508976ejb.633.1666710769962; Tue, 25
 Oct 2022 08:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113022.510008560@linuxfoundation.org>
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Oct 2022 20:42:38 +0530
Message-ID: <CA+G9fYt=P2ex2vsTFExOj=SuimYW3N42ejbSFN1RDB6Rh4EQ6g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/390] 5.10.150-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 at 17:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.150 release.
> There are 390 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.150-rc1.gz
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
* kernel: 5.10.150-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: b4f4370de958b2655d6a93d4fc386eed8fe36cd6
* git describe: v5.10.149-391-gb4f4370de958
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.149-391-gb4f4370de958

## No Test Regressions (compared to v5.10.149)

## No Metric Regressions (compared to v5.10.149)

## No Test Fixes (compared to v5.10.149)

## No Metric Fixes (compared to v5.10.149)

## Test result summary
total: 127551, pass: 110248, fail: 1637, skip: 15380, xfail: 286

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
