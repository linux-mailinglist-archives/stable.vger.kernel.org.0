Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FA960D0BD
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 17:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiJYPgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiJYPgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 11:36:11 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC62E129742
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 08:36:08 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id sc25so13461765ejc.12
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 08:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=82ef//M42q/ph0AA1cl5MXJlGqqxJmPpIAFc+0veO94=;
        b=G+7R1w2U3ya/QxsVolU9+yjkKpPzrjhZN5qIVX+OgmyKWo59Byxv6XbQnt4T6reoFh
         bFXA2G4TW2TJPqMykZiuF/P/8ISlXSzpmyTsP/RLycNJrIsDdRybOk6EGsshW0La2JnV
         07PBBmO48Omr76Oznw+Fh1nuXPwOpVRfKQAowKj5RC++psnGbpC2dUq4stw10rgeKJYK
         xvo6PscCCml4AA5Uj8fLlHq+NDKkm0jboEirGhQ7Ebb+CRe2SW3xmvZsE7xa90bqQm88
         EqIgv+J0l3Kioeb+t4Oy80rtHigajPdPgCXO94C61R0FOh81jmZ9OLy5dSE6vxuPv+6c
         aLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=82ef//M42q/ph0AA1cl5MXJlGqqxJmPpIAFc+0veO94=;
        b=Lev4Y9gw8bL8LQDr6ZuMJuvx8W+iglDEExNvAm6ExACeqdFvJujFPWurob2h9LGbjp
         Q6ehinAe/ITEX+hHBGDpBzZI8LluqZiD4rpNAl7eOLViJNe8NmEWHoXArWqGamZ7CWeG
         3OYiMiyRy6YZbLb/2VNhbJsxQKXt0BN8jyv+fFxsHSIRsZ8C6nnMFr+uOJwy2J0kP2dQ
         Sm2L1QsvR5+tp3jaiJ24AE3/A0hZxsFgMIIhGDpVx3bKmT49BIU/R3X8BCFIK2v5DVmw
         1Wrzoxqgy9X70xZcTkf4oDRiBLsDjdIDfLuya0XpG9bB9+tLpGatVEzQoT8/5ZV8iSvP
         buvg==
X-Gm-Message-State: ACrzQf2GUhWcocID8M1J225kgQA7UFyBuwh4EVkWQQohA4acu2k4I7Rx
        xX7yliMN5G3lou42EBNIssk5rusNZolgKAHrHTM5rw==
X-Google-Smtp-Source: AMsMyM6cj8Flu0aoakrXowfyjCuC3+dWajqgDK0lTvPgx5Q6ZhB8zwKX8rm8g9k9SkIZ2HCNJOLVGfW1qdRsH5VI3Ds=
X-Received: by 2002:a17:907:80b:b0:77a:86a1:db52 with SMTP id
 wv11-20020a170907080b00b0077a86a1db52mr34342197ejb.294.1666712167286; Tue, 25
 Oct 2022 08:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113002.471093005@linuxfoundation.org>
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Oct 2022 21:05:55 +0530
Message-ID: <CA+G9fYte09-FmRXOfB=OhthKNKESqX_oDo9Y0raUsHCV6UHEGg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/255] 5.4.220-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 at 17:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.220 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.220-rc1.gz
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
* kernel: 5.4.220-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: f49f12b65484790c4e83771c36bda5027fb7483e
* git describe: v5.4.219-256-gf49f12b65484
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.219-256-gf49f12b65484

## No Test Regressions (compared to v5.4.219)

## No Metric Regressions (compared to v5.4.219)

## No Test Fixes (compared to v5.4.219)

## No Metric Fixes (compared to v5.4.219)

## Test result summary
total: 79483, pass: 68536, fail: 1061, skip: 9474, xfail: 412

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
