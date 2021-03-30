Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B7E34E0DE
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 07:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhC3Fu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 01:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhC3Fuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 01:50:52 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA6AC061764
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 22:50:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z1so16749806edb.8
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 22:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q7mjnvITW5POKusZesCDDAXlzdQv7Zg52myaiOsYaKU=;
        b=h6EKKILdhOMo3nj+X7yTX/WnO2fS754IlwJ7yuibHwBw0OuJQAq9NthRXts+JsMTtL
         KSBCV+nM0UKnHe3W6RUe5O1mYcLDjSp5uAc2GxcCA5QouWayBQOjUgYAGMXhg3JLk2mn
         Pq8/BSt9+BUa6+siA9PM5uQHr6eUVKcRQD7S7TU/M7/8yY5vzB1uAKy64sNVw1WEfMU1
         NncG09TW/FO634ya4QFp5uLgiT90NCzHcTcsnSIQgDOv3XcnXdC6j7OakYieTHeQieP7
         Y2h08Gegw7s0+uTk+TB97YG2Hft1FhEzYtdjdN5Y10mxnGv8i/ZWTvK3qwpKDL/Hlmj8
         lEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q7mjnvITW5POKusZesCDDAXlzdQv7Zg52myaiOsYaKU=;
        b=n8LZo08Bl+OJRfJvGpGm14qCvxhqMtoafqPfW7MUPRA5e+VoyxLSR66DwEoHDoJOUK
         WH3npXxrrI5DddQ4X4hPU+YoiugwACWgxHdsG+kvkEW7vHwRfYHPnivIdoqJfFU1Z8ty
         CEBhEKjOKNmTTDG1cgVQvfdkF1AF/wKpY3aZH6FGqNNzQmNY8mtSQMME/Y72QXhukpBX
         LP6M4LxDZAWqihOaw7PJ6QzmmYjphwTqK0V3Dcr5bF0lYgqkTnvgRM8Co958Rdzell5E
         D6YErH9+oNcRE/2m9kBEAbXwR5y2c12S7DhJ+Ud5DoWuvMVuJzC/BAucGzZVBQbUEqnH
         dKrw==
X-Gm-Message-State: AOAM531DYGFXfDVGLLltcbSi00EZCaTh2i+LuIvHgUrk6sk7truKdKLi
        RROoF2/tRpwZGFBXBqLkZgBbTgV/ecdzCqXmdwSBGQ==
X-Google-Smtp-Source: ABdhPJy6Tv10yyHVHI+Fl+Wj3tJfowaAtuTKGJ9SHoed2IDJ0VEgwjL/q/1AhyqIaK+PYzwXWUewcoJfWTNtJT7tB1Q=
X-Received: by 2002:aa7:d287:: with SMTP id w7mr31517351edq.23.1617083451172;
 Mon, 29 Mar 2021 22:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075615.186199980@linuxfoundation.org>
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Mar 2021 11:20:39 +0530
Message-ID: <CA+G9fYuhZ-xO58ZxMUO9DHd+j4H-j4fG6nkgPzTThkw_Zheniw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/111] 5.4.109-rc1 review
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

On Mon, 29 Mar 2021 at 13:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.109 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.109-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.109-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 7b78fa4bf15f02997c4dba22fe2bf2ca8aa9906f
git describe: v5.4.108-112-g7b78fa4bf15f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.108-112-g7b78fa4bf15f

No regressions (compared to build v5.4.108)

No fixes (compared to build v5.4.108)

Ran 59776 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- nxp-ls2088-64k_page_size
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm-debug
- qemu-arm64-clang
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-clang
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
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
* kselftest-tc-testing
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-intel_pstate
* kselftest-livepatch
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
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* kselftest-kexec
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* rcutorture
* igt-gpu-tools
* ssuite
* kselftest-vsyscall-mode-native-

--=20
Linaro LKFT
https://lkft.linaro.org
