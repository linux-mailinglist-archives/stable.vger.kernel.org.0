Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD438C3CD
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhEUJuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 05:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbhEUJuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 05:50:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAF6C06138D
        for <stable@vger.kernel.org>; Fri, 21 May 2021 02:48:38 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id c20so29600376ejm.3
        for <stable@vger.kernel.org>; Fri, 21 May 2021 02:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eisF7/tvHZBRL69+5MCh0dy7rhokDrpqCcqSKT/Yj3c=;
        b=VsgTIZFo++ZXlzyfDeZJV0cPRwqofdSPQeW2AtfPzQGJXxNzgxZK8bkFehpNDFgfRU
         +mpOeeGoBp0RX1Ua3oKmQEihRKhlkyXnwRVBhoUeqjxtYWRQSSnlvstJuo/Y9RMXBeHI
         jrO8OemCG3wBVHvTUNEd6RGa8VOLUCPAnOfMyglZ7DizDcuD5r1BxsMDw9nCkJiUCMPW
         WTCMDzv6m5q4j472uuj8WRVjK4IPtp5Ts6VppqwL13kwSIiDDMvMoe2pEmaI3uKefj0q
         kFgzHLuN4U5zkK52WCEq6V6MOFnt0hbSrqHqlIOmG7wtdvkrsoSkUbVihvH+4dll0WNr
         Mzhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eisF7/tvHZBRL69+5MCh0dy7rhokDrpqCcqSKT/Yj3c=;
        b=lbNQYaCQayKE2BUoeZrXVafWml10wKuEaXoaiba3cxPPAStOL4uAEKMGBZRWxjbdGQ
         lm7B5VtBIt7urnAFC40PAj6AQ8ij7IeZe5HrU0LHuHcanvj/l7NabboFykHmK7rHl/CE
         TvumEbaNfka7JNb/UX222j981OqXzdq9zxZknA4ECUNEXmlI1RGZDHpsls6St86rwpl4
         PvgMn1s/GYazppv5PezvWU298QMelxp1h3wEeSOBlNyk3MHYOzas85dIQYcRgKJqesR9
         I0n5wV2PLrFLWunUu16bsAH0SOu61hpbF9s8G4g79uoAwvHhOYUhZo3PkF+S3faOK1DQ
         RTqQ==
X-Gm-Message-State: AOAM533n6dr+/GGFsa0yR1WN1oRk9PI5GSOoXhOssXDz49u4pY1JF9Jt
        reQKC3hha2CkFRlVT4Zpvc2JR0fsTI1Xy4s1yVhBeg==
X-Google-Smtp-Source: ABdhPJwlZqxM1Lk3AZ8NzbbXE3xQsIO0ye5wXxOCX2WKDrcaYB0b6dJmUQ0nQzo+9kxW1e3KgMV8Vqhk34bNrHf0rAI=
X-Received: by 2002:a17:906:f896:: with SMTP id lg22mr8501020ejb.170.1621590516547;
 Fri, 21 May 2021 02:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210520092108.587553970@linuxfoundation.org>
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 15:18:25 +0530
Message-ID: <CA+G9fYtrt_wSX2LZF-GYa0ngk5nixoky+F5ErrfNheLZJzubgw@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/240] 4.9.269-rc1 review
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

On Thu, 20 May 2021 at 15:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.269 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.269-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.269-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 8622fef5eee9e91d1ea0f1626802ac72a9cbee95
* git describe: v4.9.268-241-g8622fef5eee9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
68-241-g8622fef5eee9

## No regressions (compared to v4.9.268-223-g0394f1845ddb)

## No fixes (compared to v4.9.268-223-g0394f1845ddb)


## Test result summary
 total: 59150, pass: 46996, fail: 1439, skip: 9788, xfail: 927,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

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
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
