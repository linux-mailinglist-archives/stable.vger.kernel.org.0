Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE195FF08E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJNOrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJNOrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:47:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B4012276D
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 07:47:34 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s30so7187481eds.1
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 07:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QAKUb4MuSpN5a0Y0/cadRof5wSBZgkcrrOjmpmbSjLw=;
        b=PcUEjmNwqnHFdawpikUxUdj5TgDCBzpl3SNSClBMIGBtoSUhaGj19pEqUOv+wJQdiS
         5xpgccLU3f3+kMBS/XGFzEcPc1bQE8+dff8gHRM1aQtTqe/AP28aXSwI1/W/TOL0b0Qr
         iM2nWui0VOildJYwcQWptElQOmpbcJyYSIfq+t66Zjxkf0mhs4TiQXT0/jEufHQjCPku
         KvEX+5OXGoND+KDNHsCl4/M9hFvI7FsxpU7GBpKU/ozWCujTAZ3Ee7YOz/rXCAQZZZKr
         W1dOlLlciXbJKSzmnKz+JkjdMfkNYrXCfdgi1WTDLHABMpf2Sxt2wF6AcaxCtf8YSZRm
         M5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QAKUb4MuSpN5a0Y0/cadRof5wSBZgkcrrOjmpmbSjLw=;
        b=hyPFlDNnia+SfSbn9vYxG3M7EmB/Zc/xWc6X08HRZyZMFaBSZ3DRyl8ScGUiQ2/7T5
         IOm0esyxwbWHirULGIHXnkU6cEos9R87ixSQ6EG6UBS8MEQdSkixMUVz7+WAIiMV4cnb
         oV3PKsdPzb3CmAskylX72jpwN5HOwSWCCapjyB3aAi2SjqjzgPm+m+PZTQPU6aUXWZuh
         ASysjVlChvCgJPEMsMWCrYg7oiY4BSdgTznP++3dBRRYHyGhDCwMZfJ5P9XxPLF6rMqf
         EiVCcIpu9TJ81s8hTsQwHRnTyeRa5fx1MASo+RLcd7ROlkNvI9pRs8R1rq12RRiWYWj4
         yUDg==
X-Gm-Message-State: ACrzQf2ewPMAKOfFkCyKFAhr9ozb9qjunpH3C8WGAmNTLx2Gt4hcsbr6
        C8G5mzptuVFQ7oc2eeIO8dGydWzMXdeCgj6YDHTFjw==
X-Google-Smtp-Source: AMsMyM71RsFSG+WqztWT/Qe2ymo1z0kDcPDcOfzrPWIxCuLd4qIlLKe6cVLAa1g99FC9h7Q031EvwFMs8m7kNTtHAsI=
X-Received: by 2002:a50:c31b:0:b0:458:cc93:8000 with SMTP id
 a27-20020a50c31b000000b00458cc938000mr4705187edb.264.1665758852435; Fri, 14
 Oct 2022 07:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221014082515.704103805@linuxfoundation.org>
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Oct 2022 20:17:20 +0530
Message-ID: <CA+G9fYuB_uS_WkGTEJCow4TwgYOCRpjfc8=O1b8-Bc1Mvq=Ygw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
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

On Fri, 14 Oct 2022 at 13:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.74-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.74-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: e3d8c2f748861227f55b9dc8ba9e10b6f95e6ec4
* git describe: v5.15.73-34-ge3d8c2f74886
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.73-34-ge3d8c2f74886

## No Test Regressions (compared to v5.15.73)

## No Metric Regressions (compared to v5.15.73)

## No Test Fixes (compared to v5.15.73)

## No Metric Fixes (compared to v5.15.73)

## Test result summary
total: 117411, pass: 101156, fail: 1769, skip: 13988, xfail: 498

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 333 total, 333 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
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
