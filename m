Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124C360076E
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 09:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiJQHNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 03:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJQHNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 03:13:01 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0104021261
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 00:12:58 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y14so22739724ejd.9
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 00:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KJrhH2F7uJON+OIrH6fgwC/AeouFBzeMMasW8/7uZkY=;
        b=yFwPWDfXBF+DZOjXQFyL6BB1l4+ZCzLKZPU662WgdCabSuTUSj8Zlv1k2oJzrB5nwz
         B0vltkzzngx8sge/O1mvs2Adb4aMwtbTT5Ok91i/c0kteI4/gUGyG+k+sknGHOCugE3Y
         pPJWodW2bT47rPlPKoaHH+W8gFVmTgRM7PBSjZb2sD9QKyhl1rk2ad5rh2ypVq4J+puY
         HNMf89LLqqtJ0dcswjlC9fdZkxG0IP4hM+ZHKMVhv4Qu62tfEXPKIhBDp8lk5+Y5IXZc
         9x6Tt5XIXGbiheu/ik1MSqtPybGWNJILyrbiOslru15klunb+2544Jje1z7Ja9X0woZ6
         2rlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJrhH2F7uJON+OIrH6fgwC/AeouFBzeMMasW8/7uZkY=;
        b=N8JjzGWNFnF1MwbUdkAaOu1bwaSDW1o4Xg8FEQn2xjgn0BvGckS1ziMIlPC5+NT7bc
         DFw+mhxkesqXczxum5k660XDFQn5iVW6b/bXOx5Xo43MtKlIg0jiOJUS6Xha1GsOCmV7
         xHC0/NqMjBow7CC6d1Yn1QiR/WCQZRvlMgQe2DtaUoA7CHqd2Mui8E+DXaPMNScdl0Uf
         jQQcyKygnURwzTufGnwIhCX9yaT4C8105VuRBtyENE8XsuBO0Ow6l//XHfRpPvo43ye0
         880L5ufeu3lZB6F6RvYNegSYusnPtqF+w6zX0jZBwUhzxunDssaVfZqB6Dz+pPO58qwB
         O+nw==
X-Gm-Message-State: ACrzQf0eXYoFQVhU6WyBtc6cGKvPMCr9FXBf+r6id+C9ab2Lxmra4C9n
        0EIW4rQpGdJa38zn4kbYpX2M+q/+h+TONrbR/EyJqg==
X-Google-Smtp-Source: AMsMyM7Rkee63nSg/2gdS0CS50T5Pl/67pcZ46Df4oNkssUPC67LGf1C197OZieBViQcm5Z3p64H7Vb6FylDNF6sujA=
X-Received: by 2002:a17:906:da86:b0:740:7120:c6e6 with SMTP id
 xh6-20020a170906da8600b007407120c6e6mr7405132ejb.44.1665990777297; Mon, 17
 Oct 2022 00:12:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221016064454.327821011@linuxfoundation.org>
In-Reply-To: <20221016064454.327821011@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 17 Oct 2022 12:42:45 +0530
Message-ID: <CA+G9fYvH0rYGRX5BUq3Ut+Yk6t+xd-exZdS5CC8E_yhpo9ibFw@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/4] 5.4.219-rc1 review
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

On Sun, 16 Oct 2022 at 12:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.219 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.219-rc1.gz
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
* kernel: 5.4.219-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 5a1de46f7e7462992a5dd980fe8d06ea57b4ad17
* git describe: v5.4.218-5-g5a1de46f7e74
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.218-5-g5a1de46f7e74

## No Test Regressions (compared to v5.4.217-39-g34b618a713e7)

## No Metric Regressions (compared to v5.4.217-39-g34b618a713e7)

## No Test Fixes (compared to v5.4.217-39-g34b618a713e7)

## No Metric Fixes (compared to v5.4.217-39-g34b618a713e7)

## Test result summary
total: 99448, pass: 84788, fail: 1219, skip: 12965, xfail: 476

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
