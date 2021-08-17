Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327C43EE675
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 08:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhHQGCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 02:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbhHQGCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 02:02:03 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64D8C0613C1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 23:01:30 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qk33so36286410ejc.12
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 23:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y7AJNStwqm0bYtfSsEg/nqONSaGNaLZ8T/knTPhYbgQ=;
        b=OIv7gBDXfLdMpKuUg+z3lY8v7a8PibndPyAl+nQu+4QW05TxoW4y9p1tKur4Sm4GR2
         o3zzkclQrU2NUDSC6hTtc0IMlWGgWgUWtBnNgN9Wsyu6yTWpvWTkuhoYxF9MJC/t+ybL
         YDlKtX0OgWE7iorShxM7Qu2mAJxM/DjOjfmygbOWmR4wvwsE8jAzSxppI/O2Tw6ZJ35q
         lBi1iKc7v9GkvluzHSbhiD9H0IebrLUudjdzgGK+JuYOOddM3wUgosPfBycIiNtSMbhC
         MzOpsuyPNaysHQMMBg+6VixuHek5FaGK0g8eiT4gwUv5MIioRotz5bCpCedDdjgtxfg8
         Lp7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y7AJNStwqm0bYtfSsEg/nqONSaGNaLZ8T/knTPhYbgQ=;
        b=rEvLSHyrMG5ncfMXmR/ftwXtfzPi6AHtAu3Z8Q2ADZyaBPJlRUwBsOyX6aPaP0BL75
         4HRKAii4ESfHUSbFWw3Krz2I7M1YErURUEJsyn2pqDtitUBe6uSg6WLWaej4FIw9Z/4Q
         Ef5LXA6NOtduv9aVGBUKabmHbbitU7Y2FM9mapSCdEoUblTTSyZN+syoxLNB63CWJmW0
         AZgCr0xIBfGvjWh2kbZ767hESYapF3vsn+YTHJ9sR39J/bDW/gc91E3cW/RVCmd4LTBk
         fYtjLzjbLrVi8b4JkyirgrgCN4cCz+LCfguVEIu6mL0AzSqrOhJdFWQ8E0TbaKPyvtbL
         C6Xw==
X-Gm-Message-State: AOAM533nlVm9Gi75S34ax83COCjT9t/Ieh17aGkF/tYzaz9YiarKScJG
        1EJ7EHtXgNgQKTznH7IUgGWVdEMufGek7lYBL6zz4A==
X-Google-Smtp-Source: ABdhPJxMg1O0uY5JDM1GgZZh+TrjVD5Xs7GElYi0KXDJWqdpC20Hb0bKk0hY3Z7spPJUZcvjEI2h9bNeZBdls8oWPDw=
X-Received: by 2002:a17:906:40d1:: with SMTP id a17mr2023925ejk.503.1629180089177;
 Mon, 16 Aug 2021 23:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210816171414.653076979@linuxfoundation.org>
In-Reply-To: <20210816171414.653076979@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Aug 2021 11:31:17 +0530
Message-ID: <CA+G9fYsCvz4g5N7wb0rqAJEAXU9dqnkR7zjiY4ugsrfNGv42SQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/153] 5.13.12-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 16 Aug 2021 at 22:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.12 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Aug 2021 17:13:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.12-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.12-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: 13f08821433012f3a60bc8c70bdfa8fb007d3108
* git describe: v5.13.11-154-g13f088214330
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.11-154-g13f088214330

## No regressions (compared to v5.13.11-152-g8f08f2c2c72b)

## No fixes (compared to v5.13.11-152-g8f08f2c2c72b)

## Test result summary
total: 88294, pass: 73881, fail: 953, skip: 12470, xfail: 990

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 194 total, 194 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
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
* x86_64: 28 total, 28 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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

--
Linaro LKFT
https://lkft.linaro.org
