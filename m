Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8D730D21E
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 04:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhBCDWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 22:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhBCDWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 22:22:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297E4C0613D6
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 19:22:24 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id q2so10529800edi.4
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 19:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dGGHehLtQGHqVsPXvFWYMLyI6hzOn4IRNyPittgEkcg=;
        b=Oz/bo2Xtmace/8RdWyG8lFC6Z6dbBWhyP5Yv3EYkts8uin9AL/HV2yj7KJx8JSkcuU
         xj1A4XXLc/NLgzQuKjNIl/hqzq6iXROFXnlFu6qrxWmG4u6m5xfa84ROiDIgyvUqpsQ0
         ooNSPdsUMH4hbUJ+9oPIYqGKQw54BYjputoqkzF0DLOJhwgNOqUC0rJSoz8OAFSz9a6X
         4pByEA8LyRI8UNOiozk0E5bTSMeHewBHMq+bh7R+rbshA6LVfj8EsksJwEp+l31wzi1M
         kF2vHfmWXmTQBxuli4FgJieaYTi2DknG4imq4rDVNpUoWRBYMa7si6SQeHfROVJJULtB
         Bf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dGGHehLtQGHqVsPXvFWYMLyI6hzOn4IRNyPittgEkcg=;
        b=RRofGfpvLNk5rZ2E1vhL2EWPP4mmSd/PW7SJNYUeGe07VHBldsjmJVTuif0ahhMfgb
         Rik/ZAAJedMMWF70w0Q7GtBogOhB2ept7cVW++CQIeZAO51BwZWAIxkGVzKbtSdW1ymC
         9fp5MdMYrf8Kb2S2KPPkMIUqzYJ8jILeDbQRfKwy9WJK6wOsroPuE0SZ4e/nVrE6M9wm
         uoi3XRSHnDYO8lBIyE1J2L7LxS1lPAuVsOiY1YpZKfWIovw74uvvAaNoF2Fy2o9P4PAE
         wWrJf5IkqEfjgEiEaQdsYdSUA0hoTcdBvty6BolfqotNTYWgHSuH3LJBBlmWnZ1qkL/N
         TQkQ==
X-Gm-Message-State: AOAM530Kmxvd7PcJAe1tyQcg6eDqX7mVhnlrUj507WH4qSC7IGpsJNQD
        MFEr6LMjDgpIkElB1Tg/QmGBYi7A6t4aQJIFHBikSw==
X-Google-Smtp-Source: ABdhPJwd3XcMOmp+GxgVhXKlOnN9PiLk2g7/Kp9JYnnsmUbZKXbnTIYa6xt42yVEoZS/WtBXkqMU/pwtXhzXNo4bz4k=
X-Received: by 2002:a05:6402:5107:: with SMTP id m7mr1077026edd.52.1612322542781;
 Tue, 02 Feb 2021 19:22:22 -0800 (PST)
MIME-Version: 1.0
References: <20210202132942.915040339@linuxfoundation.org>
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Feb 2021 08:52:11 +0530
Message-ID: <CA+G9fYv=3eNxNZCiphE=CYd=THHUUa9AV+ohnbRP-2e92kFJhw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/37] 4.19.173-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Feb 2021 at 19:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.173 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.173-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.173-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 5230df3466ef513b7813df2e707dc5d4cf7602cc
git describe: v4.19.172-38-g5230df3466ef
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.172-38-g5230df3466ef

No regressions (compared to build v4.19.172)

No fixes (compared to build v4.19.172)

Ran 48365 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-ptrace
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* v4l2-compliance
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* rcutorture
* prep-tmp-disk
* ssuite
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-

--=20
Linaro LKFT
https://lkft.linaro.org
