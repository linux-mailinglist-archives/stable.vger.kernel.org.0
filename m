Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FFE3A7B35
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 11:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFOJz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 05:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhFOJz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 05:55:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A738C061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 02:53:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d7so2194397edx.0
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 02:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cKwXaFtfo1UcndItOAOi1vW/fkZDQUem/gNCLtwtsrQ=;
        b=HpbAw9eUZ6Qv6wa7ZD7R4SdYLj9Yr3rica9QeHWCo+5tIEHsbujAi1x0XMD1XmjTWe
         U5SbdGkqtWhViZdKeZ7lSDQkk8wj5sjy5k56++U2GmRCXBqMMGo4Ke92V3Ltn8MKMnJ5
         U+53xSgLmV2O/Mbiox2w9/pxxmgGa3+MwcjVBSDAqB8tDx1sJuJh/0GB3BbConxxnhzX
         KDPUrcMVk6m1mmwUTWdl4sazWlJwVxwQ62wwu6vDOnnSCLGRP8XN381T1PfgQ4ODwGLP
         ysXV3NI8uZO2oR+35BjS9ZNupwmW6Fhw1UXNwfmH+xid4uXM5DzjOd92D7VW+lb6G5cN
         XYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cKwXaFtfo1UcndItOAOi1vW/fkZDQUem/gNCLtwtsrQ=;
        b=IHoNShFKrCA2b16FdKoOJ5Xgqiay0IVHrGs/903SE+P2OX7dRZcoe7gBJR47M+LFYI
         fTapvT7BNNQ/eprlt80JYzy3sjuAJFVrbXEwjZRoZ3pQggkLK6kxnIg91Kzi4ojFWRse
         SEtCvefkBFwjMohwPOaUn87UdN5uaDosHyiYYVHO+8bmx8tGAmr5IPaCompnjy7/eMfy
         y2hyXniC7sEAJW6xF9V1/GV2Fhc1usFOOISVXIz4vKqvysTAknnRQ3c8gg6CzBfVYkG9
         mwrBAOTg2eK0WEXYQBrRsAnFU+H8067TZyXuScH/ZRb3hHHbW9ogiJPtHkuJsvHGH/CM
         VG5w==
X-Gm-Message-State: AOAM5336HQ9vmspD/WHaoFpu2uZTOqs8z1YIaZEn5N0PzSS7WYq3vwSG
        Dflp1+R5LsWxTO77b578pzbazwN6Z4q+PHSpVbOo3A==
X-Google-Smtp-Source: ABdhPJw6YQBcNVxGgVHj23SWAafFXKwbSIb/up7LwXKYz4QsYGUNK/idanshb0AVNzFOE7TqSm7XGfbzQ0b6lOa/r8c=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr22539336eds.78.1623750799553;
 Tue, 15 Jun 2021 02:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210614102641.857724541@linuxfoundation.org>
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 15:23:08 +0530
Message-ID: <CA+G9fYtGkjbFvr1Ln-o0jFSTA=C5A25n-+KbPmrQa+Dij2ctig@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/49] 4.14.237-rc1 review
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

On Mon, 14 Jun 2021 at 16:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.237 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.237-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.237-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 2e03cf25d5d0197592eed1d477a1dca0ab898e16
* git describe: v4.14.236-50-g2e03cf25d5d0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.236-50-g2e03cf25d5d0

## No regressions (compared to v4.14.236-40-gcd5358beb134)

## No fixes (compared to v4.14.236-40-gcd5358beb134)

## Test result summary
 total: 60640, pass: 47894, fail: 1240, skip: 10366, xfail: 1140,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

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
