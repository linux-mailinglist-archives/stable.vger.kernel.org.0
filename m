Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE9A38BDDA
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 07:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhEUFZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 01:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhEUFZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 01:25:02 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB3C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:23:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l4so28626982ejc.10
        for <stable@vger.kernel.org>; Thu, 20 May 2021 22:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6Pu9OKZH4OqgD2+pMd/e1QNIreaf+pm8UlgvYX0fZ5w=;
        b=U5BEe3O6zjWT0JLJGatCONCJ5rfUDb7/T21/f7Jn3pTHOT8ZeY0R0s6vVw31ItVEp6
         KaRLt68UqeRmGoCEsgHyx8qN6799WJaN+X7/KQY9pboMnRi8cw0fjGC5BKX/YdDG98IC
         m+EihlMtmgdfR3qG+680tCRtb6/LV0734ly7wrUQxLgfPv1dlgxvfbGffzuDnOpaOHd0
         ZT3eaOUG01oWbW/8awoz1LOs9mqWXzixcFOXgQoekL8g3myA4h7RFYj+gMs9imY7yHZm
         ar0KH9NLyAbnId1RsuSspWs2WLt074Tj1lQjMnk159A1mG4JZe8N9+QHXizaIt9ndHxh
         b3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6Pu9OKZH4OqgD2+pMd/e1QNIreaf+pm8UlgvYX0fZ5w=;
        b=ovq+KW4SNBe8LrqbOoLp8FSZG2CUMS/V54NxY+L+sgNkxq+D+WKFe7SVON+wvs2yCE
         mxWvfda9/4LQxASmfdVYuVWYdPW66smlS1hBoLJM1rWfwypoVHxX+TlEh8OUugaZDWK0
         ValDLbM1l4XjLFYeUPDgRFzO8yZEr7yiEzXL2JMOuN6kiEjCWBiD8nRASnLlqhA7zRtB
         OgIT99GH0qL4jCbHEQkfVfU/tqnDKbDAlCVOzFHooEsB2FXk4261UJCCb1es8nQcuP74
         tJznmaMJb+RzJhf77ciDHwAPuHXMI7LQbXR4+T5YN1J4oz9cbT8eoJ5y8M1BN3Am3ioF
         NhjA==
X-Gm-Message-State: AOAM531mRq9+jtK2Nnh3902iH0pMpB4kkt7o0/Yi65PmzBnxPeznov0R
        XFKTL/FMMw+TPICz1tNsIoZ6RdcIEpUUqu43w2wyOQ==
X-Google-Smtp-Source: ABdhPJz3F/dE07QvRWSh5dsyHL1J+wl9nvaCqLseX0b8QQO9d2q+uEZJqaTO/eh+pofiqzG1C+XCp4vAwV3803XwC8U=
X-Received: by 2002:a17:906:4e59:: with SMTP id g25mr8445733ejw.133.1621574617939;
 Thu, 20 May 2021 22:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092052.265851579@linuxfoundation.org>
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 10:53:26 +0530
Message-ID: <CA+G9fYvpCtdExtHqhv2K0+O3dxCVs5BaujkTYs6Ed7fKmqfNvw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/37] 5.4.121-rc1 review
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

On Thu, 20 May 2021 at 14:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.121 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.121-rc1.gz
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
* kernel: 5.4.121-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: d1968aee6ca982be479b6584d449c4d9b749f244
* git describe: v5.4.120-38-gd1968aee6ca9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
20-38-gd1968aee6ca9

## No regressions (compared to v5.4.120)

## No fixes (compared to v5.4.120)

## Test result summary
 total: 77107, pass: 62518, fail: 1864, skip: 11921, xfail: 804,

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
