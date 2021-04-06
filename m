Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17075354B51
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 05:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhDFDnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 23:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbhDFDnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 23:43:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EC8C061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 20:42:52 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p4so4508962edr.2
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 20:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VMY7mUBdsG68kS0JiJFFUl5jnWAGVcKXBPoSy0XYHF4=;
        b=ty45KpsG9G0ydy4hB0APvCnFSRg9IsLipa3HrzKs3YGxM1jO9Y6kvn+JAQu9KloLiU
         57VhXPcwC4cjMBjxir/5BXnrdJ0epgDuu13dKVwY857HVX7lUexAXe6yo//c7VKhC5bq
         UMPgPtHSWUfyFieBMWlMikh9giKxTFP2nkD3MTSlO1iTrR/eHL6lmDmI6+06fjiqRhET
         OreHPW1wuDDX8capdldelSJ3LRn+tqP9jbNoukummlrp9mNJLDNQoWR/j6Mw2a4ydnCM
         opGU9TGPonDWHW9ffcnaJ4QsBnP6uHuAraqy3aEiANzbl3F9RozFU+jtkAcW0AtvxF/T
         AONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VMY7mUBdsG68kS0JiJFFUl5jnWAGVcKXBPoSy0XYHF4=;
        b=i7EaHyHvl3myZ2/axFcrxNUwogIkQZIzGle2VmrU2EVaSNjgUe57YtIigH+EPNjb/A
         Ymq6vA1kemTo8t7sRZg0oGEViZV9SARJnoh4/zAZPgHw5E/xu1UhH894HmSs6dWUKYO4
         FPc1l1lRA9BND8Xa72ZFSvMmXutaamVw5JfphJCspG2qR5j6AJy3mEFP2DQMnkOYjaIF
         VOT6i7dsex3u7yz6CHpefPoUiO2GxOOIuuuTMGL/VauWVheaebR9rJMqe9BBYQt0cEKQ
         PiqdHLQ5kg+ZAZS7ym3qIpO2QKygw7xvJN09o21fpcQJEuz1XqPBzOrWI0E2qbzBr6bk
         0ONw==
X-Gm-Message-State: AOAM530FNerYLnFpuqmIykh0ntAZTVGNSgr3/56aUwXn541XvUrQWoQ3
        0e2YJnnZcUQHcayPDA1KeXoY6saRpnMLPddQDpfIZg==
X-Google-Smtp-Source: ABdhPJwVE79lZ76HuTrHYnCnff7nqRq4PigsZMJ0eSRQBjeLVG3HJoy8S70/ErZdsdBh9Pky7dFQt0MYdoo0iZYQYO0=
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr34713020edv.230.1617680571050;
 Mon, 05 Apr 2021 20:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085024.703004126@linuxfoundation.org>
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Apr 2021 09:12:36 +0530
Message-ID: <CA+G9fYt6gqjmiyrPWbdg7B0Pyzovm0HenJcUWjBjYK-dig7vww@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/74] 5.4.110-rc1 review
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

On Mon, 5 Apr 2021 at 14:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.110 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.110-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.110-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-5.4.y
* git commit: c6f7c5a01d5a9e0d0cfb721249d5378de5f00310
* git describe: v5.4.109-75-gc6f7c5a01d5a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
09-75-gc6f7c5a01d5a

## No regressions (compared to v5.4.109)

## No fixes (compared to v5.4.109)

## Test result summary
 total: 71104, pass: 59473, fail: 795, skip: 10620, xfail: 216,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 191 total, 190 passed, 1 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
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
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
