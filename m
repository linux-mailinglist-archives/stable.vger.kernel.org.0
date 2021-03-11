Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21F7336DE7
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 09:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCKIgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 03:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhCKIgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 03:36:13 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4364BC061760
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 00:36:13 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z1so1468671edb.8
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 00:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4Kb+dTW+digtgGHqIiSy+mHizYzaFwzy9otWMHUyUlM=;
        b=boixaW8nzO94y5eRVcTgFyC2KkHBPOClBHKn32lpqCqFcdigTgIcpNwb5k+8D3ZanH
         /ARGWNPDPjz23rLhyW6jOCrHktpK+UDREN+55ITfIMvdmxe7h4p5zgXHCh2SfJcXCYeL
         R6249hIJuH0yLOUHWugIYC749PIYWjPuD9Dn+9ThIRfarn5hSZxku9ZwUYa9jAveXuV3
         3781mtSaIqmuVJOn67u8vvZfiZ3l6/3YwGksiT5VoYL7iGokrh+pvQhvOnmPM7O0/vHW
         j1mTrWGx2UlXj5nmXh2/P4llNs19RuCdaaPm7ISjACML96Q/diun53NVxQplFVjD4IGJ
         711w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4Kb+dTW+digtgGHqIiSy+mHizYzaFwzy9otWMHUyUlM=;
        b=gpOLFcZmJznAoroesq7qsbFK7DOqUiRc5hwAnpCisx7kPgm7rFTB2/aUy2eAkFFfDQ
         cBo34+Eh8vZhllbgzhTbFsSWX1tXRdWNQw8xEL/8rj23CW7qtpEnbGxjLBPZzesYdunE
         fSRADbpmMqY+AdkiSWUHZGrCAhMZoD0HqIFaYXqlchE3pluDE0GW/3Jhi3rw4UFQy6+J
         um4OQFTasC+JxpT7B0x/jkhpcq2vyAwHOY513f8sLcFfkTOAxGBRU6wuKkr2QAOlxVa4
         tXlIqByylVDoHHXkzPQWDpFGkvVuWEK3+Vk8a5o4xs84FK7FxNTVEKKduFOLmZSWWzTY
         1brA==
X-Gm-Message-State: AOAM531d3Fl82DEAvqwPks5vwlC8KsFmMVTjFblsG5JyOOErabnjjFsZ
        1obzBlhBAGGZuHbhrOoVqrJzuuYV7D/IszjtCCtyBg==
X-Google-Smtp-Source: ABdhPJzVFvmB+MSziQlhFPHCOltvhAIUsXPPjRZhAegnXWEJa+Y+pZNNomK6mHfFty1Orc/9wjKs8JZ5MTecqLlpBOo=
X-Received: by 2002:aa7:dd99:: with SMTP id g25mr7288797edv.230.1615451770809;
 Thu, 11 Mar 2021 00:36:10 -0800 (PST)
MIME-Version: 1.0
References: <20210310132320.393957501@linuxfoundation.org>
In-Reply-To: <20210310132320.393957501@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 11 Mar 2021 14:05:59 +0530
Message-ID: <CA+G9fYsg8Oo8AaAoyZ+B1XuCKCR0cnH-4somYOct36Of-GGQ9w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/11] 4.9.261-rc1 review
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

On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
>
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> This is the start of the stable review cycle for the 4.9.261 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.261-rc1.gz
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

kernel: 4.9.261-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 8bf14e5a6c5c131e93c7c423725d758b0a6f531a
git describe: v4.9.260-12-g8bf14e5a6c5c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.260-12-g8bf14e5a6c5c

No regressions (compared to build v4.9.260)

No fixes (compared to build v4.9.260)


Ran 41377 total tests in the following environments and test suites.

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
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-tracing-tests
* v4l2-compliance
* fwts
* ltp-cve-tests
* ltp-fs-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-sync
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
