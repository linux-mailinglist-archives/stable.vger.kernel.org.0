Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED53C6CA3
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhGMIwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 04:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhGMIwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 04:52:31 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1C2C061341
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 01:49:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c17so40025716ejk.13
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 01:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g/yfFiQI6SsyaCP65eQfttE8/fWlGgjgVAsURdjrUTo=;
        b=M0tN6iSrKci7SAcdy2LJyu/cey0629XNJ5wup6yzbDBMtbeTHivUKEQvIPlR0Kq9Va
         8BsQxoVWI6GTDTVtZbCxMcns5tsuvt6lJtWPmOgGi8ISWlM/CyTceSIKNKyxeqBMW0qp
         ntpTbQEhx31kKGleojPSgXdLL/M4p9E81DrKaSCq69BQ2bbZkRIBu7FYhsAX/UX7Fr71
         7NcHdGSm6yqPeHaeI0GLqdRazfEWx5dIuFKXAvrMbCXta4pDC6pjtiqu3/vDg94BgLZ7
         f7v//j2vA/iOJkFHB8mUjawOdF1+b+hG6tCvVZiLdoTz+VnIh7an9gI4TpFJq+uAvEA4
         Qy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g/yfFiQI6SsyaCP65eQfttE8/fWlGgjgVAsURdjrUTo=;
        b=lDhhf3bx6N9t2yAyoLJ54cnXs/fdCLOp9vy0fAgGwkuH4a6WmkxEW97hNzv7n3DaqH
         hfeDpV7zN3qWN830pu7WTSB+u357o5FcjqEakujByz6//6eCEI080uRfOGN17wNGQpb1
         TG6a783USdsH6KOeHhzS7V+dqeBmbToqpQb6hPIH74YhihdQEDgPaLrykLfWvr1J6irn
         sg8ppJdYKEzFuXUnh7ra3VVEyr4Wn56rNCcSR9NV1aD5F0IgXqdiqcxruo7F/X+PDPuW
         fb46WzHh572x6Rkm07dmy3ne2ZMH1YWJIv0ZJvX9VW5Dt8OdKcOEbujOCo5u4G3TUjG/
         DQVQ==
X-Gm-Message-State: AOAM530xcxJCycMM3nnaSTtVDzACJ4UDLzpUPnt5gjEcpTYNRoyuv2nr
        nRPbHAmtnzM/DL7koY5tatmGEkqXAxfqnjHY1XBvBQ==
X-Google-Smtp-Source: ABdhPJyNZ1rmspgxu8nBplT/BItEcTgguLuCVgVnd23jxn5m/g9jxi5vorqZjV+v0J9rs1bSenOJEohaBBelMHokgw8=
X-Received: by 2002:a17:906:4b46:: with SMTP id j6mr4347138ejv.247.1626166158159;
 Tue, 13 Jul 2021 01:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210712184832.376480168@linuxfoundation.org>
In-Reply-To: <20210712184832.376480168@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Jul 2021 14:19:05 +0530
Message-ID: <CA+G9fYtKs9fGCSPNwKtmgFKd_2auqKVCbOnV-mGqvv+mpxc03g@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/598] 5.10.50-rc2 review
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

On Tue, 13 Jul 2021 at 00:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.50 release.
> There are 598 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jul 2021 18:45:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.50-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.50-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: f820b41f4b3e043e9c7a8543e703f2749fc4f931
* git describe: v5.10.49-597-gf820b41f4b3e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.49-597-gf820b41f4b3e

## No regressions (compared to v5.10.49-593-g5be87d816c6b)


## No fixes (compared to v5.10.49-593-g5be87d816c6b)


## Test result summary
 total: 76306, pass: 62225, fail: 1938, skip: 10988, xfail: 1155,

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
