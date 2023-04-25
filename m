Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E076E6EDF1A
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 11:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjDYJXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 05:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjDYJXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 05:23:11 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB7A3AAD
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 02:23:09 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a1e0cc1a2514c-76d846a4b85so2058040241.1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 02:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682414589; x=1685006589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIIgRt/0c70fpW7qbqR8z/oyo23JtS4KwnfJ7yD/xmE=;
        b=qubdF7gxqZxSXRZ9Tp+rK7WHwX8OaBHPOwA7xf8PTv56OQj92gb4AVdRR1bvhMs8XW
         y6Dr0zQEcTWMP14sh8REjXSJIfhJDW9C6Fj+prfZQ7jtY2h+/laU/FUKqh6WTHOqFttA
         H1fZaDC6RU93wzyQHXUC8ZtsLHdgG+YXBWJgHXY7D9GIVg0mx/2kMOQFePR0kGJlepIV
         7NaIrRmeD/J51/+Q8ifnfqfjJr0w7KX12/g8ZyUt99pvrViV2p3PhW4M7z48Z/HuwDum
         waBBQNtJoFdOJqtNGbqw1Mj6fbevTsHQCqzVG/xHF7AsvX4xpJScPeXn32qdfyiSuzsF
         83jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682414589; x=1685006589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIIgRt/0c70fpW7qbqR8z/oyo23JtS4KwnfJ7yD/xmE=;
        b=jFo1vBYeKQPZ/ZUsAfuAXPkt7yz1NCtRZjkNL4sCHKUoJOYCWwddjBF/mf0qOKAHkd
         YcLP3r4xCAYQ3Za4uvoTXSfk0eptrkBevOJdbeujgbYUacs0HFy5ZO/6FZ1cCPLXerex
         OkFUyH9lLvNY4tvmXCfYJLkK0i/5dN6HjUJWhGofc84qbHO09HZqzdHf5aDy6Y9Quwly
         G75s3yM2qbOrvmRJthpnyAStwqm+vBirUXk9rsDqKn2ka14kiZOAtqApcGrI11e+YmOj
         X5IYx7muGtIIiXGp/dKGzuiBRH4MxGYPEj6qXxDxgXqPOfXRMS/sYGiym/wK9FjsPUeq
         CwHw==
X-Gm-Message-State: AAQBX9ceZbvcF5BJe34sfBKq1XxmmQZuWjJ3t29n9qiL+dsJP3XgmyKg
        PJyg/08iQefdRFisNmI+EvJJZL3bB2f6kx2lEIU4ng==
X-Google-Smtp-Source: AKy350a7fBtImrtyDLvrcmmiYJg3F4l+VQ86P1Yr8QYqg2tPJ3QgS0gGwbPu2QfBmXQr3Z7kySj/FnEKBD6BMW3CaVM=
X-Received: by 2002:a67:db81:0:b0:42c:761a:90ed with SMTP id
 f1-20020a67db81000000b0042c761a90edmr7009721vsk.6.1682414588688; Tue, 25 Apr
 2023 02:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230424131121.331252806@linuxfoundation.org>
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Apr 2023 10:22:57 +0100
Message-ID: <CA+G9fYuxr=+xRF6QmK3+L5M7A6D7gC_ztaKpfzTNeffKukMX8g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/28] 4.14.314-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Apr 2023 at 14:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.314 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.314-rc1.gz
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
* kernel: 4.14.314-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 05f80276ba11cf05a736470e5c5e3a1a1c78dca6
* git describe: v4.14.311-134-g05f80276ba11
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.311-134-g05f80276ba11

## Test Regressions (compared to v4.14.311-105-gcdc53f89dfa8)

## Metric Regressions (compared to v4.14.311-105-gcdc53f89dfa8)

## Test Fixes (compared to v4.14.311-105-gcdc53f89dfa8)

## Metric Fixes (compared to v4.14.311-105-gcdc53f89dfa8)

## Test result summary
total: 83171, pass: 68540, fail: 3724, skip: 10732, xfail: 175

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 106 total, 104 passed, 2 failed
* arm64: 33 total, 32 passed, 1 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 24 passed, 1 failed

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
* kselftest-ftrace
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
