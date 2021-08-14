Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB603EC320
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 16:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhHNONd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 10:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbhHNONc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 10:13:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B35DC061764
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 07:13:04 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dj8so11726804edb.2
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 07:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uP6RbH8Pgo9wDsPbdfuuwayUA6fJ/RxF+MP+Rr5vsro=;
        b=WYVzTIjdNDUeOmoJKfzdTJUacAlCp0s5TeM9WPVCUIN9cQ97bvvoqeT4rke7Ojh/Dc
         /ZyDhv9LFqkJo91hiPZTOhZNoiYe4hsmaQJMecS+xoStN5ObJ0gGVoz92Mqmg8ffCjer
         pHX+i4hsLMGJ8Lteh32LzpmXlBS0ZP8RZKI2YTTlldENPfCOOfF66eapemNDae3k9nEo
         /DTF1fudaQKy8sGIVLNIfIMaPMg9IBic1v6NnIjDxNmBmilPluaHX3p/hjE54iEItfn8
         TMi9ow7uJLui+acthVtByapnhvdpG4O/G6rmBhmlml0vzDWnWsebC3W1WkSbCfLZARUJ
         WIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uP6RbH8Pgo9wDsPbdfuuwayUA6fJ/RxF+MP+Rr5vsro=;
        b=Nsq/IVa1eII8Ezc0NNCpvaJDe1OkoMB0SK1TP053METWuCZe9hXti3yJHrUSBInw1q
         MVLks6Cd/ncHllwBuDuzg9kSSXrqxJicRg2XEmitSotp+kXb1MvRLxLLZ34wOARxY+ZO
         QyseDQd4Fj6C7MENNsOBnY8NGUd97GBO7f44FsOFH99dSh603Z7o4C+yq31eJhGKKRF2
         ZIs+iY/x1b/ryVtWWoiN3SaN2PVDEmMQk5IJSm3VcBemMmxX49IiMjkcv+3IkRsuFdih
         bFKUSGz+0+PyLDX/llorV6oU/10TkwICRJd3c5PWJtvX+7a/HEkSVPNyMSISFza828cv
         Sl8Q==
X-Gm-Message-State: AOAM530q8IjKwe6ZdpzG0n0seeDnQha5KJbVnpn4wIPXMdluYDX0LVff
        JxexFn56/UQAZsgKw+kx3Lf8JpUAV5ah20qUtF7JgA==
X-Google-Smtp-Source: ABdhPJzMElQAJA1X4G2K5OxvaFn7gB8Fq+kPAzlkCwfszq65w0z9hbbU8tIt46cWISXmpcGPXBfMBhyzfZ/tqzg6TMU=
X-Received: by 2002:a05:6402:1a23:: with SMTP id be3mr9175661edb.23.1628950382884;
 Sat, 14 Aug 2021 07:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150522.445553924@linuxfoundation.org>
In-Reply-To: <20210813150522.445553924@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Aug 2021 19:42:51 +0530
Message-ID: <CA+G9fYsSq_LooJ=_UV-=XJmOcg-vrRDGZvUCvo3GnMF0c8pvSA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/30] 4.9.280-rc1 review
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

On Fri, 13 Aug 2021 at 20:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.280 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.280-rc1.gz
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
* kernel: 4.9.280-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 5124b049250fa384487453ee2be70fbf82aea45c
* git describe: v4.9.279-31-g5124b049250f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
79-31-g5124b049250f

## No regressions (compared to v4.9.279-31-g58fff7715c9c)

## No fixes (compared to v4.9.279-31-g58fff7715c9c)

## Test result summary
total: 74784, pass: 58530, fail: 535, skip: 13533, xfail: 2186

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
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
