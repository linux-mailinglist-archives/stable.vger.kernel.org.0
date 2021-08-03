Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7B3DF0E6
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 16:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbhHCO5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 10:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbhHCO5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 10:57:52 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BCCC061764
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 07:57:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nd39so36830487ejc.5
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 07:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0i2FRyXkHxaXq1271k6IK3L0yRy+wcd8z9KmUNA7o8I=;
        b=AllGqyH8UY0VArjOw9I0Gu4E7lLgYtQMQXjUMcYVbB67BHHuzLeHOrk9Jx5yXPyTO2
         RzR9+fkR+JVgHL+upcyPbl+D7poem4Ymr7y15RKrJJT0wl1zUbaJcIBrw+px/FkEeBhj
         6hmk4d/cmS9f1wGUrDxyHkgzoJbIVRjdYk53CC5M/C9k/BM4IV89nfG/8Rxpjux1BiXM
         40oVMS0l1QJdqO/lcBbo4KfhI3PP+fMbAQN+sg0tGz+U4cTyz60uxW3yHfz1yL95xofZ
         VdnFREu4539p7gJ/8xkzUN1F2joiGH4NomItuSGSezx82MpUnTgZDz++I9sSxbDFDI7F
         /T5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0i2FRyXkHxaXq1271k6IK3L0yRy+wcd8z9KmUNA7o8I=;
        b=QOJfEfSUG3FjhZJkGBUJu7s9L+PQpWU9XmoNliYEIbE/MdCxK0dBazp0Zj5FF5r7vo
         P72BQTRFwbJin0XY1TjTHrOKTnipj1m1uB+rMd+csydIWPrac/FzTKs5yIF0q9Sij16v
         q7EV9Quf6bAukqo1LZa5ApZ3FqyTI5wBIp1mRhB06GtgByXEJQxtre1tdeqFozldCCWu
         w9gN/ih56tak+VebWlZUbCjnVREGP8pJbhmI0DWv6ygx2SovyjjC4AXvW06t64OlXknm
         eVDAkA6RytPobKZ3yyU76mMQz2V6bi092F8+Rdgjb0Vbs9TXUoJuqRJifmpnErRHA1Iy
         6Jxw==
X-Gm-Message-State: AOAM530/Ds9QlzXsdpnkA+BjSlxxovqlqoCoNrY2A+ga6+N+a5NxzaHh
        EPeLdog1cRBYICCsx7daIyiIn3W/oMqDEcqxI8FKUQ==
X-Google-Smtp-Source: ABdhPJw+lGxKs/G9/BamrGUYo9cPXvPx6npvObc+Ou/dCxUfQW4kvGW6yv29rJA5UZ6PCrkNdotUAeMMBmlOqFeeGL4=
X-Received: by 2002:a17:906:8606:: with SMTP id o6mr21029379ejx.247.1628002659591;
 Tue, 03 Aug 2021 07:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210802134332.033552261@linuxfoundation.org>
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 3 Aug 2021 20:27:28 +0530
Message-ID: <CA+G9fYvv5vY_m-w=5L5h+U9mPDwAeiwudjJKQ2zGuaW+Lx9OAA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/26] 4.4.278-rc1 review
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

On Mon, 2 Aug 2021 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.278 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Aug 2021 13:43:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.278-rc1.gz
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
* kernel: 4.4.278-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 0de2c08236b37f04155d7a3dd65098f2a31fce22
* git describe: v4.4.277-27-g0de2c08236b3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
77-27-g0de2c08236b3

## No regressions (compared to v4.4.277-20-g46908ed929d6)

## No fixes (compared to v4.4.277-20-g46908ed929d6)


## Test result summary
 total: 45986, pass: 36044, fail: 377, skip: 8270, xfail: 1295,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 36 passed, 1 failed
* sparc: 10 total, 10 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

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
