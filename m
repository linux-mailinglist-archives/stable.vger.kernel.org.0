Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366C5677901
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 11:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjAWKUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 05:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjAWKUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 05:20:52 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C00F113CC
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 02:20:51 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id u3so2755520uae.0
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 02:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TI723EaFJjCdeoH4wD1/6ZdZyl2LVs0sMMO9i4WaGY4=;
        b=wLbR1B1AiDQfW+6n+hB/BJT+8xqP3s2dFpN77KkfgbpMkmwMLSDKXNe8yd+/sMECuV
         HPsBjAAd78teRFAHuVxSHzhjWgJ3MtwAAL9HUcQw6G27XoWp1afLMIWlQpRvhQLb0qK4
         E5ec6rRUKu+cqK+07iiq5XxxkwzWKXZyoKHZBbisCMiF2kez4tQCf8KAC7xoizmnKejZ
         xDK6Y6OEgWMkOLaH/PL8VPcW9yPqFHL4aTfa03aj/y/Kh93T59dy+DwJcwIzqRsKbqYQ
         bfA96JI6Y19+n1BojeliZa2mFegQzRu5JkcTEw8FH2TDc2fkxZCU6sbbMyKUiseTd+Fe
         iFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TI723EaFJjCdeoH4wD1/6ZdZyl2LVs0sMMO9i4WaGY4=;
        b=0jWKJkYdT1y8yPT7Px71SQkAH2Yg65pxuhrkEBUjaCq88tHbjDfy/duwBRTD356zji
         v9tlYm2E6LIPNLYgkW+xLO8daj4NXn8cSr6S9RarMD3bYl5fqDrEQGoZdYCxR5k2Yieu
         F4tt5bZxjFUjcqkWxaDoY1J4x3kmMWKM39MdBGfjJQtGKt0duGXD/H/87H6vWGJIjUHW
         42PphangeoAJdPrGb6ksMwm1NL1B24WxLfNBV+HbbTOxTdyRwjqmHgc0M+Dv6s3pbLCW
         xOnP9Kner4t6DTf8gino7gi9x5S4H7Qs7Hlg6NW0bJ6HEhBvtgrfs8P1NMeOQbQRIzSb
         EGVg==
X-Gm-Message-State: AFqh2kpNclWQZM07p1Npl5A5hSyUF0voFhcZICavy21bmO9FxoQoLYMo
        /vsuYPU3Nq0keYmbPx9wVwN2XfuqJfq22aaUiH49jQ==
X-Google-Smtp-Source: AMrXdXvPpBqOZ6ZrU75vkHJR7YvKofdAVwP0hqGp6qmq6ZD/vpJtf0AiHrYN4kxiTnsWuS5maEPnOh4kM7ILh5qEF7A=
X-Received: by 2002:ab0:60a7:0:b0:628:73c6:a79a with SMTP id
 f7-20020ab060a7000000b0062873c6a79amr1442179uam.92.1674469250002; Mon, 23 Jan
 2023 02:20:50 -0800 (PST)
MIME-Version: 1.0
References: <20230122150217.788215473@linuxfoundation.org>
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Jan 2023 15:50:38 +0530
Message-ID: <CA+G9fYtS6JFVBVz9ajtf9-6NmaTgR5LqsjD93BqSPkuEKSkLxA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/25] 4.14.304-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 22 Jan 2023 at 20:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.304 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.304-rc1.gz
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
* kernel: 4.14.304-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: a6d71d85fd0f5c89a0e3aa52de437d22485dfa61
* git describe: v4.14.302-364-ga6d71d85fd0f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.302-364-ga6d71d85fd0f

## Test Regressions (compared to v4.14.302-338-g558d1df6006f)

## Metric Regressions (compared to v4.14.302-338-g558d1df6006f)

## Test Fixes (compared to v4.14.302-338-g558d1df6006f)

## Metric Fixes (compared to v4.14.302-338-g558d1df6006f)

## Test result summary
total: 93929, pass: 80837, fail: 3353, skip: 9633, xfail: 106

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 304 passed, 9 failed
* arm64: 53 total, 48 passed, 5 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

## Test suites summary
* boot
* fwts
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
