Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9AA4B5A54
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 20:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiBNS7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 13:59:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiBNS7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 13:59:34 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A9FD836A
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 10:59:17 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id j12so26805282ybh.8
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 10:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GJ+eZpGJUnHJz5l8gaNC3tvulBKkIz+R9GkRf2snme0=;
        b=cgnTHXKtEwaXZWuqW/KklrrOxnNanZWJs6RN5PuJptXxtKYzBKVmCk1jW4snZHqQHZ
         7jB6J42+ElPtGA0tmXFss1bC/YsWkutIgDsuXnUPmVkU/TQZ/pZft7sVd5OPt2v8Pzyu
         bl2iGwECDoCWg4Qarlyy8qtSN6GhPx3hL8BS4PUYQrm0IXCYaz+Fq23BypMeHwiqPYMv
         2eGZVp25g0whH5Lq3xsPuDADzezRswtWvz6kRcszbrXNKb9DEkVUISpqkYxvRlmnqX/v
         evaGJYaU8l47od/NFWQQMQ3o55W6K7FChb/c99unMbevKXu8sIpygDuXI3tWFV+vbGch
         NL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GJ+eZpGJUnHJz5l8gaNC3tvulBKkIz+R9GkRf2snme0=;
        b=ZjOpR7UYVeaLrrnDXFfPZJOwNdsXon85k2eka6EloYeuwLvrk265jjBUV9kQt/x2v8
         wQMNbvYwUyDCJiRdeNIpJT1S6fFJf8GkU8PrNq/YXYGVXJapC1o7xDfhdlo5qpNX6zYg
         QHfjemB7gti4ehAN8xel013lz8rqC9ZiA3mKtjf8vG5kXnDAgmMYKlqjgDEPqHDUUNqN
         Jm8GtEWIeV8zBOA9/lkvsb/P7piv6Zw5egt5BjoZZWr8gMGBx7eoHC09WM+R5U6H5DnS
         aD/8y7cADaVl49mjHs7ILndInDUOqGfknnDnUHJY2frxIVyq/oac5uxzX4A1IR7CfNMu
         QUYg==
X-Gm-Message-State: AOAM532FupeG+4y6zojxRKMRYeGXkF9DCrJGLN058y6ar2xYUSs+Ex9g
        OXLRN2GZa6pVq7BEzQmj9sHhi5nPngn830MOaZQtsg==
X-Google-Smtp-Source: ABdhPJz3i7JHoNUndF6Ec1Fb8QpOe6v4m7eyGAWhslH6XqyY/ShD2m6QLQQJ8GowEdEA24k/ES6hDfeyiMMGbfqWgl0=
X-Received: by 2002:a81:a403:: with SMTP id b3mr113404ywh.310.1644864863599;
 Mon, 14 Feb 2022 10:54:23 -0800 (PST)
MIME-Version: 1.0
References: <20220214092510.221474733@linuxfoundation.org>
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 00:24:11 +0530
Message-ID: <CA+G9fYsWTTEKyqaU=p--HdAhxNMSy9jojrdec+d5iFzGDmO43g@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 at 15:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.16.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: 5c09166a84bab4ec112638721f9e2a7a3831128a
* git describe: v5.16.9-204-g5c09166a84ba
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.9-204-g5c09166a84ba

## Test Regressions (compared to v5.16.8-6-gddf6ceb4eefb)
No test regressions found.

## Metric Regressions (compared to v5.16.8-6-gddf6ceb4eefb)
No metric regressions found.

## Test Fixes (compared to v5.16.8-6-gddf6ceb4eefb)
No test fixes found.

## Metric Fixes (compared to v5.16.8-6-gddf6ceb4eefb)
No metric fixes found.

## Test result summary
total: 96370, pass: 82041, fail: 1389, skip: 12172, xfail: 768

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 35 passed, 2 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 39 passed, 13 failed
* riscv: 24 total, 20 passed, 4 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
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
* kunit
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
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance


--
Linaro LKFT
https://lkft.linaro.org
