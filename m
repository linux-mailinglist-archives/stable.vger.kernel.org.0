Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58E048A705
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 06:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiAKFO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 00:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiAKFO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 00:14:59 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C9AC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:14:58 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m6so33751549ybc.9
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 21:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F1DnS9sCmbdeb4JrbE2m/+T6GWQXHNi5EGutXDvA3b4=;
        b=B+1y0he3f2uT2uw6Qquv5i3oxPVwwyTgAM7PFihWed5i7NzYtMpIwuAmHaW0jxi5aW
         plGvuh1VgGiFZImCHIh6QPWuKVLt6PFXJr10Wm9lDGIGJiQL8D02eCgrI8uMMHpkzNtj
         07bAdPyGUSmXrIlEz94j5d7rrx5UtFsDcecDdgOvOldIIZruWZiHgovPGC2JiWH7ZK/V
         /A2Ohx22LS0TVKFIDORjWZMRcKBScKj0YU10x0F1zarn5EFrISvlbRMFL6GgZG3n2gO5
         Dybrv4nHKaxKhJcVx3X/5ejet+QXB90DaOAz7VVKFa5Koxzt4Ewfk28dwse9hkXbJa4a
         DQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F1DnS9sCmbdeb4JrbE2m/+T6GWQXHNi5EGutXDvA3b4=;
        b=5YcWnXIVP8+CRQC0DnvZX0P5hFt80Sfe3fgRRJUNGIQDzs/8RU7cAb5z/PDCT1BlTF
         rJAYVbRilyqJox4br54mIRjpBN8ytDfVlvRPtRRQZ/drr4+UQC2geqnd48IXaprtbwy0
         Z2cNCYut5aYPsAViPB0+pjgzFrsPfhsUC10dt1K/k96IvIpwra3G2gqnzyN5G9m/cJP9
         5xPCU/370L9R3VaH/nEyK7ZUBHM1vq7DF57NHlXP2Zm1AkB0y0twDRghAm6953X0bz0v
         IOpzBdF8+80WimfQB/85K/5Xib6qv7gfcI2qflEkhB0jv9Vy3nQYpz6T4Xk3jLVGtf/s
         hQmw==
X-Gm-Message-State: AOAM533VIboiMeXT+ZM4OwFSY7b6s2Qi5e4OGHIRu6wtCli5WsvLIfwL
        lNW7UazuvnWVfhNh+YS5zEE+kjkw8qr0ZNDb/yfYYA==
X-Google-Smtp-Source: ABdhPJwjrbbHpyHT5HbhjU4WFLXOGAm53DJGXXsHAcO7EA8L+8O9q7Z7b6EWiCNetOSMv1U8JjT3NCbzfw98IfUS2JI=
X-Received: by 2002:a25:2416:: with SMTP id k22mr3808436ybk.553.1641878097867;
 Mon, 10 Jan 2022 21:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20220110071821.500480371@linuxfoundation.org>
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Jan 2022 10:44:46 +0530
Message-ID: <CA+G9fYu+CPS8mx0h2c-Y-uaoRA42te93UfA6v3ygWimZ6Ly8-g@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Jan 2022 at 13:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.14-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: e8d40b0a77381adfdcadb8307596341334c9e18d
* git describe: v5.15.13-73-ge8d40b0a7738
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.13-73-ge8d40b0a7738

## Test Regressions (compared to v5.15.11-129-g47b0c2878802)
No test regressions found.

## Metric Regressions (compared to v5.15.11-129-g47b0c2878802)
No metric regressions found.

## Test Fixes (compared to v5.15.11-129-g47b0c2878802)
No test fixes found.

## Metric Fixes (compared to v5.15.11-129-g47b0c2878802)
No metric fixes found.

## Test result summary
total: 97540, pass: 83368, fail: 678, skip: 12534, xfail: 960

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 263 total, 257 passed, 6 failed
* arm64: 42 total, 40 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 37 passed, 3 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 31 passed, 6 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 56 total, 50 passed, 6 failed
* riscv: 28 total, 23 passed, 5 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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

--
Linaro LKFT
https://lkft.linaro.org
