Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE06335D709
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 07:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344485AbhDMFSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 01:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244464AbhDMFRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 01:17:49 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BFFC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 22:17:28 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g5so17172282ejx.0
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 22:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vqvkCmn4qTNxem2yPP8PNKHH0FnWCKcax3P32psm9Fs=;
        b=PNHf+ajxBRipHWrpARq2/mX8j/K5u6ivps5+eX/eNGOPrD+YPrcoVmptCX4xb4YVkZ
         ELT/VB0eQ7k5KMULR2gmqcQmBKoe2kl/pWHOtBphJ1zT3gCJkISEb+EfbbhrboNeffZE
         lVwczOypSro3MfNcXbv0mY6kpGfgtf+w2bWiqQCj5h5FTX9kUXlVaf8WEJzR5ge2/qlj
         RKaocxGdFNhueCpFEy9c/ar2ocSla6uLknRMCqUaK4OIWxCYRthceE6i6JAyISF4ole2
         dIUpkyXRycfL1YLt7IJwdVD5hgi1JFPLM3gNcZfgXfJwwmRuGn+gQkKUuMTwk4x5IyBx
         ADWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vqvkCmn4qTNxem2yPP8PNKHH0FnWCKcax3P32psm9Fs=;
        b=aHu/2lIY79or+0yWFmH2lvTN8TvdtgfFrx3cxk/r3tSkC72FwfxlP2Je5aO/zj4C6r
         tILmQwxYg4UxlqBbpMQfFeafEP13yVOrZ7rqjIshbUV7g0veuG7Z4zrZ1C6zqtcuuziV
         MNJ04ZG/AYcqBCqtNBitlNiUWj3k38F7le0grh7cUaSMfUcy2QuH4XJi+Q2EUytjjg1Y
         ZL77QUsXniv/0jasL5EJJDYLXGsUvma8A7QnDVPyWmxWp8XbUWiraPAVkGwqp6O1+EMh
         IvVy3c4h9tuey6ViK0/F9UzTvKbHJBRWG3aRzwGYrSt4P54+orD9SRVDxsASo3nOwVU0
         8Vhg==
X-Gm-Message-State: AOAM530SpNo3unCVwJPNOFBeFAiDWgB9IAomIW/W/DydWypkbD6m54Sz
        l1Dbx4+uq7xPYW5LMrL/V9DStBXV/sFZiBNCOIEAng==
X-Google-Smtp-Source: ABdhPJwu2KbfHyyEi3zb5EPokT6yEWh/fqRnKJtQ8gjHvJ9j2wFLhE7vM88OcRoZlIpt6YJo9StgFZ7XHnziqOZHFPI=
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr29503659ejc.133.1618291047542;
 Mon, 12 Apr 2021 22:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210412084004.200986670@linuxfoundation.org>
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Apr 2021 10:47:16 +0530
Message-ID: <CA+G9fYsF3Q8SdRHHSCf+3B=HOGw9y=sThVy2RUGubgwWkLdnrA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/111] 5.4.112-rc1 review
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

On Mon, 12 Apr 2021 at 14:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.112 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.112-rc1.gz
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
* kernel: 5.4.112-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: f9b2de2cddd4601c5d2f2947fc5cebb7dbecd266
* git describe: v5.4.111-112-gf9b2de2cddd4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
11-112-gf9b2de2cddd4

## No regressions (compared to v5.4.110-24-g9b00696cdc42)

## No fixes (compared to v5.4.110-24-g9b00696cdc42)


## Test result summary
 total: 66568, pass: 55229, fail: 884, skip: 10210, xfail: 245,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 190 total, 190 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 1 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
