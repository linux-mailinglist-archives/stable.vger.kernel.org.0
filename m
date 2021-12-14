Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAED473C45
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 06:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhLNFET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 00:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhLNFET (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 00:04:19 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37D6C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 21:04:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so59467015eda.11
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 21:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9XjWK0aSq+pJUOyN3OhKYqGOzF0wMsi7YB2sa47N/l0=;
        b=mWQUIgkmo973Bbtgyf4YmJ89rCSr325vstXzv5g1nzJB67ARIHUYCr2C1No/mpehF2
         msbuz98v/Km8z5SMLSUhycW9t2nu+OEBTjCkbGa6K+s47LGATvU67lDp2jFUeod4Qw+4
         8Y2IsrEzdHYHJ8oMx17hnIar3gJEvXG7D7xceRkTZm8KtjwzK2joIVawpMoJBeKo+h/v
         k+AnOj6gdevzOerhmJcJNC3bpa/G1xAs00qpgtQ5KM0m27Vdx/VhzaiNGnwXtszDoLF6
         v4z3IWXVDz5SqlVCiJoeXH3MezbdWRtEqSfCIAslPrKECv4Isj72UyzLnSOp/0DM9SON
         wYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9XjWK0aSq+pJUOyN3OhKYqGOzF0wMsi7YB2sa47N/l0=;
        b=czlWVAEj00HrUtr++Wn52oo9WWljuWZeBx4hfBHFu6hEH6XANmz9b3NOAF4aw/S+6h
         cYNsfNRonF8NInLnVfXQikrHtw2FdFa/2HfMvQzmKeQEbB6j8uZiNGhLt6/ECoA1ohEX
         3lrFcYgZF+mt/qiu8UG6I2ClQWvruJYE6eY0iQbsRzvGuXvk1NGEj3ZtRI9luMz8wR67
         GHNXqIqvFAdeLyK9trOa1lbDNpSMEhAnibeC7MQcx29+8piwoMlaBJ3P6+fPJynsjYAM
         esEuuYd7zsRNVMF4QRmaO+V+qfIfHrpW2TbtZ8mQ+qNArpQ4VVWe2lJmrrr8Em/Edy1Q
         XtsQ==
X-Gm-Message-State: AOAM532QBEVtqptHmqXfFCZeCDx4ak/GkpLwQsz8JQ1PW63Dw/dyTQ6B
        qRMIzLeNY+7OwVC4tqwl00npBTnK6OQ/ungGSeDcjg==
X-Google-Smtp-Source: ABdhPJxMRGadaefB99dCp/iPLUu3c/1uiVlHsXE5AAGmtXVKD4/qbvdYLNhd+FOmfcf7TCipQY9TeaCnVq2WAKDLmWg=
X-Received: by 2002:a05:6402:4b:: with SMTP id f11mr4585450edu.267.1639458257161;
 Mon, 13 Dec 2021 21:04:17 -0800 (PST)
MIME-Version: 1.0
References: <20211213092930.763200615@linuxfoundation.org>
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Dec 2021 10:34:05 +0530
Message-ID: <CA+G9fYuCFSbLMarXOnapUXN_NRgQMkjfr_rSTPjzBJQ-FT-Q3g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/74] 4.19.221-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 at 15:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.221 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.221-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


NOTE:
Following warnings noticed on x86_64 and i386 with defconfig
building with gcc-8/9/10/11 and clang-11/12/13 and nightly.

make --silent --keep-going --jobs=3D8
O=3D/home/tuxbuild/.cache/tuxmake/builds/current ARCH=3Dx86_64
CROSS_COMPILE=3Dx86_64-linux-gnu- 'CC=3Dsccache x86_64-linux-gnu-gcc'
'HOSTCC=3Dsccache gcc' defconfig

WARNING: unmet direct dependencies detected for ARCH_USE_MEMREMAP_PROT
  Depends on [n]: AMD_MEM_ENCRYPT [=3Dn]
  Selected by [y]:
  - EFI [=3Dy] && ACPI [=3Dy]

WARNING: unmet direct dependencies detected for ARCH_USE_MEMREMAP_PROT
  Depends on [n]: AMD_MEM_ENCRYPT [=3Dn]
  Selected by [y]:
  - EFI [=3Dy] && ACPI [=3Dy]

build link,
https://builds.tuxbuild.com/22E1yyBLiIA9rwo90Cee5hMgOPR/


## Build
* kernel: 4.19.221-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: c65e8cddade7ba91d6b7438b4746b7b02a83bb72
* git describe: v4.19.220-75-gc65e8cddade7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.220-75-gc65e8cddade7

## No Test Regressions (compared to v4.19.220)

## No Test Fixes (compared to v4.19.220)

## Test result summary
total: 81020, pass: 65995, fail: 642, skip: 12539, xfail: 1844

## Build Summary
* arm: 254 total, 186 passed, 68 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* powerpc: 52 total, 0 passed, 52 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
* kvm-unit-tests
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
