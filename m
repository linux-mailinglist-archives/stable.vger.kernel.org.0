Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3885946B6DE
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhLGJUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhLGJUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 04:20:36 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F0C061574
        for <stable@vger.kernel.org>; Tue,  7 Dec 2021 01:17:05 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x6so54107193edr.5
        for <stable@vger.kernel.org>; Tue, 07 Dec 2021 01:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dwd5dEAn3MA4kor56BytGEzIDB2TFQRsbAMpOWBTitA=;
        b=f/QD/lMUy0YmQaqqPJWBDgEEJociX9CX+d2le4r/K2kC+2xzCZJsbft4M1m4teXm74
         50a7k06zZyx7ptyxv0qNj18pffQV9SNF6t1IkYYKnjN7fZRi6fWmqUy/7K5SLqqZelgb
         bSSmbYHLuFEAhLoZBzfCR8aSkR91ryqQZ1ybupwvf9VjDqH7J6ZOkzCDAtHlOCym1Yxz
         hMadGzX5NgnHAAK5rcC3Np0A5R4vO/jmBsaS7DniXeh0RcjSs85IBnEfA8YFM2QwOPVx
         aafDMqj17aV5FN/RqanQelB1HNQl7VWsVo5LrxBcfiQFuSdO0LmhtsZ4iCFugZssymKP
         h5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dwd5dEAn3MA4kor56BytGEzIDB2TFQRsbAMpOWBTitA=;
        b=SNVjdxC3WCpz0llEhZ7z3+jazbKULe2yHGWWUz/DB3eLEU5BloBEdGionVbYEC+Xkq
         LQs9Tvswe7GMdqObnmUzj1nmmCH9ClWGnvf9QkN0V1wefapOiXXrn5AqIH8j8E+kstbQ
         ntHnid9tHAVD6xCVYPSAgMChpyjRXu19JaijKVmaxJN3g/8mPBgjlNfph6IlScOfcwwP
         eoNwX2JTkkqxTD2YEhwznGFfYkbx/ShXIbqjniOkRfCZEQFersGJkzqCj9D0G+0u/ytf
         V6LCZuZMTzKorForItlyIUDJKgOBiP1I9XBkybCdMCgKH+OxlGQmw0pXKSmthjY6JY0l
         5E+Q==
X-Gm-Message-State: AOAM533fedOU1goHrXV1xIB7m3IiIg9lcxzF6w9heyg7qIh5s4htbrr2
        kXlX82LXdESwp7zLJFFAdzCtZt91SMxnTe/obx4IhnRmIbeSTA==
X-Google-Smtp-Source: ABdhPJyfJwmPW5CI6Uzto1iOXsYCxcsEsWPbQz4ttteHzi0HhhLOfp9wjjDHmYlr4c2ppE6ilWL3B8dMsOp12j/i1cs=
X-Received: by 2002:a17:906:7955:: with SMTP id l21mr53959605ejo.6.1638868624248;
 Tue, 07 Dec 2021 01:17:04 -0800 (PST)
MIME-Version: 1.0
References: <20211206145551.909846023@linuxfoundation.org>
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Dec 2021 14:46:53 +0530
Message-ID: <CA+G9fYs0icvitkzDx4Qrp7ZAuxRppoQ769GO-+0XXzBUL2BiJw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/70] 5.4.164-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Dec 2021 at 20:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.164 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.164-rc1.gz
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
* kernel: 5.4.164-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 5d289daa9fc282e333cd99893062f9ce3e69e842
* git describe: v5.4.163-71-g5d289daa9fc2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
63-71-g5d289daa9fc2

## No Test Regressions (compared to v5.4.163)

## No Test Fixes (compared to v5.4.163)

## Test result summary
total: 90099, pass: 74767, fail: 727, skip: 13223, xfail: 1382

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 41 total, 36 passed, 5 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 24 total, 22 passed, 2 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 35 passed, 2 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 58 total, 50 passed, 8 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 22 total, 20 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 40 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
