Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0653AFD99
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 09:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFVHMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 03:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVHMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 03:12:35 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD846C061756
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 00:10:18 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i5so4785534eds.1
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 00:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=751H0Sfs40L7Rv3GHwjTvsIPUkvpkaBDHMSy+vxJASs=;
        b=wkHIOVqPTFP19gUngw9TbS+Alf69JR31hadllYt3EaImQYJt9+mqNgajnAlTROyAkK
         kcU0QkDbDVre/5BxuqwSaDL813tJqBT08BxmICrYeYz5rKfnxp/s4fk+oB6VzI9lIV8e
         mnJELXXCUKh2y+Q8HZFkn6PWzqv1cDjgGzbjxSWoSo6+/2+o9RtPbd+iKbhHX6/EqX2n
         Ux5GjGIGMOVbOTpkbru4Ie3/cZPtNg8WYGrqxp+EKgVVtGD2fi1SlthMlEDyR23YQKVx
         kZNQq3MTY0eqGfG8267tEqYgzMPFoMuynGTtvmGP8/aExagwgni/Yq2hV74NVB+Q+/n5
         G5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=751H0Sfs40L7Rv3GHwjTvsIPUkvpkaBDHMSy+vxJASs=;
        b=kF4SJ+2Ytd3dYoo+5+rgffWxk7rmxEy0VO0nxlgR8IfgsEZAiaNiATV+L7GdK8Vx9R
         u7OWTJDTrGrnMXLIncARVnrt0iWueRfYiCE2OMMLlDGX6GWbx3EOUlQSCEJe6UHKrlNR
         Ane/NtD36uYnt9vKl/awxd80kHhXhdJPnskIg9ne8KwR9bcqYLYxqDp6JfcgtTwI2N+1
         HPfspanOqp0C6EFDioNsW0gHxivKaoSy6bgYgIM6RQSLpNtPvrg6MpN5eNE9b2HGFfkZ
         0jmb6DionvJKA92Y2cHvAN3DKX9gujMTDMS+S2zZHXDVR2ba4NpT2oh3xnNTIO50f4GI
         pfPA==
X-Gm-Message-State: AOAM533gVZDEDzBBeCuQ0mNITJTNDvcJ3mMp37Yc4QnckpDLPyosG2dI
        JPrUH7dQ4XfLLwU0g0LqK6qHejWQa6968rplOIW3YqglFeUZcIKg
X-Google-Smtp-Source: ABdhPJwh4yTx+A+AXNgh0ewbLJJiIA4yp7YmfN/LkxF3SiINhzuGRQeffMM3OwSLJSQE8SD2qIdIo3nXME1rRU+Q6DU=
X-Received: by 2002:a05:6402:2ce:: with SMTP id b14mr2941190edx.23.1624345816709;
 Tue, 22 Jun 2021 00:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210621154904.159672728@linuxfoundation.org>
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Jun 2021 12:40:05 +0530
Message-ID: <CA+G9fYuF92Qs1R5O85decQzAArfGJuhxKZ51JmUtYGqmNSV8vA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/90] 5.4.128-rc1 review
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

On Mon, 21 Jun 2021 at 21:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.128 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.128-rc1.gz
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

## Build
* kernel: 5.4.128-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 3840287eb948c813b04c456d2ae96f20a77aedee
* git describe: v5.4.127-91-g3840287eb948
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
27-91-g3840287eb948

## No regressions (compared to v5.4.126-29-g4e778e863160)


## No fixes (compared to v5.4.126-29-g4e778e863160)


## Test result summary
 total: 74568, pass: 60365, fail: 1139, skip: 11818, xfail: 1246,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

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
* kselftest-tc-testing
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
