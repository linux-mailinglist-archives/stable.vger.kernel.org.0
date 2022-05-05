Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB451BEDC
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 14:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359512AbiEEMLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 08:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357001AbiEEMLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 08:11:35 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FD315FFF
        for <stable@vger.kernel.org>; Thu,  5 May 2022 05:07:56 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2f7d7e3b5bfso45849577b3.5
        for <stable@vger.kernel.org>; Thu, 05 May 2022 05:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gjywDP+ovyQmR5hK96gfZIq8TNaMr9xQjsaWHLuf+e4=;
        b=jG9/WWDNN6gSV62apa193JWZ8LCLE/ivDFRzKZZ7tJRaQIywDArCJYf6iTQB8VQEO1
         oxFh0USRD/5bDHVMkLXlf5EbT5yacFuA/lv2yfA7FaJneJkrqfLuXTjwrVHHjj8d0Ily
         /GpEguzuyRHkdR5v4sAcwnf0/uPe3FZlPr8spIm2hfQN7WvqsG2rD3UHNMX0agehp4NL
         KYBFHOh3poLYboZRy15LwTmXbIqLeDcTxi6QWzYpdOyTXZiE2wKIRFMhTrmq8HQvSdlD
         xXWl5nfg+9pkNhQCaWVCQzUTUJ2HUmji2HnPpXNAdEE9XLR0+nMy477yhL3vs7CEgr6M
         VBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gjywDP+ovyQmR5hK96gfZIq8TNaMr9xQjsaWHLuf+e4=;
        b=nERDIQA1HyaVcHI/q7OjeCJD8GIISKi0GU0iKa8FPI8j8VerAlwhwYeZz56snUlJMl
         VM6Kogu9DS3XTQOIMqPmbqXY+gp0NZKxO090dRuptL2qXMdqOc5dgcf0fm73nJneYEjb
         IGlRLcf20ZukEt5AyvdqpgdVQXydxEZFJxMt5j/Wb+38draUX0ZEGpsA4MZCDtRaU9Sv
         4ledjAc7TAml8GySEScxt9hiK9caDni3lVkJn5wv5TU/hI3xKHowOAbtn1oXuJLgoVCd
         f2b8iP0MduplDmDWNSQUW1T5Uhgh2VM+dW49qIe+puA8/XDWpPMXpDAmCkCChYJN+R25
         Hw3g==
X-Gm-Message-State: AOAM531Mcl+iPJUpc81LH9zpqgc8vFAYbAHo1EXOn+l+Usioxgam1fKB
        HxKqdK+Rb1dCcT/8xs5pC59YA5yub4iGDNOswcuRVw==
X-Google-Smtp-Source: ABdhPJx/e7d19O+IRKxU5aKO/cqjVmvXNj18NBvQrYgDB8m8NKs5KrYuFtiN+bZhOsM8YPZTiVl6aQKl38+5eOZ7Znk=
X-Received: by 2002:a0d:ffc3:0:b0:2eb:2327:3361 with SMTP id
 p186-20020a0dffc3000000b002eb23273361mr23604261ywf.36.1651752475391; Thu, 05
 May 2022 05:07:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220504153021.299025455@linuxfoundation.org>
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 May 2022 17:37:44 +0530
Message-ID: <CA+G9fYsu03yTrT9LJiYzvoatof69Lk5g9dA+geW0op+vyUa+Rw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/129] 5.10.114-rc1 review
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

On Wed, 4 May 2022 at 22:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.114 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 May 2022 15:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.114-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.114-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 0412f4bd3360abe0f87f814f6b1325813bbe9f44
* git describe: v5.10.113-130-g0412f4bd3360
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.113-130-g0412f4bd3360

## Test Regressions (compared to v5.10.113-3-gbc311a966773)
No test regressions found.

## Metric Regressions (compared to v5.10.113-3-gbc311a966773)
No metric regressions found.

## Test Fixes (compared to v5.10.113-3-gbc311a966773)
No test fixes found.

## Metric Fixes (compared to v5.10.113-3-gbc311a966773)
No metric fixes found.

## Test result summary
total: 100855, pass: 85629, fail: 641, skip: 13505, xfail: 1080

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 51 passed, 9 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-net
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
