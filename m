Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43995354B7E
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 06:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhDFEDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 00:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhDFEDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 00:03:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0128EC06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 21:03:05 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a7so19708260ejs.3
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 21:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rr1ylOvQ8jGFpmlvfpSJkvg/mm5/9cENURWuBmm2UcU=;
        b=nj3HQ0RXxBJAf5fvQAJESxn7aRMQ9QlzQKkIR4UFGWL1lp7N3VUxE+OpA1o6uV86mp
         l51pajWZjF7FJEITcEgV97pjbzehwTTq6jXzv0GHUrZZyMC5/GGgsjGX9i3+SAzUdSOS
         lLgzv5YpuiKxoCUYmY+6CRyeANpbkg7C4FRtrXyVkCHN9MK+jVQNcWNSy7MuSXqTLE2c
         YcRnjqTr4oMCJepBjuG8DdHcmkQyq/2bH5Vp15S8EyYPNBjube1c3koCc4SzXb/gF7nP
         bqeAnPVnkG8Ag9V37MBX2LyXlUhvf560IO8CfsXzaF6uaenJWdcHXcyYf+0S9zgIioBe
         hd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rr1ylOvQ8jGFpmlvfpSJkvg/mm5/9cENURWuBmm2UcU=;
        b=jS/Pv980fPsuffiizHmtscMsJFqwaGeIa+D4G/9Hmnt1ZQ7pcQP7WTJnOYuoiFnjG/
         0DuMOVIilOn498kBQ0ClmYk/cMBeQjUj2zWU5kq26EM34WWmlVlSHB81XT+KQ4qEZtIP
         E6Q3vfKDmC7rgOxZO5wQKN8sKhPrQ9+uQcfuCmx1S3zsmle0pqtTN3smp6M7e8r6r1p6
         Q9PBjEp7fMNxsPrQ3tb7v0sfFNkE53PYfneBQplLd3ZuYIjPJ2IAtqf90Jo/oC+MQ0j9
         r1rjK1s5Z8XoEenCGVWoz70+ZFGEh4DvmpYsoH3MUml12wf+SkjP90nL0AGXXXEhLFMm
         synw==
X-Gm-Message-State: AOAM5321WXcJpxsSI5wHoUWzrL7/Als7fG6ILt8VOWn+zVK2gOawPQf5
        cYCJrC9jIlR35J5B2nZvAJAAmgkvMwAEu/kk6MRWXWpZ3EHV2jpi
X-Google-Smtp-Source: ABdhPJzUxI8kOWMHJS/bEOJ9I9gc/cx5Gg/t6xQGnsd+vKXSTlyUfdo5u8uP4QiGW52lHKSmCTN+T6jlwpcROZGhUw8=
X-Received: by 2002:a17:907:2509:: with SMTP id y9mr19306405ejl.170.1617681783602;
 Mon, 05 Apr 2021 21:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085022.562176619@linuxfoundation.org>
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Apr 2021 09:32:52 +0530
Message-ID: <CA+G9fYub=cJzZ5nOBYeVfKdU=iOwqXDho-NbtMWjuoBq34+9Kg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/56] 4.19.185-rc1 review
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

On Mon, 5 Apr 2021 at 14:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.185 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.185-rc1.gz
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
* kernel: 4.19.185-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.19.y
* git commit: e80ef2122d5c0531670cb281f5beea2cb469aee1
* git describe: v4.19.184-57-ge80ef2122d5c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.184-57-ge80ef2122d5c

## No regressions (compared to v4.19.184-40-gea7c9d15cb8d)

## No fixes (compared to v4.19.184-40-gea7c9d15cb8d)

## Test result summary
 total: 69440, pass: 56308, fail: 1824, skip: 11083, xfail: 225,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
