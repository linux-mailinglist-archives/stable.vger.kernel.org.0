Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0CB3CC7D3
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 07:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhGRFLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 01:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhGRFLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 01:11:05 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B90C061764
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 22:08:07 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id qa36so778431ejc.10
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 22:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k63KwcexfQ/trbQfAxJJ9bXfqYrH7waIF5eMyRc0K+Q=;
        b=Dgcb4ECdixAFvZI/VVJCaD1ucI8p8o+kpwYZd6dTIZdABwea/gGqD+kJV1kaeuNtZC
         pSbM0Wqpe2HlAJ0xSh+SJSluGUuMaOeOXVuNfwpsFEfcOxITB47J7aT/N/U1GdHsWhvw
         8s41zOkcCK3aqzJN892ASY8ndP/o+N0KIWytFdJ1UHLwMDZT5bKPRrRxSxmQpcnhfC4d
         Udz6b7SFWu//SeSc4Agelxt6c9unCCEp7sDyYLnZJicdH1t6oqndo4XpetVjE9n4OOHk
         DtTHNCnmPp33jof7qCLovgcl6FJL9kN3gYp4w7i51APMO+UzhTx2swJgQxb2HfLIgz/Q
         jTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k63KwcexfQ/trbQfAxJJ9bXfqYrH7waIF5eMyRc0K+Q=;
        b=r8tNFcoJRe1LmQ0uSACpfXBGLosmYqXrW3Zx/vsxx6YkzYjDaJpXanSUQcVCaRcx9z
         nfj7T0z/+ynT2AwEGKs26XyIYQac+1ewdxqmZAUQEhkvKWurfvNsyi4VP/+fO8ymnIVF
         JVrPkE5GRqCy03k6WzsrCd+wU3BTF9Wug0ToSO5Ia8U+EF381qXnzymbrmfS5t6uSAGw
         Ra/PFU3T7B05DdD/P6vlOdBW1PvpNfLjCryUY9DBP+fRu6awanfiSv1I98knF1uLsT+F
         NCCqeMJ4im0zAhkSMZed8fPylzxOn2/UBpxq+iEfViUejhXJB55oeV9UfIhD0ZOlBzzi
         vLig==
X-Gm-Message-State: AOAM5336SctwKxwzpR7QZOFCOvRHvldrswj9ABmqSem8tiJawuJRRyx5
        zfVX6JybWAkkFee0C3lTlQheFB+rkG9OGvo1YKeCUqNQFVBOfao7
X-Google-Smtp-Source: ABdhPJyXRTcU339VkbZ2leOfSEShcKNNnmWp49zlCLS1bnt/t1sBQqlnQpkgP0AmYjT7mYMbF9ByDWF6Z1+j9937wK0=
X-Received: by 2002:a17:906:844d:: with SMTP id e13mr20638301ejy.503.1626584885451;
 Sat, 17 Jul 2021 22:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210716182029.878765454@linuxfoundation.org>
In-Reply-To: <20210716182029.878765454@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 18 Jul 2021 10:37:54 +0530
Message-ID: <CA+G9fYujYcZKM6kErHuP7amrncCD9-fdaWX09h-GimRpzLk8nw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/119] 5.4.133-rc2 review
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

On Fri, 16 Jul 2021 at 23:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.133 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.133-rc2.gz
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
* kernel: 5.4.133-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 017fed873b8e6dc52381e14f3fd58bda603e54d6
* git describe: v5.4.132-120-g017fed873b8e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
32-120-g017fed873b8e

## No regressions (compared to v5.4.132-123-g7f5fd6e106ed)

## No Fixes (compared to v5.4.132-123-g7f5fd6e106ed)

## Test result summary
 total: 75991, pass: 62449, fail: 857, skip: 11406, xfail: 1279,

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
* timesync-off
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
