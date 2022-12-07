Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97306645588
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 09:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLGIk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 03:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLGIk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 03:40:28 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE815581
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 00:40:27 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id p18so9516132qkg.2
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 00:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLC26Ke5fZpTRF2yXCb0Zzz0rWG7QspcEyfjjpZuefA=;
        b=OLfMnsamTMztkSPHhCbImeUMn9iFFnW/C5MvcbYVR6UXWWhaqSlLKU4VvINPE29BsX
         GE9ED7rztekxlZkH7wu33P22znQsxn8n7H2twRuuYOuwUbfoCOGAAS1bH1Y1pznOyQa0
         /Yrsl5HrUP1KYmS/BMoa6R3KS/xM959I5mXDTt1icNj3N4LqqA7Zqqbwf4Nu2eq4vhxw
         SOKnvUNVjcx1pAmL3paM4tENUfSJ0dYPJeyywmcI7em4lWQ0UFaalVbbgf341U9OMRMR
         mMlQ+m0GMFndMY04lbgFqam5mZNzrBDBakmA+Y4dXcQO5KPvXjdxBpn7/qReUJwR1Pou
         DMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MLC26Ke5fZpTRF2yXCb0Zzz0rWG7QspcEyfjjpZuefA=;
        b=FVaDHUV9qEF5R9JiEwEG1IR2nZKkFdG9PC4oeBRYKxS1IIlIDrj4VomHcK34vYioqc
         MN7ZkW4ZmZZ9AfshgYceE6MvCMFnL/Y/XjLcJcnGPQkgJEsPiMt8qJD74gSgKx3M3BCv
         rw0+cDeyHiS4+zuh6F5dqo73asnZVLaKd5TzPPb1WYeu1lXKRTHCDKtL/UfiBVQ3v+Ep
         Yas/XSwWKiz4IHTaiRPBnX46yO6zAQ4PnWbpjdXSt9NkhsTBzDkCxbccmq7DnmcSI5hh
         g2hVyJMj9XtL+cELK9cxhplIoJ/bvBOAIY3+CM4kXYIj4e267dhrGvIfdkZIIDGzWo2D
         Ssmg==
X-Gm-Message-State: ANoB5plr1hoXqREmtGC95BrvrXD3IcuC6rUyZAvakdZGhlZTw2Z/P3Tv
        rS+IzCYpjYmdpo+/2QFsrQTZrgSqZaWbecrunkSQOg==
X-Google-Smtp-Source: AA0mqf4InsWz5gWyz42gsS73/ubeKbtB7JkhPdqfSzfmkW0T4JxuczOehqy6CZkXBTVB5vlGfBjt7LLkSPAtVvxScOg=
X-Received: by 2002:a37:9a43:0:b0:6fe:c3d4:d9f4 with SMTP id
 c64-20020a379a43000000b006fec3d4d9f4mr8417472qke.646.1670402426282; Wed, 07
 Dec 2022 00:40:26 -0800 (PST)
MIME-Version: 1.0
References: <20221206163445.868107856@linuxfoundation.org>
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 7 Dec 2022 14:10:14 +0530
Message-ID: <CA+G9fYsNLYgoaRo7-0XCJEo2e6QaL3RRgo1bXXT20p7LZA-f-Q@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
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

On Tue, 6 Dec 2022 at 22:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.12-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.12-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: b2f10309632954c8f7f5b26604c42ea6944edfd0
* git describe: v6.0.11-126-gb2f103096329
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
1-126-gb2f103096329

## Test Regressions (compared to v6.0.11)

## Metric Regressions (compared to v6.0.11)

## Test Fixes (compared to v6.0.11)

## Metric Fixes (compared to v6.0.11)

## Test result summary
total: 150169, pass: 130851, fail: 3573, skip: 15282, xfail: 463

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 48 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 41 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* ltp-math
* ltp-mm
* ltp-nptl
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
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
