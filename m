Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702EA4D94A2
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 07:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiCOGdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 02:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345233AbiCOGdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 02:33:13 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B94A92B
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 23:32:01 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id f38so35415403ybi.3
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 23:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bC/2gCrAoQ2lchEZ5qkbyu3pFJoZ4KVQMge0RpKDA9Q=;
        b=dfcISV5u5AKS+WLviKJJ9yxoVPnO9wGv3w6PnUxuoXTV7+6LK0J+AIDXJDHkKhQ1d3
         ir6uUEJHl2lTMTzGfQ0qv4SihDkwnbHGFio5F08ow//yVlO0GyRAkQCWUvQr6EJAViUF
         mTM/bhkCkRkrqRws+5KsKd3yunwnf+yK6LEqgvuLBqG+fkYWNsWtBxbVEkW0i7HIkE3k
         8RYmRJh6Kx626bqgB9yV9sN8dxg72CptSuajdMoO7TrMDReqg7vuR9iMtIq2iHJDDzKB
         fFYTc1c7xV6WTwDEsXZqb708FyiZ86CZ+m3OBm/KqyC2BsHFIN0LMe60dv7oI1vH+MvM
         pM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bC/2gCrAoQ2lchEZ5qkbyu3pFJoZ4KVQMge0RpKDA9Q=;
        b=2EwoGFq+kcL4N8cAOIhUFZWng765cIVcDe4dBSAAXQKc3noGuoxj6JbOHXZRlCY6TB
         upRyY7zM+dPRBceW5DEe8T2oKSYrTBw2zwC1coBrJ+xcXoCeRhaLrcoSJ4ZcYBN+kvbd
         YmOTxDUISV8B27sRKfa/HoJG4y3477TJYeUyw+oWWZip0BcAG0ngX2HEXamNET22xHAq
         0IV8j00WPqdGrEtqKWjB8WGJ3s/zbbnN7loRm2kgRGHWxzM3SY6SZ9ChuJHc8DSy5Au0
         j9xmaBMb272rfPGevcFKfqnWJfSPRrvq8c24anqfq4G1Jsp032lm7/hL1VGg2DAAnzSD
         xtKg==
X-Gm-Message-State: AOAM533eg6S6tt8lqCsKYU4GMy43Yyn30sPWheT3kTuGhFmtvM6/wloc
        q7qWYfnbNC3atgpOQFK3iXfMTsbY9rX5dYXjMfd0Ng==
X-Google-Smtp-Source: ABdhPJwczPmgdFMqwJ3G7OLF06gZjRwRikJpmCznYjngqHJyY2IZLI8W8Tn326sJ0ZeUmBltKZ0joGqM34rnuAFylzM=
X-Received: by 2002:a25:9846:0:b0:61a:3deb:4d39 with SMTP id
 k6-20020a259846000000b0061a3deb4d39mr21859369ybo.537.1647325919690; Mon, 14
 Mar 2022 23:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220314112737.929694832@linuxfoundation.org>
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 12:01:47 +0530
Message-ID: <CA+G9fYutPYhZ9nbYeZ2-ttdJ4fbbCj=hEhUr_3NodYVTPH5Wqw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/71] 5.10.106-rc1 review
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

On Mon, 14 Mar 2022 at 17:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.106-rc1.gz
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
* kernel: 5.10.106-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 1ef0e2b3149031c288a85198919cc1778754e515
* git describe: v5.10.105-72-g1ef0e2b31490
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.105-72-g1ef0e2b31490

## Test Regressions (compared to v5.10.105)
No test regressions found.

## Metric Regressions (compared to v5.10.105)
No metric regressions found.

## Test Fixes (compared to v5.10.105)
No test fixes found.

## Metric Fixes (compared to v5.10.105)
No metric fixes found.

## Test result summary
total: 95856, pass: 82843, fail: 543, skip: 11705, xfail: 765

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 46 passed, 14 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
