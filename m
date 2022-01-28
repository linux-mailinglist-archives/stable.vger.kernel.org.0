Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A698E49F82C
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 12:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244281AbiA1LVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 06:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiA1LVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 06:21:10 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4415AC061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 03:21:10 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k31so17500868ybj.4
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 03:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M4BeB1J6W2PRmsJzowyO7vWIcmigNqTDOxreANXUuo0=;
        b=nb3YvBpbEvhwePBOrdqpqGqMxOlDfGgr6XmVCzRmcEUDRM98A/V4fUHz05JNDglKRN
         dxGewucmMOjEWLSBd2R2Fw96jVXxRSkLCY8CPn0kHY8r7/z408c+Ldf88hOPq+sLhgVG
         G6WX5O+YCRHIcXPoabfGURupB2rLtFBz86PK3moCVXi1dFhxK/GJtsgPUvYIRkNlnqgG
         kjBbWE16daUxzE9/PqPLYD+n/HsLs04DDy31rNXLlTSl9qOOyiXH3Er5v6nLedXUrTFP
         rqevwtALJUwUjiEJPv9JA+UmRKqNyXP2TzaM3e0ZBE3IOVxqBeiZW/iTn+RCh3nPJ46R
         krAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M4BeB1J6W2PRmsJzowyO7vWIcmigNqTDOxreANXUuo0=;
        b=e0XTr71uyTOa80Lam/7GM9uGN8PS9J086E9J0iq45ajCPk55432xyquZS7QVStgrQT
         h7p7j4P9XsE12iJFaarn2fqMARMBNpMdjFHa81tR9KP/p4ckvwq+g2slHHSXv1XX3lvV
         pBMZvlS5L/yYUsL7sx7vfoXU8TH6zEYJFbPuV5OT3E3KXt8W2DeWHYK2vRon3Zadn0OO
         j9tla0lKGfydM66Hq264SLMMvyDNv6aIrTJxDiAnymmFeOMmHce9Tc0dnam36IjeulE/
         XJxCGjlTCU3hyQH+v5bcKCuw91ogyKOmilit82ELaMpBTT1iRi6EtdVGnP+jJYMblxMn
         aotA==
X-Gm-Message-State: AOAM532EqVG5GVVZ1ol6mQLw9Fq4H1a0DVr79EXLRdYI7zyWIlJeBDiR
        n4SATqZ6dm+mB8+t5/G+NLXeOdulMLSv/810dZB6IQ==
X-Google-Smtp-Source: ABdhPJxtF0xacgMGBp67LP5b8sJFRHlI2Po7mJNqBrOVe2G171wxG1bC20daqEZEmQvZUJajUCaBrQhgrAPHXS4iYSM=
X-Received: by 2002:a25:b13:: with SMTP id 19mr11056045ybl.684.1643368869334;
 Fri, 28 Jan 2022 03:21:09 -0800 (PST)
MIME-Version: 1.0
References: <20220127180258.131170405@linuxfoundation.org>
In-Reply-To: <20220127180258.131170405@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Jan 2022 16:50:58 +0530
Message-ID: <CA+G9fYumJdMaTvVk8vkRopkXmkkMsGpJLqN4XhsOrdBNBT2o1g@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/6] 5.10.95-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 at 23:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.95 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.95-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.95-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: a2441d7f51b176a085cf4ea62e1071ffb4dfcf2c
* git describe: v5.10.94-7-ga2441d7f51b1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.94-7-ga2441d7f51b1

## Test Regressions (compared to v5.10.93-561-gf32eb088b139)
No test regressions found.

## Metric Regressions (compared to v5.10.93-561-gf32eb088b139)
No metric regressions found.

## Test Fixes (compared to v5.10.93-561-gf32eb088b139)
No test fixes found.

## Metric Fixes (compared to v5.10.93-561-gf32eb088b139)
No metric fixes found.

## Test result summary
total: 84455, pass: 72139, fail: 461, skip: 11140, xfail: 715

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
