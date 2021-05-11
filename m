Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3684437A0DA
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 09:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhEKHdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 03:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbhEKHdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 03:33:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988BBC06175F
        for <stable@vger.kernel.org>; Tue, 11 May 2021 00:32:47 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u21so28228641ejo.13
        for <stable@vger.kernel.org>; Tue, 11 May 2021 00:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wtv9JlgiKwZDuaWLRXAz0cY/XF7zX41X4Yq/U8V+SfU=;
        b=UDydojnafge0s9etN06up8ZovG4+1a+1BK6/eo8NGnW5tpapUMdM9lLabZMaL7VZeT
         O2oCuDS0RPXsqEwN4YwqAg6VAkpLcVMlCAZNrg9ZQRpHnn4YPyuSnOwBr1f+8LemyMGU
         CAk9kHlz5rhu8EQmi8WJj47AtuvEw1jFg446Z0vvPTcNrKj3o9fApPO8xv16yoi57TqR
         5DBb/2IUyIAYk416w0y49JJmGIyHdM4sp3fmY5jOodbQCnpDtieh5tD69iuruJoo3Fyq
         fMU5e3/2JzL5/Okbv0hVsWiuqvw/iOT3OoadscvYWpIQAkxA8w0KVepTIflWp+YvaoMK
         bHqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wtv9JlgiKwZDuaWLRXAz0cY/XF7zX41X4Yq/U8V+SfU=;
        b=Owr6QG444fJcc6KQPskX7jlVGd5w1JGjUHR1TvK1bx6OKMgbMWWsN+S5AaVdPxEKDG
         CJwb4gTpajQBgG6fwMHjLtnsLJuR85jnuzKj3fwU/HKPKNojB2u/b16P2Lymbyy4k0uj
         LVuKiBYxFfE6ZWaB7oBDNwFUJgl/BXfwnSQP2Ip7IZK4hnOovi9wEnxQnmeUHddzZYMn
         amYKLQNsTrdCrZsmehIAH4xjC0Vrt/4B9jvmctVuWQv0C336/ld3NB/EInHsOAjWr9A+
         N/wpLbDJ3kOqstDQflRUAgZSAIQ2yPAqIFbqPt/dVdnuBgw0o+0liGplZ0S5x9+D126r
         actQ==
X-Gm-Message-State: AOAM533Ixq5I0w54HZXEg6KjSXFw+Ty2Ir1Qy9Gl2fM3nNtOZwpjUKGK
        sinf6UtWJPlKaajrW6GsklzbwpaRFCju8x3eQvubjQ==
X-Google-Smtp-Source: ABdhPJzpEtCNOiJgtRubSem31v9t/olVej5qvHh0jL/NqOZdJ+PTTDBqhUQJ9bICOR3g0Rvxx2MIEZwLclz/FopBzB4=
X-Received: by 2002:a17:906:11d4:: with SMTP id o20mr30141723eja.247.1620718366230;
 Tue, 11 May 2021 00:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210510101950.200777181@linuxfoundation.org>
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 May 2021 13:02:35 +0530
Message-ID: <CA+G9fYtDAFAVWSt+BUO=CUPbU7bPE-zOXfP5xnKTSHMDRcKc8w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/184] 5.4.118-rc1 review
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

On Mon, 10 May 2021 at 15:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.118 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.118-rc1.gz
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
* kernel: 5.4.118-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: eb078a943f9777461b67e3f61b4b6376593eb08c
* git describe: v5.4.117-185-geb078a943f97
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
17-185-geb078a943f97

## No regressions (compared to v5.4.117-135-g07e3ee575ce0)

## No fixes (compared to v5.4.117-135-g07e3ee575ce0)

## Test result summary
 total: 78227, pass: 63083, fail: 2683, skip: 12195, xfail: 266,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
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
