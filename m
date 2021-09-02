Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA803FE93D
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 08:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240160AbhIBGbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 02:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhIBGbq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 02:31:46 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60483C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 23:30:48 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z19so1207626edi.9
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 23:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QuwIpwp8E1z/0BLCjmuK7IT9VkpALdbWDDH6ofq9Yyc=;
        b=Y1LTrgSFGQ9z6uNZWqMrvMKHnX6c+QgflhqiMGsuOAdROV9nkub2+p2Drk0MaHcWMt
         FRKVAlZnPXpI5WC4eCvxgeyARTkk4mJ2YLqtqeolIHVFOnHCEiysgaiooE6xPPw3sFP2
         623akhBRVvTSyPV1s9er9OatbSCXjnv5zL43OXLEnFCfXn9nEQPCX6gsqlOICLNThTfO
         Vw5HSHfhEhw8jOrt73wZ+9ZXZBnWvwZlPhfUsT17nP5+mH68wHqTrc+YXpBKO3CGob6G
         nnCBTTFnawBTExGyFCPxu6XLMrt4XnaFUGJI4LEtvn/38icOLCPQyY64lG5L0eC3HK0a
         H4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QuwIpwp8E1z/0BLCjmuK7IT9VkpALdbWDDH6ofq9Yyc=;
        b=uZ6vWiEu6kIeVLiwYV3anrB44yqu0mgDmnkoQE7Ij9m2oRQhAT0r4c5JH1P3+bCra+
         xhsYjM74rJUqnDv7bHldIdQSm+2bTuPfs9Xats2q5zwxPgw9GfbUHwqHCLNO33beShY6
         6KJeP0OP7J9ZU1ez84W9+hBqnlXupMNxP1h+EQQ8DxwkTy4VB8Ogj6XnXP16IqBA/563
         ZxZlCKgEERrjg5xFat3f+S1G7tuQWFV47T0R4QC+f9a2u+rjPqcjkDom8ENWdD3NDEqb
         Iw9/+YCaaO639Sawd3OyOWhw0oFtmqSEsDzD2fprW9y3l30gzYtwT2sFdL3UyiSlkX7w
         r6UA==
X-Gm-Message-State: AOAM530928VeEPBVp9gvNlzmnmJCni0X+ZMVWDef45kDEHGTHLsnbq1o
        /K4DnOWsgtKWoslQN4awMfadayS2m8KK8yg6yxuISw==
X-Google-Smtp-Source: ABdhPJzAAcqT6eNbA+E6YO+qmTP1bMlyvT0c8T3AVbVJGIkQDFVNr/vwi4kG0U+0fFWArZa+h/ejkkMqo14KZhxBNhs=
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr1922302edv.230.1630564246735;
 Wed, 01 Sep 2021 23:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210901122301.984263453@linuxfoundation.org>
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 12:00:35 +0530
Message-ID: <CA+G9fYs9whmNgshh915Yeor-FzieEUCMf6itw3T9d7mSq9H2zA@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/113] 5.13.14-rc1 review
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

On Wed, 1 Sept 2021 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.13.14 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.13.14-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.13.y
* git commit: d049bfc3077d9ae46a73c99a7e1db0efe01d55c0
* git describe: v5.13.13-114-gd049bfc3077d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13=
.13-114-gd049bfc3077d

## No regressions (compared to v5.13.13-74-g5a5b2e290019)

## No fixes (compared to v5.13.13-74-g5a5b2e290019)


## Test result summary
total: 90478, pass: 75396, fail: 1134, skip: 13017, xfail: 931

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 258 total, 258 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
