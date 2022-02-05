Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B77A4AA74A
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 08:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379475AbiBEHUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 02:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiBEHUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 02:20:47 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D33C061346
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 23:20:45 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 124so24511342ybw.6
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 23:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YuSevJHq0EkhDQnmKb1fVwMKVv5yPkrZ7mzyilXRIp0=;
        b=DMWM8FcKjHnJ8KdBjViBB10zIV5SqV2Ax6+JAVEVcGcXafE6gmBewaaDQrqUlb7ICZ
         mzUM8FSaqD7cRiGwiX8HUod2meH2BlYW3cz95lAS4T3qpEr5pwBQmH+YV3aMQtAnCVIt
         wjwN9eepUfT9GlpPEvTW2XtzdwEvis1uIcgofOXyVY0ywxwfZBrLTpgSM1u8KNiCzsns
         8EBDYLIguO1qvMQlacsYzayOoZIwnX1RYwMOrC/7eCt+WTo6YfgayZx5yl1t5g7pxkwI
         I8taawGB8rjqn5sHuRNiOTxirqSSkSxjqjOp2IDPrcNnR/8QBYZC5NLe11CFQqSM0AEb
         17LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YuSevJHq0EkhDQnmKb1fVwMKVv5yPkrZ7mzyilXRIp0=;
        b=1pAGFzUepj4Q5JjKJmr67+6TAXmAySbev/d38+Eeqiv0rN6/V4D7LyQA3vWGDSH1Ev
         73eJhC0F1UYI9Z3KoeQNK0atVvyYrmUxud3KkBTruvE/Df33hsQ45z8Lf+mRQOK/G6Un
         V2P1UPDoTQJchwJFIU7vd3cF8S+OBYUGBfGPfIS5YeyfcbKpKRdJQB2YB91QNaOwXb4p
         SVa4IQO3NhhFYX9DoejplFyaXXdmfeQ7uJW74hSTR+HxDkbaXizw9Ctzi6eLgEo55N8O
         qJ74246F6h7WpSpxavpm/DiQlYjdzpMNM/HedC1jzKviMfe8X8SJMmfb/CgYWK/1xLfW
         n4CQ==
X-Gm-Message-State: AOAM530eHGSToOvnt8SR5fY7C893v+H6PI4f6b9q+fSQ/fGGhVkyJGCB
        D4+mT7hO/BaEqO8a7VFOe6GgGk5B/2/4htaKTU4PJQ==
X-Google-Smtp-Source: ABdhPJy6Nq2TWok14cMJ+Lka27+NbS2AK0bf4JiOfT3xv2RHEPeJLKBltdKmLopjmcOacKDGl2bRzLYdjdEYcPZfrOI=
X-Received: by 2002:a81:3986:: with SMTP id g128mr2623268ywa.129.1644045644997;
 Fri, 04 Feb 2022 23:20:44 -0800 (PST)
MIME-Version: 1.0
References: <20220204091912.329106021@linuxfoundation.org>
In-Reply-To: <20220204091912.329106021@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 5 Feb 2022 12:50:33 +0530
Message-ID: <CA+G9fYu5fGRCJkQYejfLbv22zUiVAAKPXv75OPvieD6cNjKBVQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/10] 5.4.177-rc1 review
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

On Fri, 4 Feb 2022 at 14:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.177 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.177-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.177-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: db9bfa6e8ef56c7c343bcb51031ea93db5f8d157
* git describe: v5.4.176-11-gdb9bfa6e8ef5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
76-11-gdb9bfa6e8ef5

## Test Regressions (compared to v5.4.176)
No test regressions found.

## Metric regressions (compared to v5.4.176)
No metric regressions found.

## Test fixes (compared to v5.4.176)
No test fixes found.

## Metric fixes (compared to v5.4.176)
No metric fixes found.

## Test result summary
total: 93678, pass: 78131, fail: 764, skip: 13342, xfail: 1441

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 24 total, 23 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
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

--=20
Linaro LKFT
https://lkft.linaro.org
