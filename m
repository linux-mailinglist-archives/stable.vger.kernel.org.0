Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB66D3E9665
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 19:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhHKRAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 13:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhHKRAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 13:00:54 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011BAC061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 10:00:31 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id n12so4748020edx.8
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 10:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1lyCX4uoOl9TkSg5+9sCmiEFCTaxYNyI5pWwpGNyYL4=;
        b=ZoH870kdqfn5xTB/o0o45+xfGDzwBVtPUKmIYP5/nqN5EfQygWuAamKLvD02jOrKz2
         Jponfgm/8BPNq+3+hCOlxY/llaDl1F+uRsDlVCsrAvcRjHXQHpu1E+3yingcZOTOoTLb
         rCs3HZfLDpPnT560Q0xH0/nb2KEAcj+nSY/c8l4YV/BMeJeYSZeGo/mHH9YBUI7KpkCN
         kiAWLCbHSiQjv4A2Axsl/eA2I5GDeM5I/mOahiuzOnTShL5MfxN+ockc+cohlmQGOIVr
         atVZ80YRq8vt+4NtrS80gS6Me+fSxjdOEPItxQv9fRT2GxvAacaZ/XvkYb+vg8PvK/fF
         6FQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1lyCX4uoOl9TkSg5+9sCmiEFCTaxYNyI5pWwpGNyYL4=;
        b=L5BgzNhJUBIBP1cN+mSvUQF6UHPVW/g0NCh8TSC5Mns/rycJ/VhjvLZKnRkK4gR5fn
         c49mV6Ru0QmCxn/R2alVD2P5DMBgRv1X/hDB0a5BjwJCgnCgXotPTHBjv4HHDtSQLnfU
         RZrAjFoteLquJC0rd6LNHF+TJhPtOVezaYOH2XcVeBlPxJ6/Y8X4BLQSsRB6rkqmCOwd
         5SkTguI/fP6egrsFGeoPvhcH9uizN1gUo6lVbZP9DZdYk8ZAhc5oGNJXTHZOnT2uerEv
         Wcll2fS5p6YfnXk1rhgPfKJJUxBNiLKkiWvQe/QgJo5N7elD4KlUmN4s0hwkzMlw3BBi
         3B1g==
X-Gm-Message-State: AOAM531xjjta8mlv9jlnxhbKOezkeMpaCWQwAL27c6UHB+bhznIVSBRx
        QxZheNR0VDJvYG5Fk2rJb58mpXwYMxG7qw8N2E6Y3g==
X-Google-Smtp-Source: ABdhPJyBsCDIe3i+LJ9SYJAFhB7iHMEvS/Hk+ZJppnfICoZ4n9Ki7t7WaLhvOBaBga4Hm+7JTXy9f8AHcVdhlXYePg0=
X-Received: by 2002:a05:6402:2153:: with SMTP id bq19mr1857977edb.239.1628701228710;
 Wed, 11 Aug 2021 10:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210810172955.660225700@linuxfoundation.org>
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Aug 2021 22:30:17 +0530
Message-ID: <CA+G9fYt6Uvh+YcnhiwRHLix8Like3gUMzhbi8WWvJa-Rmx=ifg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/135] 5.10.58-rc1 review
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

On Tue, 10 Aug 2021 at 23:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.58-rc1.gz
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
* kernel: 5.10.58-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 252d84386e003502ea789f777bda459363174184
* git describe: v5.10.57-136-g252d84386e00
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.57-136-g252d84386e00

## No regressions (compared to v5.10.57-126-gb04ed4b2e724)


## No fixes (compared to v5.10.57-126-gb04ed4b2e724)

## Test result summary
total: 82063, pass: 67049, fail: 2170, skip: 11566, xfail: 1278

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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
