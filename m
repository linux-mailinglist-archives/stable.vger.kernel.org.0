Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39454D9393
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 06:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344831AbiCOFLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 01:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344813AbiCOFLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 01:11:46 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEC945AC4
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 22:10:35 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2dbd97f9bfcso188665707b3.9
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 22:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lL7cd8qE9IaU3wuuUAMrbO8uNuGot6UwjtaA+bbuf0U=;
        b=pNMj2k1CAnM+L/QbehYMm2BTsrp4h9cPWa3gtwCx9JLSaDKGyoDBVFguwTVI0i9nVE
         Fqjco8yr2eT3BMQ8KzheXqZBewMBwCGlsjXGB9KKFRLRgLT1O/ZosRA5zylZpi++uYg3
         qhUTexDEUqUuqTmhiKs8FX4TpUAkhPpdwQ/561OZVNZIqhgMdyhNMQw1xJBDsWv93PH8
         h6lSbNeCCzuM1mkCZ73eHBzjjm7iO4x4o8ZFFxAOMF3wx6oYibwqvwR9fC36Xb8/WGOE
         rZ9bIglR0yJULpypBVzmDuqsF9Jpe4X4OH6MVMzZumnNU2m4w2yppnXpcufGSskJJlON
         4gng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lL7cd8qE9IaU3wuuUAMrbO8uNuGot6UwjtaA+bbuf0U=;
        b=G90isRmqli/r/V6ILb0p8MzZPBbyA1Gxppsj2Cqzua1JdRu8gV3ZwLdB7u0I9ueUDO
         ktaIujnMNsHbKMt6DUPhFJ454sTGanTA6JM8w/Me+p81mtxxckNyM2tLYetGLCiB1qof
         VKQQvsvLhFM+ZAlbOWFBLml5xDWGTSJtsgryP2h3cc07fLAaMlVkNfNfigxEaJf2uc2L
         7A4he46PqT6iWkVx0gdvYjqHx9ZCqlNogchVcGtnJ7cx9s3g9kvxHomVsfT3N6/PTKdJ
         r6STR2EJ99OzONfFP9eD4+bS2nipYjG/LQ7tCMJeNr5Z1cVwHH5Co01o5d5bIsMMkVu2
         gatw==
X-Gm-Message-State: AOAM531RDgi6bXylxuKo++Ku0wb7q/w6nfT49hcaBiuKYIPTR9dsDTzU
        ck2xdwf81SE6T7oUdrKyLTQn0ejqu72+plMotsRHPg==
X-Google-Smtp-Source: ABdhPJwyFRz05LI1PLzsussDvbrnvw2EN9RDlMRMRYp1Nm+7L4L3VlDugtTdGEucyoIJczyMpuwuugDdm1xrGWxLDqw=
X-Received: by 2002:a81:678a:0:b0:2e5:8748:5c23 with SMTP id
 b132-20020a81678a000000b002e587485c23mr1718051ywc.199.1647321034468; Mon, 14
 Mar 2022 22:10:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220314112744.120491875@linuxfoundation.org>
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 10:40:23 +0530
Message-ID: <CA+G9fYt16S2P4r8qbF_7ZcDVN0ScFhyXofB7uuR82xoNP+xctQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/121] 5.16.15-rc1 review
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

On Mon, 14 Mar 2022 at 17:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.15-rc1.gz
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
* kernel: 5.16.15-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.16.y
* git commit: b2a408c85a229c023493aced7ac25f71e2f61107
* git describe: v5.16.14-122-gb2a408c85a22
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16=
.14-122-gb2a408c85a22

## Test Regressions (compared to v5.16.14)
No test regressions found.

## Metric Regressions (compared to v5.16.14)
No metric regressions found.

## Test Fixes (compared to v5.16.14)
No test fixes found.

## Metric Fixes (compared to v5.16.14)
No metric fixes found.

## Test result summary
total: 115372, pass: 96926, fail: 1741, skip: 15433, xfail: 1272

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 46 total, 42 passed, 4 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 2 total, 2 passed, 0 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* perf/Zstd-perf.data-compression
* prep-inline
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
