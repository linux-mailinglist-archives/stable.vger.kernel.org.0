Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88FD47320D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 17:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhLMQmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 11:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhLMQmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 11:42:36 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2059C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:42:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so54759894edd.3
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 08:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OoyZdpbqT5Z3wyU/USbcnWnYz2BKH2cz4anuEz8Evk8=;
        b=qA1zXgrSpvzhGXFG7CGJebwec0nxStKD07NruMf18N9Gs5PrmW6XU3+/YDnBMryAL0
         XX66k/V0ZfCdrcKnN1/MrbDmd/BahDYRifVwYP0JAto6LdDWIvEDoGKmgbJfBushys64
         c94GWhUCxnqxLlT2TDLVoKURhCv/1dxWVFbajiwnqcxNoeMiJpHZRzuIJN9V52M301kT
         uCWbQpBRWQSlTXIwI8Wa3RYODj2yGmUKpl8uhlx/zM6bP8Q1vaADDJrAfTJmUO7W7mae
         h4NITDawXF8SqcaRKrYMS8R6htQC0EJK84DW070GQw2vljwoZbeY60QuKIOcFhdhcvcT
         7KTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OoyZdpbqT5Z3wyU/USbcnWnYz2BKH2cz4anuEz8Evk8=;
        b=sCRzKDe6IueW0oy2aRTbpWhlWSYchNiR5itpDvrt9nMf7dyPDpdzR/NxeeAJQVLdGi
         brz/SkLpPr8vlcq1PL8VWdUVfZCE3K7S9AFJy/za2oU/tSKkA/wbABLmNUrodt8AhqjX
         IgLE6uE3/XP1XllJHGJ00eyy9iTCgMjoejW5Ea6ewQwI6kNC8JQaNcRWUtHpDGf6Ma7t
         odbhOrHVwPH5ER/f5IW1Pl4uhQq9H9a2VTACINFbBKUAvj4qPGyJUFfKbJNK6nkh8/pY
         YJmWy5ktYkc4x+BCC1Ikvw4qVp9tIyMa+OvegsranhggCnR9kfHO0FYY4OAz8omyg8k6
         Ig3w==
X-Gm-Message-State: AOAM5303Y92t8oFSYXDNdgalrximVKAyMVjkI5a5VA5n17PC9L9mE/6Z
        lIPsebF0vz826H5nzpKcnl12iv/KDcZVbUd7DN9aLQ==
X-Google-Smtp-Source: ABdhPJwI1xgtoGccXHW3zHjr023WnjqGMlH0Yrrzk9tlXXRKtz2dSqN/DzzTKheiiisqqIazsdEak+wAifzCNCcQ8ws=
X-Received: by 2002:a05:6402:4b:: with SMTP id f11mr2604824edu.267.1639413754237;
 Mon, 13 Dec 2021 08:42:34 -0800 (PST)
MIME-Version: 1.0
References: <20211213092945.091487407@linuxfoundation.org>
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Dec 2021 22:12:23 +0530
Message-ID: <CA+G9fYtW1USHtpgQ0x_iyRg1q2OKX5BXmoq96FuA0gqYnd=L8A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/171] 5.15.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Dec 2021 at 15:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.8 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 5eac0dfa371b154308861ff6fc0d6ae0ad568e56
* git describe: v5.15.7-172-g5eac0dfa371b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.7-172-g5eac0dfa371b

## No Test Regressions (compared to v5.15.7)

## No Test Fixes (compared to v5.15.7)

## Test result summary
total: 95983, pass: 81995, fail: 721, skip: 12474, xfail: 793

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 48 passed, 4 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
