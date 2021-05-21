Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1055438C44E
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 12:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhEUKFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 06:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbhEUKEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 06:04:53 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE0C0612A6
        for <stable@vger.kernel.org>; Fri, 21 May 2021 03:02:38 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id c20so29655488ejm.3
        for <stable@vger.kernel.org>; Fri, 21 May 2021 03:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/wHHEzOeyQrmNCaW2tS23FfdNlMbSDSVT0iemNZw4rg=;
        b=QlNbvvpjz8UXSwLR62zjWawiN1zk9Sd2x2tMJHXhosTGmBEsza/4EL9f1IyvS+d4be
         XKBbbQuwI/1mgtOjju8cUt2aG4o3xPXucpNQ3BqKlrdItdo+O1RzASUbfRzKiMqdTBuC
         BpWvYVwfhlM2LzYgubmzuEbIYSG5ASiegb6BqfUgBh6AOwJLWuCbs+FATHk31ePDcx7b
         6JJgbA1N5kLuwuRTiXpccyqLzofFL0Yyh2D7l/ifQRo4UTF8BEPqVw+yeYLUyDY71PjB
         xAaRhssG4Av+sg9LCns1FOJcyiMkBFpKbQIgG4fOd0hzsZeYr8oFMUC/2T735+BOS+q+
         qwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/wHHEzOeyQrmNCaW2tS23FfdNlMbSDSVT0iemNZw4rg=;
        b=rldfj16KZNerK0+7E8dVXg7Y+BsduG/07P3T6tmERpPtJh3ag64F4U28vTEHUjLSFU
         OvZsTGTjP5VzJm/ukv3J4EuH9mIzjr+HqDug83tOqa1V0K6Bs39KCqLxJKaSGWD4tK6L
         JOIYCMOsIOQLQEYT2wfs/UBbQB4yrqqpSvhRSuu6us2na0M9WyjqhQYeGGN+x+vXCa53
         Hg6lvEVhn9YUw/MF0i5r78ED114Q6jh3a2Dw3e606lEtJ2XyFpD5Hvlqte3mO39Zq1J/
         819Lt5upxWZowYu5RkByThoQsrbqDvpaCNEnEOa3gYSvLL5+HdSKimMXfuYvo1Jlyc6H
         abRg==
X-Gm-Message-State: AOAM533uO0vi9/9IFF43c+7Bv85CZ72ehq55d1d/u2iKt1NtPIBIC6d4
        ewknMm/FCu5dQc3gs7kqtzxONVkRIuHdA5YN2u0cGw==
X-Google-Smtp-Source: ABdhPJwHDlKpumbldcnv7G8+A7rVh2SGVN1ITF5GFy0agRp6tL47lFLJezXmy1kyDCnor0NukCKS/jcpuQfYlu1NLgk=
X-Received: by 2002:a17:906:4e59:: with SMTP id g25mr9448179ejw.133.1621591356816;
 Fri, 21 May 2021 03:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210520152221.547672231@linuxfoundation.org>
In-Reply-To: <20210520152221.547672231@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 21 May 2021 15:32:25 +0530
Message-ID: <CA+G9fYsOPio7aH_kGfdvuneuxt5oQVRSJmsXY2QEKz7jo1RH2w@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/186] 4.4.269-rc2 review
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

On Thu, 20 May 2021 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.269 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 May 2021 15:21:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.269-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.269-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.4.y
* git commit: 9d2abc11d0b5fe18f62908e3a918af52ac95b3a0
* git describe: v4.4.268-187-g9d2abc11d0b5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.2=
68-187-g9d2abc11d0b5

## No regressions (compared to v4.4.268-191-g580f473963dc)

## Fixes (compared to v4.4.268-191-g580f473963dc)
* mips, build
  - gcc-10-allnoconfig
  - gcc-10-ar7_defconfig
  - gcc-10-ath79_defconfig
  - gcc-10-bcm47xx_defconfig
  - gcc-10-bcm63xx_defconfig
  - gcc-10-cavium_octeon_defconfig
  - gcc-10-defconfig
  - gcc-10-e55_defconfig
  - gcc-10-malta_defconfig
  - gcc-10-nlm_xlp_defconfig
  - gcc-10-rt305x_defconfig
  - gcc-10-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-ar7_defconfig
  - gcc-8-ath79_defconfig
  - gcc-8-bcm47xx_defconfig
  - gcc-8-bcm63xx_defconfig
  - gcc-8-cavium_octeon_defconfig
  - gcc-8-defconfig
  - gcc-8-e55_defconfig
  - gcc-8-malta_defconfig
  - gcc-8-nlm_xlp_defconfig
  - gcc-8-rt305x_defconfig
  - gcc-8-tinyconfig
  - gcc-9-allnoconfig
  - gcc-9-ar7_defconfig
  - gcc-9-ath79_defconfig
  - gcc-9-bcm47xx_defconfig
  - gcc-9-bcm63xx_defconfig
  - gcc-9-cavium_octeon_defconfig
  - gcc-9-defconfig
  - gcc-9-e55_defconfig
  - gcc-9-malta_defconfig
  - gcc-9-nlm_xlp_defconfig
  - gcc-9-rt305x_defconfig
  - gcc-9-tinyconfig

## Test result summary
 total: 36496, pass: 29277, fail: 624, skip: 6061, xfail: 534,

## Build Summary
* arm: 96 total, 96 passed, 0 failed
* arm64: 23 total, 23 passed, 0 failed
* i386: 13 total, 13 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 13 total, 13 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
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
