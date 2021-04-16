Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57959361D62
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbhDPJuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhDPJuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 05:50:21 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8755C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:49:56 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id e14so41206627ejz.11
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b9xcU+bHCH6H4Mu7XMxMJgfJPmJdYS6JjfdFloan2eY=;
        b=O7b7afvKsVytUgchxcoZQTWt5+DMHs6JcMkOXtU+LYfcENx1T8fCtUONi2MfvEtXqN
         2aXgrO1LizMJL1MB+nkhUL0QpvLmUfrmznUFysVax+BV/kgoreq/liyXA168y8ec+S/R
         170HVnAnz3uEciN/N8fvbWIVPWIjZoKSMYzLvX+2Tg9WxtD+YGnybXE0TXdEx231QIGj
         jdQeLSMo9fx6GrpQK2Zuwvb2uU1laGstMLzGHSX2WmedtKY8eDrkTAizxrFEyA31voB0
         VMZPC7MhMUPV6x46vDMkhy+E90lbdEgl/7FNX2v5p+dg5GsAJhlc/CeRq9IDPTiaaEwP
         1uYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b9xcU+bHCH6H4Mu7XMxMJgfJPmJdYS6JjfdFloan2eY=;
        b=pgVVowdRIMi7eHF9aZzMB8IK9hNV5+hhy9UQ4JQHAs/6MjLL7pOo/67E3X32cyEYKb
         JjE6OC1D58q/QMCK29kA8Rf1gQHfcv47zV/zIpQLPC/EHYHJSTwzlCmhmL59zT5YTdHe
         u3S1t6NjwRdDOJDI6QpEUptmyey9kaRrXyCm0qbjsKzyG8wS7fq3jySqitwIxCaznu9N
         l9+SFHW3859HdVFe0RhctNo3Enj9dfGy7KQ00dQ8U91uGq9QU8sLJ5lHvKodP/aETAPr
         QMT3wyrppBIv6FpQya3fwFQK4Fr7FwlsFd9+c8PW3Un9jImhjlaqy8sAeNZjEAnf7mDs
         KITg==
X-Gm-Message-State: AOAM533gjV4udE2kk0ReZAjTtSJdJyJ2wIkjdR2AGbuuS+wi9iZninLS
        P7/f427+/q8TXhkFSm/obFKS7ex+LZ1GfOulNtKMttf6vLcF3eLe
X-Google-Smtp-Source: ABdhPJy28vY9jrv2LfPhq7lFPJ0hGDvDfyDSRrWKFrpmwW6obPj14vaOnkH3hlUEw05sJ8JBByIuoqO1kwRO3vDFQmY=
X-Received: by 2002:a17:906:f155:: with SMTP id gw21mr7431696ejb.170.1618566595315;
 Fri, 16 Apr 2021 02:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144411.596695196@linuxfoundation.org>
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 16 Apr 2021 15:19:43 +0530
Message-ID: <CA+G9fYu4r1+UUh-Lm6RH_9tL6xkQvOUNYEONXAYG888TnsWZng@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/13] 4.19.188-rc1 review
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

On Thu, 15 Apr 2021 at 20:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.188 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.188-rc1.gz
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
* kernel: 4.19.188-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 9f5de887b160253cf03d6ae91e72ba7dbd4a2317
* git describe: v4.19.187-14-g9f5de887b160
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.187-14-g9f5de887b160

## No regressions (compared to v4.19.187)

## No fixes (compared to v4.19.187)

## Test result summary
 total: 71166, pass: 57695, fail: 1809, skip: 11392, xfail: 270,

## Build Summary
* arm: 97 total, 96 passed, 1 failed
* arm64: 25 total, 24 passed, 1 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 13 passed, 1 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 14 passed, 1 failed

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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
