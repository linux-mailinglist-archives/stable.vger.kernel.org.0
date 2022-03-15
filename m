Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F68F4D989F
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 11:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242225AbiCOKXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 06:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiCOKXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 06:23:46 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74838506CE
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 03:22:34 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2dbd97f9bfcso195300337b3.9
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 03:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9O1QfHi1I0g1rKMxOGzWpZRk1RXFbwE7xufKq2/FhEs=;
        b=ShFdeB8w8gvB1NNpEKZoaVhE/7zTtC75kc9Ay4V7ehH5nnrABGbkhXgtK/Gv4xXgXL
         XFxrf+5exDfnh4z7iGQbvkkRpRZSeGk2FpItDxq0TEG2xEmXZflPkHdCJjYpQZBTWuQt
         tkcQwG3rpjv2qWMQWwuwpNGzlz/4ztMQI8cGF8r1cyWqBqH4n35F8i0SXSYhCMvXYVT/
         bmqj0rvTstc5JHG7YszcLCLL5IHrdDnTm9F64PfMMhdi3JPlzPE21QUwUOu40bNIG8IK
         5INy0k+ENNPyFySvNpAzB7uFeu6sRq60Qf51l+N4Fcc9GI027ilWt42SzarIE4/tzT1T
         W2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9O1QfHi1I0g1rKMxOGzWpZRk1RXFbwE7xufKq2/FhEs=;
        b=ro5Z7oNkO3jON4Cfj2+K/HcS1tX1/4lNEo15K9MIgbM/1GvlZGCh+BUFcIphGHc4Sl
         MhCIgbVXxoaRbRXxsjxs5B2gFa00kJ8+WgbeQUjzQ3i3iZhhrdTuPTxkzOvA+lIqd2BH
         EOlVGMyCqB8WKbsaxjpY06maRC/R2JKKas3zWSMh4Tftb4RUt0G6sr0ZxFYWRpIDMZs6
         NpfRoo8lh+EeKrlNiz9wZZIuPwI6fQ1dajSrdnGVozc+DjLH1yObd8XWWaMI6HQRMqRT
         2jjXR2JTdOf62ZQ9DK/HxrEk19KlbKDBUQTv3duJq4eIKjffh+EUr47K7peO8VwbeUH6
         X7vg==
X-Gm-Message-State: AOAM532IGp73XzJRdW2g33FdFHwzyL7t67dlE70z52n/R1nbMk04rF2b
        RhSKF1/bamJdQIR245E5ERk9J4R2JvqVtu3w++WHJA==
X-Google-Smtp-Source: ABdhPJzJrqXtYFwq1O2AGJSKQaGeunuur6ljYmtRJs+3qUKIYokBmodVRHbXm/ToYTmHU5gLQuY5LU/AhYqZON1s7kQ=
X-Received: by 2002:a0d:f347:0:b0:2d6:916b:eb3f with SMTP id
 c68-20020a0df347000000b002d6916beb3fmr23287723ywf.141.1647339753523; Tue, 15
 Mar 2022 03:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220314145907.257355309@linuxfoundation.org>
In-Reply-To: <20220314145907.257355309@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 15:52:22 +0530
Message-ID: <CA+G9fYuWRag7wAPOpyE5nhb6GCWVjm=z8=e87AgYNmcs38BnuA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/22] 4.14.272-rc2 review
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

On Mon, 14 Mar 2022 at 20:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.272 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 14:58:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.272-rc2.gz
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
* kernel: 4.14.272-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: e991f498ccbf4fc46e0525c0ca02e4134f253706
* git describe: v4.14.271-23-ge991f498ccbf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.271-23-ge991f498ccbf

## Test Regressions (compared to v4.14.271)
No test regressions found.

## Metric Regressions (compared to v4.14.271)
No metric regressions found.

## Test Fixes (compared to v4.14.271)
No test fixes found.

## Metric Fixes (compared to v4.14.271)
No metric fixes found.

## Test result summary
total: 77914, pass: 65222, fail: 257, skip: 11064, xfail: 1371

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
* igt-gpu-tools
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
