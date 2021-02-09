Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF51031571E
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 20:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhBITqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 14:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbhBITil (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 14:38:41 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B471C061A31
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 11:37:19 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lg21so33757748ejb.3
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 11:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o3jYTiOHJZlHfoq5+7MSBsToqrkgCMv+obDe+1t3RuE=;
        b=ah+sPiHCRo9jFUGiRHcc6MlSUUEjL5fNdMzG17M1DHpuGGA3s1+eFZ7mghLA8F5wJ6
         QEBX4vN7HQWDmkc4KhTnMBEewLXXnzuEYm2ZBefDIvQPRoHb6B3hQ/1pJoNYL2IRF8my
         1YrB6xBQVdihAvcgMWGdLPMm8hKAzK/4tXvdrjVIL+vN1Tyg5GOXwdbbhGczQ6vN2Lmr
         TkM9zxLzDwrYjx2s8bVhKazV5+chVDN8fwdLRO1pLunEbSM9TDaoFLtmhM07nZuOhjj5
         En2DPS1Di7xn1J0iNE+a3avFHFuuRsUsdlFpIGZbbN7fbLAjfxvYXk9cxxc2X+axT+8P
         Ow0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o3jYTiOHJZlHfoq5+7MSBsToqrkgCMv+obDe+1t3RuE=;
        b=MT+bpCZ174OpsZ9d82U7HYSIW1srdDdt8YiTSqv9EHqqgm34R3zdYygh9OVJuZU+rW
         iCTV+0Bx4PX1c5VHQ/VK4kNnHTc5x4YPK57CL9MbaBkkvY6Xj3bLy3DXn9ioKmtB3jnk
         lPbi1mB4brMCB2uouJOZ0zZGYBEDrv9rTDFWdoVIZBu6ReRPAmTqgVndbdamydNJtYwM
         Lt/adibjGX8n+ZkjDPtAPLNGYPkYetA+ZN5LU3C4m+WikE47LEnzIU1qr7ZCEP9K6rAf
         RtPnbBcN/vDorbxVazmc5vzqR3GbSZXpDPj734aVyYc10NopF6ulRsGgqZra3EFBCrbz
         dLRA==
X-Gm-Message-State: AOAM5333g2XZappjkZcLxGXUTvBMLQJSHKyGW4cTEEvL82X7bbsTzwMi
        BomIazxffhoD18jHmJXvD4vswqT0n4Znqk+PWI0h1Q==
X-Google-Smtp-Source: ABdhPJw2PJt76E7qkl54G//GgcdZfOFHyO6FDhElskb438Yor31E7lvFIFCnCPc4bXHBfnIOLN9LXrLFfjxnXtEOub8=
X-Received: by 2002:a17:906:6943:: with SMTP id c3mr9585460ejs.133.1612899437958;
 Tue, 09 Feb 2021 11:37:17 -0800 (PST)
MIME-Version: 1.0
References: <20210208145806.281758651@linuxfoundation.org>
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Feb 2021 01:07:06 +0530
Message-ID: <CA+G9fYsDW5D+VBhw0BpBrF=5w7gyD2fi9Q9XucmPKqWOvdYXBQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/43] 4.9.257-rc1 review
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

On Mon, 8 Feb 2021 at 20:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.257 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.257-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.257-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-4.9.y
git commit: cffa06cb070f1ce0015e19c0f54b7a2b86ab4d24
git describe: v4.9.256-44-gcffa06cb070f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.256-44-gcffa06cb070f

No regressions (compared to build v4.9.255-14-gd4780bd0ccef)

No fixes (compared to build v4.9.255-14-gd4780bd0ccef)

Ran 39352 total tests in the following environments and test suites.

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
* kselftest-intel_pstate
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
* kselftest-sysctl
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
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
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* libhugetlbfs
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* kvm-unit-tests
* ltp-open-posix-tests
* kselftest-vm
* kselftest-kexec
* kselftest-x86

--
Linaro LKFT
https://lkft.linaro.org
