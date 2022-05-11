Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21358523116
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 13:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiEKLD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 07:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiEKLD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 07:03:27 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD26546AE
        for <stable@vger.kernel.org>; Wed, 11 May 2022 04:03:25 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id r11so3262424ybg.6
        for <stable@vger.kernel.org>; Wed, 11 May 2022 04:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5gx0qv4oj6Khd9ViuDuWKFlv4gCWdPBs4/L/qfy1HsY=;
        b=MXKVbMCwnKjBH40EuE51VQgLZoLd4/x8wKj+pcV46CxbNBW1umtTAlOjnZIY4ZugVl
         fJ0Zbu4ocL1dyGM2J8qGfsfe8sv9tgiXoVCX4kwk2sAx2nPvRW0WcmqFlR4wm3ZuuV2/
         4IKZ1Tfx+lTq47YVLoeLHP3i74GjCUzmdxnWDiccCPAyxoyaTIeJPzkpADAmICK5MMnk
         UXtiXSzfmUHlKjj7jyUkhgzwlMYBrpvMmd03UYz7BC4bCEeD4TzpwmxehlzHC3gUpGu1
         cgWJJFbZTnlaqbb0n7rn60kh18Fa+bsbpzF0LhvK2Ul32PJo0PpkkAAiR+851/fassnT
         2Grw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5gx0qv4oj6Khd9ViuDuWKFlv4gCWdPBs4/L/qfy1HsY=;
        b=rlIiXrE/mBX71/JO4+Ly+iqqGE0yu8/13WuXWV0IAOdMX1Dd5WkrdyEUBQ5r6b47+i
         1NXeHd/D7WWqYAoCtTSpx4YPJU8HoZfq5LSJFA2ADxn2VcJKBW+Nq3BN9AslLaE6DIgr
         CC0+W2Ohh81U8uPCrr0Jk10stZE5YSK3dSOKAm2/FLEEYFpFFDPYJMRZAnTEpcU/Ysk2
         9ZRPX3V1J3Yg5aFnvCsKfno7ng57ZeZZOj6zfx7YfySGfBktD5CeHZvsGby04+kJRkIN
         eYqTOwh9uValG2EVMrevanvOSGgiRRT7apjjTen6yzH8nDDdqPYNK9QchqItlUZdgD0a
         1bqg==
X-Gm-Message-State: AOAM5336Z6TUVrliFn/bJah/hhpFJMCvF9L0w09zyahXkMaJP3dzdWXi
        hXYXu8hGeQ0Mj/l1352M4+BEuj8tw/Xf7f6avETLrQ==
X-Google-Smtp-Source: ABdhPJyjoL2KLlsD33fYfEqyDUgTr5xWTczApnrCoqzdTo76z0+XFx8wmvmseknRSPf+MmPv19IrqUdn8hBWe0S+898=
X-Received: by 2002:a25:d193:0:b0:64b:3bae:9b29 with SMTP id
 i141-20020a25d193000000b0064b3bae9b29mr1466309ybg.603.1652267004591; Wed, 11
 May 2022 04:03:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130732.522479698@linuxfoundation.org>
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 16:33:13 +0530
Message-ID: <CA+G9fYtELPM+mYHTo91drd4sAMMW12T0p3KVM+QP_FcPUpdHAQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/78] 4.14.278-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
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

On Tue, 10 May 2022 at 18:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.278 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.278-rc1.gz
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
* kernel: 4.14.278-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: a6b67a30bbcccc65e9f7e43cacd172294570fb46
* git describe: v4.14.277-79-ga6b67a30bbcc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.277-79-ga6b67a30bbcc

## Test Regressions (compared to v4.14.277-71-geacdf1a71409)
No test regressions found.

## Metric Regressions (compared to v4.14.277-71-geacdf1a71409)
No metric regressions found.

## Test Fixes (compared to v4.14.277-71-geacdf1a71409)
No test fixes found.

## Metric Fixes (compared to v4.14.277-71-geacdf1a71409)
No metric fixes found.

## Test result summary
total: 79387, pass: 63229, fail: 1033, skip: 12767, xfail: 2358

## Build Summary
* arm: 280 total, 270 passed, 10 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 60 total, 16 passed, 44 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
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
* kselftest-membarrier
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
