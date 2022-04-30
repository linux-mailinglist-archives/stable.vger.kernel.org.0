Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E019515AB7
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 07:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbiD3F6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Apr 2022 01:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiD3F6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Apr 2022 01:58:49 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1691533880
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 22:55:26 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id y2so17835236ybi.7
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 22:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ktUMdoc7ws6sqgrvHayMFqpl1EJEhnMqrDzGxQVYG9g=;
        b=orGAvFGMILj/xt/FHfwH6HWrQ/yHsCL0XHz+SyJ+HVW2h06Pkb6Oh7kwGh0sIPYA+w
         Yyi41ihxB4DbqI1Zau0mi5biRQ6D6CUS89InOmqjZwSXYPjYJLLxVzIkvKe5PQHADdxJ
         fsxGak7KKE+szYTqEnJw5ai5pho8jNw+zzKtaiIj/mg97ICdl0JhyWIM7QZFBJMdRVrS
         6/qkPgUmJYgLLPDI1z+veOYIh5yq5rNUIxuwUeQUPgRMFho/qItzScBIJE9+QXUYLigZ
         YdjzRvXJhbrGlg7fm+1jk6WO/ENtL/+qoSOvd2RoZpMfhMoq1HKHfRQrvcbig+GhhFkn
         e6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ktUMdoc7ws6sqgrvHayMFqpl1EJEhnMqrDzGxQVYG9g=;
        b=rrlYeJG60BnYP7FPnzgcKVvcaJV6AFd78HH2uxvRTjsbE2+1xj2Xdlp+eKcw50bt32
         e40/mef3L4ZyOjHsBE0KujdskdhoMlWCwm4j3H8TMt/PtBt1GbgYFRBTEmUTXFtvfXg0
         E19jx9lQTkg7mbdaoeO76kulXDCit6wd0fmfNow2nRbUCPInKrXGwvetggcYaIf1rwPo
         Ek7e6J8TgjBSghbpku48ILlOubq50yV9Zh9Y91UNjRUvvDjDo28TMWabqOUuebkB+30l
         mo+9iCHqiJS61KYI9LgZkR792X124+GmZH6gDX5O8ON6MT+cMsg4AHgorvOnyfbBXIQo
         NqBQ==
X-Gm-Message-State: AOAM530GEW9aNEiSJ/5x8mSLjBWbSnCFYeQsxt1NiqkZcMYuzNL4B1j+
        KF3Ep39uM4HVvSaeKDc0Un7CazkBjxp+q0x/+N8MLg==
X-Google-Smtp-Source: ABdhPJxkCWQhD2d+1BYTgfFSDMtMFysgkFueVJyWUueeLLxBcRvsnqSsN/AodEuKVMu82JVZr0sYfLV8O1Y4hi9RrOM=
X-Received: by 2002:a25:8045:0:b0:648:a9b3:96d0 with SMTP id
 a5-20020a258045000000b00648a9b396d0mr2517582ybn.88.1651298125113; Fri, 29 Apr
 2022 22:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220429104048.459089941@linuxfoundation.org>
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Apr 2022 11:25:13 +0530
Message-ID: <CA+G9fYvH7iUPb9a_3LEZnb+i8hbisf8+fmW=+SZwWX8FbNavaQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/12] 4.19.241-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Apr 2022 at 16:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.241 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 May 2022 10:40:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.241-rc1.gz
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

NOTE:
1) As I have reported on the previous stable rc reviews,
   Deadlock warning has been happening on x86 and Juno [1]

[1] https://lore.kernel.org/stable/165094019509.1648.12340115187043043420@n=
oble.neil.brown.name/

## Build
* kernel: 4.19.241-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: aca3ff930ee4690457052e389411fa5f5ee8af52
* git describe: v4.19.240-13-gaca3ff930ee4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.240-13-gaca3ff930ee4

## Test Regressions (compared to v4.19.239)
No test regressions found.

## Metric Regressions (compared to v4.19.239)
No metric regressions found.

## Test Fixes (compared to v4.19.239)
No test fixes found.

## Metric Fixes (compared to v4.19.239)
No metric fixes found.

## Test result summary
total: 85558, pass: 68834, fail: 1124, skip: 13639, xfail: 1961

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* fwts
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
