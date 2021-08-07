Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B283E36A6
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhHGSeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 14:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhHGSeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 14:34:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC798C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 11:33:51 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id zb12so16444495ejb.5
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 11:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+7Y/msCH4+WIghRoGpXzbcxGPWNGmLe0ipJxsgxzH0c=;
        b=cAphF3tkOxEFQor5LaVL/4+3spdO4T0ncUJOi/OWWY2Y9n2TEsQYccagcx6PiwUZXx
         HIB9yC9vA7PTluySAhTxIzPUhF7MOcFgrijxX+aCJlrbj6nZ37aIYh3npmEP31V0Kpiw
         ijE88gjlij/0Dh8SYXqJXnZxaKMESxWgFlbKWlqoiuS370oNQSQ7wPQx7niFiaV9C8FQ
         TU8HfLnoj3EDvq1Ykfl64YFRmCnlB1bGLUy7L/iCSHCGIZrTepvZjCyvVEPqL7u8Sf5O
         c3AXGQiyiEskrPQrRAtqZuquMPQdKraOwFalS1F46nQeb/BJj8X/PuaIT5p9AcUVZk6V
         WusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+7Y/msCH4+WIghRoGpXzbcxGPWNGmLe0ipJxsgxzH0c=;
        b=h5JRoT8P8uk6h6vjmBmjdJX0YC5S/sooRd8b/Ml0Iwet7RXsedoBlhymRolVvFvsT3
         uchPmwLFRGREN5VT3+pUreDx2J+ANNkclhhbHu9bhGAsNm4InP2PllqUpHsN66S9dHrE
         hswNWoIr4lr1WwsxetSk3YS4SrCKvMq3XHoes4Rj8/btV5QWrKKf1QfnYq6JZ0dIzy5v
         wQI0Kp8TBWU00+nlXG3nlEY//wsM9DtqNck4mXD/sdIz0p7O6L7O9HULS0Mn3WgYXw8r
         NjZKG7s1PynDzlQzOosX5eayxi8EjCBptTRK0UGADVj1TbbhIKSOB8kL+BXBKnywzqOW
         Q2eg==
X-Gm-Message-State: AOAM532qbKcdy94lsyplOX6mS2oTBpw3zpZLR34dsF75CskhIP71AgyG
        8j/9+j/Z+tRqKeAFHziCUZoCbWkrcpIjmYQrBEgILu9Z4kzz1mfK
X-Google-Smtp-Source: ABdhPJwhIvpQPJU0jhFjtYDbwQfjWedcjmzLkpNKmNapc4l78Kd0rf1o0gNCa9JcWSI3heit12oXoMzGlD54vRL17SQ=
X-Received: by 2002:a17:907:94c6:: with SMTP id dn6mr15825189ejc.287.1628361230043;
 Sat, 07 Aug 2021 11:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210806081113.126861800@linuxfoundation.org>
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 8 Aug 2021 00:03:38 +0530
Message-ID: <CA+G9fYvNi5utM44pC6kJ5Ym2LCFHKi=pfSXXNHb3+ND=tOjy8Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/30] 5.10.57-rc1 review
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

On Fri, 6 Aug 2021 at 13:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.57-rc1.gz
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
* kernel: 5.10.57-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 2966d5d5122963b08200afc8de1d4f284cd6c31d
* git describe: v5.10.56-31-g2966d5d51229
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.56-31-g2966d5d51229

## No regressions (compared to v5.10.56)

## No fixes (compared to v5.10.56)

## Test result summary
total: 89683, pass: 71939, fail: 3437, skip: 12726, xfail: 1581

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
