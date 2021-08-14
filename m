Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5787E3EC30F
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 16:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhHNOE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 10:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237921AbhHNOE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 10:04:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0AC0613CF
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 07:04:29 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bq25so13535503ejb.11
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 07:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8/fhOqsko+piDK6QIKsOkDMnWLeq6SLA1U45eptyGsk=;
        b=YfBpEzh2nzpytMd6VbjJEvoQFkBZoJqFFxH/Ddnx9/df1SmZfmlBISUTTT6arHEtTa
         clE0Usplw87tPl7zzgzIydjJRGgI7vK8OC+x7JRiRexWKyxDwFuPCxsNt9aamkKWOkI6
         RCHay3h3m8oPksd0AVlecAZzrnhs40HhPofXqNm1p3MIEzCQ9BNAW7ET68oj+fv5HAwn
         TBExtPNyf37tYg7uDCSjfQusSS33byDfHxF9G0HbiufaiLuNV3eJTpgawANigSdT8+af
         DUCmDPokK+m5XDBwlAI9ShpVzJzb9CzMYRgUXv/sqmVWbLyBBdv8Te+t7TXXpReiHhn5
         IEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8/fhOqsko+piDK6QIKsOkDMnWLeq6SLA1U45eptyGsk=;
        b=uZ70J+kLIVbPGNthbd/DOJPGnmhkwMeK+FGV8qzJqK8QEB4aJJUbu77DikOmhJQ2B5
         SgceV8Db1DIiDqu/WdKKJiWuvfUINFQX2Ddl/3MWvPodqSMniQDGxPsE+vAFAopdfJN3
         WztE+ox7L3RdNgDwG2ZM/q3ZKXJsUQRbeMvmhLjkq5jSGgQQKrHo4op7Iiz35rNdEE8B
         Y168/rE9qHAKmvy7+ajFJ3NeY9m5dAQeKZZZejzptoNgY696LCLEpdYrpMvL6lqBcx3M
         Lt3XcDtmVtDmKhmVmGB/rGyletriyZNeyIkTuZvVLYXTkmIC98ZyarmvGNEM3leOEbid
         n3WA==
X-Gm-Message-State: AOAM531osBGLyE06H5UuzgXZYAOdlnkOJ+t8lIsJZaV7Y2tzg0uP9+HH
        TwrgbIEqJb3L3v+Z4Vu1aeEkktMZ2Lkg0ZjT5rkU9w==
X-Google-Smtp-Source: ABdhPJyK5gOzl42h17sEo/UZ7PfPJZo7WV+zHxR0eJidXibt0IX7idtKfSxMlXEo3yjwRp2Hc7p+/0MfLKALoXfWpMM=
X-Received: by 2002:a17:906:40d1:: with SMTP id a17mr7616128ejk.503.1628949867392;
 Sat, 14 Aug 2021 07:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150525.098817398@linuxfoundation.org>
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Aug 2021 19:34:16 +0530
Message-ID: <CA+G9fYtsCQOL2KHcXpRqVQ8mXWBGPVQLbr7NcEGGKv8-JTHW2w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/42] 4.14.244-rc1 review
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

On Fri, 13 Aug 2021 at 20:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.244 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.244-rc1.gz
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
* kernel: 4.14.244-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 075e1c248317223f321e3f13377e1fd6d2d7ee84
* git describe: v4.14.243-43-g075e1c248317
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.243-43-g075e1c248317

## No regressions (compared to v4.14.243-39-g7d5ea050a415)

## No fixes (compared to v4.14.243-39-g7d5ea050a415)

## Test result summary
total: 73624, pass: 58097, fail: 677, skip: 12835, xfail: 2015

## Build Summary
* arm: 98 total, 98 passed, 0 failed
* arm64: 25 total, 25 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 15 total, 15 passed, 0 failed

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
