Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA25C3BC5E6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 07:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGFFIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 01:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhGFFIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 01:08:18 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA89AC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 22:05:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id v20so32092608eji.10
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 22:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1aY9pV+Xms1QWJkFh6PFiUFJO/L6VxJrfdxhBvw2IIs=;
        b=a4viW667C4I0pe8u9HVEYVeW0P8W1WaQELYx+duLGcVGEI7cxpgzuhlIyRaf1O3ODi
         nfrCDosDZMhdQ3A4gl4ZTc+vbpSMzIgi4M28qlvzD3bRFL8qvEaxLzXw3iet/bQFmqel
         qNXI2VzoWX3tnn2rXq6DCD4GP0eFAmLcd5CYbMvo3BxqLBRNCrYZJu/U8AX840BNiS4l
         cCwX0SCHyHHZQnjwWIkHJlJMi9AqilRgR02tKz0IzbwXTxE0OfiKwUTGr6E2/bo9Z1if
         AitU4zWRvVeEANnpQdcWEahXVbicTzhvA+Ne56IZvrdsQDc/uGBZ6Om4g5QCmkmE0qOD
         zl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1aY9pV+Xms1QWJkFh6PFiUFJO/L6VxJrfdxhBvw2IIs=;
        b=tGy6D6MOQ+iEnypQr1oXpR2DtHhkYmgNlJyOnbRyWbb5sZLMMw3mhohAE4ZLQsxjjq
         QyVMjFvKX+ZBXnHgbPBf1caOOJHh5bCs3rfGVmcKKUHjft2Qdl7vXRdO2ZRF+8gmZARb
         m4KCeQaZYbfLvEZtgnOGL/ewU/WPLt8apBE/UFv7VjheoZahLD3xxRV7KYfUlCUdy412
         nfGqwOwaqzh+FR7IYWjAWym22wmpCRqv5+Www5xb5nJJDlzwoyrHZhB0MXHQ6cS6Tp0o
         fuOnfUUTuD+PWcZZD3icnav7LjjNzZgq1ZgfKpMjT7cJl34f8NeE4TOqpPSoww9kKIQX
         /mcQ==
X-Gm-Message-State: AOAM531ZnOFg43gyG9uY1i8idF8+RYgesj4Up0acvvb7Xefs5pIpxaYw
        zXUaFBJawpXCAaiaIUoy93Ski/helZ31JdEui4GLVQ==
X-Google-Smtp-Source: ABdhPJzi6kwPz8i2CQ8xiuuCmR4LYMA7Lx9B13lKNAKf2U73odGkdr7KNONhaLDi7D0Uxkr/f0qFWHShrFwuelwfkg4=
X-Received: by 2002:a17:906:fcb5:: with SMTP id qw21mr11690543ejb.375.1625547937417;
 Mon, 05 Jul 2021 22:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210705110029.1513384-1-sashal@kernel.org>
In-Reply-To: <20210705110029.1513384-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Jul 2021 10:35:25 +0530
Message-ID: <CA+G9fYsd03U9XLBuk4b+VasOUwcF1w0BaUe_Ct9caYGkG_AVJg@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/6] 5.4.130-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Jul 2021 at 16:30, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.4.130 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Jul 2021 11:00:14 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.4.y&id2=3Dv5.4.129
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.130-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 730ab99d05cb6e5857910adb0a22eba8d08ee621
* git describe: v5.4.129-6-g730ab99d05cb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
29-6-g730ab99d05cb

## No regressions (compared to v5.4.129)

## No fixes (compared to v5.4.129)

## Test result summary
 total: 71569, pass: 58697, fail: 518, skip: 10733, xfail: 1621,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 191 passed, 1 failed
* arm64: 26 total, 25 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 14 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 25 passed, 1 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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

--
Linaro LKFT
https://lkft.linaro.org
