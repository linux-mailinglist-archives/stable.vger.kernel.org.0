Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6E33A7884
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 09:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhFOHym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 03:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhFOHym (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 03:54:42 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3742EC061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 00:52:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ba2so48042408edb.2
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 00:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yVDLROW+cc2NklY4nTrbkoEJKCrXDgyIGjdGeBc3LeM=;
        b=bIIzNQR7J0g7KHUEkIvEg4aYhCwpyd0Io/zW91leuuqY9zjyHYPhjk4O0wxl99bYrF
         La5kdGdevJ2XEHNRpHn+2P24Ap5QQlG+Zb+moiYXgSdhsFyG5fIFZKMFPGaIqBhGmFrY
         jmy43LRiBa22hl94V3MVlGPz7uyDO0XC4/vE9PR6ZMlTqTaR35+8O8SDnuABYE7aRhB8
         jWxE1Cxa8eD4fudwIJ4Ij8B4V2x1fAqQqVo2P0xkcGTryGalPC3p4xE05W6Y1m8AKkkF
         dgIweKh925Oa//PDTyF+o6bC2GiKwWZF4ORt8oaxWTR6VtleQnkJ884C1YO3so1nbOWC
         yxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yVDLROW+cc2NklY4nTrbkoEJKCrXDgyIGjdGeBc3LeM=;
        b=TU9k++oZpTaHqCPbGxt9iSrRWIcecGg4AAozh/yYFt2jwBWp/XzF/jyC6HLiThAxIy
         04sOFNu7ThnQ9Jsrd3+dS90utLKU7o2S7CMoEvDjkO0eJ5ioIlI9Tpb/vbqC3GBpLwVH
         8FwPgdBpMQIDlAP8vCn4Jsk9yVT1yURhQmWPssKdMJQ/8V97JCZmQnCf4fxhGZJtfa7x
         rId8Tbyvsq8go4QlBcBY3tJv3FrifHC1lljtFPlue+UyS9cOxKr65gBDpeIApvj57grs
         RfboXRtM8xJrvFDDvCrPQthoVwNixsBLcC1oGZZqsAK0b4AqEZXv+ZDfj/VWrnEBfP7q
         J63Q==
X-Gm-Message-State: AOAM533cc+Ivw2gzHpTW5a/rER4daGpyQflBIkD6yV5Di8NoWPZa2w8B
        5shfwjRMXAaDSSxcK8FoigLCWdtJjbn3PJqcHjaqgQ==
X-Google-Smtp-Source: ABdhPJzj6mUmcDSisIei5ho225JafAtBa3U0v7QrmrwJUde2R3vf3f09jakhAa/0/jVP++O7GQzUAQ/1hSO19YikP5g=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr21327593edu.221.1623743556707;
 Tue, 15 Jun 2021 00:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210614102646.341387537@linuxfoundation.org>
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Jun 2021 13:22:25 +0530
Message-ID: <CA+G9fYvYSjc72KOhwPhy3PP_hatzFgAKi6o_opKwXq+841HuTA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/84] 5.4.126-rc1 review
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

On Mon, 14 Jun 2021 at 16:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.126 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.126-rc1.gz
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
* kernel: 5.4.126-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 4a2dfe908c1ec200cbcd6d22b4d37a52086af057
* git describe: v5.4.125-85-g4a2dfe908c1e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
25-85-g4a2dfe908c1e

## No regressions (compared to v5.4.125)

## No fixes (compared to v5.4.125)


## Test result summary
 total: 67279, pass: 53957, fail: 1343, skip: 11000, xfail: 979,

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
