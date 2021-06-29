Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780573B6EC0
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 09:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhF2HcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 03:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhF2HcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 03:32:02 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2944CC061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 00:29:35 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id o5so9612695ejy.7
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 00:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=03PV4K48V6c5/R86L70XCFhcKvRTMy+AXQxfxuAmtVE=;
        b=L7KJevzhmo86xhp86Z6zI9rdQnlmfbzYjTFcsW7ijmWlCiKdt1qwKek4x8Phd7cBq8
         vA4JSMGA8kDeKz2Aur4Tr2la+iQS9pgt9LwpoSSPoZgs2XcJq3PJt1aB3JUkAJ5AL9yz
         XwLAZXCSwVL0+XOqtGb8W32rhUxH8KLkJy9uwGxVWMoi9bArHJssX+04Dkf/uGjKzcIL
         F+qoaG927E5Q2tlNcpjXc3MMbwcLYiAqr33ajjzUcmKL3eLqenOf000Fd/4x8oyNdHeJ
         v2/Y+OdgHuk09vY6vetsU+/0gKYgCcbIfKHJXVfnQQA2KkivKZZAbMb2rJwpYU2aougb
         6zoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=03PV4K48V6c5/R86L70XCFhcKvRTMy+AXQxfxuAmtVE=;
        b=D5RE+ouD+b1MuwV0AZucHvWnHbFDdyzYch57g77uUAQLoHkBcekLF6SSvb+6hAdW+2
         rvGkjN/MeYhGWyCJpwPxFfSvrek+XGGT2sMi32RbvCoK4Z/HPKBX5eKCln278AhTOcwY
         S4oX42JqbwL8Ajjot/fXhJKWxexozBoa21/9ybFJLzkWT7QhhZ3jR+PMGMcOJTO0h4zE
         1JSl4lhX3htq1UevknoDHkjj+xktR2RTzBH140rXlrpWglh2JWU6SNYc5UV9o6kgL5pM
         dCYYOO9fkrI7Ezds/Qt0sx9Hkersb0pvlQKp4xvA1FIvcaJJGl8Nms3gmkfIah6LBxft
         hXyw==
X-Gm-Message-State: AOAM530HIyZScOfSd6xOxHDbzwEFcwAuPSfNAtTbAjdcEACm/kk+if7d
        fJ4LvUpZ7/O0D2LyX5tPfjTwTLswPS/Dv6+AOMB6UA==
X-Google-Smtp-Source: ABdhPJx13l3BNeNDnbsxjk6VQ2Yn4sEnRVmUSxU/d4gNvrl3CB2QGvLbfV9KGmcEKC1EgyqpkmEhbk6SjxccEe82sl0=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr27747079ejb.170.1624951773414;
 Tue, 29 Jun 2021 00:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210628142607.32218-1-sashal@kernel.org>
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Jun 2021 12:59:22 +0530
Message-ID: <CA+G9fYuVhXzNGuk+Gp+PSGdRyqbXCJG2d98inqF2wqH3jNHprg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/101] 5.10.47-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021 at 19:56, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.10.47 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 30 Jun 2021 02:25:36 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.10.y&id2=3Dv5.10.46
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.47-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: a41d5119dc1eec2f0ffaa0a1777b0218a76b9f0e
* git describe: v5.10.46-101-ga41d5119dc1e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.46-101-ga41d5119dc1e

## No regressions (compared to v5.10.46-13-g88b257611f2a)


## No fixes (compared to v5.10.46-13-g88b257611f2a)


## Test result summary
 total: 80209, pass: 65767, fail: 2329, skip: 11358, xfail: 755,

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
* x15: 1 total, 1 passed, 0 failed
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
