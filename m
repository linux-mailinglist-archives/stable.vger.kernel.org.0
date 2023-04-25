Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F966EE3FB
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 16:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbjDYOdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 10:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbjDYOda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 10:33:30 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E68114442
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 07:33:22 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-7756904cbabso3958210241.3
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682433201; x=1685025201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQ2CLAjMPgKbOZe4brMjde1QLHkIgbVunV88zomi5KY=;
        b=QSOxF8e2muGNZob7KuS75YfJBtMdxjOuLe46O21qktQ+fC1TxNejM/vKZelejgPkSJ
         Z2cQVvS8kWWMKlVg5wlM5bsl5FzNx6n4HkbqFHmC0BS6FeJq2zVuSMnIPOCqdApDolC8
         wrLd9RRJJapVfcfLySyGHOMmgG3TIGGmolWSzjlkSc1d63pgfiNQMRXc98EYnz/PlGgN
         oJXqqtCY+nm0Y8FaMWXxO4XGUose6KR2aaYWwfe6Jb3bub7G2BlvBn9GLWAmiiTuLvts
         osduTNr0RZZ7LksOlBptFLuAePl8noMgCOF653i/zNg8vCJFZP+WOsu0RBt0InLcYYH8
         xUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682433201; x=1685025201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WQ2CLAjMPgKbOZe4brMjde1QLHkIgbVunV88zomi5KY=;
        b=R7qQKtCJgxcMGUvVrNz3CyJpNzFKL2Vq8dwX1ZKVcXKVUlK95Cjxjbtgll6Dy5KkdR
         0AmD4dL9FeW2wEzkGBTZ4/fPLgoQarwLZoanh+UbdoKvS9emUJ42bCDBANEwAYgphFLd
         2QIgX9DCWaNjlqlXANPo3YtBkHpPAbKrM6Mg6weOHF/ZIG5dI9yY4YEnQ3eXs8QL06uv
         wQmul0IOF7WGGEQ72Vhj/pqW5vFTIRz0tnz53BuiZ8GMCiRIjiiaM/8xr3SHT+2RAH/m
         jkenVhoxlfqueQaGllydbDqo0rHruAZGpl7M2LPbnlrhBzrfMJ/BN1sVZ99d0iEXTJ9Q
         jxOQ==
X-Gm-Message-State: AAQBX9cjgMpLS27/ICVXK7COIgwz8MjNmRQpDhN5p2r3644omI0iS53V
        raabikC3yLqudWxO3NnolDE5sqJpBmFpAICa9sUgFg==
X-Google-Smtp-Source: AKy350YX6AwO0pQHfBFGLNBOTtx5pYpGmcG+rrY+6QopEdOgUNUrMvxAJKNFhncmK2TEboB273ZjpmyipgS8gxjrLrU=
X-Received: by 2002:a1f:bd0f:0:b0:440:d7:da79 with SMTP id n15-20020a1fbd0f000000b0044000d7da79mr5766207vkf.2.1682433201450;
 Tue, 25 Apr 2023 07:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230424131133.829259077@linuxfoundation.org>
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Apr 2023 15:33:10 +0100
Message-ID: <CA+G9fYvc__9umKyeMWk1mmO6K6hfCt=MDt3BTHpr_XfJc4HXXA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
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

On Mon, 24 Apr 2023 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.26-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: e4ff6ff54dea67f94036a357201b0f9807405cc6
* git describe: v6.1.22-574-ge4ff6ff54dea
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-574-ge4ff6ff54dea

## Test Regressions (compared to v6.1.22-475-g45df5d9a8cbd)

## Metric Regressions (compared to v6.1.22-475-g45df5d9a8cbd)

## Test Fixes (compared to v6.1.22-475-g45df5d9a8cbd)

## Metric Fixes (compared to v6.1.22-475-g45df5d9a8cbd)

## Test result summary
total: 155536, pass: 137480, fail: 4021, skip: 13697, xfail: 338

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* timesync-off
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
