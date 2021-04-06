Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99803354E02
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 09:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbhDFHlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 03:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbhDFHlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 03:41:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B81C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 00:41:00 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b7so20377112ejv.1
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 00:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nBGqA/M3Vak+IwmMaVk8X2rx3tclSvs0k42JLfwZRLQ=;
        b=sbbnKZrC6hqH4sUwwG1zvNw0iayCAdDT9eUOORudr3/kBmIbv2grL2S1CXxVclBU8j
         RAebTm6lNL3zmhDVGucU6sQ8Q9Q1PTG+wFoEruk2BQQNahOJHYfEQSoRjtWN7cje9z9G
         Yn3Bj46HSKZxuIQjnU7R6PZqv1c8276WE5G4zFA/Y9XLgnUKJMVyImL9n0MVkPFpa3Zp
         GId30KBAHc5Vp7RQxrnaWKgh0zZ0cjtJPKh4CnU0RPfBMAKQ8d8E7UHotE9JIjd9wMTY
         N0nE3gNOhExOpOHxEJ9aEmaNX7gCUZ2XLZ1dbU37T7PBRXBRAyqHKer783J1zHEvCEil
         9K/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nBGqA/M3Vak+IwmMaVk8X2rx3tclSvs0k42JLfwZRLQ=;
        b=kJA+3TS4UCPPDuebqqmDfgbddSjAoXwEQuJwDplL95pXOrcumDzVfzvslDLJMdbeoq
         9VgoMG9KkIHA098r1WYuFoqQJgVPL/74HhJKBY+A6rPSFQbhuceX7zkI17lvHl9D3mLW
         JE1y0d9M/pqj6AyWG7/R/1zVJywI96Wl45mDekFGonjysvmS+5y0JcU5D35eBpe9BKks
         3H9mFaoWDTNkkqLO/NY8ZJMzw9P3i9R2keTuddpUarZb3wJWOwTqHjk8gXNq6dGDVQXC
         D8Omd0Ozoh86Oy8Ca2xFQFruH1xAVdPalYnJzGatl1P+6cvSnJJgq2n2TSY/UTx+oVQn
         Xc8Q==
X-Gm-Message-State: AOAM531pjcKRpSlGWaaYbsVJR0J9Mzo52Kion+OG7qQvnQkbRi/oCpXX
        KU+tRA7Bc5K4JwFG4JVW8ox55u+dY0sH/4M/0c59SOUREOG3rZVl
X-Google-Smtp-Source: ABdhPJxpho/8WLwFhf/GE31J5akOJMd4S3Jm/MuEgDlLzmlpjvX9lhA1LKSKPpidGaSYdx5TgSrdDRADJOB4HJARYRY=
X-Received: by 2002:a17:907:2509:: with SMTP id y9mr20075309ejl.170.1617694858892;
 Tue, 06 Apr 2021 00:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085018.871387942@linuxfoundation.org>
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Apr 2021 13:10:47 +0530
Message-ID: <CA+G9fYtN+Njtss0zP4S2Jpy+b6w6YS3vw8D4M1MC0JY7x+jm7A@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Apr 2021 at 14:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.265 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.265-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.265-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.9.y
* git commit: 570fbad9f4ca61dfb49359b9c2627a97e41e2b4b
* git describe: v4.9.264-36-g570fbad9f4ca
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
64-36-g570fbad9f4ca

## No regressions (compared to v4.9.264-25-gea8146018e96)

## No fixes (compared to v4.9.264-25-gea8146018e96)

## Test result summary
 total: 58777, pass: 48253, fail: 593, skip: 9676, xfail: 255,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
