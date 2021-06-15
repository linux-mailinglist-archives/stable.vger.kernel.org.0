Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BA93A7AF5
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhFOJnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 05:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhFOJnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 05:43:17 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639DEC06175F
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 02:41:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ce15so21437930ejb.4
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BLVFHcMOWvwj65JMfhwAAkT+PYDZaPiLtTNguuvICyg=;
        b=HTZ/lNLjKHLJ4R4/Mmt4xzvvzYDBk43/iQRlrebtrfW7mP3OgkwjlEJOlUHt5eup2m
         c6kZkV+rDe2KQFAiD9OcXulkpJ2zYEO8Z9qtjG3Wy1hCSbJpFaunbJFOO33rPGHS0D0Y
         sUXrw9cxInCDUTGIv7oN0zVwItDzQc3XyED2s2gJvby4ywFcVDZs9MKCcAID03Rk2A/R
         aWn4lk/+IpLZ9qeRMjFQCLKsJx5Foo5u/V5rebxwHEZLHZBngaJNDJ/kZ5d5BGic2tAH
         dZcRmh+c7KXjRKFWE5XFniroT6DED/XfJ1IsgCcXfu6fueeeX+vneBBBJBJoZ9PKUg6k
         aciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BLVFHcMOWvwj65JMfhwAAkT+PYDZaPiLtTNguuvICyg=;
        b=YAYifOSFDESvXVhnPJkwYEzgPjWbQ6lvKgbTxmip1y9SSV/HsOgwWHFVa32hHYB7gl
         ntpOqB07ZXpmSRwlKytn0dEGJ/jMz/477Cbi/GkOF/keafOyM3Pi8uCoCe0MBlVgoXVb
         q2qGLObfuA/EozWd7jVAykzBAAOhU3xoycvPscnie9at9hFuvbKRyQTm+xJXVUSNok9y
         B36jPa4y7zeNilrSNOtO4Q3HrzKVfDDQeW8wVZ5w9sx8HkQMvnKStQS/ZvvFH1NPV1q9
         4bR64QfGFgH/F6yCwA2FrZ8Yvb7HlEDBu5ZoACMxzZxTfWPI9P1g7347QZnQ053vrhWP
         vnWQ==
X-Gm-Message-State: AOAM530MI7E/JVIU/4bTD+lTyBfYk1uwMAU8MgFKaWFKUvo/I//DS9zO
        B7xitl43Nf5UwnhtIcqpm4GVlBhzk7c0gVPjW80o0g==
X-Google-Smtp-Source: ABdhPJwx3DEeICIgAcIKorrmXPO9nQe2m5M2+7cZZXQLIkpOU9g94q91YGaFtZTrAUOy8Gpp2SEV8DlDp5W4xcVyePM=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr19418931ejb.170.1623750071665;
 Tue, 15 Jun 2021 02:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210614102643.797691914@linuxfoundation.org>
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 15:11:00 +0530
Message-ID: <CA+G9fYvAjapQyx=RR1UK1s3n3EdBQiVNS9Y3DvDfKvGqsqv0fw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/67] 4.19.195-rc1 review
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

On Mon, 14 Jun 2021 at 16:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.195 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.195-rc1.gz
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
* kernel: 4.19.195-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 3c1f7bd1707440cbbb07d14370ce120a1a29b79c
* git describe: v4.19.194-68-g3c1f7bd17074
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.194-68-g3c1f7bd17074

## No regressions (compared to v4.19.194)


## No fixes (compared to v4.19.194)


## Test result summary
 total: 68535, pass: 53388, fail: 2443, skip: 11628, xfail: 1076,

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
