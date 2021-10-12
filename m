Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C6542A218
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 12:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbhJLK3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 06:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbhJLK3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 06:29:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9BDC06161C
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 03:27:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i20so62732069edj.10
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 03:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8EXwD11SEIxjl+Mcu3oG+NFAC6OahBb/SWO5Y89SEOI=;
        b=d6/ooUZu0fIRAhiz/tXS9E1OVaG/iBKY1Hd3/CiSPrLgzH5EQN5HkBYICkiPPDJpQj
         kEH4nbhSzYVuh6fwjBX9l0Q0Z6IUlrWgPxD+7T23o2CuH+TyQ1vmRMj8zxDCXuFlL/iH
         OOoTgF/+sK39j4FO/g4Bh8GpyCxgwkEUWulrwXCymvRjvDOp0/37DeGFppw3pNoRcwBh
         PtVrc6+RA0pwovPuVmweNkAagnHX2etdrr5fVG61XvWUKWVtezTVBQG5UT1SzEDs0qri
         AMCutF3OR+rN834UTXZKZGVBTM94Av9jhoBm0BiV0YCEGUjNymvLxS8QGwX0cZTPG9I3
         qE3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8EXwD11SEIxjl+Mcu3oG+NFAC6OahBb/SWO5Y89SEOI=;
        b=H/1e0T2BTkTv3JMnnoXYiZYqc35iFD7LR9lU0p/aOpzCfQY9u8T1YdqDdBk/8JxyBw
         BrS+R8HqkxJpUTbWQOby0dM3RkdWvrZAhMhIl7ssTsltPuwm0hnXWwoBA8oF8Zn2xXcB
         PpYszwbetnZbAqcrJr2QJQFsodCgxAxnFaBYb9nUCnaedatkUUORq2g5gOgIxZxqjMmY
         4SAk3nLhCA5FXGXgBPRgFpWvwRFJaMoqqv/BfBQSvzHZgLnq+D+Q8tcyVYp0xXYKOMRk
         qzLFeyTKwFNCaOdur5K9QeNTZ4MN8WxcyS1TGK2mvwGwzqIWJ21QeGCCUSH7oW6Br54l
         vO6A==
X-Gm-Message-State: AOAM532kIVpbe6htRC2LbCys2sqqJFd9Fu/8lawMq0EsWY4K/viEfzoP
        aALslcp/WgRqFjGV9q4FPv4IgHFBnVP+VCVeE6fM/w==
X-Google-Smtp-Source: ABdhPJxfc8UsxvJoVjCDdnXXfCJDTbt0Yc6Wq/WwXRKdXPDpftaOm4XzahiPwLuBxKE1XqOFijy8YCDfIo5+URqeJis=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr32708608ejc.69.1634034467139;
 Tue, 12 Oct 2021 03:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134517.833565002@linuxfoundation.org>
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Oct 2021 15:57:35 +0530
Message-ID: <CA+G9fYsci1oPQhPs_WbGO3WO+ZZTTCxMYE4sTQBzQxhCRNRyyw@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/151] 5.14.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.12 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Oct 2021 13:44:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected on arm.

The reported crash on the arm x15 is an intermittent problem.
Which is also noticed on Linux next and mainline.

We are investigating this problem.

Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: __lock_acquire+0x2520/0x326c

URL:
https://lore.kernel.org/stable/CA+G9fYutz0ZgJ=3Drrg8=3DFd7vh9c7G-SJfF2YoH5w=
ZyGzUHu4Dqw@mail.gmail.com/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: d98305d056b808dd938d2ae6bfd0e3ccac00a106
* git describe: v5.14.11-152-gd98305d056b8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.11-152-gd98305d056b8

## No regressions (compared to v5.14.11)

## No fixes (compared to v5.14.11)

## Test result summary
total: 94671, pass: 79926, fail: 1186, skip: 12797, xfail: 762

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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
