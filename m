Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83E5331DD8
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 05:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCIEWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 23:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhCIEWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 23:22:17 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0932EC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 20:22:17 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id dm26so17928961edb.12
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 20:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m6tZwUbokIeBXeV/DnNSwkZ9hS9ZCPfaIxmxV2RDTZw=;
        b=OkDnp82YvS7ktccNiRLiNE4B0ZYfiJ10cJTkxg+16Ki0jyMiuDL0A2AOlYa2OFTfzV
         wECHkzqgEYhiX99R8ZW8WhiFS0JwZNd1hP2jsxvYjyx5b1lO71i27yVLIG7hczvzQPCl
         FlU2fldeuFauaupP/h6ipAF3S4IEKgKefYyMV38SRgD1p2HJU3Smp2z3IkQxTHgeSsa9
         WiR+k49dsrqsIIkTa+i/tgD9yLCW1fuXE4mc8/wOdRgWCsmLNa8YVjfZd7Z36ri/Ho2d
         SUh6jJp0pmMd+56AhFL5nuefBqQ7PIJwfyymPLlqWj9cjgjCNUECx809bycVqTPQek4a
         Yd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m6tZwUbokIeBXeV/DnNSwkZ9hS9ZCPfaIxmxV2RDTZw=;
        b=uPYhMBRbdKgoej6K2ogJxkcX5qZ+dAyZtQkz8GeVN8aVev8se7B9pTUcE0wDJ9WaKv
         IHtt9ohXrj6O9OPh4q/MM5eKXIP7GcMuAh1MlzYsWIbDX1HphSVhJ5g6lyl/2WRfqS11
         j65hyLbT251bc0g9xaomaI637R34C5TOCCjwE7S1XMPuaazjZtMTM8v8tPtfINhZ0R7E
         hq+LSFoaiY3JAQmq2n8CVxENDfLaVm7tOOD8iWzTY/wg8B+CHAMTotTMayfjgopB1Iyk
         3R+UUjVFpS6OY329KRtQ3kXGlL4i/OwclsSHXQqKkDvflebmexQXV3YvFmhS5c4VCrMn
         BOZw==
X-Gm-Message-State: AOAM533/Ciu/xjKmsTPERfcOAZwuiCg/hoXSz+tyJdCXaJtRTOwJpInJ
        t4tOsA4kGbn8jRAUulLLKrknHj3wqV8+y4bAgqi+0w==
X-Google-Smtp-Source: ABdhPJz56rp3nxHXNcoWFSY6ZMzLqg5AFyApV1bTfSaBP6ccS2+wpcj+XLhVmXtgkXE8GtTm5Wf2wky6A4QYCmZcO5A=
X-Received: by 2002:aa7:d287:: with SMTP id w7mr1870488edq.23.1615263735669;
 Mon, 08 Mar 2021 20:22:15 -0800 (PST)
MIME-Version: 1.0
References: <20210308122718.586629218@linuxfoundation.org>
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 9 Mar 2021 09:52:04 +0530
Message-ID: <CA+G9fYs+sw5R0wE2YmeYpu+9b5tR=VgfFCk3Aw_ey6iDv13RQw@mail.gmail.com>
Subject: Re: [PATCH 5.11 00/44] 5.11.5-rc1 review
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

On Mon, 8 Mar 2021 at 18:06, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 5.11.5 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
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

kernel: 5.11.5-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 89449ac6c71545ec3c6f1ea5a63b16a0c8b4d479
git describe: v5.11.4-45-g89449ac6c715
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.4-45-g89449ac6c715

No regressions (compared to build v5.11.4)

No fixes (compared to build v5.11.4)


Ran 53609 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-64k_page_size
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-livepatch
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-lib
* kselftest-lkdtm
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
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-controllers-tests
* ltp-open-posix-tests
* fwts
* rcutorture
* kunit
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
