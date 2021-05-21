Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A38B38BD10
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 05:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhEUDzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 23:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbhEUDzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 23:55:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9DC061763
        for <stable@vger.kernel.org>; Thu, 20 May 2021 20:54:19 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p24so27214449ejb.1
        for <stable@vger.kernel.org>; Thu, 20 May 2021 20:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MQ7cq8Nvx9khbCsCmbRcfnX0qTE0c3vUh6MfPDSSdX4=;
        b=fH9cRmj4I4MzsoX3eGccQNnZY1ffEQQnHjfAPpdYoJH5DGSwSLiczV9XGWkKNszBYz
         TzX8ldhtJPcPHfqIKJIy5UGx9NnhHm4TQ9zAZpS2MM4zuj8h/OdbFnp1txcNa5ovcbdP
         mtknW7CLIye8Z+tSgKJFw3d6E46t5NcWUGmp5knIwoj9WUHuH8a21ZB7I7Qf/O0zwRSv
         mC4LWPWQlYOyqYTQp0vShf2P4d2YktVVsYIAZq81zBmeC8sit4hW0TKO8p6ZIrwnqQSo
         H5gX9kYTymRdNTVO2G8x6Qph5fqXkRYd9FSNW/K3cdjKN7aLka6r5gFKtjKBBxPkrNGb
         pzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MQ7cq8Nvx9khbCsCmbRcfnX0qTE0c3vUh6MfPDSSdX4=;
        b=YULot1/niI1YQ+6Byqz2IuNrtUyCogAxnlA+JxO02brhqgCB1TJm5KCZqgcRKkQn5A
         DzQd8nj9ib4w+0ao638zHApu2/i2zOzh1bA3NdsBxCHR9Pd1z/Iw9G5fde+A5/4TAO9N
         P1lh00Cf12iWqMHRqwWJLEjzVEif8xVN+9VELzCQkUD1HhwoR79w908jyma+bP1m6Ixz
         ESLPwvKB1NxO5yYxbc8e2J76BUxoRcwNrcyNOrGkP5w46mKqf1yzI8XIgo5nA0PkxZFD
         smG1FIszeAsgV24IKRiKxvfokbhnykXLFhIy5/aHof7u/D0KJ2sfpafR2B1W//p+H0i4
         b/vA==
X-Gm-Message-State: AOAM532UqNlfhwTdBKjdmv9V4DNAAuNHIKWw5mKZ8M91HkMVn6Wj3XCP
        HKIH+UKkSEgzxEo6CWl6ulBb10rK3/hf/LCp8/vBTg==
X-Google-Smtp-Source: ABdhPJzmaGCANMEp9JRCSjLoVcKQmwivQeS2DTsL0m6xfIS3+Tips9H02k8l453iLCMztK5/3uTmLhfqbat4pDRVsuM=
X-Received: by 2002:a17:906:c211:: with SMTP id d17mr8057991ejz.247.1621569257491;
 Thu, 20 May 2021 20:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210520152254.218537944@linuxfoundation.org>
In-Reply-To: <20210520152254.218537944@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 09:24:06 +0530
Message-ID: <CA+G9fYv_-7Cchnkpej0+W7o2nhLiyVBL9UB4gzgO_YFPfci_uw@mail.gmail.com>
Subject: Re: [PATCH 5.12 00/43] 5.12.6-rc2 review
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

On Thu, 20 May 2021 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 15:22:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.6-rc2.gz
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
* kernel: 5.12.6-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: ee71fa12d93bc1ea09ff69a8e6b7f44399cf209a
* git describe: v5.12.5-44-gee71fa12d93b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.5-44-gee71fa12d93b

## No regressions (compared to v5.12.5-46-g735770af9611)

## No fixes (compared to v5.12.5-46-g735770af9611)

## Test result summary
 total: 83518, pass: 67552, fail: 3303, skip: 11987, xfail: 676,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 0 passed, 2 failed
* x86: 2 total, 2 passed, 0 failed
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
