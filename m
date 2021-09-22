Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBC341415D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 07:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhIVFzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 01:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhIVFzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 01:55:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155B9C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:53:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ee50so5248408edb.13
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 22:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y/nCOhN8AZjYpM2uGvc8B5Khq82DwNNrPlQBsEzJzFY=;
        b=PeKgN4831mVJIXwE3He5AswTg4qyZcTnnwHLqv+PYunrZRJgnJBX1A5tNi6JJzQozb
         cif7d8djlZPD98KD7PXiD5zbVlWLmxPC67D6PB8wKrRlyksWO44IAPh10kC3DB5py1As
         zEywYCw0De64eNo08OtYWWICcslIUFgRmOO3SBPBdR+9o8LhntnZaIdnAJooJf8M3IQ5
         yMFGvh8/s6NicfZ/O7pvZJV/QX4v58zLos3hAcXJ9BHEc5Ry+YDghDLYjUFplWxgCwxc
         zq96h28mwMGZnC8mYdLnFdqIU52f0kT5dvnOYClQuXfIRaHq5orxg4bvxIVC7yuva4Uz
         rd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y/nCOhN8AZjYpM2uGvc8B5Khq82DwNNrPlQBsEzJzFY=;
        b=4Do9jJ7fHpMOicOHfodINE0MD/8/DoTqrYcRlYQJljI7QgXko0MK7wOpwMnQ6bitgA
         DhJ3bMTHYmJNp0CsOJzmvzxH/NpWjlacvsHZPaXPJVVG8rT84eG7dUZ0Jb7RmOAFcg/z
         QjIeyiDfPuGsVHDaMSjJzlQMjUOE5dQJjiIkMhmcmtO9YMMo4KClncRzXtH951zRflms
         +mTqbtpjFp0567T2DrzRDM19ILrniJFsDRYVGisU+A7uioR4Tu9z+Tq7NORIHnFSlhXe
         IHNIFdrdNop7uZaAa3sq3zRbB8XKvX3xkQnbVpcoNqi+U8nDMovXdqPPzfD08r0Tp4TT
         9Z0w==
X-Gm-Message-State: AOAM530ASjuGtxovR7VvGeMX4Fyk7lzvMO7w1BuW4RqPpBbYGZpcR5kb
        lQMMYH4yLYyCvMDVafKQrgcqQaQxGQpsuRjIznjJng==
X-Google-Smtp-Source: ABdhPJxXDbclNfZmtzFC4b2AL0bdzwETCGmrVAIVZlEvnC8qF8ZXJYtnnU+PzbNdbOEjiq3ccmeeDGxhYQGVykximG0=
X-Received: by 2002:a17:907:6004:: with SMTP id fs4mr872899ejc.567.1632290018492;
 Tue, 21 Sep 2021 22:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210921124904.823196756@linuxfoundation.org>
In-Reply-To: <20210921124904.823196756@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 22 Sep 2021 11:23:27 +0530
Message-ID: <CA+G9fYvS1k+zO4CH3n0xyafU_mpi8JepVGrGjzt70TrSgnoEmQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/216] 4.14.247-rc2 review
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

On Tue, 21 Sept 2021 at 18:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.247 release.
> There are 216 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Sep 2021 12:48:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.247-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.247-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 21da330aa6db14f0db6c57090f438542d6ff023f
* git describe: v4.14.246-217-g21da330aa6db
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.246-217-g21da330aa6db

## No regressions (compared to v4.14.246-218-g7c9c2ff5fef0)

## No fixes (compared to v4.14.246-218-g7c9c2ff5fef0)

## Test result summary
total: 64153, pass: 50362, fail: 654, skip: 11213, xfail: 1924

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 18 total, 18 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
