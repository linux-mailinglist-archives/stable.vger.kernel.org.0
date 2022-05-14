Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475565272CB
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 18:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiENQHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 12:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiENQHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 12:07:49 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634501EECB
        for <stable@vger.kernel.org>; Sat, 14 May 2022 09:07:48 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id e12so20164254ybc.11
        for <stable@vger.kernel.org>; Sat, 14 May 2022 09:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G0eVXpYcKIK/j+1zkeKD2oL9HRdqUSTcmLP8+WyBRnI=;
        b=mitoN4cP0mKoaRMcv0pC3eEe5T4q/qafs9KxPyHMtuA6LYPQO94M+G/3Fa/F7ZHm+U
         fb0418Hoe0L1b+P1B+L4Pak37aj0RkRppIBZREZMj3ydsRP9+QRjcY9Qkk8qGJ3KNFx3
         bmFxHltw2ztm5gRVU+l3rn+GtmJXxTx+Jxp3fKGtkNxSMtZziMS1l4rtP8kOB4XniRJc
         FgxktOyyjhHlbWqDt9torTmvDc1Y9W84drvWyaBf78pQ+8bfooFGvSz0bh5ihzwJ7KW3
         acMG9hRK4HuQDWG5RAXho4+OVJscYD/yZ10mrnfcIQNx4ePwSzEhQO2pa7H0dCkMPF6B
         oT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G0eVXpYcKIK/j+1zkeKD2oL9HRdqUSTcmLP8+WyBRnI=;
        b=R3lmhR6TPR/b/E+vuoolOw+kdiYAo77RxKOfPdOaFm4TVkKwQK9OPSh5jNIkhDlmtW
         yHvLDd28hhkz9VKLxfeMYYRgh3vml5ZWByLcgX4WNxE21jnokhKGUiO4LVjR3rOza4Tx
         ftsXAERSe5eq00mfyfYjjgp9FEcV9Oj/kQi97duw0RgQYfJ26Z03H91Bk8/ULZwb19UC
         YTCELt4MKRf53rCODFiZ7fPlqpN2X5ns39O/QRYZp0hIYoAxC6sA/8r8sJzlNSkUMA+t
         Pt913M+ap4Bh9wyb9EKaYQVIyP91O1gmxf0yCAnqWDzijWdTQB9elrxv9MNcWwpsoo4G
         22jg==
X-Gm-Message-State: AOAM530wAusMQrXftGc8b4t3E+7KHADOHI4nRXB63fIW8hcdDi3Mh8Je
        SvGlotMLkzd1Me94bbR4+eOBq7KB3L25yuFdvYzD+w==
X-Google-Smtp-Source: ABdhPJyUtjvnYjzV22I3GFuVWb7pyCbaVQJl7iU8WoUjoa3cZ0nnQZyV/pbJmSDtNWnCL5ncOGZllksGRzmzFAXnLqY=
X-Received: by 2002:a25:ab72:0:b0:64b:9be4:d8b9 with SMTP id
 u105-20020a25ab72000000b0064b9be4d8b9mr7286471ybi.128.1652544467479; Sat, 14
 May 2022 09:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142227.381154244@linuxfoundation.org>
In-Reply-To: <20220513142227.381154244@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 May 2022 21:37:36 +0530
Message-ID: <CA+G9fYsmH6P2TQuXH6WOH0mwY66QejAc15kS9v52m3cSTZvRaw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/14] 4.14.279-rc1 review
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

On Fri, 13 May 2022 at 19:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.279 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.279-rc1.gz
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
* kernel: 4.14.279-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 4477341b2b1996b745937de9d99ff53095c7a679
* git describe: v4.14.278-15-g4477341b2b19
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.278-15-g4477341b2b19

## Test Regressions (compared to v4.14.278)
No test regressions found.

## Metric Regressions (compared to v4.14.278)
No metric regressions found.

## Test Fixes (compared to v4.14.278)
No test fixes found.

## Metric Fixes (compared to v4.14.278)
No metric fixes found.

## Test result summary
total: 67829, pass: 54211, fail: 882, skip: 11056, xfail: 1680

## Build Summary
* arm: 270 total, 270 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 16 total, 16 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
