Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4624AC9F4
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 20:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiBGT4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 14:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240991AbiBGTzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 14:55:54 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8920CC0401E1
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 11:55:53 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id j2so43571559ybu.0
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 11:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cIeGIDwEX25ldmpB0Z226M8rnhkEGp63Yp0NEvcjQyM=;
        b=FxDPRuncyydboj5DBXA9bBILTdhAgivJ2t+m/B2zLIEe8l5/I5tjzLZtn+CdBoqa2F
         PHABYz1evnKZkqaiYlDgujbQwMDajqFUb0U2Ib9rpKfTdU/KBXc5f6X3d++6qwSW612L
         Qy2PHiLfVyNuWpWlk2eR9pbICvHOLSubwinut7li25SC2vP3LQkOJ53uL9jA1C0y8yGx
         UYIHDU/0R1WX9noC8R+YuiNgnm7SIFk4O5ISzf0a2nptzLEmDPx8N+eSbz2bBlHlPUAF
         EKLUK8+Y4RmXTcV8qbx9maZTLq5xuzocwA6KfVu3yxeERBG/jhtsvsr8nAVfFSh1Nu+g
         q9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cIeGIDwEX25ldmpB0Z226M8rnhkEGp63Yp0NEvcjQyM=;
        b=XDcCk2D9Asbd3DA6gGLMdgjDiLqKVBtK0eBETR3I22IxwBirpAPXjQ6zgs3lXPkUDP
         vjcwL+tN0SvukMq9czLd9JMSezaCCUKybBV81N2hWvLtG7D6DkPrWHG7lQRbYTbMIdXH
         vhNeHJWnUiU0QvClzznPddwO8d4MT8r9AErHryK9kH0Ba2N0P84s+8AEVJeB5eIV6Uw7
         mKO42LxbXA28EXyfyvYXz55xC0+h1YhwxvdbMd/UhtIuvOI9wBOod5H7UXdsLyqiafSF
         Les4gr3edqar5dQoNlzXTCX5hVtIwHtvG9Yyd71QPMNAgOCgzagK2Jao1XXzijs0niIk
         3uuQ==
X-Gm-Message-State: AOAM531GXLb0W3W/w8ouB++BYZdLuGSPJmM6xm2lrHVWSWGVh6AWy2EF
        OwRVTngkwUzdkVGpuJHwUOKPphLimM7lgAaQ1CUmvw==
X-Google-Smtp-Source: ABdhPJypA1OJ3anBiqKzgFuvUx+sUQdROCHaXV8NFzNKd1pSP7YKC/6bNcHVADdFPGCRcSLgYJ1ESdFxCUM8AN4UN00=
X-Received: by 2002:a81:3986:: with SMTP id g128mr1556995ywa.129.1644263752610;
 Mon, 07 Feb 2022 11:55:52 -0800 (PST)
MIME-Version: 1.0
References: <20220207133856.644483064@linuxfoundation.org>
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Feb 2022 01:25:41 +0530
Message-ID: <CA+G9fYuCnmRoDu4xDhyKzPX1RB5uj7iw-GUo2=y6KP-_Qcnvzw@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Feb 2022 at 19:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.8-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 87d888a197db9443026045ba3c253a1a929114d4
* git describe: v5.16.7-128-g87d888a197db
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.7-128-g87d888a197db

## Test Regressions (compared to v5.16.7)
No test regressions found.

## Metric Regressions (compared to v5.16.7)
No metric regressions found.

## Test Fixes (compared to v5.16.7)
No test fixes found.

## Metric Fixes (compared to v5.16.7)
No metric fixes found.

## Test result summary
total: 103985, pass: 89106, fail: 847, skip: 13204, xfail: 828

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
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-lkdtm
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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
