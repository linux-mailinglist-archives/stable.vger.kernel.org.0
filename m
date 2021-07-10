Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E873C34D0
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhGJOPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 10:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhGJOPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 10:15:42 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21A5C0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 07:12:56 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gn32so22394523ejc.2
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 07:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4ZBlORueev7N3L2RXklowlFtIS2GriL03DvyoTu5144=;
        b=KvI1NfNIsemdS8HdYwPil0dntb9nsSrNSWyfGV2+6yKVeFPkQq8K3v/2I/ralJ3yur
         4lbqvZo0Yss73DMJd3TJoDNXtBWReWI22LAfQwkcX9LdOE1489ccqnpHg3PaGDQ78ChY
         TTwEuKM4nWplXVwoi11CIkJIWu/kCJLNAAs6FBdYH3nuGD5tJFL+E//EpWu5NrEzAOtd
         i7efUZeLuHeXmRqrYYX5F+gHTYpMkc9ggj7Jof+ozzc8izlNem8D8BaiCyydF1Uqt4Vh
         8nML0/TshaOGBl8AtCzkPJzEjODE9Ii1hFIbf24cYwxVhicQdzoU0YVTW0D1MIGmL0A/
         jYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4ZBlORueev7N3L2RXklowlFtIS2GriL03DvyoTu5144=;
        b=TYJetHXvlnG5ab1L2liwiGG7168j72rSKWd5+DjSMgl2MhPlsDDJDRf5OJfcIDBQLS
         fZUVLhqQjap4FPSaPSarfFccB+/u4I61KqhYEuhh1Agwwq7/X4cBRFn4Vu6VLu1lP3UN
         gTLvyo++ufwuUpmd1KhGV7+dbSyDvR1bIBsnLH1f+Astrd74wG6Ol+yBvvY1pkFRxAxP
         +qTFExgQ9rTTcpYe+7G8GOftCrE9lMVbvF7QneDVppRyAuEEtJ7xSuHUsRHCo/nHHJO3
         0EhrFaZay/aLg8HDBbqyymCsep+Qc3Sv0vbifzjQsolxqXuiUeytBFNdwDeFC7hPuG9T
         ZeVQ==
X-Gm-Message-State: AOAM532R59TuAPU2Q+uB3nTPbvsrf/xYoxLxiPm04ipA+uRvLfhpBwrT
        i/D3LTBzwKG696D29hVWi/D26MS9oyNBctEAKH1Yiw==
X-Google-Smtp-Source: ABdhPJz7bmC1jtFvUjgTDbIqdwowlOIoHdqDhxRQPqbx2FodllR8dUT4ZXZAlOyqQhdOByObVeDkcJa+oys1ze1ZnaU=
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr42732672ejb.170.1625926375249;
 Sat, 10 Jul 2021 07:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131542.410636747@linuxfoundation.org>
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 19:42:43 +0530
Message-ID: <CA+G9fYs_dPY+fx_5KmUb--Y0QDa--GQbF_QNddLj9199n77sXw@mail.gmail.com>
Subject: Re: [PATCH 4.9 0/9] 4.9.275-rc1 review
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

On Fri, 9 Jul 2021 at 18:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.275-rc1.gz
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
* kernel: 4.9.275-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: 972f4299f6ca84d948d7be286aeca2e200c4c62c
* git describe: v4.9.274-10-g972f4299f6ca
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
74-10-g972f4299f6ca

## No regressions (compared to v4.9.274-7-g901e917fb1e9)

## No fixes (compared to v4.9.274-7-g901e917fb1e9)

## Test result summary
 total: 65597, pass: 51002, fail: 595, skip: 11784, xfail: 2216,

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
* ltp-fcntl-locktests-[
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
