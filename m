Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09BA69E057
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 13:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjBUM2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 07:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbjBUM2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 07:28:09 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED469761
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:28:06 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id e5so4724264vsl.11
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 04:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676982486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6s881pmuKwph24asBcE5u5JIORQ5AHE6gdovKQqgyMs=;
        b=TPOMTNt0WiYkI2y93B0i8TZbPyD1GxgQWEaxNLI/oi8xc6ywzhHKusXaxgiez+3awM
         Bl/u0wNJ6PtNG2ofV2jsAyaqRlCKAJ3KEKh3SID1aEizECMvXv8J58p2sdbhq5vsy4iM
         gsevlU7g/a2qo41pKK3rCRGvv4BZ82on+Z/8t353kwfpEWO46veyFtWNVjkPStNCsGVS
         rRDp3qMyAKuAnRXw6k9+qgHWNr5yaSBaJxKgtmMTTNuZPNKlMaJT/DIos2Vsvi4FWfoq
         Iym2Wvoq+yx45h/2XAX2BH1s2LJaWu8Ucvsn8JsCP5t7XP3E7Tox045R43wvQJ6ytfvn
         hwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676982486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6s881pmuKwph24asBcE5u5JIORQ5AHE6gdovKQqgyMs=;
        b=I8qgeYUpHfZbGUFdR60eipWlPxiweAFpZBA2n/bHWY7WD1dHDeSsHjR6ETBGYYi1bR
         K36QOTgX+8UW8DtzBp63nB8vtRcp5YkSpZjQ7alshF3GBRG7bKt5UQYfAyWNPGnIe88S
         DTL6kB8n6Slg4mBqXP3ZST90+LZsKgGJGWkKDJhUTAXpKPuJg5HAI6i4pVck3LvHR8iZ
         RYvZZmWTImvzCP0eox/aHtEgnrHxazss9R0J3ZzaFj3JA9MpyH1IbsYdO+9Aph1JD9MX
         dYwzbSusupXEAWFKS92E3NouhfIVBIwzh3COnJiIUCgTh3VHhm9gjwxZM0Y0f721/9J+
         f4eQ==
X-Gm-Message-State: AO0yUKVdVF4JKzNisJEHE9LNhZqJ4L5xwUeYKjwdzjon1YcNCSA2v9z3
        ka9Sofm9f7RWMQxRi9CXAAqUKlRHqbFMPyUYNsG/UA==
X-Google-Smtp-Source: AK7set9CgFAXa8X0dpmM5jq8DddbwBC8HpXgS0UKe/A1/EqRqLiIunwYtMqRjMGQ2584zHktQaX59LdgAs5TVJ0D6Jo=
X-Received: by 2002:a05:6102:a24:b0:41e:991d:8814 with SMTP id
 4-20020a0561020a2400b0041e991d8814mr223496vsb.71.1676982485594; Tue, 21 Feb
 2023 04:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20230220133553.066768704@linuxfoundation.org>
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Feb 2023 17:57:54 +0530
Message-ID: <CA+G9fYuXJVQK-a-EVR+Z=ihgEwQPsaF9kafW=JYWpY3JztsYRA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
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

On Mon, 20 Feb 2023 at 19:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.273-rc1.gz
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
* kernel: 4.19.273-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 717ab64d0adf6544c30105e64d851b388324c7ef
* git describe: v4.19.272-90-g717ab64d0adf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.272-90-g717ab64d0adf

## Test Regressions (compared to v4.19.272)

## Metric Regressions (compared to v4.19.272)

## Test Fixes (compared to v4.19.272)

## Metric Fixes (compared to v4.19.272)

## Test result summary
total: 108520, pass: 84162, fail: 3369, skip: 20591, xfail: 398

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 232 total, 230 passed, 2 failed
* arm64: 48 total, 47 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 43 total, 43 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 57 total, 57 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

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
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
