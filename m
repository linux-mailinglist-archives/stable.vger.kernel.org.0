Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E503E3905
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 07:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhHHFZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 01:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhHHFZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 01:25:21 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E3CC061760
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 22:25:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id qk33so22925019ejc.12
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 22:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k/8s96HCe18/eoglPW9pZsmNfYl8igMHuGmdNpfUBaE=;
        b=sikGcX4llhELl7jgeuNaD7/h98+zDpua/NMk6ZqqEkmgDLfjds8yX9LtEsXTpkrMnm
         oyKglZLOppQMsMaRo/UsP9roBbPTi40fyyLMnXWgbLb1nFzWeEyVcNUt506i6Ia5O2ne
         y2/i0zA2c4wMPDQ1UZ5OLRXP50QkICm60z0n0ofRCrJpa3Dr9Q0u5Czh7oafOBF/17j6
         wp8dKfIi6fjNEvTqauwLQA83n5TNxnNzhUe94me7yVbQqE1JYNZ1ST6at9rYe8Ugk+u7
         2gpC5pJFXs4KOMVw1fgzRiCDF9TLimzlylT3yGWHtW3myhYeCAWHRbaLgZ0tP5/bhWRS
         Cohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k/8s96HCe18/eoglPW9pZsmNfYl8igMHuGmdNpfUBaE=;
        b=Ot9V9m+nlQL8gzJNTqq9IR4VLpDNRRsrhKTev+YyI+32RaKn5Tm41VV0RRtGtyhEr7
         zvfy6CLfm2nWvX/7WXlPKSNruIADsM7EbQZAReCn2R1Ph15j6jDALNM6dZ93HZoTf1zu
         2Y8vQH9o7lYCqQXCFIwvP1s/G7vj/w3CtksIZE580DbjnzPX5Q+Zr+11h8SER6vOV+60
         M8SoQ1D36Cf/oal1tEGtT7Tfk0WDizJsjqMZbPwuFdtyv0jahYEA8fjk67e725uvsRxU
         /31SrhYnqNEfXuJms6AjhbpurF9LRolqy5ESJuIQbm7M5Pe/l35TTpBx04h8VPfQz1ay
         PO3g==
X-Gm-Message-State: AOAM533yNlRksq3ohJURYifp9EEUMjrg9pvPmGRB0ESLHf+Tlm4LFfcl
        82bgnTpwyF+4diqiN00PPndOJKKeKqA7TojgFyJm7A==
X-Google-Smtp-Source: ABdhPJxrauaZsx+2t9Y5fusw1eBRDsCLJMQqsd5lAdSWqTMwr2voeLiTRroRTG1YhCIjchMZ+XMKWfK/zU6sYwLvqOI=
X-Received: by 2002:a17:906:45b:: with SMTP id e27mr16783768eja.375.1628400301558;
 Sat, 07 Aug 2021 22:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210806081108.939164003@linuxfoundation.org>
In-Reply-To: <20210806081108.939164003@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 8 Aug 2021 10:54:50 +0530
Message-ID: <CA+G9fYt=6NUXw+x4YbRE6a83OJWjzugG-=F4F0OHi=ZyYX1UeQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 0/6] 4.4.279-rc1 review
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

On Fri, 6 Aug 2021 at 13:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.279 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.279-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.279-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 155338eca25e98640866913820fbb3c0d3efed49
* git describe: v4.4.278-7-g155338eca25e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
78-7-g155338eca25e

## Regressions (compared to v4.4.278)

## Fixes (compared to v4.4.278)


## Test result summary
total: 44119, pass: 34594, fail: 366, skip: 7880, xfail: 1279

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
