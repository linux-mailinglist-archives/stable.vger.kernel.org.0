Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1336432E14
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhJSGXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJSGXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 02:23:33 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D33AC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 23:21:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t16so8648034eds.9
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 23:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OHOGwDSVEfVWjDixnzReHf4gOyr6Oktv6s3nxmgUyD8=;
        b=kPfMAxB8IcFY1mr1ROJclWC35ZRdrfsoINfReIsZY5iXT7hUHdOBlYQnQUy3jBXnEX
         norIaOxrXWHCFai5u+3/SQjMKE8FjCSWTsByKJIvF94twKbC0G9+LVsM/kBp1xJatqRn
         vWz3DoFl1L14QJbbLXvWkJ9R4AywJtwyVqr/wa4oORmgqCzHDLN6Hraub63MeVGMwfdf
         9vjXIaxWIs19mJbFrNmPi9Wx4uYj5r0dYrcbrIY6haX2xUbhM+ScmVHRgD4og3a6y1Ma
         rpDi0vk0YBnIdtRRUfGLw0aPeL8dZdmN/OOBah6UHKS8b1AVSLN9TYru3hpoUeD4EDIL
         lEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OHOGwDSVEfVWjDixnzReHf4gOyr6Oktv6s3nxmgUyD8=;
        b=UvIOnUykJ0sWs7bBfLsUR6sGUpyPTGHEWOtlI69yNl3fya2y4kY2dZcgpI641CrMvh
         /1QHwVk6wVmT6qSkGfuvyLQCc9ms1ZOfJ6sf6onrc7UU/SVE8Qg0HIv58OdTaQoAQwaG
         ptRFeB5gAVrw0T+LwvHczrHT121doXz6s3YMBcHaLIYO5BZbUa6uZXpZ+axsikaoSS60
         s+28i9gP3qMsYhtvIyjcpADvUCFeyDIWMFHa8ufWqXZhehp6BcxDK10Ge5zDRAFA3t6I
         RQi3SKgX3cJKbf7dUvAKGAL3plUczyOepB0Pa4ZLvFS+an2GCyvU9915RbdD4gjVIDy/
         jzfg==
X-Gm-Message-State: AOAM5304+i7HO3bXPCTqX8QkAHYCFxM1a/5ZfW4W59mdh93U9Lg1Lizx
        5AnPs0yRm0HWyyLRFRnAoTR0BKhqwq/56vyTEuLSsSeywaPm5A==
X-Google-Smtp-Source: ABdhPJxNBP22BcHTX7jTxsarP+pe2iUZwNWGflBjvB7mEQu2ESKM5TBGNAfYMy/Ugf79hL5aUKCe7IV/S58IRZqGUfY=
X-Received: by 2002:a17:907:8a27:: with SMTP id sc39mr35179639ejc.567.1634624479545;
 Mon, 18 Oct 2021 23:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211018132334.702559133@linuxfoundation.org>
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Oct 2021 11:51:08 +0530
Message-ID: <CA+G9fYttfYbp2krFz-+sE1tKCjyknyNcXwXYz2090zejDK2wPw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/103] 5.10.75-rc1 review
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

On Mon, 18 Oct 2021 at 19:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.75 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.75-rc1.gz
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
* kernel: 5.10.75-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 211949e9074cd293bd9e8df5a3eb8b2ded6cdda6
* git describe: v5.10.73-127-g211949e9074c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.73-127-g211949e9074c

## No regressions (compared to v5.10.74-26-gb2defce123df)

## No fixes (compared to v5.10.74-26-gb2defce123df)

## Test result summary
total: 87431, pass: 74711, fail: 249, skip: 11698, xfail: 773

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 39 total, 39 passed, 0 failed

## Test suites summary
* fwts
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
