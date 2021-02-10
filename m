Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C11315E8B
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 06:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhBJFF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 00:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhBJFFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 00:05:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C63AC06174A
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 21:04:41 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c6so1292147ede.0
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 21:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qWpoVrEkN2lzYJaj+bSGe7C9ZM4er71WTkqgbEtWRzw=;
        b=B/JOK9Vqs5MXVhSZkeYnkPSGG1tFb8s2cMjv9XbDrNwo9o9dNDkUk6K5rXb+P7t2dm
         Ob3c8zOT0odOek/wEm+s3K7wLqaD5b9yqVqWflaveG5uROxfiCYMQecOrwydWeXr+N//
         aWZXfIqNixfRDxIIC+BZUYmHrLqhlAt/dnjx9y+qCCMq//36hmmOborLP82tVMxXfWo2
         R+TzEYtik/2/CPNdQm9RKEXUkO8Q8zGOBiOHxxTDvORa9V7xIPeGTG0LE4sqJotOdQm7
         t3QhorFymVAnQiX7FQUqDi5TK0o///nQ4g1fkBkWiDztD6odsAyDZO+c+JDSmliajTS4
         lGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qWpoVrEkN2lzYJaj+bSGe7C9ZM4er71WTkqgbEtWRzw=;
        b=cU/D/4vULTKFx0Yapc2kFuJYUFUZ/f3YpzdirW+llmc/EdMt2llLYcphUP7kn/PyI2
         xeyhNcZgV0p8A1v50mN/unDDh/ows+QZvGuG6/Lyv8YLs2rrzIZCPW6i81km8kAfryjL
         z9+9/yoTjpRXPfY54sGtmIyidfVt0Ti9GFE078rzpmxKIeutajJZKc6pcYt2CiAy9Pwn
         7YB0jnd+N32PVhQRyON3hRpg2UZccHyIQpzCOCxV7qxRSzaNpD/txNUk79Duqn+3yl+F
         n3qdtqzykVjKslbGiNNuRUdwUFfFT1Ej/etukhHQnKl/Xrp5FEPrvXZGgnNEn/5CC9sz
         8Ohw==
X-Gm-Message-State: AOAM532cM2s2iaE5HiE119MFm3GGAE1nNcqiEQQf5hEXqU6MiocFfQuo
        2SCZXgPXKZPntLAVvyhg+F55MeCtL9MXgEI+Y0XzeA==
X-Google-Smtp-Source: ABdhPJxrwYEqvBimtJiSyz0eb+J9/fOeI8aYdvEGIOW48nT6x8wYabREMcKN4f4Ol38/t9W2fsIOi81tiFqpCYe5a+Q=
X-Received: by 2002:a05:6402:26c9:: with SMTP id x9mr1428484edd.365.1612933479827;
 Tue, 09 Feb 2021 21:04:39 -0800 (PST)
MIME-Version: 1.0
References: <20210208145805.279815326@linuxfoundation.org>
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Feb 2021 10:34:28 +0530
Message-ID: <CA+G9fYv+rOgpr=i=t0M3c1YcdJxw6GTXDHT+0KpMxuiP+XAWrA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/38] 4.4.257-rc1 review
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

On Mon, 8 Feb 2021 at 20:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.257 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.257-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.4.257-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 1a954f75c0ee3245a025a60f2a4cccd6722a1bb6
git describe: v4.4.256-39-g1a954f75c0ee
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.256-39-g1a954f75c0ee


No regressions (compared to build v4.4.256)

No fixes (compared to build v4.4.256)

Ran 31608 total tests in the following environments and test suites.

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

kernel: 4.4.257-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.257-rc1-hikey-20210208-927
git commit: 288b6b317ee80392b29cd493327d429385373359
git describe: 4.4.257-rc1-hikey-20210208-927
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.257-rc1-hikey-20210208-927/


No regressions (compared to build 4.4.256-rc1-hikey-20210205-921)


No fixes (compared to build 4.4.256-rc1-hikey-20210205-921)

Ran 1953 total tests in the following environments and test suites.

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
