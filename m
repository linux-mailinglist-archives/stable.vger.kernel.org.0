Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF19F38FB96
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 09:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhEYHYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 03:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhEYHYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 03:24:33 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC281C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 00:23:02 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i7so27845504ejc.5
        for <stable@vger.kernel.org>; Tue, 25 May 2021 00:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DYAqWMiDQ+kkpM7W29zoxxV/g8Y8WskJxooftmjhlkE=;
        b=X/tnYpuGB+YoS8SOtfnSm4tkpmls5tFMBzJ38OSAhw7DLDApqhUkmhGnTzoTyaCS0G
         zt6XOsFzvtdfMRPpv8aOEZRYSKV+x2XOtfTjqt25mBmXKkFNf2Hf1CYY3bEOQfbPQPv+
         uvIQuSXgqhoIWmJwVRIlsXbdnU80ERVs5d0gasnSA6ExRK5pIWDuUIriole+mbqOPJpS
         xfIEi16mn8VMCzWLD8v13FjzUcnpRmRWozGbCtsLbpSLObB+kw1Vp4TscN/AP2GiipQi
         dbqBlJ7w/qzYbGhLFxFvdUEYJjrMBev5nr9SEywRrmFX2FSo1uG8UUy77e4xChEfY8mg
         DsvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DYAqWMiDQ+kkpM7W29zoxxV/g8Y8WskJxooftmjhlkE=;
        b=PLY+HuX20QXzKzSWJBwCUrvVGnNf/VtWevZBIbFym3PcwXARhyKykCZJe2gwaVZXsC
         CRifQ93M8bINKMTb6qVqVZFqiSpo1iiSeEGko02P/EhJbB1HCDE6WFWw6LkRLteoTA29
         Juam7wy/9BQsALSz5e0FfPP5JoNkVRVu7r5yBC9GkoksvBacbhD971zbL91vYXOYmCY+
         tm4jAfV98mqGikT6O5uIySUyyhqKproXnm63SeN3ptwUEc7iPWBD82C68OQf9tUd/Zlv
         weZ/K04oWK4F3ervflPYPwp+kOq8WWmKqDtqVS8XxX2t3fUAzLRiNSRCJI5iEI/ZM3dr
         E96A==
X-Gm-Message-State: AOAM530KjfiqBoCtehfgCm3gL+0CbZQN+rCt0PRlWw3PcVlANvcAIIyv
        bhNW9F6mvROIshrcCd4KiBXOCOA86J2SseQxidhP8g==
X-Google-Smtp-Source: ABdhPJxVlgCSmxuPtZLhIAVNtY/aiz9Am4euSwyH2MPGQyzAqH9zsKjTDy3BD4R0dMSJT077x5uGFrQi1h8iz5fHIV0=
X-Received: by 2002:a17:907:37b:: with SMTP id rs27mr28263620ejb.287.1621927381215;
 Tue, 25 May 2021 00:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210524152332.844251980@linuxfoundation.org>
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 May 2021 12:52:49 +0530
Message-ID: <CA+G9fYtPfHxeNAO9gdu57phnZp5=6oXKUAcGJZX0tQ6vQbe-Nw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/104] 5.10.40-rc1 review
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

On Mon, 24 May 2021 at 21:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.40-rc1.gz
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
* kernel: 5.10.40-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: d8d2794a2bd357476a82c4d315ba323557fd5c80
* git describe: v5.10.39-105-gd8d2794a2bd3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.39-105-gd8d2794a2bd3

## No regressions (compared to v5.10.39-105-gd60ecece01f3)

## No fixes (compared to v5.10.39-105-gd60ecece01f3)

## Test result summary
 total: 82881, pass: 68064, fail: 2523, skip: 11584, xfail: 710,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
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
