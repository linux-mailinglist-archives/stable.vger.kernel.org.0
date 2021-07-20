Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCFB3D0035
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 19:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhGTQr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 12:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhGTQrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 12:47:24 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A010C0613DB
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:28:02 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gb6so35454390ejc.5
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 10:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MRDTut5sIr1YAD+wWycEAbZH48ThMpXHAJu6uzoLBOY=;
        b=KeQiUz7V65d8hsHZx4TqWydXGejkLlKH+ZKykQ+Ut60Miksk6ErxTnwudR93YozvUp
         6OgCwoKIvtvLKkxZL17Hx+Nf5KkxLZLVlO2d/TRJndOt6kHyWjsCzADoWHz3g3GXnutj
         8aMquGAkknQ5EltXZoFc38W924cqlI4Qh160X/WE1fgfRUATIWfHyrasZYc+REtWH19T
         XsgQ/2zK1z1MFfekUHieoCPkonYvQ0uc178wVZBKpQZh5VFWsjt/dM4voDbrUDd4mg+w
         mAtbfRIVEKqF8Cgqq0W9Z4WRUj6Z/eQNoLj9DRB+nLWrhjk+aEfX8ym5Fe7BAOAf0MnL
         t7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MRDTut5sIr1YAD+wWycEAbZH48ThMpXHAJu6uzoLBOY=;
        b=TfgiSaeUyb04e5fCGdWZ71h05RVbmhbpyeAtcBdnuXT1H1OQhWG9mBvkZJA5Fm0fkr
         DSRuetgkC0rSrBc2sY4//5zOm6l+vgnTLfxxIbDvDC+/FiawlReg1JaVzDcWRqOl8Rfl
         JpWmmacLJUYco6z3psY7QWxK+VzPsHTPOjJr0IF2krFK0GFEl0TQEmPf5v+IO9+XuxFo
         MzK+CPK+eOFeiPkKT0Fl5GKEeX/ifUT1Tl0FYS/OOqBw36v6xJaAQjSd2c/NpcKAdaEF
         71DG0vp5wAcHPZKqmEK5yV/WvQcZrP00c6fGY5PpgubRuM6wpxYI1PtBxNzzWWio2CIG
         0/Xg==
X-Gm-Message-State: AOAM530Pc/ScxHa8xoEyMcemSMwfyDj60iW6JdPvLop511hBIQSIeGd+
        TybUXuT7AtvxR9ouTOs1SA07vvaMiN9WTGE+JW43Hg==
X-Google-Smtp-Source: ABdhPJxlKIwqBIkfBNplXV0/yEFsoTHAXsk0pUCJPTFBTuS2Xn3d5CpWDTSC/Z+nE7YOEL6pEmdzvoHMKJHeWBBtrvA=
X-Received: by 2002:a17:906:cec1:: with SMTP id si1mr34170651ejb.18.1626802080721;
 Tue, 20 Jul 2021 10:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210719183557.768945788@linuxfoundation.org>
In-Reply-To: <20210719183557.768945788@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Jul 2021 22:57:49 +0530
Message-ID: <CA+G9fYtJ=H7-pGMSjSDT-ZTFdCru9WAVAmtz6sYM2m61x=3Piw@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/289] 5.12.19-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Jul 2021 at 00:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.19 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 18:35:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.19-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.19-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: aa783473cf1e00e4344531089962861c6bbbb818
* git describe: v5.12.18-288-gaa783473cf1e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.18-288-gaa783473cf1e

## No regressions (compared to v5.12.18-293-g825db1d6b9e2)

## No fixes (compared to v5.12.18-293-g825db1d6b9e2)

## Test result summary
 total: 81358, pass: 66831, fail: 1848, skip: 11427, xfail: 1252,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
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
