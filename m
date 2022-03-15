Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9124E4D9858
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 11:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346927AbiCOKIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 06:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiCOKIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 06:08:40 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A1D4D63B
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 03:07:28 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id h126so36253679ybc.1
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 03:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=52KNiuJ+/FvHOPGcQ/6L99f2s1fjypA6SSoO7jVwNgQ=;
        b=s2JYRuJJBxWjbhSdPxCdACGYkWysL+aTUVneClF2zw+pEl51Li0NO9p9imkbw1xdWS
         ZtZld+ANq9QxAjqTYxp2tpCbvR+4QTNPchQfv4tTGcuHUbqXbrydTyULnO8rbtNwjqXt
         c2m+tWOTT2JWwlyhj3zVlzR1taTrSgng/o+lKQZKo7eDDvCiPmzDRDwQ5SuygargY41d
         FTWiNCufvO2sWwVEWWff7D/XbIgvZ1cIldYGnu5rgPgZNJtg5bJY3Qnj5P8IX1pE82z2
         uxhgLmlT7eBJHmk6qwOQkk2+GdgrZD51ojTtViuiF7w8HUndyelh51nT5Bp19gMgnDI9
         JF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=52KNiuJ+/FvHOPGcQ/6L99f2s1fjypA6SSoO7jVwNgQ=;
        b=IDHRNMia9g9iKg+ZeaFGR6wDrH/WOBH2mMA2ou6GkulE+Wh/khdP6dI0jgDoWfmmJ3
         khY2yCN3xolj2ZtU+8E1nn4Aivt0uMmFhbGeYosAtOrtIfVQGmQqBSAWLJ0YiWoEsLvt
         wXY1tsjxijwZkeHF6O1F/xtgkf0lhNY6+Cuei4W8zZkj4kmn1PmybHao95PcmjRpjW7h
         da+XIBavlJGhr1PiFD4tONDIf29Ova4TVTU7oDHGjFcOk9IAO/Skg0U606ujJmnvbfpH
         yj0SkGoI30lTqbqLfQBhQDUwBBqLS6TFwDZ9R+zFMIedEVYVtUy35Z7Xj7OUd5MAzDEO
         0NKw==
X-Gm-Message-State: AOAM531AU75l9BIrtSmUBHNDyN76RGlCe1xV9qlRMMsYsw7enpVosFNn
        rNUTJBag8UHBR593SNZR5G8kVu0vxAlJKE1QzXB6ug==
X-Google-Smtp-Source: ABdhPJwlHBBJgzvpc8Xa+pOZNv8mCz2UQiQHFPG8CecgyadTVWhZfRtvh5n4J4eJS6qLBJDup09xD5KHh6yG2DS5r5A=
X-Received: by 2002:a25:9846:0:b0:61a:3deb:4d39 with SMTP id
 k6-20020a259846000000b0061a3deb4d39mr22471047ybo.537.1647338847141; Tue, 15
 Mar 2022 03:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220314145920.247358804@linuxfoundation.org>
In-Reply-To: <20220314145920.247358804@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Mar 2022 15:37:15 +0530
Message-ID: <CA+G9fYsdmbeT_uEw618vCRqrizOKKDP1BoddKYgScQF5Muww5w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
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
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.235-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.235-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 4401d649cac2c3bf2cca0caf51a27f17b4f8bc26
* git describe: v4.19.234-30-g4401d649cac2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.234-30-g4401d649cac2

## Test Regressions (compared to v4.19.233-19-g83f8068e02bc)
No test regressions found.

## Metric Regressions (compared to v4.19.233-19-g83f8068e02bc)
No metric regressions found.

## Test Fixes (compared to v4.19.233-19-g83f8068e02bc)
No test fixes found.

## Metric Fixes (compared to v4.19.233-19-g83f8068e02bc)
No metric fixes found.

## Test result summary
total: 73008, pass: 60870, fail: 357, skip: 10332, xfail: 1449

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
