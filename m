Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5F84E42E8
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 16:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbiCVPZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 11:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiCVPZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 11:25:29 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C0A7665E
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 08:24:01 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2e592e700acso194765227b3.5
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rMRkgxZtwh6LVOknVFp6JkiWO/LBgxf8wvheaEHEFqE=;
        b=cw5D14hd2fIgYRAdNONpHmcE+H18zfoHizxp3JEKFUQxzn55sJcuLg7o36Y2v56rMl
         ZIwceRY1ZGzmW/YMWU8mQRELGIRPcv1In6ShobUFQEYi9DQma80k9KpvuPvFmZzWQNyV
         ketpiudLDPSQFh3dopoUa8Rqo7J1jdIwK9IHHnhMyowpON7wNxUS1BomCGzaS/ppwrpl
         EEliVF3VvRua7ZBMSak+F/Impt/ygz4AK0HCF2FcT/4ny3qPbncytcYS7/p6XGkSo+2t
         BdpPJw4xl5pwu9Tt+F7eD6eoZmYgj3zu7UE0wIS2CoIoDpiLA5RyQsGZiHELbSOJuesX
         g+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rMRkgxZtwh6LVOknVFp6JkiWO/LBgxf8wvheaEHEFqE=;
        b=nq/2jIWwKVSHLiB212buMawm7wm8XM86UuHkN21n4ZHSPpC15rBE7OmOKowPAJ902L
         nNx7Xh8nuM1pqtXll3vQg9bkZ7VpoVmf8NLYL7MFhrCG1zjq/Ts36V43BCIoT20iVnRm
         Lg9lyTKtXU9IxpUm1QEGH4c4BJSVdK+K6NQSKD4zjtYQbPpznuKfyKGVLchvbey4jMVY
         a7yBdSoGPbXCpDOZSC8A6d8HaDUW4UNxnvIxuCaXVwXC8FA+nFatHJkxCdK7lcWNgDdi
         chIF90nvOZHuU3G+qtMhvXip9pwO2Qya/tviVmxzPhRcP2YMVyrEu4G9pZzXEfrlzTxy
         PPyQ==
X-Gm-Message-State: AOAM530b+kI6xELZTQSw9cj/4QhTT1G5G+0heNoMcmsb5IoCRT8fmrUu
        UPi+OY/ru9BBGhrH/cgi2VtOsvJzyfDthh8v/9SHlg==
X-Google-Smtp-Source: ABdhPJwLLAOxZ4thC3+vdVClOxmlxKlNCJQ5OEiQIuA6+C5ovVTGWnNeeIuX2bOlL4uOpLf95NIp4dX+B5Waub2lmqQ=
X-Received: by 2002:a0d:d187:0:b0:2dc:5d83:217d with SMTP id
 t129-20020a0dd187000000b002dc5d83217dmr29395151ywd.189.1647962640392; Tue, 22
 Mar 2022 08:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133221.984120927@linuxfoundation.org>
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Mar 2022 20:53:49 +0530
Message-ID: <CA+G9fYs0+aKGR2Q=4xRHqTubyODeDkMRJMZ_dyQ=EcY71H0+8w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/57] 4.19.236-rc1 review
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

On Mon, 21 Mar 2022 at 19:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.236 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.236-rc1.gz
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
* kernel: 4.19.236-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: a78343b23caede1f7ef885dce0e97225fb3f19e0
* git describe: v4.19.235-58-ga78343b23cae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.235-58-ga78343b23cae

## Test Regressions (compared to v4.19.234-31-g4a3043563aa9)
No test regressions found.

## Metric Regressions (compared to v4.19.234-31-g4a3043563aa9)
No metric regressions found.

## Test Fixes (compared to v4.19.234-31-g4a3043563aa9)
No test fixes found.

## Metric Fixes (compared to v4.19.234-31-g4a3043563aa9)
No metric fixes found.

## Test result summary
total: 81796, pass: 66849, fail: 852, skip: 12389, xfail: 1706

## Build Summary
* arm: 280 total, 274 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 19 passed, 1 failed
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
