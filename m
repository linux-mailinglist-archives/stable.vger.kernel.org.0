Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C21396CCD
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 07:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhFAFbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 01:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbhFAFby (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 01:31:54 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35911C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 22:18:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s6so15709195edu.10
        for <stable@vger.kernel.org>; Mon, 31 May 2021 22:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5Y1aD/mhYzZNlmN8zlF6a252/zpnt3wSAmr/T0bADys=;
        b=ryodzXOwQxwL3aLrspdlr1NAu++cAPzy0oA79UesMBDSH3kH1cf20gBgZNax6nz/WA
         3Aq321jtIlj63r/YAYGkNf+V3Z8czVPtno0hiScUwkZrdK3Yg1Z/WEDEIOqqjUv+py9O
         LLJgVOdwbWL0YKEw0A9p3DmvGbqZd0wiWZMg+Gzo+Gmj6+VMkfzFZ3lrtp3BctWz5mLy
         bttYC/DTTMQ+44H3xxDEIuCx/Naam5BtC3eHfy5hLthE1b6lK0C8fQaiJZKqTeWiC3ZL
         AbI+HRhreK+/b8ejCuS/TmUhYJFNG4UHIIVQx/iXs4XWqnKH/FHXdXbGnndozAhqrbOM
         VtgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5Y1aD/mhYzZNlmN8zlF6a252/zpnt3wSAmr/T0bADys=;
        b=I5hS77xhOgZ1+vQSMDxm20NRpGerLPLCkPaS5QtIbrWo575fmTZfrE5w32BTgz0a20
         J3pwzgMzFyignEZliOOzSRhf4//NYtbkCCJu7Ya0/e5lfmXVXw0DDepNsfF8zYOFZQCF
         NFR8G1Ik3pW78s2pMQokNwghOBDQxhgXruJqe/OFwozaKXpC0PBrUO3VN+rM2SaA8F6M
         pZPhR6j/+F9KgPIu0URGTbmmRofnI9mTgfC/V7x/1h91kw3u6mHIZGDCZCO/gyWD8GdP
         5/X6kBqsjZaPX7AUHSJVRiqrX7tRaTQ5CZWvXQk5JQ60O4GHGRumYuDTOuleJt/zyLZu
         7ftQ==
X-Gm-Message-State: AOAM531eEEnPdY6c51XsHLjY2V9vWJXzG58rLsg7gNVZD0lHg9HhO0g1
        1x65Y/K53TgVk6ZtCseiCKUhBtkHOa4VgX/iMG4gEQ==
X-Google-Smtp-Source: ABdhPJws6eazEJDMFUV7K/t2UAF5BhnqHE3Pc9O2LlB8ty5fj+dJDbe2wE1GcMu3uB2wJjj71qlIonwn21a2wV9jvHM=
X-Received: by 2002:a50:9346:: with SMTP id n6mr29589751eda.365.1622524716739;
 Mon, 31 May 2021 22:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130703.762129381@linuxfoundation.org>
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 10:48:25 +0530
Message-ID: <CA+G9fYuO-uwwuj3DvnaKgN00mBAizA2dRLiv-jS+-bD+e1ppFQ@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/296] 5.12.9-rc1 review
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

On Mon, 31 May 2021 at 19:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.9 release.
> There are 296 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.9-rc1.gz
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
* kernel: 5.12.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.12.y
* git commit: 327e3cf768fb44b16c21a0589a492bf7bccef28b
* git describe: v5.12.7-305-g327e3cf768fb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.7-305-g327e3cf768fb

## No regressions (compared to v5.12.7-8-g6fc814b4a8b3)

## No fixes (compared to v5.12.7-8-g6fc814b4a8b3)

## Test result summary
 total: 76833, pass: 64662, fail: 605, skip: 10956, xfail: 610,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
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
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
