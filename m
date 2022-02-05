Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31A54AA71E
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 07:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358580AbiBEG2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 01:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356126AbiBEG23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 01:28:29 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB4AC061347
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 22:28:28 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v190so8737073ybv.4
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 22:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q2b6hK+TBoO9q6ZGhN1bE+KXFAoRmLEloZyJgK+U1JQ=;
        b=o31QP92Fg6G5lmCy0TzA1/oG5PcR7pc7EEnxGtmc6ahV53+FXD4+1dm09BD5M45Ldn
         WKZrbDOg3wGh2Yf6RDy+izhDhuHx7xf9SeIy2GSFLawZs8Y33j8p/672HJ+i9pMNTwBi
         GPyc5kWukRVpJkCsIKS2fuUxz2Llcy8pNkF2eMitkumQ0G7Xg2dZIzEouXXF8L71EcqU
         xTvXr65izGe9fbdvASZvINTkshE3ZyV8/yM2mShIzYEewaegNC/dcCeHXSbdFahdKZXP
         YZHZYWfyJljCqmrYEnsLyvdsGIlMiraCazt5QP0i1wRqsa5KEMUivRMkMs5b/TNWfSUd
         cIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q2b6hK+TBoO9q6ZGhN1bE+KXFAoRmLEloZyJgK+U1JQ=;
        b=A8No7EXj/VPbIEEqBSikT+pJY/P8/yMC5Tr402ZF6wZkTHwDTjlPvXyd3+hu6vkvV9
         gMdvTDFgQxS1NsHNfOQlNLBfx466f3/zyRqoKOAKDbNTs50ODgEguiONyLl7xSZmPNk+
         4ffQoi5/g4o2BhTF7E0dbeH6Jpo7oIB7jciauxceGNOxQZskLhVhcrB5zu31RLbjkquj
         hscDJgjzeA61s61QnPnPBxYzBDfR8ivg36qGKlxV8dWHW8TONc9LdAt7w5MXo/Q53ryO
         gypNOZh/QCwwuSDVijUApTRghq9CwByVzQx0dQAeeLWWRcrNY8KaP6o2q7QRFgTnCyTu
         xtDg==
X-Gm-Message-State: AOAM533Ne4gkOXZfSQQn4d1mRA2uV/klBCTXZX/266u/xdl4S/LUdZge
        U0jXe4uIlZtG8huYPLqNitvFZ+miQovmTmL2UqZvjw==
X-Google-Smtp-Source: ABdhPJzaJv84AqXc6f2Bj8Au0jGzmLUAZAArTjnZb7B66h4ZVFxqRGLDGMHSFofY8r8vEjlgqz2MS+joywbhODnvPus=
X-Received: by 2002:a25:d8d0:: with SMTP id p199mr2415880ybg.704.1644042507670;
 Fri, 04 Feb 2022 22:28:27 -0800 (PST)
MIME-Version: 1.0
References: <20220204091917.166033635@linuxfoundation.org>
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 5 Feb 2022 11:58:16 +0530
Message-ID: <CA+G9fYuQkEFqsDDe-OQdpkpJSAxNN08iXqX5vHT5zE8BRbAj0g@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
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

On Fri, 4 Feb 2022 at 14:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.6-rc1.gz
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
* kernel: 5.16.6-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: f58321948b36b3589e2af9c3fc5718862597e364
* git describe: v5.16.5-45-gf58321948b36
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.5-45-gf58321948b36

## Test Regressions (compared to v5.16.5)
No test regressions found.

## Metric regressions (compared to v5.16.5)
No test regressions found.

## Test fixes (compared to v5.16.5)
No test fixes found.

##  Metric fixes (compared to v5.16.5)
No metric fixes found.

## Test result summary
total: 104848, pass: 89220, fail: 1185, skip: 13345, xfail: 1098

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 261 passed, 2 failed
* arm64: 42 total, 39 passed, 3 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 22 passed, 6 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 39 passed, 3 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* rcutorture
* ssuite
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
