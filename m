Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6069D60CBE6
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 14:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJYMdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 08:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiJYMdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 08:33:45 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127BB18499D
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 05:33:44 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id q9so12224732ejd.0
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r+aV+XBd2ibXuwsHHzI0medh1k+MCtx1/0dodUbeKOk=;
        b=Lckt6jfPzMHBW1PLunbUYp84UCGAOYmxu3gE0MJbwuGhAzt4Vbav3H66oT+JPZEFza
         u+BIVHJkXtrmcv4e8MJoRfBDeLNtu54Gt4b78/yJkUrwisx/9iSkzGzL3R+lFnOkSjNI
         Gulx/1k9+aQTJLnNLzsFRgluzOaLyXspGUA4Htkebp8SJRNqeFwDmBpmy/W7j9PviTOT
         sm682No1D6RVgpcPPl5RzZDflGkDqpyrBP8h/FQsxppCu5uOKgleqPjTiBIYP8/Kr/Z7
         wvaYq+slCxEEyVrPIBRW8+UTy6654L8QVSdemKCyZUDm1mieWQx+Vzt6J5MhexGU+5O4
         Gdtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+aV+XBd2ibXuwsHHzI0medh1k+MCtx1/0dodUbeKOk=;
        b=v4KyTMSm0uSW3eOULsvTU+NBJDeQpifuKTXK/gasl6V2sitfjh9yb0jlkt8cItJqt+
         e+di+ekxufx6LlMCGF9iImZ4m7D4PPk7r21Xij+Ew4IcqH8W0zfY1LYVibvX4j7Vli9v
         wsJmBcFWhH7ro629KDfi/1R7eYmn8LuV4V8JNQLa2S5OT710zLN97S6cwHC5uyevzJXn
         lanEqK1xz3idXjCif27Ew0fdLhsWslonppEcP+M6wK2+6bbHEta0X8n2YepM6twSL6Rg
         QhFkFS592OqFnz7mu2JajA6f2ngENLUj5EsHZ+acOKxLqPSBFf9Tz79S/eitVBbzvfTr
         FDgA==
X-Gm-Message-State: ACrzQf2PKiiK+jl6+2XmSxuUtJ5M3FZJ/WyGHiGxwNDfjT/2O8FxPtgx
        JhKsebLvi+FURpq2KFu5yfjddQnwW8c35dOUNherig4fqrdr0g==
X-Google-Smtp-Source: AMsMyM6F538BVTn7WQ09QOrHs6r9EgO0Ja7WVMtf29SSBuZCPMFTTYKEzvR2C+4L/Myu4Nadq7aDDrOEVlZvGtiVgqI=
X-Received: by 2002:a17:907:80b:b0:77a:86a1:db52 with SMTP id
 wv11-20020a170907080b00b0077a86a1db52mr33486871ejb.294.1666701222341; Tue, 25
 Oct 2022 05:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112934.415391158@linuxfoundation.org>
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Oct 2022 18:03:29 +0530
Message-ID: <CA+G9fYsjwO4F7bQkFX+BWxVVX4rgdb=U_Qr-1Y5GLjdhyUkimQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
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

On Mon, 24 Oct 2022 at 17:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.4-rc1.gz
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
* kernel: 6.0.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: [None, 'd4150c7b49be8290e2a00c80f2bb2a534a627ad6']
* git describe: v6.0.3-22-gd4150c7b49be
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.3-22-gd4150c7b49be

## No sTest Regressions (compared to v6.0.3)

## No Metric Regressions (compared to v6.0.3)

## No Test Fixes (compared to v6.0.3)

## No Metric Fixes (compared to v6.0.3)


## Test result summary
total: 144226, pass: 123359, fail: 5726, skip: 14716, xfail: 425

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 329 total, 325 passed, 4 failed
* arm64: 61 total, 61 passed, 0 failed
* i386: 53 total, 53 passed, 0 failed
* mips: 54 total, 53 passed, 1 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 67 total, 61 passed, 6 failed
* riscv: 26 total, 26 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 23 total, 23 passed, 0 failed
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
* ltp-at
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
