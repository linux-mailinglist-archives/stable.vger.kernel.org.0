Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098D73900F5
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhEYM2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 08:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhEYM2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 08:28:35 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7CCC061756
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:27:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id f18so16855006ejq.10
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EPzlrwdG7/FLGCXscET2rkqV/EskOC6vwMfINLWX74s=;
        b=qsQK0/ZYFcFNoPBsREQspcwVO/KTL0rkK6dz9sWeHRyZIH7Qp177LWPV5Y87gLFGpF
         iS+7jf/1p7egYVCbmXuvrZ9cScph2VU6sdJMKCvuKHKA9d1zt3wF3kytH85DWEWNTUNy
         fisbEVWmwblT2ZT5gkWRB7LxOz6QNtieK74VI4B7N9dwmXL+WJLoRCI+9hjlO0/Ivgw/
         g/COHXalZld2Vjf+nXeg0l2X2YJSgaFw9THADwgRnuev8GjnOKsn4S5CpprRPPbg1bXy
         0i6Q6iDldlN1xlFW23Qf93CrLa51pOGtQeazQaXBn575wXFx5S0PvHUbhysqMdQdbzdN
         lTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EPzlrwdG7/FLGCXscET2rkqV/EskOC6vwMfINLWX74s=;
        b=bqNcf4kCmnsQ4BXAepobOeYkS9tX4QiM3h3Y7hd0OnjA+CrXQnuSp6W3FTtFrCoRRC
         Vna/34pWJwkOBYvC0jn+uzAfUqkIqYuMNmgTmO5wHoX5AWNaKlKuANaxzWiHNc8rqnCk
         hFpCJAk0Q1LHrjHM8saHrI0AbofYV6aIliIuGHaUARFd5eZOSCrOEtx1yfzmOiO/9bHt
         2odJu9+LVNREc+9+f5WNF+nEP8ZywA/mpNsQGmebQOyNELFJu4sU7mnqyWcL4+H2VmxK
         0lQ3jc654vYSMWZbpBkIpK88vd1ikJQVVb1rGK88o0BOzxWGZ5AztRXVGa32392yW2zo
         vpBQ==
X-Gm-Message-State: AOAM532V5ILrMmo5JpnfIHg9S72kb/ArO/tXNWnhJjCBnM4pcyFXNKlj
        +0Zr9mGlP8Py9TM7IXuvPIPpEeYYhLOd2VIoDLtYJg==
X-Google-Smtp-Source: ABdhPJwhPM9jyQntElXDKbtOL5AOaowYPJKiFR+Ui+BRswD93qZ/Shmgf6NkBqlrl5AouW/pkbQOpw9pCdlfSHh4d1c=
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr28367502ejj.18.1621945624461;
 Tue, 25 May 2021 05:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210524152324.158146731@linuxfoundation.org>
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 May 2021 17:56:52 +0530
Message-ID: <CA+G9fYs5-zpEO5VdDquAtP4n6irKVz2782iicx0tVKAK_gExvw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/36] 4.9.270-rc1 review
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

On Mon, 24 May 2021 at 21:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.270 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.270-rc1.gz
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
* kernel: 4.9.270-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: c1efed5276d233a93736fd701ad502ce298890cd
* git describe: v4.9.269-37-gc1efed5276d2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
69-37-gc1efed5276d2

## No regressions (compared to v4.9.268-241-g8622fef5eee9)

## No fixes (compared to v4.9.268-241-g8622fef5eee9)

## Test result summary
 total: 59911, pass: 47886, fail: 1284, skip: 9944, xfail: 797,

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
