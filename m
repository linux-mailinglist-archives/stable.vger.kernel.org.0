Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A413FEA88
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 10:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbhIBIUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 04:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244345AbhIBIUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 04:20:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BD6C061757
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 01:19:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a25so2427518ejv.6
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 01:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gFiQ6i9XW7BIqSyRN+BbO3nnGGXqz7dQGc3ivcA8ZM0=;
        b=J8Hh0yoSoutPTJOlF3mT/vZj7ZkbPd8U5Hpb2hor+g29NYFcysNpxj/1pVF/mLsR2k
         45XbOCXcW5n24AkudS1WKqVwAGjRTekWuT31NXEOb9k2rqweTJUC4sOfNE6mN0IQ+Zfq
         8HRmlqw2sWuT9P/HsG9QNzvdJDkLcH9ayd3OeEx66TFIQkNv8fUYmu6sC8NBHnIXBeom
         RKrGeuyKa6u4csCCrSbarPuqlLyYfAFLGjzpLMrJBjYsAckyF/QxFu15R3gBXVtd02jp
         yHVCY90fzsFnTSzxtaHrF/zTK+43cl+XpEtcwFRCe1QZXOX77mIHrvEWQLJFNJMeV/hC
         LWsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gFiQ6i9XW7BIqSyRN+BbO3nnGGXqz7dQGc3ivcA8ZM0=;
        b=Ykuq/7OfHvvJ8yGDgcVVsDIuG82BrsiHhYP2KLnTgp1EvATYOTTqFncTtvIYwymV2a
         C9C4U+MhuRHC/EsX0XdS8guY49bvqzdoZkFUA48/X6aiBpl6XDJcPHS4IfaNORJR8PvR
         DMZVO3HRbTdzPg/ns+Zj+d6aeRyEXcNYg+5omOGO5B6eTe4bw6vmfyjecpoPIX4dsRxP
         FreQ5Pkgz0pxyzIl/AOoPgvDOFsxQvEm+R+zZeKtH6Y5D2pi4lqu0pJ+Cf4k4kl5gJxO
         zZugPbqJtV9ZKanmFpO7EIsiNHHSZmP9MsyTAGTUNXyo/CyfilzguKJgkmW+IzI3h6Ye
         7eOQ==
X-Gm-Message-State: AOAM5326jJq3scOBh5pWnMlNg2tfA7F5gLH2tE06RK6IfqOyxRq0D+Ju
        TIc762Lo73XNn59fL3WjFxE7AX1JmrJTgXmpGAvPZw==
X-Google-Smtp-Source: ABdhPJyPGWlZQFIEgh0z0b2eeHHYfQlymOjK/g3vv+0lGumbd+mmG/bsgb+vLQXEr76gPIYLDJ0VHnnnVX+G6mPwM7E=
X-Received: by 2002:a17:906:32ce:: with SMTP id k14mr2436793ejk.503.1630570774121;
 Thu, 02 Sep 2021 01:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122253.388326997@linuxfoundation.org>
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 13:49:22 +0530
Message-ID: <CA+G9fYvJqppD8xKCnmLvt=BZ=Y4BJp0Ld1DikjoT5yJh7nFG2A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/48] 5.4.144-rc1 review
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

On Wed, 1 Sept 2021 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.144 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.144-rc1.gz
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
* kernel: 5.4.144-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: fa7f9f53436ea73ba28358d682e08577f20c1342
* git describe: v5.4.143-49-gfa7f9f53436e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
43-49-gfa7f9f53436e

## No regressions (compared to v5.4.143-28-g66b6adc3ce6e)

## No fixes (compared to v5.4.143-28-g66b6adc3ce6e)

## Test result summary
total: 82537, pass: 67479, fail: 741, skip: 12958, xfail: 1359

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 257 total, 257 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 16 total, 16 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 35 total, 35 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
