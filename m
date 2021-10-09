Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E6D427712
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 06:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhJIEMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 00:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJIEMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 00:12:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B9CC061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 21:10:44 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id d9so19656024edh.5
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 21:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jwIk6DoGEf9TP7Z80lA8E8gEbDecGq93ZrD08M5e2xk=;
        b=zMEZFgTrb0pkV+kKQ5PvtsYNFpS82Ub8EKQUkdbP1WQ8KovmWsPyR6nL50frcBp78M
         r22BDZoavEgQOOCwBHv1O5JpMqmJx6Bdgj/FlxFYohlf+qtf5PxqgbvnBcJ8+ysC+zG0
         wOWD6bYUePpj90sH3UWiKfVWjqa2jGsxcRA4mA4V9weDnk22wkpjchr9k7wzonACZitg
         +9puPyKJwVh0xEGU4uhuAllZQix6gjWOHBpDHpBl1XcmdHxZnafthXtqia+RG8zfgbUj
         xWoD4B//7o/khFcwdonu3ebr8QVYCMQTeEHVVbHuyluC6OokOjlljNvQSZNBDFPgeBBz
         iafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jwIk6DoGEf9TP7Z80lA8E8gEbDecGq93ZrD08M5e2xk=;
        b=KdPrmBD7AQ6HrQRl87JGMZh8EGBXUMm8G20F0zyRn2YHh/vYfh/3p/Gmly8CtYvGE3
         FWP1CF6p1Z1XzNOP/OmeUlp9kEiylXAeaaylhkDp3TzLgirenIF7HgCx3qn+U0ANaZYM
         PMS4pgszAjf8R3o2cTwEBo8TaMsimrf+wzcbfbnuIEKcWW2TzrjcHo6kJV1yGgRbaslp
         gGc4waoOCJlmYK6BHx1Xw7gC0n6OHy8cwwVruAKTM/QXtowI/z9AGvk1UQvTMrKLLiWK
         a76o16t7bOSho7L2TK04SeiprFLGgZ/wwrAfCYo+MMvx0xqwPHugesI9/3oPU+0fhMov
         N6QQ==
X-Gm-Message-State: AOAM533AYdtcVle13zgR5OqteYK0/nqoWMCY5eTdKQq8dNqBAXsx2d3O
        rsumAlvozS+TYI9SW/hgPTP5HDaWlf5+M35OPXNq5Q==
X-Google-Smtp-Source: ABdhPJxMgM7yXGhMNA3UWNlicUqx5KeTYQU8EKJX3OuypJs8Mz2lk6nB+E7gPuuOg18TLNcaeRrd63tbN8OPaMYAr+Q=
X-Received: by 2002:a05:6402:3587:: with SMTP id y7mr20650096edc.182.1633752642854;
 Fri, 08 Oct 2021 21:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211008112720.008415452@linuxfoundation.org>
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Oct 2021 09:40:31 +0530
Message-ID: <CA+G9fYvx+c1ANBqjpmvVZWw2f_yxNNGNx-d=DnfSsjhwpP2YtQ@mail.gmail.com>
Subject: Re: [PATCH 5.14 00/48] 5.14.11-rc1 review
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

On Fri, 8 Oct 2021 at 17:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.14.11 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.14.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.14.11-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.14.y
* git commit: 24e85a19693f1f7231d0187f165cb4dcbaa95125
* git describe: v5.14.10-49-g24e85a19693f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.14.y/build/v5.14=
.10-49-g24e85a19693f

## No regressions (compared to v5.14.9-173-gd1d4d31a257c)

## No fixes (compared to v5.14.9-173-gd1d4d31a257c)


## Test result summary
total: 93302, pass: 78578, fail: 1250, skip: 12589, xfail: 885

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 289 total, 289 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 57 total, 57 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 63 total, 63 passed, 0 failed
* parisc: 24 total, 24 passed, 0 failed
* powerpc: 72 total, 72 passed, 0 failed
* riscv: 60 total, 60 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 48 total, 48 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 60 total, 60 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-co[
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
