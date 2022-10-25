Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65960D29E
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 19:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiJYRiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 13:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiJYRiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 13:38:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118FD165C8C
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:38:23 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r14so37426394edc.7
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wF4aqXwCTlRmrcK6xv8XUJOmo/+zsAs4kMlaRm0p6cc=;
        b=MBQJMrMfKK8qCUpJwbw0XoaQperNpDKvpSO/+U2r/HRh+aqrLDwKe8aj6hIrxM4jDq
         0fQvStQ4KUAZz0YHX4nGX6hqMuSLkWD5VQ/PQKo2n2M6wxtqr8B1hhrfs8oCZoLq1xzu
         b/k4+idh86O7XXK8aXh5CNlmoiNzFxFl1JsW682ZG+t7MsT/OXklCfCJZJQu0+xx80Vj
         ORBmZND40XxaPktt1GNMGGMp7TGO/M3RRKIjDcnbitjGmYJboKKZiSvQfZwaz0Gf0xWJ
         fsdPq6gTGXMINVePtBkza4CFDeMaid2ddTJXKlQ7ZHXeq7FYwRDoxOVa4x89qW6rRovV
         e/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wF4aqXwCTlRmrcK6xv8XUJOmo/+zsAs4kMlaRm0p6cc=;
        b=SiyXTYYpNgUqtpZUUQlJMakPWqB/K3miJRwABPRukic0Ytve/lEkTtEXGR3do2IBhV
         4SWokFsWojibao6waWdOYMLCH+1/oAMQNOcwPifvhQM9bZffy4MDqNj5+qehoWFIy4+I
         4sfSYNNjACY8mqR9ohrukx4TYsA+bvfeoUbU8O66PU2+68xnpCdC47oxvYLOIDUD0+FV
         62tWeOel8pmW0TOS+G+ftxaHEa1P5ZfnTWUX6L51rJGXY9DX1b4zWVfogPHZbkUwcg6U
         VS9w6dFd5bsaYdMGzgyJBRlJ7JIZ/eDwhAwZsWHzKH3lMOmZcqf1Rtt8AxMG2dX2b6TR
         5MIw==
X-Gm-Message-State: ACrzQf0nu1f9D3EE0q9nAn/s4PfSgwjLAQgR+no3im3dmd38ssvMG+0S
        tkaJGiQcOZgNoMSi0oPKi5b8pSUwNTGiG0NLs46jKg==
X-Google-Smtp-Source: AMsMyM4robI+nba0g1eT91PhNNzduTzY9wnyV34vj3SMuDDdx9ZM8fEmAkwjSH8d3Z4kJXtlJmK8GBylEn2yeIoxkoM=
X-Received: by 2002:aa7:d996:0:b0:461:88b8:c581 with SMTP id
 u22-20020aa7d996000000b0046188b8c581mr16155341eds.111.1666719501374; Tue, 25
 Oct 2022 10:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112956.797777597@linuxfoundation.org>
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Oct 2022 23:08:09 +0530
Message-ID: <CA+G9fYsTAZhwXowrRe2Xe=PzpKTJ7JALUmwO5H+K18BhF-5EPA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/210] 4.14.296-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 at 17:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.296 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.296-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.296-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: a6ecd3a0366ab2989ed6efc0f00a9af63cd46086
* git describe: v4.14.295-211-ga6ecd3a0366a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.295-211-ga6ecd3a0366a

## No Test Regressions (compared to v4.14.295)

## No Metric Regressions (compared to v4.14.295)

## No Test Fixes (compared to v4.14.295)

## No Metric Fixes (compared to v4.14.295)

## Test result summary
total: 103404, pass: 86901, fail: 1381, skip: 14220, xfail: 902

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 308 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 50 total, 49 passed, 1 failed

## Test suites summary
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
