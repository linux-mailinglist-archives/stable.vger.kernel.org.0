Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2584C4BF227
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 07:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiBVGi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 01:38:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiBVGi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 01:38:58 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA605A5BB
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 22:38:34 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2d79394434dso19663697b3.5
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 22:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9JZGu7s6k48pgGptARpFNGKK6ukikwXRkWeRj4mkf6w=;
        b=AAwUZ25AqwlCM2v5Ic1b1w/lFetp53PDZn8o9XHngoNprcgII8CPKcL7lbHyMX8IrW
         f5dKQg3O6+l6b7GjDyCG/rGAYO03DJgz7Tj5qN8t856FZ34icqZ22VQTfEGUE6fWJP/K
         cT2RU4fnUh/pXNTr8QWnQZexd5DB7Gq6/PRWU4uA2l3T5syZ5rHXUySKLeojRXz2f/cG
         UXbF7RN6myR9V03F7iJ7BmPGUs8Wxam3tMDou3CdduNxTsSrTKswPczL+yUmjwiqTta/
         rtEdxasHUMxGicci6mWi560+/++IteemomhFrupwAv06P8isbaouoGyo/sMi8q/H616P
         0FWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9JZGu7s6k48pgGptARpFNGKK6ukikwXRkWeRj4mkf6w=;
        b=ZgtiEjwiiuLQ09DGDCi8uilV0zBzZxKYlRG8HVI0/eBSR7dpujX9z984G6rHQTXNE8
         HORWoS11nSJSngLUpz9JRX1Kn72uDUtdN+xgT19pQry2Xx6ZuhhNy8eorxHfpxZrOsC/
         ROqc6/67r5rS9DHHUnI0XXU5DAhRpxq3vpJqjVY9RgWwNtiWsrXmfIhz8GOTHIUvxema
         EW2j64w3KuIS1UEY1g+ube12rBdCVXVXCFtFRliL37fCqKZtm17sWWG5L7xPMKrGh3NN
         rUqNRNzZNrGcZNdc46WKtL6XlYfYz2yBUJzjsGa6XRJo/TpaumgsnTeuNLdFrKzEm3MH
         XNpQ==
X-Gm-Message-State: AOAM5309DF3WYu+HjvfPtEl6pLLsLKUY7aWiF6tDFPVUQy8D3RKjyqPi
        zqTvB+y5+FQdWxa34LjIoVhTeO0Uw2NpEpA8lSDZb/9Sqa6oAQ==
X-Google-Smtp-Source: ABdhPJzIAxw+So2hADbDa1PD9YD18Whgbf4zscgkoSarj8JoxT8oiLdBaWJDWuLhBmheGND6+rm8R8C9HOZYcEvOvUE=
X-Received: by 2002:a81:7141:0:b0:2d3:d549:23f8 with SMTP id
 m62-20020a817141000000b002d3d54923f8mr22877765ywc.87.1645511913159; Mon, 21
 Feb 2022 22:38:33 -0800 (PST)
MIME-Version: 1.0
References: <20220221084921.147454846@linuxfoundation.org>
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 12:08:22 +0530
Message-ID: <CA+G9fYsEJ=zLgAHjk7Fp4Tf7M330Tw0vPWHNoy7LGC4LfiYyzQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/121] 5.10.102-rc1 review
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

On Mon, 21 Feb 2022 at 14:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.102 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.102-rc1.gz
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

NOTE:
Build warning noticed on arm and arm64.
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
undefined [-Wsequence-point]
  726 |                 rc =3D rc =3D PTR_ERR(ctx);
         |                 ~~~^~~~~~~~~~~~~~~~~~~

## Build
* kernel: 5.10.102-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 6c935cea31db8d0fa9dc4f765383345cc2ecafef
* git describe: v5.10.101-122-g6c935cea31db
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.101-122-g6c935cea31db

## Test Regressions (compared to v5.10.101)
No test regressions found.

## Metric Regressions (compared to v5.10.101)
* arm, build warnings
* arm64, build warnings

drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
undefined [-Wsequence-point]
  726 |                 rc =3D rc =3D PTR_ERR(ctx);
      |                 ~~~^~~~~~~~~~~~~~~~~~~


## Test Fixes (compared to v5.10.101)
No test fixes found.

## Metric Fixes (compared to v5.10.101)
No metric fixes found.

## Test result summary
total: 96836, pass: 83846, fail: 529, skip: 11518, xfail: 943

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 39 passed, 2 failed
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

--
Linaro LKFT
https://lkft.linaro.org
