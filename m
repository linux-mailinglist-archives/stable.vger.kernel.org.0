Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E98608EEF
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJVSLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 14:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJVSLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 14:11:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698EB132E92
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 11:11:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a5so4079767edb.11
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 11:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rRTMHQ1BmhsX3nP3r+K4SG1SFZ05Xk8b/C+EBfXX5XY=;
        b=jN7tam/20zmMEAQOdVB/wRM0cYIbw7Z3JgNQrb9QunLbUk/uzz7sgcpCjh9gbi1RLb
         rPJapVCrIUCVMdhMizZaX5siio8Xw+ao22pKVlGAWQl8WX2C0P/YAuTt4lNl5e4Zb1xe
         qSeoCOWXMG4CKJFAbGTrtQ/rMIGjCzu9MvAS1Sa8orDj1DeJ5dGAG0vHP7U9Tn3jAEHM
         eeampVMs08mbEe+AlfE/8ixb58Wm+CuT0NTEJh0holG4WSDlUnnpxjZTQvXEzEqu2aLQ
         NErvCdHtWAtbXcpIyiafMnnnglHqzrG8eVu+VLZZtKdLi7dvI+6/ADoU9ONdcWjuUJQ/
         B1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRTMHQ1BmhsX3nP3r+K4SG1SFZ05Xk8b/C+EBfXX5XY=;
        b=PjCDIp9laJBkKnSvJsHIxsSpzeMwvrHxgzGMTBy/YVlBTeaXBdNvTdAZQxmVSba2S7
         mgYa6Bi2U/vj0cBOqYYJ56UTLCVtK4bm/wVYaqNq3OInU4vmG5e1xhEW7SY3qXOxUHmF
         3W8iarfq5AjAMWDKSzmBQpWhLIcPWWPGUnfTElpWCVz3qPPZ5A79o7G9l7zCmxsPj0nL
         tWAzrfxA0NEDZJHvFCDypCdnUQReqIF7yuSCKLViq/e8hjAsLzSTO5Z0Oo7ws0yuYwso
         +Yrumxkdi0/KA91JuaiKFnIEcHxICQw+N+uEy+Afo1G3Bc/DUgFUXmbiPGoM+oJAMsSr
         pBcg==
X-Gm-Message-State: ACrzQf3JroZr64XykL92ow7XYJU/Nj3IWwylHPlw/2cMvwT5lFIeI53t
        HCiXHCIL2KP5BFVTAg29MPS0TZzaEgNuwqvnYwRVMA==
X-Google-Smtp-Source: AMsMyM4xpd/jqgQ33l/RU+SBojdxL7CQOdFTCjH/sLDY2OjlOg1+KtxG/r7X4JI1/LzfXayU6yGtc4a92+ZP+j1exjQ=
X-Received: by 2002:a05:6402:190f:b0:45d:2c25:3a1d with SMTP id
 e15-20020a056402190f00b0045d2c253a1dmr23788397edz.175.1666462294771; Sat, 22
 Oct 2022 11:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221022072415.034382448@linuxfoundation.org>
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 22 Oct 2022 23:41:22 +0530
Message-ID: <CA+G9fYtsv3869wko8khDOyqNCOSxVd2N46RpApxLzNxodpG5SQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
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

On Sat, 22 Oct 2022 at 13:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
>
> Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.17-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

## Build
* kernel: 5.19.17-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: b0c2a34d484bc2819f59332935fd31bc30ebfbba
* git describe: v5.19.16-718-gb0c2a34d484b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.16-718-gb0c2a34d484b

## No Test Regressions (compared to v5.19.16)

## No Metric Regressions (compared to v5.19.16)

## No Test Fixes (compared to v5.19.16)

## No Metric Fixes (compared to v5.19.16)

## Test result summary
total: 121631, pass: 106766, fail: 1652, skip: 12837, xfail: 376

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
