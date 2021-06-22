Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEA3AFAF9
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 04:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFVCTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 22:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbhFVCTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 22:19:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6E9C061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 19:16:52 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s15so21520206edt.13
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 19:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zI/tuew0SqY1Sk4dcTKsfP7TId2zVm49aO1S/T8Zrm4=;
        b=NckrPLhhnNLGPjf2lwGQz9xapzKs4j6rQU+1goVD+VABRqT7OUgQfRmIBVzY9ZA2Oa
         c8lZtBx41B8KO8PgE6HM0Cak5PVZJU/Oha5HpkjN8Oo31nTOf3OB58iqART9PUWnSCQL
         UaxVC53E3k16mq5eikwhYGMATO+KPVC4l+Alrx2YZpaK9v5k/jdHxJnFO6DUgVAwoPNP
         NHWRjg0rgGIXmspqq8pJm+ST6rMXirgu+xo7Da5ILyuCceS+WfYiu1E+3x8mniBUx07t
         MUGFv5HV8zC1o88Nog5Zuf1z4y0oTHDtRDTmZ0IyraLvvHQ/UhObKnCrlUGHdan1Lh++
         TX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zI/tuew0SqY1Sk4dcTKsfP7TId2zVm49aO1S/T8Zrm4=;
        b=NWkM65XC3ev7lA9j3phHN90WIMDrT0sj4UfVq84s4ix5ptun4hvr2wg+yoK5bS2J2h
         SXn2lfcdDXICPO17Rp5g9ySNIvufaDZ9YsJzaN3vCIWxkii/zm97MF4ulqKkLfxA2nsE
         qYa82ODyBOcByEchYydQwK46WNmOtUPjdfacxLe8lBJkJz5Z+zxJzIEsB8DbyAnc2Zll
         oqs80wcEGpUPsMiotkrUTBMafCcXXzjY4SM/efbO+A7dvji6RusFmQ+cdAZKwagUKDlL
         kEfCAWZ2houyyaC/2fnbzRJ01WmqoDYBYkIbA0Zxdt///6BTPv3yTP5Af4cye9pmcF5Q
         kwxw==
X-Gm-Message-State: AOAM5338LOKfvX1iQ+GiDJGDVvW8JjL467rpl79jCDmHD5RCQh8wPOVd
        NYdjfp0xqYtQGA68QP0+QzKHc1maENVei09whxFo4A==
X-Google-Smtp-Source: ABdhPJzapohHdUZoXnftwa+7XHDYhStu9rfrjFoyv++xM5eJwVck1qvhCOV6/gNhiI6CY4nfQRSrXCu+Rbp/hBUU+88=
X-Received: by 2002:a05:6402:402:: with SMTP id q2mr1659694edv.239.1624328210991;
 Mon, 21 Jun 2021 19:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210621154921.212599475@linuxfoundation.org>
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Jun 2021 07:46:39 +0530
Message-ID: <CA+G9fYuKqcerm-njG9Su7d=CvAG_f9d1h4CRpqdEHzO8CZbKhQ@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/178] 5.12.13-rc1 review
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

On Mon, 21 Jun 2021 at 21:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.12.13-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 88a915cf22fcd20d2323dff7a4b0f70909cf4099
* git describe: v5.12.12-179-g88a915cf22fc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.12-179-g88a915cf22fc

## No regressions (compared to v5.12.11-49-g3197a891c08a)


## No fixes (compared to v5.12.11-49-g3197a891c08a)


## Test result summary
 total: 92709, pass: 74966, fail: 3757, skip: 13183, xfail: 803,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 0 passed, 2 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
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
