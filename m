Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E33C34CB
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 16:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhGJOIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhGJOIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 10:08:23 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A57C0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 07:05:37 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s15so18583831edt.13
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 07:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EYwqPF/Efyc/51Og33CRU1VurVxgBcOLAgbCveQdHqc=;
        b=Js/sNv5bECh9nP6bOR4pevkrlWEfNrCchqyUTtblwQs8gS01hZNHjg189/wy4YMHgE
         34QdFmUf4zVxRTjuVMi18B/0w1ON1RKc/5Nj1dUn9c9WkkZpJHLKhvzmQ0ZCP333mk1F
         zIaijOk9YGp/tbSowpkggRlwHovxW9CE4QmhmVCB9qXVQfKFtcouG+SbT9u1rtnJgJAY
         pTRjSHh1JIH35UhuCnqwhGFlQbfqbI4CneNocNgzizyHe9JvCVrr5Dl35JcgodPkfqR+
         +B8A1oIN1cAceOcPBfL+oM+0skIXsnB7LV/W5zFpps1aUoo/h6MsFJBn07fd24GedOYw
         hxOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EYwqPF/Efyc/51Og33CRU1VurVxgBcOLAgbCveQdHqc=;
        b=Vzi53V14sB+nuseqCEhh+LmGJeLpjXJGNMRhqX4+LMvibjcVW8X3jcTzyLUwRC0CHp
         9f6yF8CtLIan2znEQsiPo5kJ3iMKBglrr+OQJ/Gcc7zh3Ss/jpf7wjiX/grGr9os9FVH
         +pIbuJY10+Ccq612EgTk7L/EVTC/htiB0X5thkiCvw1yaE2xpEpAf9YFLTd3+d/Gatmz
         m9DYiZebmTvPSEae5hXw6B9l9bKvXuW7Th5MQHlGP1Smun2GM7NRg6RhXlj2NOrh2NT8
         adUzp4mbN8THhmkg6N43ws2Y7JCzbwBivZtQOgej0VWMo6RMvAxPmOTVjmzBMpAJiNMD
         TkhQ==
X-Gm-Message-State: AOAM530a8QQ8DLhBu/b3jGslbAc4J3ShmrIVagr84hFeuTjyPuXV3l7Q
        c1QNnKsE3HO1Dw+QaodFwA0Ar0TeB6wu6Zu25CbrjA==
X-Google-Smtp-Source: ABdhPJzrFD5UQZXt9OAU76wAjkdfw4LYgKlh++OOD1LfW8Du8j58JVEcvCx/XMxDQwNZ+6kcWp2WbmYuGxirdjamb9k=
X-Received: by 2002:a05:6402:1e8e:: with SMTP id f14mr40981426edf.52.1625925935363;
 Sat, 10 Jul 2021 07:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210709131627.928131764@linuxfoundation.org>
In-Reply-To: <20210709131627.928131764@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 10 Jul 2021 19:35:24 +0530
Message-ID: <CA+G9fYtqJqR2_cL7B8SbBJkQuhwx+TLGK28TwaJm9tLCJ+O6Xw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/25] 4.14.239-rc1 review
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

On Fri, 9 Jul 2021 at 18:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.239 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.239-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.239-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 89bdc2d2afb34594a4865d7be3a8b4b898e0d955
* git describe: v4.14.238-26-g89bdc2d2afb3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.238-26-g89bdc2d2afb3

## No regressions (compared to v4.14.238-22-g6fb138f75307)


## No fixes (compared to v4.14.238-22-g6fb138f75307)


## Test result summary
 total: 66243, pass: 52214, fail: 682, skip: 11377, xfail: 1970,

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
