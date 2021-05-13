Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0A837F59E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhEMKbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhEMKby (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:31:54 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E9EC06174A
        for <stable@vger.kernel.org>; Thu, 13 May 2021 03:30:43 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b17so30434733ede.0
        for <stable@vger.kernel.org>; Thu, 13 May 2021 03:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AZSFjayYfi3ClQbRrqUjiLyPsSqwDK/MRImoKRKimnY=;
        b=bqBx5+gvELlqgsNFy4D6g3tnMdncEj/ft7MkLfruviz5jKCyFRcbtSjJHYeIgxWJBC
         5tNqQ/7SEP0PnXq9FuzgKNS/VcOX9UUVxczjU7phF1BlRo+TMFEXbZR32J4DUUHNmSCE
         TUluw0syqM7tI7AUn9M9HOGDaaQMraR1KV5ERtJyIvLB7jhHhk0MGZLHEM/nWmwdyoqr
         mclZko8K5K9dFzAgUdShAwbVLZfvAhT+SOwkc5z/fd7H32S307bUkE8/IKGsUpzPP1Pg
         BKUogk8tco8p1nXiPNzPwswxsIDqfMY1D4OVuqJpuVJvhlWsWWturEP1LQ1myPiGIk7B
         UbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AZSFjayYfi3ClQbRrqUjiLyPsSqwDK/MRImoKRKimnY=;
        b=YvJaH/abpVNU2SqL+9qt4W4ckCoCj+4MtWCoNBtckFojX8DqHEmzKdC0awNkUvCFKp
         cew6qUhVI/RZR8coKfFp0g0LvGmKcRK9uDzxVor7mgMPDCUJ7mMNmVmO12GCKUmPEcjZ
         jOZQWmp2nq3WIB6haI+IfNOWuosN3Le+Kg1OJ71aQFNKKnQSmLy+oNHUThEO6eTUn67l
         AXfqvx1rWwRFVAYOQ7Pp3GyJMCyWdksvYUl1UwYDSIWBKPbeGOdNDQ9p64u58XwdSmg+
         D0001nTSoAAbrFVcWXFgzasVlgyEeGrBkzHAj1kmsndrZ8EwmbNFIk2/A4mNRXJ4o37a
         x3aw==
X-Gm-Message-State: AOAM5300e4Fmt7Lh8Lwlv5r4DrkSJQw1V2/zP+zzLB3FF1AcmXQnwYWw
        I4uGeeShtK0uaHB+YhXsSRzRkoJxTAP+tjPwWfKtJg==
X-Google-Smtp-Source: ABdhPJzMNNexVDFiwDrPQslaep4nKniXCswXLoEUzhufUQcz3eOYtrNYrK2Kov8DvoPPp5GhfNRD5Y+9wTC6DJamk+Y=
X-Received: by 2002:a05:6402:12d3:: with SMTP id k19mr48869463edx.52.1620901842082;
 Thu, 13 May 2021 03:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144837.204217980@linuxfoundation.org>
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 13 May 2021 16:00:30 +0530
Message-ID: <CA+G9fYsvg2jHk7f5QZcirKumDLcuwtErq=FsEa6dm-vBUeHf-A@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
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

On Wed, 12 May 2021 at 21:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.12.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Apart from mips clang build failures no other new test failures noticed.

## Build
* kernel: 5.12.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.12.y
* git commit: 6c1612b7930018e618fc920494f1982130d24d5b
* git describe: v5.12.2-1062-g6c1612b79300
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.12.y/build/v5.12=
.2-1062-g6c1612b79300

## Regressions (compared to v5.12.2-384-gb0def16b48b3)

* mips, build
  - clang-10-allnoconfig
  - clang-10-defconfig
  - clang-10-tinyconfig
  - clang-11-allnoconfig
  - clang-11-defconfig
  - clang-11-tinyconfig
  - clang-12-allnoconfig
  - clang-12-defconfig
  - clang-12-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


## No fixes (compared to v5.12.2-384-gb0def16b48b3)


## Test result summary
 total: 73854, pass: 62161, fail: 1288, skip: 10405, xfail: 0,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 45 total, 36 passed, 9 failed
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
