Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1D33EE6F8
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 09:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbhHQHH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 03:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhHQHH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 03:07:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D70C0613C1
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 00:07:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v2so19769469edq.10
        for <stable@vger.kernel.org>; Tue, 17 Aug 2021 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LGrI4o5T8p4fA5XRctVZXXIyOOKFj0F7BQaVyKHpqrk=;
        b=Gpj04ryhuS797+wbRKe0PTo8SRp6EzRRbaJ1mPIvBHDieedeCABwunE2OGldOxINfo
         bdDwuoEHR06FL8W8dSTN2ilMDZX/3hojyyiSTEn/ov8Dlh9ZoXDuF2HH8rXs/cAxATpM
         64L7IvubBLncXXe2ltBmjrJl8Bh2/PH4nWVT+GFhpbl9LnpPcVZ7+buo3P4l9/wfJg5+
         1kx8FEl1GXPtf6Nq3t4vcw846TEKlj6rD4WrjK8qwAKxEL9Bv8bFwuER0dO2Geyz2XLI
         uA84CfrG0obIHUx6zr3Vgqc3ycOUPXXTixyQZmknZCmzzAM56/+Sz+vL133BHUNK/VOd
         6zyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LGrI4o5T8p4fA5XRctVZXXIyOOKFj0F7BQaVyKHpqrk=;
        b=iKhx57lQztgByPV9njw3kMZAXWrhIyxM6IVMdXCJ8pnj2r9rRfQOJC1x/SAQpvq3ci
         FVcpgdimYq6bVS3WeV/XvYdoYrKiJ2DZQxIbs2bcrxznd9CVl3ebXWRKh+PUWyTo3NAp
         bx+PdcKdd030A9UQB+giyrGXu4Q5t4XOfk45lrfmbyxB0vMgrAzl8B/oemWc/vEj6U0n
         57yn2CfEAk72HNgXmUtwZTyZRjCMbaAWMeaxGqwNq9yoLuD1eZo8q637BR1mvZ9dY+Zs
         PaDXRGdmSoGwUT76iD+b8iWl8nACfd++Y77O1n/BbN6S0J0RGIi9aq4lrAXZaqlLkE3l
         nIfQ==
X-Gm-Message-State: AOAM5319TFMj8XekwIQ82ObsOlP2qcnq2myvlZ7TTmHOC1XwFr8y3WBX
        2rEdYJoNuV9X9foY9e33RNhOtm5UMzJMqVar+/OyMQ==
X-Google-Smtp-Source: ABdhPJz5uUI6/y1ZMHbls5YZkCv9cpxYzByvXwFdTDksRpqcFG53qb3D9T6KH4xtuvWjPw3lZFpZOcyRGKVGkibZLOI=
X-Received: by 2002:a05:6402:148c:: with SMTP id e12mr2107554edv.239.1629184044339;
 Tue, 17 Aug 2021 00:07:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210816171405.410986560@linuxfoundation.org>
In-Reply-To: <20210816171405.410986560@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Aug 2021 12:37:13 +0530
Message-ID: <CA+G9fYsLGTFG5Dzgn7b5n9EatcGJBb8Q5AoXN6W+dKqrMN5vRQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/64] 5.4.142-rc2 review
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

On Mon, 16 Aug 2021 at 22:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.142 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Aug 2021 17:13:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.142-rc2.gz
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
* kernel: 5.4.142-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 24a339d553e6ee1ba2c6216df053c7cce1e3db4c
* git describe: v5.4.141-65-g24a339d553e6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
41-65-g24a339d553e6

## No regressions (compared to v5.4.141-63-g13046907c978)

## No fixes (compared to v5.4.141-63-g13046907c978)

## Test result summary
total: 84832, pass: 69927, fail: 655, skip: 12851, xfail: 1399

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 16 total, 16 passed, 0 failed
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
* x86_64: 27 total, 27 passed, 0 failed

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
* libgpiod
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
