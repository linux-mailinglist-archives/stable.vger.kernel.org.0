Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED13EC26F
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 13:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbhHNLnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 07:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbhHNLnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 07:43:07 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF217C061764
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 04:42:39 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w6so19861990oiv.11
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 04:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zaWVzUVRZLO5WqJOhIBxl6lzKnrs6pInA5khtUM4nz8=;
        b=W91Gz+D1mgjivBESDaqiomEy7/BQxI9eOClbJE6yIs6Fj+stBevheM9MK4LlOepTjt
         DuaIDMCrmuUQbt/nLkB+vsycFKv3M6lM6sRtRfPRx+ZEdF+Gh8+d66kCM0Pdty2Zmenf
         oJ5+MOp7xfDQZrk7NWk48KPIXR8mO00e4ktWu6FGn4vuvi8u8Vp4QKN6lViOIkZDkJG4
         So+lK/X9uR5L9KVZeX2zE5/06dTgBQIhkmUWYrfX/sez0K14NivPcC7JSjGrlbBl/xaD
         xnVcJtqn8+b/uSpG9VoZ7Ymok1+eSRlxAlIldGXQwOZvzg0qF3BIv5K2/SUG5mHp2ASz
         TTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zaWVzUVRZLO5WqJOhIBxl6lzKnrs6pInA5khtUM4nz8=;
        b=V+oZvW/xs/7gWyquqcNXj9r2TApWYvNb+UWXFx6gfaS+UOz5yJ3tDPVQXin0zXoJtg
         kbndCO1Ip0OVEliy3P++JeAJKCpzAE4fX8ARkRiiL4J5pC/L/y4Qde0zhaQ3AhPHe7Se
         e2HJMQbZR/TohbeYdAKWV6RaoNAIHe0feQ7Dg9aJ6pTu2+1LI2Fyfvf9NfqC1rOwp8DK
         iegndZgDf8TjumghLJ9z6v3f+ESLERJyS+mpkk5pcm9iwCT6cP9N36GXvNV+lFKA4iCf
         l3Mw/FTAlYR0oXh1yHJifZn6/Hmc2pdrJR4XuFk1GeAPqgaaa83DN8FtszT/HY9jxRrN
         B1nw==
X-Gm-Message-State: AOAM533fGYgxBJ7VUq1F7wiHhP/NcwMkQwSknQR85apl1UpGiBGzgdpP
        ZLQsVH0QnPj9ZShrOis4q/RKeTDF4ZGnDXQZ+v0j+g==
X-Google-Smtp-Source: ABdhPJwkCcpFviEFpeeuh7clU0JGSpfFAkqdVeMXi2WfAp0wcW9pyY13vr4BeCfVbwiX2FuBDpqyT7/nR+j0x0Xcyno=
X-Received: by 2002:aca:5316:: with SMTP id h22mr4333581oib.13.1628941358984;
 Sat, 14 Aug 2021 04:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150520.072304554@linuxfoundation.org>
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Aug 2021 17:12:27 +0530
Message-ID: <CA+G9fYvufm2PYVSknAQJw599_SExMd6DTwJcyZgy_8bH8HTyqQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/11] 4.19.204-rc1 review
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

On Fri, 13 Aug 2021 at 20:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.204 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.204-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.204-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: b834d1a90a9e65e1801193248f277d85161dfe69
* git describe: v4.19.202-66-gb834d1a90a9e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.202-66-gb834d1a90a9e

## No regressions (compared to v4.19.202-55-g752ef2004f4b)

## No fixes (compared to v4.19.202-55-g752ef2004f4b)

## Test result summary
total: 77080, pass: 62531, fail: 392, skip: 12637, xfail: 1520

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 16 total, 16 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
