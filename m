Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116323E3691
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 19:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhHGR4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 13:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhHGR4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 13:56:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADC6C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 10:55:59 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f13so17995895edq.13
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 10:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V6t/mWhJLB/H0xUxdHXenggFzdpuNv7D8Vjt/MBUyTc=;
        b=kLlPHHFnT7+viWSVJatPDeaH+6UDz/1KLiYpIFveJ8tapRk4GvC9549CXOlPRq3Qp9
         1eCcuL8mFkOEfCfYz+U/ZdcCneDp46s5lpLRZA2GvZf5UWmLasHvfbPQXRhrgzq/VE9s
         qh9lidfRZ+HP2E22Xwu/0pWkGVEks/xHwUhDp51YazOIkkJsxEiJbbRgN8UlMiIZCMqv
         4yqFR3bNVLLcTVnBAb2AXczNbS1+c59yUKvutyQsGqQf4bLzUdzBEBxCy9RXpQ3lFp3q
         k93ASrNfFTDlbm6zKaNJYHR6bh9HsaH9mn27AaRcEpfs31B12CtHvOvCSyzZ0yEi7a96
         S5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V6t/mWhJLB/H0xUxdHXenggFzdpuNv7D8Vjt/MBUyTc=;
        b=lmx9WXafIQjVLq4OZzo362wQTsR3eh73vuanEqTn9RdO+Ls6Ud31b84gN1AcgXMNo/
         2+I1bVyuZhUEISKtWpVp6GFpzYHwxbXXUDq5F8wQNCRyClA7JAlklVCZdJiLFMzf8MQk
         3ASP29B8Lv/6CX/ha5p7NhmY7sDOeVnrFqTbvEmdJRYaOlk8tmk25ghodPTKZA09BrGC
         MNMP0jvjN8nHdtzfZ4crUpCIIowEtGz1PBEYia8KFsVpSbV4e00vN7DUoysnf3XmZEI6
         vXYTy/sJQ9sfIj/YMck/8U/4rgzPMWPy3saZ7MF4ozfCg/VHkOw3YP+NRW4DRzOu1FZa
         cxcg==
X-Gm-Message-State: AOAM532CMET/iRwuxEndAEa27XhbZCsB7tMLT20fACPP8Q1UN64qd3Bx
        8KLXkdatec00qs8jp6ujBx9cKLfQKTOlYvYN4qYvag==
X-Google-Smtp-Source: ABdhPJzsY4knyfCzjf+anzDhNQNZYInovNMWclAT4l4r29qOWUvKbnPNn8nPEYVhoU1cOQrzz3kxGu4wfFyn8iUlPoQ=
X-Received: by 2002:aa7:c647:: with SMTP id z7mr19962545edr.52.1628358957393;
 Sat, 07 Aug 2021 10:55:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210806081113.718626745@linuxfoundation.org>
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 7 Aug 2021 23:25:45 +0530
Message-ID: <CA+G9fYs2CPfO-+TWLOYEiMqKWY9Pt+Oo8_6HSL6WRi58uoAqzQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 00/35] 5.13.9-rc1 review
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

On Fri, 6 Aug 2021 at 13:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.9 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.9-rc1.gz
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

NOTE: Found an intermittent warning on qemu aarch64 and reported.
https://lore.kernel.org/stable/CA+G9fYuH=3DKQaCpbBuYV0EEXtVcF7hTr+x6C5zmyUe=
NqVwLneYQ@mail.gmail.com/

## Build
* kernel: 5.13.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.13.y
* git commit: 1eb1590ab470d5f73dd2d20a7196bca35fa3d3e7
* git describe: v5.13.8-36-g1eb1590ab470
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.8-36-g1eb1590ab470

## No regressions (compared to v5.13.8)


## No fixes (compared to v5.13.8)


## Test result summary
total: 84738, pass: 69760, fail: 1654, skip: 12066, xfail: 1258

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
