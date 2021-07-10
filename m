Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC563C34BE
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 15:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhGJNre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 09:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhGJNrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 09:47:33 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277DFC0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 06:44:48 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nd37so22258179ejc.3
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 06:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S0cFkdwp0bEWZTl2ElhiwTD0Iwt90QyTrrE3B5CNeyU=;
        b=uzm8uQLlWH/PUcfzk3WLalcBuhqRG1Rv4vEd4ZDPIiXe3Kh0kYQVhGmsvHAQA2vZHL
         tjlKRFY/5HfzRpcAM35L5ER9QItaMJcUeRkfTLyiYuFygTNW6aepM2UXldAOzzAN1zYS
         9vVUTb5WUd8SynvAOtT21C6bM0LcOhRsttLIvJzOjeajjjApuyX5+n9vMXP8SYIR/F8D
         qvgS7eASjPFJxPCqonraWfirD7RP4Vv5YmnioN0B+AtprkYZQ6Jm1mEkNmMrAKfk3ovT
         UPU4ePUnQ74eggIzWKDS/tMtme68oBy0mpVSi3xzRxwdlvS5YjNcSTBbL0QER/G6SvtW
         PWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S0cFkdwp0bEWZTl2ElhiwTD0Iwt90QyTrrE3B5CNeyU=;
        b=Ylt7eGjGHf+gkkygezICCh6rQMNIt2ntlLcIhqdv4geV9RAE76HGT8FnhGiEfEz7Qi
         zJhVUMQ3Qjoe+spf1/0rf9a5GNgZ+QF+Vj0BBHKmWfHFmnGL9mD59FSinc3yWefyYRDV
         MBbL2Yn+YPVEQE/Bkp0CAfbWMOgBVyicE1mABg8l5sw7vENJ62bIKC7DC5IYRqqrjEmG
         GNUvljebzgjcrIQm6AwbfzOWzVyVHKjSrPLWfimmSCfc6JJJwQMXgiWFAZtQ+ng9gUiN
         FCjebErV3Z6XM3/gX17CcUgPR6FA3ZBsHNzq5qKSNgP7fBBQ0EVJJGwYFQb+WLOVwCkB
         auqg==
X-Gm-Message-State: AOAM530ciLscD55Z7leNEE8Csx9PYHbhdR/HD+TnoW25nGCzmxK+oC+w
        rwUPRSstPyCzRyYbq4kR1LOClsdessru0rAu20p56g==
X-Google-Smtp-Source: ABdhPJz5I4BoUc63XJ+J0hN4mzcNW1rWKYOIrqWxNSz7sZ/wqntGxMbngLVSfZdD2cJk7d+JDIG7s2Rk4jfr0myT+ko=
X-Received: by 2002:a17:906:cec1:: with SMTP id si1mr24929089ejb.18.1625924686273;
 Sat, 10 Jul 2021 06:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131644.969303901@linuxfoundation.org>
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 19:14:34 +0530
Message-ID: <CA+G9fYsvDCBtxXO1UKfKLWNK3hG+g7QHJ4Gw27AMOngFKgFrhQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/34] 4.19.197-rc1 review
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

On Fri, 9 Jul 2021 at 18:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.197-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.197-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: df520a4397b2a281e4b2ac05b0c85f8875c3ea11
* git describe: v4.19.196-35-gdf520a4397b2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.196-35-gdf520a4397b2

## No regressions (compared to v4.19.196-25-g7bbc9654862c)

## No fixes (compared to v4.19.196-25-g7bbc9654862c)

## Test result summary
 total: 82675, pass: 62074, fail: 2967, skip: 15186, xfail: 2448,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 39 total, 39 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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
