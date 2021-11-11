Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3092344DB9A
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 19:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhKKSb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 13:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhKKSbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 13:31:55 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7A3C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 10:29:05 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f4so27571587edx.12
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 10:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IcwbXZucJsTNqnzdTpf86BquOpPAsu81m1AVJV7dkSQ=;
        b=Kup4YGwQbcKPyadn3J4W3sat/ynEYcFgSD4CM6bCPSk+ky77JkqbOyvlUEI5KN5aUV
         MTNeujWbOKKkRoaEpEgqYkUaM+QKgrzRbOs1nazL83woaPJGeCCMXqehF0YMlVVqMJOt
         AkQQyNfOsk9JvJ99Vzr53+ETv8If9tB6E7jiDaHduzzgQmloETViEraDaVzlBPwEAFtM
         YeNHr1h41CqS+kDOQ/ZiSFZWUK+W+1klAeebZznD080QHxAA6z5c7FR7agNnB1y8e2vx
         CxlEabOqG1+3TFDZC4yrPjR4WMhY665HENsnMuwFv1OUUqJzb6IHvIItOrdno1ywW4Bt
         S/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IcwbXZucJsTNqnzdTpf86BquOpPAsu81m1AVJV7dkSQ=;
        b=zlMmXs36cj0cjHtuBtzILbg8jnNOyLOgs/Tk3Rnx6rXyBsWKU6kYg4OWZNKrTM8+yh
         kLieEB3aDm5Yb4cRArP495rjpQEG8aCPcJGUITr0Bonu0QAnDah4RJeJ17LG34sSHnY2
         VfsQT43WBLiXcQvYv7AjfTaoSymubOESpn0nCezO70U8Guq5pink48vQT4swm7BPG1SD
         9dSGDO3p4iB52XeME/nWSF/kpFjRqWmWRJIp1CtwbQfVVzzoTa4DHqM/icMwmxdiYPvx
         94ZsFGiDD8ghYpQGVcRfFphM0ToGv1vEeArfB6kqnrzSx9d1NXs/LTXccmhO9YnOHAo7
         EQvg==
X-Gm-Message-State: AOAM531iz+hYWU0IiepqYzugU4bNAFmeA64JYTwEh5LKhG7YwBkOD0KY
        PXnrb3ND7genRCDCRBBx/wnIliljxjFx2fV/XoKiVsrbHxLWsQ==
X-Google-Smtp-Source: ABdhPJxjA4aqbrTvLklWwLujnvbZ6z/Vb3iaOld/Ioj/WYWuiaARGkF663Hbp0qXEYPkIZLEzVhKieHsW/LYaq3is3U=
X-Received: by 2002:a50:e184:: with SMTP id k4mr12421174edl.217.1636655343912;
 Thu, 11 Nov 2021 10:29:03 -0800 (PST)
MIME-Version: 1.0
References: <20211110182001.579561273@linuxfoundation.org>
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Nov 2021 23:58:52 +0530
Message-ID: <CA+G9fYsV_01XNayKoyqgGKJv4xvHDo=LkmCXCqaW0cuVjrn6kw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/22] 4.9.290-rc1 review
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

On Thu, 11 Nov 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.290 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.290-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.290-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 6ecf94b5fd89c4070a40fdfb328efa97d4f1171d
* git describe: v4.9.289-23-g6ecf94b5fd89
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
89-23-g6ecf94b5fd89

## No regressions (compared to v4.9.289-5-gc1043f1153b5)

## No fixes (compared to v4.9.289-5-gc1043f1153b5)

## Test result summary
total: 67618, pass: 52963, fail: 614, skip: 12148, xfail: 1893

## Build Summary
* arm: 130 total, 108 passed, 22 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 19 total, 19 passed, 0 failed

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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
