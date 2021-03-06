Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C710132F956
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 11:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCFKQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 05:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhCFKQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 05:16:53 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0D9C06175F
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 02:16:52 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l12so6476913edt.3
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 02:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vpCJk3kxAUD6YVwGA0kurvyADNZxkbrLcK6rA9kmJXo=;
        b=GufDzOldv4hGX1K5K7vfm9QTSFRsIBXM+/q7zZDHczVeZlJJlwWSzCpDInTQXIhmiF
         P2hEFzrb9qQglczOLrDq85Z+SF50I9oIQFgCFa30ekWKn8exj8wJuwLbYvqGcQnaYRxq
         E0+WBYPRb3dV4Xh3mhcZ8lakuAoKWcw3b23KH8w7/vqPEVzQcKfeoFtQgEY75gIrBjdX
         tjpqe/H+NEEBNs++tz0DWtO8fyK10/HOqigFDHvJT8ZtnSy7wBBMtNQ4hsrfZJR7BJn4
         gs5KdGYcehjzcs+z72i2wtIcG0kR59h/Q5EJIXWThi4WpePpLIrzAN6lO+xo15/+YUTi
         gnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vpCJk3kxAUD6YVwGA0kurvyADNZxkbrLcK6rA9kmJXo=;
        b=LJ2jr8keplduCdPWOaT7j39gC4MPtJpHbdye/+ulxpWzQrRy0kDTmXHXgDxk0yo9o8
         7ks/cZsALPTcGh5TyTakBtM4+7gWSZbBrapIHddNHkKl+EJJeJ1tHOyxHwePLYtMOy7C
         pJKum4nPCZTb5Vwgp2Z7k7cXQSRgXK58frX1jl3LayRMPsZPEkBbTr4z+ooYRv8cxcGb
         KwGBKppNlK8MkmPLFzHscpToCbycMemVYs+BsILHfNQrUMVElPMLg1K4I48W2SRovABV
         LzOU6aMP65+9wPpN2rVyH5vSkWoKldLvBZkHuv0Bv7h1L+uBGRcWRNhrhfQUcYqLFFW7
         HewQ==
X-Gm-Message-State: AOAM5324B2VXTeloa3Fu7M728O3cUk9ZYxh8JqEx0uO7x0UuDmu242f/
        qrTpzc2nMh7W1xI15TIH1ZcrBkC+qaAsaJb07TX+6g==
X-Google-Smtp-Source: ABdhPJzVZrIIt1UjSDK1oGZowS0tBuWMTmzUW7gHV8FAOSzVIM6LDX0gO3qjd6DetjqVEVE9u4MppSEkD9uqkAnKd5M=
X-Received: by 2002:aa7:d287:: with SMTP id w7mr2701579edq.23.1615025811350;
 Sat, 06 Mar 2021 02:16:51 -0800 (PST)
MIME-Version: 1.0
References: <20210305120851.751937389@linuxfoundation.org>
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 6 Mar 2021 15:46:39 +0530
Message-ID: <CA+G9fYtsUsbvNBCvNLU5oXmw2+e08cUqrm=CAw_qtzx_DtKhsw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/39] 4.14.224-rc1 review
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

On Fri, 5 Mar 2021 at 18:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.224 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.224-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.14.224-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 31fdc1da4f570e606123fad56182d8e3d5e8049e
git describe: v4.14.223-40-g31fdc1da4f57
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.223-40-g31fdc1da4f57

No regressions (compared to build v4.14.223)

No fixes (compared to build v4.14.223)

Ran 43847 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-livepatch
* kselftest-ptrace
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* fwts
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* kselftest-bpf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* kselftest-vm
* kselftest-x86
* ltp-fs-tests
* ltp-open-posix-tests
* rcutorture
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
