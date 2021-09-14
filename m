Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E396140A91B
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhINIZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhINIZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 04:25:55 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12079C061762
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 01:24:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id n10so18551002eda.10
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 01:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8CnH5u9yufMoSg7KzG1hf8pqoys9VXHRCP6Ri7HRyPw=;
        b=vC4HPBnAdz3mNnDfdYKIztyC1wdXJtKNi53wOglZkqI8aKNbfQKYVJorqXcF9idBzO
         Ana0JSnZYWzNG+SHiL4ZXa8t3qFxNY6NRoLsnyJx5yY/ex1kklXcCUu3xBbGFrZ4iimK
         AdxLCZAvWcO85+N9b7s6p/tu053fk7QzCNf915irQneeaqHMnEPZqZSGuUvmgi6wV4M4
         3eXMhrvclYO+xvlmeJAEp1KBkrqDPZPlCsIOfc40NDt+wFUArkHHg75F6fi1u826llG0
         bGXi5X4epos5fQ20QPRMAal9daOBlx5/3Sxgc40XGBWIUejoz3G0hWeIgzwdNEQLVeil
         4LWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8CnH5u9yufMoSg7KzG1hf8pqoys9VXHRCP6Ri7HRyPw=;
        b=bx1mRI2f/bcFeXpS6Q83AvefJRtErRzn7j3wvCwnF7KUIkGobqBB5A5+PWKNFnQfq/
         bxTdki+30vkl7vmpPrtM4NTrH5DblxrTNHb6VEHDSn84B2RhUMrNKdypUgQKHAtFi5E0
         Xjgi4yD1Hy/POL+BKbGZwrMTW091UtNGSITidNOJH25SvO7ULfgX9ZdR7AQNHgCACTfN
         KnYoJW1muRPdhty9QV92gNWTrL//Lxlhp/n/Yu/L0TTSbrvvQ0kb/XdfALslJ9FbP/P/
         2K2C2sTZ2K9VL02U4+EdfhCl5ZsoYXW6Hp8bW1xJylDVj1zlqNhpd7HFeQFdVNGQPK+r
         PAkw==
X-Gm-Message-State: AOAM530sIxk1M3xtpSmrfIqoangPGuCc1QEKQSxp2dgEgGKDnz2uUeBu
        7/z+ZBb2mYTHcMGuGGuUnfzBUZ5kEez1OwLARoxZhw==
X-Google-Smtp-Source: ABdhPJyrVyPI02/YBWaSuHdqW8RNKIzwb+ptlbgZ/tNpzLyrsdCdSNLot///fFOUDlTxALkDWSGfoPHN2YJEYr6nC2s=
X-Received: by 2002:aa7:dcd0:: with SMTP id w16mr18006975edu.288.1631607876391;
 Tue, 14 Sep 2021 01:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131047.974309396@linuxfoundation.org>
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Sep 2021 13:54:25 +0530
Message-ID: <CA+G9fYvLuSQsCTjqOxhaca=P_hcHb9fUSWCmZQMVq-OgAcZkNQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/144] 5.4.146-rc1 review
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

On Mon, 13 Sept 2021 at 18:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.146 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.146-rc1.gz
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
* kernel: 5.4.146-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: d4596c5864b2b967c1c1019d51b2c221d27e2f3b
* git describe: v5.4.145-145-gd4596c5864b2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
45-145-gd4596c5864b2

## No regressions (compared to v5.4.144-38-g2aced47424ee)

## No fixes (compared to v5.4.144-38-g2aced47424ee)

## Test result summary
total: 80368, pass: 65964, fail: 760, skip: 12652, xfail: 992

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 288 total, 288 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-android
* kselftest-arm64
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
