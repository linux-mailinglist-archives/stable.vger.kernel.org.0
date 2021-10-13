Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F41D42B3FD
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 06:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbhJMEXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 00:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhJMEXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 00:23:01 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1021C061746
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 21:20:58 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w19so4608325edd.2
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 21:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MyPzgtbN2FRBRQB9+vczQucG7B5CsDm1YtOJZh2cUpY=;
        b=aMnhcIkcj/2ZVv4MGK8CM87IvK5sbgWMHyq8a4MB0H44sqj0TcJn/Yd6n+4PPVA0oA
         6mAqiEib4movIbqusc13qfpRpQ8yn8mpy24Q0O0RStRG9wwyWcZVdG0HCG6LVI5qjLNh
         WEO5oR8KrGk6+/i1AtaNwth+f/EsVeqEDB3bH2QFHWnZtpB0C/HX+xxjFNocIILzGiqR
         +/Lk7VveRsPRYFwzlfYeVOkM1W33906vDkRLc9E/1tIpCqD80G/79w6HbFAG7IkD63hs
         Nx5/X/ajLyHj/3yHmwbphC9J4xV5PaU9pgvrueDtvAvHRPBSuo6MecxUUK3pqoaEnVhJ
         b+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MyPzgtbN2FRBRQB9+vczQucG7B5CsDm1YtOJZh2cUpY=;
        b=ytKZZ0GYIUoQ8H4yrGuG3JpAaarC9eX9pxRXcsspUQJoPB/D1MVwX9JYXwvddYb0Lk
         IN5+doga1fiLqkpa8qBVPsbMerXnvJsIVIBj+H0sGzYVVWKUHA8cqYMJYowh3Q49nFax
         xkMZQnmComeV7uz76S9KlhsibNKNZa8e1z/APXKq4ITyRfOU3X4IwR84dbGSCymSjO6f
         f1wLDNkxh2TKrHqUdBaxxmVATZJbjqsfAROdVHRNfNwBzrFpAyrE8U2ctVfE30jfb2mb
         yNbOl81rQL8naJGNXOIPi227DhY9cYhEz/CHgFZgEQK3lUayuiP/Yitj+kFYj405Ue34
         Xwhg==
X-Gm-Message-State: AOAM5304k4vPHVGQf15hXRnibol2nuyCTH9yRQywDIgOY8oWASPlSzkR
        s9col6IAYKvBqCJO751OhwCUXVuNENFbev5m3VSrrQ==
X-Google-Smtp-Source: ABdhPJxfVwzl9WlQySbBO1qLYvXomRw3zNR2FI7w2vnGFOO+dpJaS61ip+TlmJveB7y83XfaV20uWDy8NEQL4x64KoY=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr39109688ejb.6.1634098857046;
 Tue, 12 Oct 2021 21:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211012093340.313468813@linuxfoundation.org>
In-Reply-To: <20211012093340.313468813@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 Oct 2021 09:50:45 +0530
Message-ID: <CA+G9fYsr9gzYqdr+yB42TPBsMUX-FTUE9a+xwsyJmf-NhhGOXw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/27] 4.19.211-rc3 review
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

On Tue, 12 Oct 2021 at 15:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.211-rc3.gz
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
* kernel: 4.19.211-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 9d7f82841498fc2d3a1dcaa988257501521dc37a
* git describe: v4.19.210-28-g9d7f82841498
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.210-28-g9d7f82841498

## No regressions (compared to v4.19.210-29-gdd0ad52a3bb0)

## No fixes (compared to v4.19.210-29-gdd0ad52a3bb0)

## Test result summary
total: 82227, pass: 65751, fail: 811, skip: 13675, xfail: 1990

## Build Summary
* arm: 129 total, 129 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 29 total, 29 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 21 total, 21 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
