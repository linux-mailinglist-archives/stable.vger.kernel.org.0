Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620E53AB18E
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 12:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhFQKpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 06:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhFQKpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 06:45:17 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A237DC061574
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 03:43:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d7so3414813edx.0
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 03:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ek/e+9tgXxNCKfcft5eEQgZwI99jFtBBtCRIs+kDtHg=;
        b=uCDoSTTLXTbB/+V+mMX4KYtbf1lKlFm5cWl0thzvqFlGF+yFjogZqZ5HJfV9De9FwW
         Pl6RZpolqW0z834dUfo8NHnXJrUd5QibPPTvFv+Voc/Irl541EqMECAUuTKwr1SzGZjQ
         vj/VhynoDrclu5QuAGg9yKwk69oaF/Vkj9PGWRFM506RD6+3NwYJsIK7r6yqb0Gpyu8c
         4+QNgj0AD13gHPNCi1CU1tHYpoRgMRu0OI4PkHPvhMDIeYdlh3MufoQZJSILU+KG7Wl0
         di8usirsNalC5ehwgqlzsWfQXxGmXf3dSQ3hNv1RkIo4QpAnACnBan+uBqjPfBI81dxX
         qbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ek/e+9tgXxNCKfcft5eEQgZwI99jFtBBtCRIs+kDtHg=;
        b=DabziLN27XDYdiE1lPff34KtWhx3yFxJ8B04s0aNaxEUGLGDhOyvP+0L8wbnwTYshl
         RqIVpvzeri8u03zlD3fbDqLnP4MbpY6JNJLNupwa9VoztPCMlIEje7gLBwuRbdP3f9Cn
         g4QFUVZy7QjaXHKDlwe0Xq+XwLM66zyWKhPbGcGj0JKjixrE9S7jL9j2xB+fE6T2zFiw
         vMorPIB+NhFNrA5ycARJI5hL86F6EmU5qV+wwRzIjW6fmyBOmLUift+o60vDjwvljWJA
         RczsfQs1P6HVZNBnQk4Fn4tlsjymVRcp1QSFN+Xm7+VDuwNyjXViJ58DQww5H9u6wCdj
         z/pA==
X-Gm-Message-State: AOAM533OWn2f4mMsWsR/NaPzfhTv7q/TsxjyLaKnCf9HeJXbbAdyufcA
        7eSI9dVaalLw/JxhsCzvbZ6dnGS0bA5+wGFfs+dxzvDR4yd4pLt4
X-Google-Smtp-Source: ABdhPJyyaCMsFuxBiuCT3yGiOn5g31ZI9GUFi6HOY0g6z2gw9S5WcUMSiElE/KNsl0dFdslICDfD8deCSr//G4MkIOE=
X-Received: by 2002:a05:6402:22fa:: with SMTP id dn26mr5480111edb.230.1623926588036;
 Thu, 17 Jun 2021 03:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210616152834.149064097@linuxfoundation.org>
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 17 Jun 2021 16:12:56 +0530
Message-ID: <CA+G9fYvRFjEk_xvtr66GM48VqATZpf6_Mr1vyPM6w2TT6xtXnQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/28] 5.4.127-rc1 review
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

On Wed, 16 Jun 2021 at 21:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.127-rc1.gz
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
* kernel: 5.4.127-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 4e778e863160695fca936b0a9452e94fc9824a76
* git describe: v5.4.126-29-g4e778e863160
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
26-29-g4e778e863160

## No regressions (compared to v5.4.125-85-g4a2dfe908c1e)


## No fixes (compared to v5.4.125-85-g4a2dfe908c1e)


## Test result summary
 total: 77072, pass: 62517, fail: 1192, skip: 12148, xfail: 1215,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
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
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
