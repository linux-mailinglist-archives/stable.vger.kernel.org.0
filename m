Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF65C3BC5D8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 07:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGFFC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 01:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhGFFC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Jul 2021 01:02:56 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D915C06175F
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 22:00:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h2so26263011edt.3
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 22:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OWON0C/Or9+ya+RE2j2G77Yk1T2sTxIEFoSDvz8HHlc=;
        b=JpRj/5h6fARkqrrr6mIFZMkl8QpkKtlwVKK0Q0vmlZTCKEJTsUoM3cF4I0pdxfVCB0
         PUnlRtZ/KaARZTXIki2AT72PDW7J7Ahx6xHoMnQ8PgFMqrbgsvGFe1WNTJ6KFAY5HgO0
         63cSvL78tydN5b2xrQJoX12JA3k2sdqDoFGbp5rKj6RiEcCaIlPfygULw9p9Gs1DR3Wr
         /M+9c2/BpOGUEmxAijdUCtLaLm4T0zFHDMl3F3fzeIBvxH5ZlTWm46YO8Ok+9ResQb0R
         hOIRfskCgRezNZYoc70p5DLiiH4nH5z2jYHp2BTNdW/vwypFgW+NaHj0BT20k1nXZiPx
         0NMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OWON0C/Or9+ya+RE2j2G77Yk1T2sTxIEFoSDvz8HHlc=;
        b=fPCCtss3K3/x8m2tWHOfUTl94uOFnOjaGPnpUia2ERLUSwx/kNKQOmOItgxfCcQVVH
         QlD5VUP406zWBkJX6qIqQEy1Ce+5V33Aj+U0xzbbdK/KWKzfsR+S0TrfPQLvbAh2BA7q
         tI58zfXZMry21Jux8Y3AvDu/uI2SHd+wzwiGSK7AqC8E+fuYvsLdUUC2n9emgxb/fm2m
         W1vARyx4mZy2oFPxRWcK35LfS3AVTHgE/gwdC2MyUNpSCFCxqi34jvWpL/JlUmAXBF/I
         pXiyBID/ygA59OAlwqRd7lt7hwVDULOWVI9WsCOnzGDFmayWbYvoKq8Li3jTVZzaJB3w
         qXNQ==
X-Gm-Message-State: AOAM533sgDI0tkpj7KDy71CZjG+UkAlSOnahYX4In9LT8F5feeuetAr8
        qDFXnMTlz/BEGQt+326E6ZMU+xq2uvp9XlpSVlc92g==
X-Google-Smtp-Source: ABdhPJw7UEQyBkUGIFi2G7BgcRszfz18UpwSuERJan/FflE7hoF3u6D8KFDIzZCB0VVHm2mrEfjZaWn81gJg1BKS9WQ=
X-Received: by 2002:a05:6402:90a:: with SMTP id g10mr20295492edz.365.1625547613531;
 Mon, 05 Jul 2021 22:00:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210705105957.1513284-1-sashal@kernel.org>
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Jul 2021 10:30:02 +0530
Message-ID: <CA+G9fYvL5tPNNhpjrSFio84kLd_m9sriTobo3Lpwc7E6innDPQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Jul 2021 at 16:30, Sasha Levin <sashal@kernel.org> wrote:
>
>
> This is the start of the stable review cycle for the 5.10.48 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-5.10.y&id2=3Dv5.10.47
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.48-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: dd50b7327ff62c603651aef64089569dd293b34d
* git describe: v5.10.47-7-gdd50b7327ff6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.47-7-gdd50b7327ff6

## No regressions (compared to v5.10.47)

## No fixes (compared to v5.10.47)


## Test result summary
 total: 76152, pass: 63402, fail: 1638, skip: 10082, xfail: 1030,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
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
