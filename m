Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D948C38FBD9
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 09:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhEYHhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 03:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhEYHhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 03:37:36 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20800C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 00:36:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id c20so45800180ejm.3
        for <stable@vger.kernel.org>; Tue, 25 May 2021 00:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DZ0gVFOCapFg4ql/70XQ0MbubUyTUGLf7gE1a6/6hXs=;
        b=HXZ5AvHdk4dI2xAP0zoX1gJA0v7SmtOY0ltpgkmr7S3Z1U31EM1mVQ224Ap7n+k4tC
         Dvi4uW5awtwvJ2BNjBP3FNWURvXohTYOwH69wG0LO0kuXqCPvYPRMB7S+aosKrfxVY2f
         XPXZi94pw092eGn2UUGZBh85yoBck0wVW9kAh85UkNGpbspzTBK3Gd+ouSoOP4sJt7xz
         8uC3d1K6IQ675ynVJ9zLhBRgD5yIXfzyVlKUSAIIYI35oHhbuDT1mbk2pKIPAepWujJN
         Ous1ud14UgbWvVKLOPwTAS+FZk+3nP/rhbfR2KP8r1fCVNEGj3+rRgXc+YpWViJDI19M
         g6uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DZ0gVFOCapFg4ql/70XQ0MbubUyTUGLf7gE1a6/6hXs=;
        b=bLuhpyXBhZJc209cK/4s0MPcl6HeuLyNYSs6+jNbxZ/INX3F26rT36VicFQwd5yYzX
         TuskLgOYIWXfRwa9LI7wJZGorya0KmA8Lm/qPRiPdv9J5Kax47tgB3g/5wYjuKd56WDq
         BCfJi9VXXezls/L7Rokaps35m8TCaDq60C2S7zsswlW3ETJfToCK9Zbiqyv0Rj2/FxMd
         mpYcUWQydsVXj+FV1sLbGzoMguvPkA5yK2KRDfw4FDIxdkPNv/IHehYHze3QReNNNR0d
         tYyT3Ymh/01JhlHWZSi/97bAR80zzWEEHdn5WMYdcry2Z21drwOoOqM05tT4qgwcL1b6
         7Pdw==
X-Gm-Message-State: AOAM532pizs2QGa87nNVpxmeecAVGzwOUnMQhkLoq2WOderXACANxvEk
        hooc9pwJi8TfuBccetiSutPqHVeNu2UuJUvnRoXGHg==
X-Google-Smtp-Source: ABdhPJzC+k6r2lR1J0m/1+xV8JfujkOyI217PHPwAYNJ6kAh2lZLF68UiY2EhdfiPwg1+UqleGdxmZU9A6N08W3x5Fw=
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr27318766ejj.18.1621928165624;
 Tue, 25 May 2021 00:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210524152326.447759938@linuxfoundation.org>
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 May 2021 13:05:54 +0530
Message-ID: <CA+G9fYtrFLpEw1tAByr2vUOjtJbkR+6vA5O1jYJj_trufpcByQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/71] 5.4.122-rc1 review
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
> This is the start of the stable review cycle for the 5.4.122 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.122-rc1.gz
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
* kernel: 5.4.122-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: ee309f4d11991b6f668fee11d74ed92c3a988f6e
* git describe: v5.4.121-72-gee309f4d1199
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
21-72-gee309f4d1199

## No regressions (compared to v5.4.120-38-gd1968aee6ca9)

## No fixes (compared to v5.4.120-38-gd1968aee6ca9)

## Test result summary
 total: 73972, pass: 60259, fail: 1356, skip: 11662, xfail: 695,

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
