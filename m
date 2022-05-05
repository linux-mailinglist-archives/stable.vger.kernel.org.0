Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17A51B9A1
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 10:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346461AbiEEIKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 04:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346456AbiEEIKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 04:10:44 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3E237034
        for <stable@vger.kernel.org>; Thu,  5 May 2022 01:07:05 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id w187so6354000ybe.2
        for <stable@vger.kernel.org>; Thu, 05 May 2022 01:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/lcDjUXmqCC8++TChfQPb2y1ThOaTsMZ60wPCLJmwfA=;
        b=PfkiLCiCuWYhfERRM7OhNV/KVoCSisP9NR0V9RCRfCMS0JYexbisjTUOLMO/xzc/Up
         JN/dm0Q628PUIMyjze7Sbgf0Sn/keQULXJuLVA/0IbO8EIw7pmbAD+p2PS7Mjz32TQmA
         IP6sOxIhRdgFhfGWxuZEjuASayWOlwztM2Eh290YZXnhXVbtDTLE8UCaDGsyMw9B7irZ
         AzCgZTm/kzKsXvp/OPvSMg0Mmu60mtKJdNTq5B3fSrVOSNV3aa12XYW+9eHOb0HBSBmS
         rWlnIBPHDv/ArvC/F+AeO4JEDnaKHow7rdfxYnQ+WIxlYUhSgNfHScUlaqktszkcpgub
         b9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/lcDjUXmqCC8++TChfQPb2y1ThOaTsMZ60wPCLJmwfA=;
        b=tgpEQJTcu0CCalMS7SjPTbT7QchE8vu1MoJ0F5mAkrnFkO3qi1NkdSdImX+aSEP2Tx
         BuXXUk3CxL/1Figiq6pCHK5obKZTrXMUbm2UicdKm3uBhPBzLPoE5RxRVFxw88PxKQ+L
         tl+CerNKsYInQ7T9tnWi8Uvyh0R39KeW9Y4bpm16ztX//WTm89h3JnSM+lqMF3bdLemm
         oKnO0vw9yhMP+/Ik0ipiH5tuswhwS+Nf8x+XPo71HC9p/FkF6T4Y6uRI211aIUUtSRYZ
         FO0ypWBDbmqfM0B3XluF3rREdz1Kha7ZzBRvCdgnidFTJRXMZcfPyaHVjqaHzHqBC/Qs
         Bd5g==
X-Gm-Message-State: AOAM532+Nak3mAp+J/Z7mFNeLNVRFW+mDyBE0B8+Ik3t7QquUHMXswju
        P8HM7vhnYSX9cgXD7Ffwth6/b2po0eNtif6zTsBc2A==
X-Google-Smtp-Source: ABdhPJynvain3ZWlz4aA94WoEPTunkw2wiG3XQs99AhMQwYBKyshzz8EzX7dNVM3DYp4uTxzYm9Kdya3nbQHc43rVrs=
X-Received: by 2002:a25:c64b:0:b0:649:11d:9db1 with SMTP id
 k72-20020a25c64b000000b00649011d9db1mr20279333ybf.128.1651738024465; Thu, 05
 May 2022 01:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220504153053.873100034@linuxfoundation.org>
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 May 2022 13:36:51 +0530
Message-ID: <CA+G9fYsKrM1EJULYU=te5k7i11yijpF29PWPgB6qNaxssF09cA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/177] 5.15.38-rc1 review
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

On Wed, 4 May 2022 at 22:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.38 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.38-rc1.gz
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
* kernel: 5.15.38-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: c8851235b4b74c00f49cc1cf05ab6f4a483e978e
* git describe: v5.15.37-178-gc8851235b4b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.37-178-gc8851235b4b7

## Test Regressions (compared to v5.15.37)
No test regressions found.

## Metric Regressions (compared to v5.15.37)
No metric regressions found.

## Test Fixes (compared to v5.15.37)
No test fixes found.

## Metric Fixes (compared to v5.15.37)
No metric fixes found.

## Test result summary
total: 106754, pass: 90235, fail: 665, skip: 14702, xfail: 1152

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
