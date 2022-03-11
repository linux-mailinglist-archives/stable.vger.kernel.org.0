Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7494D623C
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 14:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348840AbiCKNTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 08:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiCKNTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 08:19:53 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A3D1C2324
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 05:18:49 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2e2ca8d7812so31171977b3.13
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 05:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jooav3gkAzytXZ4ozRbElu7aQEsuPBo3emdtriXSigs=;
        b=Olg8X0qN+UJw10Vij0ENqb4oR3rK069IBtRVHIYohIlCfEphEpTuTv7BlFKEpCaAnI
         l9bqDKQ3+XfuGZz10KnLKKzP7LAk9JbivROL91SnVFDveJ1rCWD56j+dyi27hOW8QlBr
         fJGUh7+Mk8j+sgw/HnkZbEbJE8K3vao8T45y9LuE9Q4XBM/KlRTw1upCvcT1+tbWbtmh
         BUAyiOOFJJ9PGIjW7wIg87WaDfeMFt67lo908U8aQwsXRFgH8XdVuNt3uCvMyJ1U2GJD
         OTyOP8E4euHdf81+0xynObQq2Cd3b8qzKvIlDyzCl7TjWqlFnb4HbpaUWhVac+9KptGh
         UicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jooav3gkAzytXZ4ozRbElu7aQEsuPBo3emdtriXSigs=;
        b=hd6BOeY5pAHWs6r1N0+9mMGx07Q8M5DByymjfz+Zcqa9GCctJ8cjGeuh/2/ys2jXKb
         FUcUbqjogXmsEdcAg2x2MtPDz+eBYaLWoArpIDwDOikrqqUV73MzrcawxWkrKk5WRorT
         irSIOJu7umHodtAxxF5/zmwnwb49NirPaCdCGlbzKiGhGYJWBSZ5EEZCtGs098Dex1iV
         FoFn0UIFQe1P8VMbTCYYg0SgP41mTCo+uiK26isflcyRe7PG6g/9LOE3z3bvyx2R64d3
         1113mWIV5PupSpT41XlDqJHrRxOr5Znz+VDmdUZbzc/CeTRUdZ9j/Xr/NKArs5UmrS/M
         QLmQ==
X-Gm-Message-State: AOAM530bBSTXKn7Z0nTSl2zqvzBvSxKnykzGEI6YoF5f+g1W7PBBTU5p
        8BHx7bhhWTB7DPVr+8hEs82EBiXrMGabdK53EsF37iMMSuOFugEB
X-Google-Smtp-Source: ABdhPJwQhGvesL21xyLIVbpSkpw1hcw0Z6Yj8fscB8xnje1d0/y0aD30r2JO4NyMG5z31RG6kG8TcYdvLTzBwDjrUMs=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr8398712ywm.60.1647004728880; Fri, 11
 Mar 2022 05:18:48 -0800 (PST)
MIME-Version: 1.0
References: <20220310140807.524313448@linuxfoundation.org>
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Mar 2022 18:48:37 +0530
Message-ID: <CA+G9fYto1WF=inNRFHx1LzRuEY0AYig4Oc0WHLG5RBWjGzaZew@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/31] 4.14.271-rc2 review
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

On Thu, 10 Mar 2022 at 19:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.271 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.271-rc2.gz
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
* kernel: 4.14.271-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: f497d213f361b7d7eb4a85da0eda9c11136cd0b5
* git describe: v4.14.270-32-gf497d213f361
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.270-32-gf497d213f361

## Test Regressions (compared to v4.14.270-19-g310a15e6f2b1)
No test regressions found.

## Metric Regressions (compared to v4.14.270-19-g310a15e6f2b1)
No metric regressions found.


## Test Fixes (compared to v4.14.270-19-g310a15e6f2b1)
No test fixes found.

## Metric Fixes (compared to v4.14.270-19-g310a15e6f2b1)
No metric fixes found.

## Test result summary
total: 79275, pass: 63622, fail: 969, skip: 12538, xfail: 2146

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
