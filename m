Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF86322A5C
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 13:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhBWMOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 07:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhBWMOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 07:14:52 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF7C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:14:11 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id do6so34233807ejc.3
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 04:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9PxU204J8WNczOF0rVGyc6kqlv6DnjF2PxeJeM6pI+8=;
        b=eAJ6OxAH76l5//dytdgCBpB25dRPIGsUOM8gQaFRfzveffPD4Ileqpf3PSmmIrGizW
         ESfT4UJQbqCCgE7eHKCipHsQM5+lgHIZmnv1gphZMQlsh5ZVOdOgnEOQkr/XNytG0b73
         6122500CHSaSN+A3Vbjs53wscGzH04oZz+Ul3qYmfwV2gabpj98M8TSUf6VeShiGXaiF
         Eh4EIEM+ouzKu3Yts6lRgjfsvl044A4e/AFewmNZqxIICG0T9v3JYwEDEFOqqahDu36T
         vT6uCLRS7mpXhdrubTMoPNdTa1gsEUywV0iiHv4GJtw0ZkEv4/TqhETfkjmm2uiawPJ/
         7BeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9PxU204J8WNczOF0rVGyc6kqlv6DnjF2PxeJeM6pI+8=;
        b=QFKnviamBRBOFGH8GnHxBAM8eGK85MFxn/2XSJZs8UItFreO7sez4Tsu+V5vnrSuA2
         L74NW6Di1bBZMkQbFm9LEFzEuajNGZApIbCI4EO24NYg5hLw1PrsISUuLMMFCaTWJArY
         4aGGzbu9h1MSJvwMVw8Dlwr/Ud03jne9iCmO3GwJfeWzbjfBrcsFsf0guy5duQhxqQJj
         sLcdDwH/DvjrdofwniWdnyOWOOgDtcjQ490gohbcgWQq1izW/+c6ESxcuo1ZqVpquGt6
         thUvkZm+r4QOLOHX3qhfW9ZwtBUgiG0pYvicOhojeTQq46arEvHgrKGBhUERqId+3svp
         4Ntg==
X-Gm-Message-State: AOAM530altGE7H310Bmyqz03RZWlv6xuc4sYbO6jfNHvRER/6Xa2EcFQ
        pJzBfWD+dCnVw9T9eB9FPvJUQnXJEx3v/kXS0Fh+OA==
X-Google-Smtp-Source: ABdhPJwUMQQiwaaHlG4F6+GWyI1ZJduQxPzgfUtzD8YODvjbfyBZUArDisZaH017hF6Vr5W7moVEjj2ti8umiPJGpHU=
X-Received: by 2002:a17:906:d8ca:: with SMTP id re10mr26047840ejb.18.1614082450491;
 Tue, 23 Feb 2021 04:14:10 -0800 (PST)
MIME-Version: 1.0
References: <20210222121013.581198717@linuxfoundation.org>
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 23 Feb 2021 17:43:59 +0530
Message-ID: <CA+G9fYtgPD8+F4LWK8h9=i8yU-mX+995j6k2H2fWkTff1TM9Qg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/35] 4.4.258-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 at 18:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.258 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.258-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.4.258-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 1a954f75c0ee3245a025a60f2a4cccd6722a1bb6
git describe: v4.4.256-39-g1a954f75c0ee
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.257-36-gd947b6dcd5fc/


No regressions (compared to build 4.4.257-rc1)

No fixes (compared to build 4.4.257-rc1)

Ran 31761 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
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
* libhugetlbfs
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
* v4l2-compliance
* kvm-unit-tests
* fwts
* ssuite

Summary
------------------------------------------------------------------------

kernel: 4.4.258-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.258-rc1-hikey-20210222-938
git commit: 13d50bac200ebd6562e303c2847856b75c283666
git describe: 4.4.257-rc1-hikey-20210208-927
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.258-rc1-hikey-20210222-938/


No regressions (compared to build 4.4.257-rc1-hikey-20210208-927)


No fixes (compared to build 4.4.257-rc1-hikey-20210208-927)

Ran 1897 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
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


--=20
Linaro LKFT
https://lkft.linaro.org
