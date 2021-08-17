Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1362E3EE689
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 08:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhHQGZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 02:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhHQGZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 02:25:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30685C061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 23:25:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b15so36394639ejg.10
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 23:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QL9Kz/WeADg9v9gjvShigs4+y3yLHYi1e9So++MIF5E=;
        b=UIAPrQgA1Zy72PINQDrV8+dSvp2EysfatOLXH0WFub6SIzvVyZSx7ITImoIEr9lZiD
         IeYDj/hzpXXDHpT9PyRY0gtjz6wrJTfznm8W7IIXtZ1RRmgJVeiFGj42m+B0o+xWt9S4
         kNM7xvL6np0cH4CgS1n+dzEOJ1Ih1I4/08jmWa0n+/Xp7pGXZZx+4o8Mrwqw0dE9JnOB
         e9xQjEjVkQWXWfL3AE86D5hiFF1IqcZBHDlce3G5BCJtKx4mn9lq55BoCnYBG3i5VZgd
         KZ3filL5P7lj57HZUtWOz3FYM/25N4WICZEeM2Qsu2gMRkbAD1Ar9xQxVd2bFgHqtmBZ
         6XUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QL9Kz/WeADg9v9gjvShigs4+y3yLHYi1e9So++MIF5E=;
        b=G4iGIHhK3eSBVD5tY29P8xMlDWGGTaujIxcNf+SdynCvFKCqUw6FVw61mHv0GQ1Vgp
         IW76NB+H4jdpGKB8MGNuDKIrsDTTnYvXkoASJmydVzqyaiPMyqixOCMUfPyZTbCJz3lz
         QrC0B/NR1XbX0UdEjmCmAeed4mzpILp7oMMIU6YHcmr5dLbcANo5AVIipWI2jywdwgHt
         P1CXnXy84Dx4M2wMAhqG16KULYcvfoHOJmzxIegj1NqIiMfu3caKIJ4M9G7MYlUIdWHj
         0HAykj+IGZogDNv8T2WVYoXthg8oa6ZhLofUJck30Wbbs8HqCo6PdgfxvMtTqA6pNqc9
         jvxA==
X-Gm-Message-State: AOAM532yQvplZ//oGXE1LuBEU2/Vgy436Gy7y+7Yad//ixxI6Xuq+wTZ
        YhofYOByqLEKWZo9uyyRUBK7NP+8ogDg9fiyQTbUyCuzS2/UA4M5
X-Google-Smtp-Source: ABdhPJytLldrQ4W86SwhMcApQ+CdLF7vx25FN7yEqeIGoeTtbI7F6cYS5HAoolr7JYjwVP/l92ZLeGwVg7PPJw7+X7k=
X-Received: by 2002:a17:906:c34c:: with SMTP id ci12mr2161030ejb.247.1629181507265;
 Mon, 16 Aug 2021 23:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210816171400.936235973@linuxfoundation.org>
In-Reply-To: <20210816171400.936235973@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Aug 2021 11:54:55 +0530
Message-ID: <CA+G9fYuS95iiu79qUidj_9Xkb8uDpBAN-xGSNEg2Q09MZ=v8sQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/98] 5.10.60-rc2 review
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
> This is the start of the stable review cycle for the 5.10.60 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Aug 2021 17:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.60-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.60-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f82f3c334fcc9444324972565f2fd882a6315d85
* git describe: v5.10.59-99-gf82f3c334fcc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.59-99-gf82f3c334fcc

## No regressions (compared to v5.10.59-97-g9541d53f15c1)

## No fixes (compared to v5.10.59-97-g9541d53f15c1)

## Test result summary
total: 83274, pass: 70003, fail: 527, skip: 11696, xfail: 1048

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 194 total, 194 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 28 total, 28 passed, 0 failed

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
* kunit
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
