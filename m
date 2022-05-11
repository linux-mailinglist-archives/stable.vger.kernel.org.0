Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C97522BDF
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 07:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiEKFpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 01:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiEKFpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 01:45:01 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BA1244F30
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:45:00 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j2so2020140ybu.0
        for <stable@vger.kernel.org>; Tue, 10 May 2022 22:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=moTIUyykDQCdL3n8ZzydQdIRd//nN7iJ29JUpOBGZxc=;
        b=Al98zbbolcn+CsjwdUCiVUwDf4CocyMFxOjxRmpclefT2Ssd9u8c5dijSFL0rLOHIt
         Z7F/Rom7lyUs2bLArdQ6Vo+TyK2Exfc/liDHeiP+oWCRpdkYgeJii8cB0slc3Y9q8Ub+
         kkuB0c5aAoqFx7hGv+1RuOMjIS5FvxkbnZyoeZDinQ4An6ualc+KPRet1HHTTWUkcQ8P
         ngC0eChXDNXU05nYNTb7vjPFH27jKGD+KVnskG6YeeCRNk+tqGiQvM+nRqFRRWjpZg6D
         100tXpxiXiLjD1zgzVs+irnP0yzkt5lk5s95HNE0XcjQiLWajhfNgA+GCymq4DJJAQXY
         ZWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=moTIUyykDQCdL3n8ZzydQdIRd//nN7iJ29JUpOBGZxc=;
        b=apXIYhBPaQcR2JcGGIj4YqIqSWdPWo6xxWbqAG+Z101WCflsFSeJ/3fJ1ZhCdKKgad
         r7XXfmjFFs1oZMzyNp+UB63Rst4Ggjmjd+J8v2Gak/TpbKP61xPR3L6dZAKYj5mkmXzo
         B9itZKQQLVDMCSyKJ/9WbhbmGBhmKkun/YKgjVPuEcXyK3bbvs1nFt4qxnErq1UCD7zg
         xb+oeFV8O3LXeUYrRRMb9PNDaguaiOmAEu9L4/HgYbKwWRXqZkZ/QBRrLPcmFThAdH3r
         HqfikkIVO+njAFV/f7DPxlOHjhMpFPjvQfc7pebAwYXy3p/T3q/XspswFbBUpKuoX1gm
         mjUA==
X-Gm-Message-State: AOAM533GgNPT+mUbcbA/zdCUx3hwnmimDbOyDp3QJWFPjewDm9yFo59K
        4FCLiVKt+Cu/AbR5wG3Wo9BvY6vfQuSDsG5m27+96w==
X-Google-Smtp-Source: ABdhPJxfVIpuN4xZ2G4qI6DKfJkt5b7fQrIRjGDfAvjflEDG9KlfOl9Ojs0SfELUMElw8lYidXTyCcUizjhG1vETiCY=
X-Received: by 2002:a05:6902:704:b0:649:cadc:bcf0 with SMTP id
 k4-20020a056902070400b00649cadcbcf0mr21928845ybt.537.1652247899499; Tue, 10
 May 2022 22:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220510130729.852544477@linuxfoundation.org>
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 May 2022 11:14:48 +0530
Message-ID: <CA+G9fYsLHinM7+LLczS7Exf=mrxkNk6dCNCWEV4zZVc48Fd7Tg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/52] 5.4.193-rc1 review
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

On Tue, 10 May 2022 at 18:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.193 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.193-rc1.gz
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
* kernel: 5.4.193-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 52d5d4c85d2dc5c74edaba054d60cdfbda5e9808
* git describe: v5.4.191-138-g52d5d4c85d2d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y-sanity/build=
/v5.4.191-138-g52d5d4c85d2d

## Test Regressions (compared to v5.4.192-33-g7dae5fe9ddc0)
No test regressions found.

## Metric Regressions (compared to v5.4.192-33-g7dae5fe9ddc0)
No metric regressions found.

## Test Fixes (compared to v5.4.192-33-g7dae5fe9ddc0)
No test fixes found.

## Metric Fixes (compared to v5.4.192-33-g7dae5fe9ddc0)
No metric fixes found.

## Test result summary
total: 86221, pass: 72108, fail: 671, skip: 12451, xfail: 991

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 34 passed, 6 failed
* i386: 19 total, 19 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
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
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libgpiod
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
