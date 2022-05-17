Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A20752A38C
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 15:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347825AbiEQNfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 09:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347899AbiEQNfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 09:35:44 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF21910FDE
        for <stable@vger.kernel.org>; Tue, 17 May 2022 06:35:39 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id d137so13316608ybc.13
        for <stable@vger.kernel.org>; Tue, 17 May 2022 06:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fOF0mLHDO2JH2bQ/6nv6jUbZKAhgwoxMZS2LA7xTw8w=;
        b=tUErUVmrc1o90SfSkKV+/w8V5J/wOadMHXCnTV+v1hGfUBiewMMlCCQ9R922MxXUFJ
         CXL6o5kEYdeGXEZ9XUayHFw2Bx7CTXrNZEYqOR4t5UOJquSkPSk2l14FKzcrDDMN/Ki9
         HxGEuhk227eucaLiw5I/kHK/pU2boYm3aKVx0Vb/d+pCY+m7nnLGUGp82RpL1ohf/6zT
         wfcmlWPvfgs+skk/gSyVPvtCbMZ0carMJvFSqYO9OtBh5E8lrDwDRCORpL63t0RNyFJN
         trV3RStYhYzRClC0rEev6roWRm/S3wq0fjSwsVvdeALYThwPJxXCf9mubOb/D7ozxHOT
         0ExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fOF0mLHDO2JH2bQ/6nv6jUbZKAhgwoxMZS2LA7xTw8w=;
        b=X6WCOTuluH3MYM+lru/uec1zYwfiKMidfYkb2fjGlw9fN0SKXt3Bk5MVpbWF8vw48A
         jJrOf7iS0ol4BJifBPTNLF1Q6VPQ0Zba9pMamEjZMMJBGDuSAk4A3fLONa21oDkileI4
         Z7hfpIlvPWFGdkL72hciTW4abbDp+77i6T0fwGehLWisqiSiErNcTl8z1Gp1MHw2vcA6
         l6progLN+58d4VZ1PKbKhaNA5+6Y+kdLy0ylILfTQXgHxUvn3irjCtr03P0jbTBZP/ND
         3MTkP25G7FyYiUmDVACJkJFCvmdHlZYA67AFLhBGKICQKPbD/iCYPt6driImJjmnXTr+
         mdqg==
X-Gm-Message-State: AOAM531pbBot6MF873bQmxl11Ci05zp1rJjyA5yweNvT+shIU62k+Hz7
        SgaNeyAKjSmsr9Il82LZ8QtI4rLLae9tRj319PneVA==
X-Google-Smtp-Source: ABdhPJztRuQtvVBTLQg6edpSDF+qMvzQOjoWKt4vt+4eTANGq9hhZnx+sdyWM0csT1/k4MO2PGQxYV2ou6bhA2HvmKU=
X-Received: by 2002:a25:804e:0:b0:64d:eafa:450e with SMTP id
 a14-20020a25804e000000b0064deafa450emr5364927ybn.128.1652794538659; Tue, 17
 May 2022 06:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220516213639.123296914@linuxfoundation.org>
In-Reply-To: <20220516213639.123296914@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 May 2022 19:05:27 +0530
Message-ID: <CA+G9fYtupv8KgDhatu1u8HVtMniURxT6pi-R2MpU0dgG75KHUA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.117-rc2 review
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

On Tue, 17 May 2022 at 03:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.117 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 May 2022 21:35:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.117-rc2.gz
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
* kernel: 5.10.117-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 17429b76ed5416aac3996975e8e49e0b1f79ed27
* git describe: v5.10.116-69-g17429b76ed54
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.116-69-g17429b76ed54

## Test Regressions (compared to v5.10.116-65-g11c5de3d33a9)
No test regressions found.

## Metric Regressions (compared to v5.10.116-65-g11c5de3d33a9)
No metric regressions found.

## Test Fixes (compared to v5.10.116-65-g11c5de3d33a9)
No test fixes found.

## Metric Fixes (compared to v5.10.116-65-g11c5de3d33a9)
No metric fixes found.

## Test result summary
total: 93799, pass: 79054, fail: 849, skip: 12960, xfail: 936

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
