Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B1C361DAC
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242173AbhDPJoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242135AbhDPJob (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 05:44:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0A7C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:44:06 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m3so31479989edv.5
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rRe1PF/xqu0UuMVNa18GYnpri2sRMuuyU92Z0ugYpAo=;
        b=AWrprHCh4oIrKLyyoxOXv0moOagMX2kFBjgfLlge7pODzapeVn/YVK8wS6CajcgBdq
         /3sXGOG/p/1qseBNV/wDZx82ykav42znmpbwhUjiumHFGB4Lej9ChnEbDeZwYs6NDDEC
         ZCCRhPOuppHACljp7PJo9wm5wXE7rjyb5SooWf//95dsorMEZQuDGGetjcWIsfEEZkmZ
         0CpPm67faBcy3CSUIdX9nOH09UO1GIupmBPX6figxbt6mQMGA9oqso+V9lcQxtkqkK1N
         VrdM8aSB3VKV/tn191+f46QWN3CKtqynCPuraCpnys+nv3/hnSDY4F8b9pFEi1ZfCOhD
         CCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rRe1PF/xqu0UuMVNa18GYnpri2sRMuuyU92Z0ugYpAo=;
        b=c+hXORhjZAXtTEMEu/xvna0xRieLvGSWCxL0xU1CBwFVrl6A5fglSM5fXYEmRlGBCn
         mqmI218j/gJARVDAkKTVnA/u4sYYiH6rpYHAWxPUo/ovlNY4XnZDHTG6ShF1t/LgQ5nA
         TSLb2Jy+VTquBuiSzrKmfFvLiAn4UMMcC+AStIlZzdPtjWYTJvJi6OJFKoB62r1SBcMh
         /umwnbII3mhJTugu4CFKx/k8Bs0ZiMKiLzGzWs3lsrOQKPF9iWdJSjXEHUc34QQfy/1f
         ++4YrjxZ4PiwSBe3QZTj0sMZQRcjou0Y6AKJJ4OO7pzUlA2tpCgAkRPGNnb8G1XIMomq
         F31A==
X-Gm-Message-State: AOAM531JW0IcQWRKUS5uQOoW3axUt9Q+foer/wLMgKPNKSqp5JuJZNCa
        nD/a6caiX7pehtZ0JfydTbvY5Cs8Mk6ck6PXVQP7fQ==
X-Google-Smtp-Source: ABdhPJwqd/otW47l1SXmWbcZq/9GwutbNWcg+6AKGshozAJ3XpkHy+o7hEQb8FXNQ+8Nb0SSVhKfMUOYCyIVNWoXnOQ=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr8908609edf.23.1618566244823;
 Fri, 16 Apr 2021 02:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144413.055232956@linuxfoundation.org>
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Apr 2021 15:13:53 +0530
Message-ID: <CA+G9fYuRLE=kG1Ppkwhc9QLhMtWreja7_ApWEU+2RmMX6XawnA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/18] 5.4.113-rc1 review
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

On Thu, 15 Apr 2021 at 20:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.113 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.113-rc1.gz
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
* kernel: 5.4.113-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 0d80f6c61d6ba21b3cb64eae72b8485dd96b5a94
* git describe: v5.4.112-19-g0d80f6c61d6b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
12-19-g0d80f6c61d6b

## No regressions (compared to v5.4.112)

## No fixes (compared to v5.4.112)

## Test result summary
 total: 71154, pass: 59298, fail: 1014, skip: 10587, xfail: 255,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 191 total, 191 passed, 0 failed
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
