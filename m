Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D8C55AA77
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbiFYNYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiFYNYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:24:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E711AD90
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:24:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c65so7006923edf.4
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 06:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vT/L0pA679HijlQXBMu/RBXfDaFIMh01ndT9CE/1vWg=;
        b=BsqaxnRGZQNL1mwfkFmme+Bv7eLP8mS4Va4r8tZQmYRA0LiefjRLt9MqB+e5/MxEIc
         v1VnEKRc//DL+l/CaUQN+uWPxawYI6jtSCOcJR5oB+6Z8lnTCjxRkIu2IdeGKzNmvlRA
         gFsHBdWZtNKQgul6HR1/ZHH9tdTQBqmUis8kczrGBqXobluBNAtYkWB3Bo1uI4qGjD+H
         z8I7gJL4tpb/EfSFfy27sNSn50RPqb4+lwafe9jUM6Pwks3MLjSL+/han5fdP6EbYhU5
         9GmAvQIOkdafav01deIsCTJrN/10k7xQ2T/idRWo/ulDpRiCIK5eGa2A5ixrN6i0XE40
         2QSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vT/L0pA679HijlQXBMu/RBXfDaFIMh01ndT9CE/1vWg=;
        b=ZKAlOOTe83WqPqx8tflIclDmVd5irJrwyawwAuqSLnlPxJCle9o2ZOxOrGaBzWbi5E
         G8Zp/CitwRvEA8ext8EzakJ4BipyS/kofLegVYz1iz6vHDS069ZZC/5ocAi3V6SVLpP8
         I6PTex8pEiUvRoDnRyvE++Nvps5eIdQGLjXwBWKUqVXjPdhVgd0CK/608cbzKbelKr4j
         DBSv0aTCyyARR418I3tX0YFg6hjgmCw4SOxvdcGbLB6BNGe/uoK/1SgDW8a2Fi26trsU
         /f2cZFgD40UoFD15EmS5seao5S01lyzdgoZKcrMiaoh6iv73/Lz8C79Lyo5idmLuu8uj
         2Nzw==
X-Gm-Message-State: AJIora92QniBtE4ba7EBt3V1N1zBBuc/Px3GTtsNs8n2No+732oeBzqk
        RbeSNw6A92SpJ2yXSUFWTJ3oEEu1pRvFbx/MFSvgTA==
X-Google-Smtp-Source: AGRyM1tf4SQ5mEohds//tzA/laPmBOqr1TQEZNctQk0k7INW1cHHEDYfZFx3wIDA4ZqF+MP3yedQ4L+HzS06jz6JhIA=
X-Received: by 2002:a50:eb45:0:b0:437:7686:6048 with SMTP id
 z5-20020a50eb45000000b0043776866048mr1538258edp.264.1656163461049; Sat, 25
 Jun 2022 06:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164322.315085512@linuxfoundation.org>
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 25 Jun 2022 18:54:09 +0530
Message-ID: <CA+G9fYu6T+OYoo6OgA0ndu2wLg8NwSck08FqJGx7Lm39UMZGyA@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Jun 2022 at 22:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 1fbbb68b1ca97c9e8393fe69df86b23e79f81d05
* git describe: v5.18.5-154-g1fbbb68b1ca9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.5-154-g1fbbb68b1ca9

## Test Regressions (compared to v5.18.5-142-g1cf3647a86ad)
No test regressions found.

## Metric Regressions (compared to v5.18.5-142-g1cf3647a86ad)
No metric regressions found.

## Test Fixes (compared to v5.18.5-142-g1cf3647a86ad)
No test fixes found.

## Metric Fixes (compared to v5.18.5-142-g1cf3647a86ad)
No metric fixes found.

## Test result summary
total: 128467, pass: 116814, fail: 682, skip: 10271, xfail: 700

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

## Test suites summary
* fwts
* kselftest-android
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
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-zram
* kunit
* kunit/15
* kunit/261
* kunit/3
* kunit/427
* kunit/90
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* lt[
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
