Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBA3671797
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 10:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjARJZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 04:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjARJUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 04:20:37 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6CD47ED4
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:38:09 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id 3so34961044vsq.7
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 00:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xSpb9k1VQIhesAkOYuaD05lW2+xLG8Wkaag5mS/rNM=;
        b=bBoTlcpchQEAT8sYNjdVDmytBYHJotBKNLXZfjDqsEqKC/jTQNsOuGsBJNUg2cE+/M
         xK061uO/lGuoHIP5AOS0FzmmOFoSoi03wnzYL4RxWZ6At8vHJrVU6vb4AmZgO+IEICEJ
         f5ibDbvPnN5XVdiNxsaf++zPx5NdT0CLRGs+1tCW56D00nvt23R2sBwUuwdJ0B7S6IBC
         654w9R7KxamaOIMRE7FWa6lu3GSCL6XHJm7bTIeK1hc2UCBJaC7omCeM9yA3QNvrV7Gk
         T9OJ7yyfxmQtjJCNflsSjjfqJxLlDJNQkNhU1iVr1FX1wRmwUkk8D8zRZY5mAJYbublm
         eQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4xSpb9k1VQIhesAkOYuaD05lW2+xLG8Wkaag5mS/rNM=;
        b=0F7XdMHUajjXFh+d9Ml90Z6DccLDpdw92T4zAoOwdNww4scmXnpyEH3ut5+LLB4M0U
         xFhznk7NS4R8r1M7P6m0meMrhLvyppnMWBfD96GlHt07+mx9Eded5b4U9HRs2VyUYIjM
         0UlH8Fduxe6ySTkwYJFBoBSBOqbBoc23r33SQ7JSIQSqkW0tgEdu+IAk9M1P6CqDF+Tf
         vGoCPNEo6a1y/WSNpeQpr9UEU4fbT5xBS2HQY2IeOtHKLX38dxWwJUpyhv6AbBWDFqcy
         HJK2UdMzZyQkxEWBzNKnWGRUHii582tRUSw9F+H+sF0c+E/bgXGHxTafsTeF4O9Zf0O6
         OdPw==
X-Gm-Message-State: AFqh2ko0tIlPxQrrPzKCK/21sWTtqyxlmzA5N8v5gN6Hsq3tuE060GU6
        I+/zgs9kFj/iNYygBcncjRAAB4E32wFY6OdQo5yu1w==
X-Google-Smtp-Source: AMrXdXv3lM7bBzKfS09f3aOeVbB2umM972cC+13zP+aiQAy3z7Ci20mCWR4+fGIJRkSe2Mgv2EqRZt7FhE4IiH07Z78=
X-Received: by 2002:a67:f9d8:0:b0:3d0:8947:f6f6 with SMTP id
 c24-20020a67f9d8000000b003d08947f6f6mr845609vsq.3.1674031088396; Wed, 18 Jan
 2023 00:38:08 -0800 (PST)
MIME-Version: 1.0
References: <20230117124648.308618956@linuxfoundation.org>
In-Reply-To: <20230117124648.308618956@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Jan 2023 14:07:57 +0530
Message-ID: <CA+G9fYus9p1Qu7HHxdphBcttDtGC8_J1w1Rn+vEPY4Be3epp=g@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/622] 5.4.229-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Jan 2023 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.229 release.
> There are 622 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.229-rc2.gz
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
* kernel: 5.4.229-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 11f7238df0b49d924647889fa54e04c023811200
* git describe: v5.4.228-623-g11f7238df0b4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
28-623-g11f7238df0b4

## Test Regressions (compared to v5.4.228)

## Metric Regressions (compared to v5.4.228)

## Test Fixes (compared to v5.4.228)

## Metric Fixes (compared to v5.4.228)

## Test result summary
total: 127769, pass: 103864, fail: 3495, skip: 20045, xfail: 365

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 30 passed, 7 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
