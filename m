Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8479737505E
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 09:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhEFHsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 03:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbhEFHr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 03:47:59 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443AC061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 00:47:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id m12so6873914eja.2
        for <stable@vger.kernel.org>; Thu, 06 May 2021 00:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ouTCmWFpKTDg5oT/XmF36k/Rr3gENRlT/LMcL8SykNo=;
        b=N3iPImlzvbiZ5dMkmaoyqcz69E+X1DJ0tpyEVJb0dTpDPOxU6Kw1ibv3LfE4wkMAEp
         uoqo/fEk5QGB63iROU8XoSj/J/6oqUGlEcW09H0rF+seckLYLzGUtY3eHU27zb/dZhbL
         U8D+Ww1n3Rti7vDTOBQ2HEgi3E1uSsp67TtnGyKQhkLsKQRHtsEag7U68QpfLbA5HeX5
         B3MeOv4pqZv9XKeTcX1lVgh8LtPRXe8IwRgVrjEvCdu1LZSV6UKRU4jTxhkg4UeItt4R
         91XSCDQbCWstvB0ojWKgVTVCtHC6NidNg4wzgaZBHHmNKCF6ceM8cpBdE+UYtxGwRspg
         bKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ouTCmWFpKTDg5oT/XmF36k/Rr3gENRlT/LMcL8SykNo=;
        b=bQxT6yhQOcosrbqZ6xF2/9lJRkK/zYQARHDzDG4Y0yjWVh0CIJaraOin7uXUFPpCGm
         Chn2/8p7NRBu462JrOSDIr+q5K2+9EDukqQNm3+xenmVZlJxoN2M9A7saIDAzh/+rMbN
         zqf8kxe0g4aSc8BtCDXTjNrTay1tlRoHbBQt6EDkp4Si++fv1wn4vm8M8nEAiXzf1dNg
         wkY3X9qwtEw/9CnMYpHewVgL+za0QZ9C0vkvF4bwUYE7XrAmBqIURNHKyQdZrZuVz1u6
         jojlA9fS2vHfinAkLjsvxXTqqm7TUR+F86ge50v2x7Z5E5pDVyg89jWx8vq7dmz6WSLJ
         D1GQ==
X-Gm-Message-State: AOAM532fQ998lPnWxj1EKfcj/Cvnu15VuefHGZ2p+HT42qp1GHlb9fsn
        9LcFCONzYHdDE3KCCeJW6fABmUkzwcEkqxvlbW7i7g==
X-Google-Smtp-Source: ABdhPJx1KiJ65Bx8Buxnj46ldfs+vff1TRQPCh+N5FQoEVbjHtE8YrK1kWMW4yQ8IeftoQiQJojc0xFagm9vEdUTedk=
X-Received: by 2002:a17:906:85da:: with SMTP id i26mr2986106ejy.287.1620287219373;
 Thu, 06 May 2021 00:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210505112326.195493232@linuxfoundation.org>
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 May 2021 13:16:47 +0530
Message-ID: <CA+G9fYurME_qyOTEbZneX_+nX8bVQsJWFyZq8qE=LS8AQ3JBCg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
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

On Wed, 5 May 2021 at 17:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.35-rc1.gz
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
* kernel: 5.10.35-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 5f894e4a8758db7af6eeb43311c0e9314871b031
* git describe: v5.10.34-30-g5f894e4a8758
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.34-30-g5f894e4a8758

## No regressions (compared to v5.10.34-8-g14447ec121b3)

## No fixes (compared to v5.10.34-8-g14447ec121b3)


## Test result summary
 total: 75625, pass: 61937, fail: 2558, skip: 10882, xfail: 248,

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
