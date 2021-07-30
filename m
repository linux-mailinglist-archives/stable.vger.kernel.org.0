Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E273DB37D
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbhG3GYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237274AbhG3GYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 02:24:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369BCC0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 23:24:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gn26so14855271ejc.3
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 23:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OMfZlxCdprYAMpSImSSaNaMJO4xAI8KlwbjojS8D79s=;
        b=EZMa6Mi1XvY4tt4G26/MGz0jdCbS1obA2izIlayZicK0NMidUGSOUrVEu6n9F66+ee
         a0WwXbQxNhGgdij+xo7qT6nWMVzeApDpmyd8luXKY7ZZsxe04wBpsbamkop5ZxMF0llq
         1O36xioANA6tfCh8w77MuYryGjrZ12a9K9P/nkubL3n/oFRyA3c/NkCrU/SeQY3xSKeR
         WS7X+AZxMfysQERAJD78U42exZ2oIl0Rka0lXseKwRpRNC99yh1yhkaCRxQsg2q0fQPQ
         4o4sHik0lMRjuY01H31c6eToi0dsfP8PzH9a0hbU1Am3udKswHVxQLQ9xhea5MLftzP1
         +uPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OMfZlxCdprYAMpSImSSaNaMJO4xAI8KlwbjojS8D79s=;
        b=Ax9ykOYqd4I1pTVF4UiKdjWXGT+bq6SugFylqoKxt5ykOd5nvmj/T5A9R6BqD3f0i9
         xk7nELhX1adZAj/UZDzTC8rfNWrARZr6dqfphABW5bvFAVKlf0O1Wr68VqF1zw9O+tSA
         LYakT2WG8B8Iw9cc+PoYY74M986oaFUR4OIgQMJr0exWV8zX5ypfPGuSQ/legLVNe/d8
         o7uKVN2+JH4ey5qrXhsrIoW32TUj8nS3KOClGLPU+qj+OqhTqJK4EkvypR/3lH0E8ChW
         RY7WxpAWpnK7CW7+MYkoQpt3WTfBQiN3X2ZakGjfq+YYLthfs4zrDleE/wtp9X39R/xk
         CHcA==
X-Gm-Message-State: AOAM532598NhxCYmNeFhCEb+Jlh6jLbJWaTD/xzehd+yRCmnb+Kh3QUT
        a53jaQB3Q/QY5junsuY/u9d25XTdY3NRo9wp36pQXw==
X-Google-Smtp-Source: ABdhPJzIQvMlwJGxo0T9munDhJU13izs6JDlXL0JCikHMNzkctCCAvkvdq3hkNFW4AoID7XpzhXenn1793RMg1uBkQk=
X-Received: by 2002:a17:906:45b:: with SMTP id e27mr1036339eja.375.1627626243571;
 Thu, 29 Jul 2021 23:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210729135137.267680390@linuxfoundation.org>
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 30 Jul 2021 11:53:52 +0530
Message-ID: <CA+G9fYuEBfRcJx0o7m5+YnLsqzQazp6aCpr6pzUfS152dpi=jw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/24] 5.10.55-rc1 review
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

On Thu, 29 Jul 2021 at 19:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.55 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.55-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.55-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: dfa33f1e9f64f87f2483e3dd6ff84244281527db
* git describe: v5.10.54-25-gdfa33f1e9f64
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.54-25-gdfa33f1e9f64

## No regressions (compared to v5.10.53-169-gf52d2bc365d2)

## No fixes (compared to v5.10.53-169-gf52d2bc365d2)

## Test result summary
 total: 84369, pass: 69684, fail: 1624, skip: 11968, xfail: 1093,

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
* ltp-fcntl[
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
