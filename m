Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE768A8C8
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 08:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjBDHZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 02:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjBDHZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 02:25:24 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C9F28857
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 23:25:22 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id ay40so589301uab.2
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 23:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0GCIL+NITHomZ4ifseBSt0S1EJNccap+I9VoJ92QS0=;
        b=g+Fgtq8z0NI6rMy/Pzu+M/XN/mafLaNAf90VuMeVOl6uyYXnYhdunxSrLtTCFfc8oB
         xLZj+rf6f4ctGoeEAJ8aLmi8DEbENtAfPD84PjyNIpdEUzdeppgvtwZblPgTbGYr0yoV
         rirnhZCIn5aZiQ7hb7ohqOviPvlzSIQWklXMOyGVqXMJcQCDgMXkqgl6CE581H5k3+4X
         2VrWdqEJYcyzDrAS0qXqy7BysHj1UgLYc4q+pdMqbUUtGX1LGMS12UE5eovM8k6pqsWX
         PPg8Szg/i91bpAaabOW7TxiR5O4VFcND0sCrjqw27sDcLS6KYfOGrwPFj6r2JYwsmkIg
         xI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0GCIL+NITHomZ4ifseBSt0S1EJNccap+I9VoJ92QS0=;
        b=zPpvNRordVKPqBgNJfz1FCmtZjzDXQXH5ju1UMqjztrXWRnXL0PA93S3XHz3LvmwgD
         1k0gUiuf2zMVuGNGKP/cSlPfiMUBNLm6Q/5cyZnfu9ojl9+wTvJiEueHPkTKcGj0hGQl
         TuyhxJ3VSySvtyDn3BbM50K9WUjevFitVrhWsOtXEAjFDdnf/DAMyfzn3h1QlCl8CyCE
         gqIQAdQZI4eamfCJjTGrYOlG2+fwx4LXcc58H4Com3DVXGIMxwYwwxFVkziIXUVuLbIO
         lvpjinZo8TE5g+n/RITeQw9JSdtQeH3k32Pekleg3f8UFrZnirYKEYi/CHG8wmbLVxL4
         ZTYw==
X-Gm-Message-State: AO0yUKViR8yjzV7/zcZw43OKC9YSjsDRrploAw6qcM4LaIloDEYZqjsY
        In6sUR91UXko6GDR7LjEbbJhXd7B8TqH8d+0dKo+Mw==
X-Google-Smtp-Source: AK7set/xSW2zRR2PR4QfeEO1a6Uk7XNZ0F71ScF0aNCpiJogJXU6Cw96aZxq+7OskUCP8G4TWc4dL0dqssZ76wCaf6M=
X-Received: by 2002:ab0:134c:0:b0:419:5b8b:4cda with SMTP id
 h12-20020ab0134c000000b004195b8b4cdamr2017934uae.8.1675495521822; Fri, 03 Feb
 2023 23:25:21 -0800 (PST)
MIME-Version: 1.0
References: <20230203101009.946745030@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 4 Feb 2023 12:55:10 +0530
Message-ID: <CA+G9fYtsSuw=W0LSpzJRzsXB6qGYS3og1v=FOrvPHSAdRPCDPA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        llvm@lists.linux.dev
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

On Fri, 3 Feb 2023 at 15:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.10-rc1.gz
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

NOTE:

clang-nightly-allmodconfig - Failed

Build error:
-----------
  include/linux/fortify-string.h:430:4: error: call to '__write_overflow_fi=
eld'
   declared with 'warning' attribute: detected write beyond size of field
   (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]

This is already reported upstream,
https://lore.kernel.org/llvm/63d0c141.050a0220.c848b.4e93@mx.google.com/

Test results comparison:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
-29-g52d447db92f6/testrun/14545824/suite/build/test/clang-nightly-allmodcon=
fig/history/

## Build
* kernel: 6.1.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 52d447db92f6b22e04e7b12c736bf1700de4bbf7
* git describe: v6.1.9-29-g52d447db92f6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
-29-g52d447db92f6

## Test Regressions (compared to v6.1.8-307-gabbe4e7b6342)

## Metric Regressions (compared to v6.1.8-307-gabbe4e7b6342)

## Test Fixes (compared to v6.1.8-307-gabbe4e7b6342)

## Metric Fixes (compared to v6.1.8-307-gabbe4e7b6342)

## Test result summary
total: 163841, pass: 145266, fail: 4409, skip: 14140, xfail: 26

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 147 passed, 2 failed
* arm64: 51 total, 49 passed, 2 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 43 passed, 1 failed

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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
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
* ltp-s
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* ltpa-6124632/0/tests/1_ltp-dio
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
