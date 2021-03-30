Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21D134E1B9
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 09:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhC3HF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 03:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhC3HFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 03:05:38 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83151C0613D8
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 00:05:37 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h10so16899098edt.13
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 00:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Me7vnxHGYnz2smSJYO2JOjagB7j0J7nPm8dRmlQU9Dk=;
        b=A+782nnC93riMgn9iCZ8KKoFfZsFXIusSQGasDMP57Sa1bmYrr4wZE6YvSv4Mf7fJO
         sEtYGJGapFhgd12dHqGarCx3GM8p2nxj5mn0QS9PziOL5YSyDIR9EXe0R59pYIaNtopX
         1cmE76duJeYBiDyGPzNvxh4SFRXicu1pm0WQtZkJ/7rd/G4daleZfFfDYAO1EeeR44fQ
         Gast57Fri3csuhnnM19Pjxmt8rz4RVolIFlYuhcmRqSGxrKmd3nxjFqy3yYA2GcR1jY7
         PYXUBObf83OwuAETuz7no7W01cQhLOPNswvVmAAZYR627XddxJ2hq719mBTOEverDNGF
         XE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Me7vnxHGYnz2smSJYO2JOjagB7j0J7nPm8dRmlQU9Dk=;
        b=OL7RTpJdk90FdJ0T9IPULg8JvYPPqy7ssxKh5g0EdyXxfgf7Y1MKsfyw5xmpZYSqHq
         LFX2p8aoeVZJQAio5z6tgrhxiT5Knes4keOowIc9egIdMTeLhyzVp4p9DSCzQa+iqVdd
         UdEu+1L6moy+avPXsbr1/KmaA/u2fGv6im3kES+bI94KvSj+5mprvajRoQCv96KR2Ysc
         zWNYbUtfxz9MPZu4lIcf650HBJXRk8bTE3OabIcwTT78dcSlh2oVLNtajKxAqywv4SSN
         JC+oFnNXe9RUqTZs6HrxOBtae+fQF5oEaBTrMN/KNtAsIZTsgTv9pcNQt2eQJg4sdTkH
         DA8Q==
X-Gm-Message-State: AOAM531/NIYyllf0IpOkYR7SomwNSOgFlxjKpSU3iNQ4UjX8XJazB7jT
        Pb/sj2ZkmOoYut29RnGBD2EJuoIyRHYIfMIfvwklZGJ5tZDQRkRl
X-Google-Smtp-Source: ABdhPJxHVmBx3tgFEgsk/xgxdv+60etWwOovcpy8361LdRxgb0IQ799yTjee7NDHarYC172o9TU+Jhlkxix5bC/sXmI=
X-Received: by 2002:a05:6402:145:: with SMTP id s5mr14577084edu.221.1617087935894;
 Tue, 30 Mar 2021 00:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075607.561619583@linuxfoundation.org>
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Mar 2021 12:35:24 +0530
Message-ID: <CA+G9fYvS7t=FLCbtJheVJqL8LzXVjcLiuDW=3kTyzkMnGcUozw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/53] 4.9.264-rc1 review
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

On Mon, 29 Mar 2021 at 13:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.264 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.264-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.264-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 3c2295cc6be320f7598a3ae9da3abc98230bd931
git describe: v4.9.263-54-g3c2295cc6be3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.263-54-g3c2295cc6be3

No regressions (compared to build v4.9.263)

No fixes (compared to build v4.9.263)

Ran 49047 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm-debug
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sysctl
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* fwts
* kselftest-lib
* kselftest-membarrier
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-zram
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* network-basic-tests
* perf
* kselftest-kexec
* kselftest-sync
* kselftest-vm
* kselftest-x86
* ltp-open-posix-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
