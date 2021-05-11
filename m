Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3B37A0CB
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 09:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhEKH1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 03:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKH1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 03:27:51 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50481C061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 00:26:45 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id t4so28343937ejo.0
        for <stable@vger.kernel.org>; Tue, 11 May 2021 00:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yQUbhz7/E0lEtqCvmWvWa4PResjc+TajMFwGZfaN1M0=;
        b=ZhNP9Zja5NU6NpiGCaZ50LvYsMQt1kCvPFezLCYyFPH/gNyWaNX1r9v88P8G0hNyU/
         arjjOWQmAJLpxx7MI/JxoL67XzvmC3o9hi7ALxOLSVZ6rMWKtUnLI+jncozRRXS5iek1
         /7AG4Fngpq1zcr23d0Lxo7CHnA4K/WYVFf/OuPL907PippiP/GBPeLnqsNn/CnBCskh3
         WyY1vvsFcc2dGukV1v++f7cwmdlv+lzE9a0iF4M7O8Zd/6ILn7KpfTobMe3KKuI2MTZp
         nU9u52v+fsd93pkKCBsHIxn0WXPYJvFcqdE2IrqFAf3TZ+2uMjd9UrQbz2no3yubUTP1
         ysTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yQUbhz7/E0lEtqCvmWvWa4PResjc+TajMFwGZfaN1M0=;
        b=rf/DpStqKNYEVIP1utPJQXNnbcvvX/xrC598Z2kTRL9BBVMC94BGKLzaKnnIz+8HES
         SWMon6hhz+gLs77yedHw0V41m9ZB+U3VVB+O7TsW403pff39TOrXetH3xslcUg6ZEoRt
         2yMWgtO0pmNqy8uyotwCAFNCbpF7pJgfsfbBGa5hj2lzAjVXJuaxxPcTaCXAwTUXEddQ
         LLCXzKZRTS9XDfsV388bBIQ+rSApDBKzJmDzkaphRe2l88qMMxA1wGbImW7QxHzOJ/lU
         Mkd+WqxdwzVVE2O8z3z2cVYaNN9sw3sK/F3d1b07HFezzeky74t2+/DPlX+ZybyXjBpO
         43aw==
X-Gm-Message-State: AOAM530f90WI0tCnQOhLoC8fsSDX+qALlKmV2/elh+uPmxhFe1QT1uD0
        zTmSw8huxDDnv8/B65Grig97B3RGVTltDhNO3G6EdA==
X-Google-Smtp-Source: ABdhPJwbsaDcTM51zcSzyqxeFri7oUU6LjsfE6BfGESLkYeAgVA+O68N5hKg71kj2kWczEJ5QmAb227UflYnYsmSv9Y=
X-Received: by 2002:a17:906:11d4:: with SMTP id o20mr30114432eja.247.1620718003845;
 Tue, 11 May 2021 00:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210510102004.821838356@linuxfoundation.org>
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 May 2021 12:56:31 +0530
Message-ID: <CA+G9fYtPHaM5Dsdfh8ci8-+bL4YwdbW2SJ72D4t727qOOpV4XA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
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

On Mon, 10 May 2021 at 16:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.36-rc1.gz
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
* kernel: 5.10.36-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 4edc8f7e8676bbfdec9d67dc6b90ec72fd3bacaa
* git describe: v5.10.35-300-g4edc8f7e8676
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.35-300-g4edc8f7e8676

## No regressions (compared to v5.10.35-221-gbb0eba64e018)

## No fixes (compared to v5.10.35-221-gbb0eba64e018)

## Test result summary
 total: 78630, pass: 64381, fail: 2948, skip: 11032, xfail: 269,

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
