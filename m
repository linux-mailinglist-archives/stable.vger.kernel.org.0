Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE04BF58A
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 11:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiBVKN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 05:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiBVKN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 05:13:56 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FBD13C276
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 02:13:31 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j2so40126844ybu.0
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 02:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=84dXbZa7FvRhAmFpDM+EJhx/CIk7pvjB9aAjf09n/9Q=;
        b=IMpNfUYxm3fFLMnjQgJBYE0ijoWXTrBfNkBIBs4+hO5FHTTUbHQq1OmCWEGHtl5dh3
         q+js3oQxbwLJ98JX2dewwNXPaAy0ksN4MwPfr8bgtZixKpzX47YTty5t7jiioAb+9I9H
         LgqjkZ9V7PiTguCyU0ixIM6N1qJd/viBcIa446unedLlZ782tLbfJmIrj5qMYv51HJeU
         G1Ta0u2rU2j1YNtxRDpFU6fCjwQnUiAWlA0W5d5LeCwojTJkdisw902gz/vBN/rDunvT
         WI1PZektPqT/I4GWUxPG+1tFqB5VPsUCyteVOOnqwIehFQyKxT7agxs82MpnpdjyGXEL
         8gZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=84dXbZa7FvRhAmFpDM+EJhx/CIk7pvjB9aAjf09n/9Q=;
        b=Ct/DQZGUfurQJsa1DomUKCfdOwWAYGmASHYPA1Dhg+HN0o32qhZ/1Hw31AI28DlvJE
         J5vId9mwRsyAvi3zWugYT9W8tGzb5x7tNrFjh4JMTWawH+/Sw4MKuavw2CHoY9nqnFyc
         0bi7BkTwadmWGoiMJ85s5eAHUkxnpON/HN1VHOW+lR23XLpslu1VYdH2SkWHG18T8M1g
         XDBXZPU7Y/XTifMoLLoVM4CWLD8nNpNl9z9259D3iXDIwNVijmwmFGQrby6SvC+hmfhS
         XGDvIYnbDY8odTJV9iALCRiBXPB9YHmfkM9aPWbJ0gq42xTFwAstJf5z4Vc3v/YrUfCU
         dfqA==
X-Gm-Message-State: AOAM533P9SKp1FyyYGdr2nABzvAhnKHv3vHwUTD/Y6DzyfHfATemgI1t
        Vdxsh+YUCZWe/MXyocvPNAprDapVV+VciYkrUYzdIA==
X-Google-Smtp-Source: ABdhPJwgjiHVx907RUaNJfNsG9EYVM95DuMREZLU1D/CaeT7yOBkhrF69Bdg1+cU9rQu8te78WNdwrXokBG36BORXQ8=
X-Received: by 2002:a25:6642:0:b0:61a:8a17:f0a2 with SMTP id
 z2-20020a256642000000b0061a8a17f0a2mr21783242ybm.608.1645524810474; Tue, 22
 Feb 2022 02:13:30 -0800 (PST)
MIME-Version: 1.0
References: <20220221084910.454824160@linuxfoundation.org>
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 15:43:19 +0530
Message-ID: <CA+G9fYtDtjQbW850pxxUv+SpYsincVpVapZHh5Uh8_9T5HaQNw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/45] 4.14.268-rc1 review
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

On Mon, 21 Feb 2022 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.268 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.268-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.268-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 94b121cc896af77a7f03efce5e404bb61bd913db
* git describe: v4.14.267-46-g94b121cc896a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.267-46-g94b121cc896a

## Test Regressions (compared to v4.14.267-33-g871c9e115feb)
No test regressions found.

## Metric Regressions (compared to v4.14.267-33-g871c9e115feb)
No metric regressions found.

## Test Fixes (compared to v4.14.267-33-g871c9e115feb)
No test fixes found.

## Metric Fixes (compared to v4.14.267-33-g871c9e115feb)
No metric fixes found.

## Test result summary
total: 58341, pass: 48541, fail: 310, skip: 8482, xfail: 1008

## Build Summary
* arm: 280 total, 270 passed, 10 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 60 total, 12 passed, 48 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* kvm-unit-tests
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
