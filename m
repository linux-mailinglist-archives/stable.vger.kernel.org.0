Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C672C3D0BDC
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 12:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhGUIrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 04:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237837AbhGUIiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 04:38:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB8AC061768
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:19:27 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qa36so2170930ejc.10
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9RWw9hlzVBYwy1prpk3B3GTGKEmRB5xdFJOT2eSc4F8=;
        b=vnfRt4mcI1NESqVswLdc4jH8mhGU4BcF1xDJ/xduSkgyXOngZDHQf7UfmC7Un0027U
         jScVh46afpT/zCRtw8JnttB7Y/fQ8r330j9GhwGmhwlzEDLX/uKeAUR3cOzQ83Ppj1RE
         fibWNnI2Zbr7i8609SyaphphNvBR3DR4isxQg/hsjjumubnAoapC/2mtR5kS4PjXBsiL
         d18QpBClHZZ7yye8yx7D4GAVifqzmXa5hQspPUUekqldNK5+aLNvdqu3NvABTQEOZPNI
         fpd8Y2CE64t0zDw4Sn0Am+uQ5Gjn3FSbpqH0OG1npkq1ryffMMvRpRW9p61pD5IgX05M
         cLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9RWw9hlzVBYwy1prpk3B3GTGKEmRB5xdFJOT2eSc4F8=;
        b=krzdAEB1VvqTzGZBhQXt+T/Q1fzCeqvDn/Uhz7Svexh8beLGMB+Y73aGOBw9ihxV+A
         X4dN4NnCyxQdEJ+6Pk2jfhZojKunKyuOolJdX/LS0Va8h6lHTaiGbPLGtlwaE3TNPNeV
         /hvwSDPav4LlWqPHyGAwIuVjS/Yl/mQn9AQ062AvRWnPCr1T4q+zqEXU9eMFFw2M+ZWw
         YiXJVBwOttcmkgm6RfgjIeB4TrxnGWz2U75wzVB6QEk3N6kCv3BMnHFxNL/y5sI4ixCA
         97oZtHmqtV7AJAhHHjBRU8qkyLaxAnuFPyaqCsX6w1ps+pyKzH6Pw8mALRPS8xW3AKBB
         BKtw==
X-Gm-Message-State: AOAM532cohDZs3tXUHxFBdRUO6eZ0qvXUDGTd/MfqEXhjUMVhCJHJxVl
        KLkZT31iOcopnJk2kXEFQZQcyei6Y+jjA92EMLBR2w==
X-Google-Smtp-Source: ABdhPJx72YzOm/G6IPsnyoC5FFxq9OlCfR9XdEv638t1fQ/3EI5k54pURS4HKiHdkW2rF0olCtmicbHyj8f61ZNbwxE=
X-Received: by 2002:a17:907:76b8:: with SMTP id jw24mr37029155ejc.375.1626859165563;
 Wed, 21 Jul 2021 02:19:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210719184335.198051502@linuxfoundation.org>
In-Reply-To: <20210719184335.198051502@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 21 Jul 2021 14:49:14 +0530
Message-ID: <CA+G9fYvVqDWb9qk9S48O_gBO_SUD_3x70HJCNwfOzbhKK0Niug@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
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

On Tue, 20 Jul 2021 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.198 release.
> There are 420 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 18:42:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.198-rc2.gz
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

## Build
* kernel: 4.19.198-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 9ec1965d618f6ee0de12cfed19640954abd387ae
* git describe: v4.19.197-420-g9ec1965d618f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.197-420-g9ec1965d618f

## Regressions (compared to v4.19.197-422-g477cd1345806)
No regressions found.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Fixes (compared to v4.19.197-422-g477cd1345806)
* arm64, build
  - clang-10-defconfig
  - clang-11-defconfig
  - clang-12-defconfig
  - gcc-10-defconfig
  - gcc-8-defconfig
  - gcc-9-defconfig

## Test result summary
 total: 76864, pass: 57318, fail: 3061, skip: 13974, xfail: 2511,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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
