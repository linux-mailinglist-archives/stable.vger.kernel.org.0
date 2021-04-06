Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357E3354E24
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 09:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhDFHsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 03:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhDFHsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 03:48:50 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D5BC061756
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 00:48:40 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r22so2848744edq.9
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 00:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2oQGEFkW3lPUirXohU2zbEuk0gCJ76AYXVbbRyvCBLI=;
        b=cacPy+p9zw2j/+LNgB4wqihqzpZ1soO6cIhj+qoDgVv/RBIZxqe2Q4jxCShLg8AWwl
         2APOIwLjU75e1Sjx6sDCZomCRq8QhpNu52nTbiRmAoqqBceR/IXVRTEM7zAj9gRgOP+0
         JKpqp0a+uKuuuATp4pR7ksGbyzjC5gF6FSM39W7CpcBH6VfvaXz3Mi2dBhwF2B6IImzF
         eMmiKEQ5tcgiRsJBB6Wh98MwzWsMWVze1OK8ENWsSN2mDUhWxXlQXK43HuMKWXWO2RSk
         R/7LiZWigGVj6uUQAy8Dg240j/u4KqIJQr2Q0zPeQaOioCPBAr9Kv1E0LtZwNAoCxo9c
         gdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2oQGEFkW3lPUirXohU2zbEuk0gCJ76AYXVbbRyvCBLI=;
        b=hbH/t+KkgE3GpFkebNpKtvA8jvE9n6M5laubkEM7ZEjwSWsZOjNJNbP/wbOX00n4Nj
         lbHOxb6QdpqXpVp6DqLsYlDstmx6lfkV5USpX1WqY4sMFm3H4Ehbbrq3OzwqLqmvoxAh
         4V42Fha1xhO7dM6j+p7IH4On68kbd8ICaDHotPOReTzd0rzIJFNwg5EG5asgahKdcvh/
         XYdeiHy5VOuIciq4XHuh/GkatUGQLkZQqq7aIVX9kGlNPDMiW6N/ZCW8v3DRa68CHMHf
         UcvzvSeLgIst96oIu7u+wvuTy9JPN3+fdySIKBvIwkj3lqmMjM/Sx9BinlQ9uEdShR/b
         Kjfg==
X-Gm-Message-State: AOAM533z7RTu0PLttKewQ2csBQzUyIR+bplcWsmBpF2cr4VLV+U+vrl7
        fhTGD9l9qdSkzANqmu8si4OzgMA80niqAt/JRTh7yQ==
X-Google-Smtp-Source: ABdhPJyVl/Zy8uyNY6ctCkZLIOzngxRSPCFgSUhH8RWWMH5hLbrimh78AOksICc3ilDgvO2yruG2oPyKDFP3vtDaF+c=
X-Received: by 2002:a50:c3c2:: with SMTP id i2mr22333819edf.23.1617695318917;
 Tue, 06 Apr 2021 00:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085017.012074144@linuxfoundation.org>
In-Reply-To: <20210405085017.012074144@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Apr 2021 13:18:27 +0530
Message-ID: <CA+G9fYtDnYFoRFOnMbhUgydcWXXa_6xFsx_Au7fF3em4=Bkg4A@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/28] 4.4.265-rc1 review
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

On Mon, 5 Apr 2021 at 14:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.265 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.265-rc1.gz
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
* kernel: 4.4.265-rc1
* git: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
* git branch: linux-4.4.y
* git commit: 5bb7d387c8f89b4d3ff46f3e0ee3f0f00d026bde
* git describe: v4.4.264-29-g5bb7d387c8f8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
64-29-g5bb7d387c8f8

## No regressions (compared to v4.4.264-21-g8b29c729d1d8)

## Fixes (compared to v4.4.264-21-g8b29c729d1d8)
No fixes found.

## Test result summary
 total: 44184, pass: 35929, fail: 472, skip: 7578, xfail: 205,

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
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
