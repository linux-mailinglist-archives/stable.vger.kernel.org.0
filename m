Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88CF6658EB
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 11:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbjAKKXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 05:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjAKKWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 05:22:52 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599ED2724
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 02:22:51 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id l3so3877409vkk.11
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 02:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crQRzo0V6enJtMUUgyrhl4TO8BU/SJ8Pr1U+6tIxHug=;
        b=B2HRROX5xapQU16CPQFTPJZe1v3vBkQfPEOQ7ChbWKxzWBEiLbK0+wEoOWYsjoMMVO
         r0OVYUaClCA4JwXmJBEck80TeV2QcIrMRn5W8NLa4viTM76e3rwdpN6xpBQ6KsPpCm6E
         VBc4M+zTgWnLJQYcehosM7Y/i9Q8rx2rnjCj/ziP/VS7hqPzLUdlic6VCvIABCfnfXSd
         8WyIxocvEHNDMbU3pE2NPoisZch3wNac8JbCYqld1LuIRdTSET7hBHcRUbDvr54W4Ho3
         RcRXIJRLujaCNvdJkadgc14t8CIvdvo39OQuRyOdXzcegWtGWrh+b2Ub0fsnBwyMQIUo
         nDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crQRzo0V6enJtMUUgyrhl4TO8BU/SJ8Pr1U+6tIxHug=;
        b=O4/9gYuXdSGH4QNR/E5wbvq+0o7hCya1iP6p/8K++YOyJ71KaiKJcUMSUV38N+Bvmq
         r68Ef1cL4GLq0StiPniozbR3SJckvHWm6w3QKaK8SkL/85NcRFLzXrx8hPJcdSPMCXWH
         1yAqRNtcdMiRnX0SAQPoYte5VL3t/vRn9juJCIa0YnFpK9nWVJZgsZeR2mbXvHJFUkgc
         DipICeuSerPqYvDZ2pDvNNJ6u1YxGJCkf7JM86WNfFqxADKV+J6bqaYJvTQt2gNruHGv
         FmCXpyyNXBXVI93tqeKR6JHtzaV6Tk5T9aExlF7wNYkuySxS8WkqKkQTy7hnGRNaO0jd
         wC+w==
X-Gm-Message-State: AFqh2krmLUJL+AOkNDkaya7MdmryX1py3LWeECNAq3NeSsTcU6SWnc44
        +nM4Eo3mK7+t8azcSsizbLPhNuiB+uNh4d9M4uxbJw==
X-Google-Smtp-Source: AMrXdXsAzmmdXeb2U3sdaaivmVhY5mbc99HYtUVWO05839xziS1XyIztI9bndQIhHrPLFQYPC5xWHYryXBIKm9JAadg=
X-Received: by 2002:a1f:d904:0:b0:3d5:413f:ecd0 with SMTP id
 q4-20020a1fd904000000b003d5413fecd0mr8564318vkg.20.1673432570234; Wed, 11 Jan
 2023 02:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Jan 2023 15:52:39 +0530
Message-ID: <CA+G9fYuRNS+soY1RkOxsTO1punVpKJRn0uf263JgHGu1RsxHZg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
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

On Tue, 10 Jan 2023 at 23:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.87-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.87-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 5e4a8f5e829f10ba7300f2b854cebaed7ac88e73
* git describe: v5.15.86-291-g5e4a8f5e829f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.86-291-g5e4a8f5e829f

## Test Regressions (compared to v5.15.86)

## Metric Regressions (compared to v5.15.86)

## Test Fixes (compared to v5.15.86)

## Metric Fixes (compared to v5.15.86)

## Test result summary
total: 158884, pass: 133407, fail: 4419, skip: 20714, xfail: 344

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
