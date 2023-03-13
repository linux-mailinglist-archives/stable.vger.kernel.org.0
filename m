Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFC96B6FD1
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 08:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCMHF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 03:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCMHF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 03:05:57 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC144DE15
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 00:05:52 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id o32so10074881vsv.12
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 00:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678691152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHE01/3tgA1nAt03cXd+lN8IWHSdq0jQSdwx4eqGdpw=;
        b=abP2bBAwNBSfgd0V6SSIh0qDHUOwiK3VKrkFpakyjDGyKhqJag+TxCiZjCWCJdHryj
         7rbBXjoYT39kKxL/UkAvc4uZ4aKKuTdrLCojKCCn+MKukHeK8Hh4s70tLkXK9tmq+gel
         imWMOT25OgG9yDDl+T+0iRnLV2Ex/i+dUUveMte9UFVVQLGEqV+47rfhhfwjTC1srl7d
         3PFR5AZkghgcHivrkyF4Ngg+cARJ0UIMWgmyzcHzV6ya3VIKPK6X9VoiE44sUWlwyD2R
         Vxp+DZULOX+R5nnTqvbTD0UJ54CUt+iufXbG/h24ddL5RtKd+5VXbNihhp41alCCn7kH
         2Egg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678691152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHE01/3tgA1nAt03cXd+lN8IWHSdq0jQSdwx4eqGdpw=;
        b=6EF1dBohJQT+Tpfh8dLZXXHpWCmTpCjaC1whgr7dp+14mKLn+L00S/mBpM5DfG/MSz
         ETCgOV+4ooWJYopkZ0qE4oDrQEWHD9i7BzPaYnZP6Bi8CTMupjFJswRHngZcTIV6HU4i
         xlPHgGXdid8VGO/orIEVjHI+zmK2cplfUNPj8Q6mFgU3gZMDw7Ti8EYUabqIpcOuuSxA
         ikXlCgivmZVLZ25wJ8j58/ginzoy9qzRQpdki2QhbXVEkOS+Cy/uczsKOwdlzqPvJK01
         5VqPohIBOGZfd0zGEoMqrsCXczj8PE5ORrG8d/lZi1WfymRg4cVniDksrFUM1gDZJNVM
         1VXg==
X-Gm-Message-State: AO0yUKVa8Hbb2LQVl3/mR0WZURCyf1vd8yKjxqQY1GtqyJo1MOrVTYcN
        6vX2RsAgv/y6Wobwrs89kAUCzAr9cPRE1hMJcidpgA==
X-Google-Smtp-Source: AK7set9x4Emhcs/V+eedyuFq7xYtTaQ1TWUeAYtMC8cCh6ilFqFMqZBzhk4F9tiNlZ0iHCI9LrIjfoxg0IqPeOLLsak=
X-Received: by 2002:a05:6102:3210:b0:425:87ab:c386 with SMTP id
 r16-20020a056102321000b0042587abc386mr1232533vsf.3.1678691151710; Mon, 13 Mar
 2023 00:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230311091806.500513126@linuxfoundation.org>
In-Reply-To: <20230311091806.500513126@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 13 Mar 2023 12:35:40 +0530
Message-ID: <CA+G9fYvEQTVfqvCD=umPFC4KTdEjafC5bN=MO9Fm5X76kmNOPw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/356] 5.4.235-rc2 review
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

On Sat, 11 Mar 2023 at 14:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Mar 2023 09:17:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.235-rc2.gz
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
* kernel: 5.4.235-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: ca95bdb3ada07ed988b0bcf95a489479b6a3e800
* git describe: v5.4.234-357-gca95bdb3ada0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
34-357-gca95bdb3ada0

## Test Regressions (compared to v5.4.235)

## Metric Regressions (compared to v5.4.235)

## Test Fixes (compared to v5.4.235)

## Metric Fixes (compared to v5.4.235)

## Test result summary
total: 124626, pass: 101269, fail: 3329, skip: 19651, xfail: 377

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 37 passed, 2 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-bre[
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
