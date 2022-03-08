Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C9D4D14C9
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 11:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbiCHKbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 05:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345729AbiCHKbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 05:31:32 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F245242ED8
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 02:30:35 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2db2add4516so196270317b3.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 02:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pI4sO34o2WA60Pcvn5zAQkpz6zs55UHDC+h4/Al1DFg=;
        b=e8dlJ2VyOEpOosCUIKiHjr+2UKegfTOM8FweNzRevMZdK1CIAdG4hV643EGMhONo4F
         HCsysbFENbfqLlORsf4fknZPyBMXosHKlQ3VrkOsyHRX/xMR0OqRlKnaqoHIk57WcZP2
         zxm8RZSxyNVxWP+Ut78bcezuzQyjv2oKCqVtDohNv8bsjPcfnrvRzeUisCzpAl/XZj3/
         z580ZA9Lo9WFgPBJO9IRs3dYBC5MWqrb8rtcftz3guLpDptQkUw8siYN1BWtDnjOml4Z
         gRyzrFJkW39TBSMEBowkxKSv+Wyyy77jpU9d2+sbPOUxQ5DupCe6pVXLwXtZLm8+Phas
         yg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pI4sO34o2WA60Pcvn5zAQkpz6zs55UHDC+h4/Al1DFg=;
        b=6RP5da5nUHgEsFzjP9qMgs/pGmeqEGuhjjliX3rHiTYxqSJVF0HgIKVXMb92B/q67G
         2bRYTZlt/EQwptzP2OB2YUt9ETIhWXCzo0JGsq8ZleKxfD4qIG2/eeqBH7B9+Gz7t710
         7CTIt6UIQ1EetdI4jy65DxWAqrZi32uL4sfew4l/Wre4eqxzxHkMLZozwF2ckW9FcQ/p
         Kud0ggKacvZ+Wj1MwSk4pDLS3qXnoozpL60kJzE3q7meGspqNlBF444R4md0JrS4NGAd
         8Hso3TxMmhIAHcGs+97OLBIdhGzccwdBY9q8e7UXQzxqdxqHIEQBDT3qZ8jgBaC7e5d0
         9iUg==
X-Gm-Message-State: AOAM533sIyZNsjcNSQ3yU7o4FYwo1R35s/ZwX0ENosqzfTmxU4mCLdji
        3b3RnS1ipLx26vbklSyJBHVmoI3AC/wGpWLSz3T92Rvq98ZR8sWe
X-Google-Smtp-Source: ABdhPJyD1mSCjF4jbeM4VIh8FpKRW07XbUnf51YR+THWdLXcImQb0DvP0dz6M2IUemltei896sLHEu7x/UVe50MXerQ=
X-Received: by 2002:a81:4ed5:0:b0:2dc:e57:e5f2 with SMTP id
 c204-20020a814ed5000000b002dc0e57e5f2mr12070641ywb.199.1646735434976; Tue, 08
 Mar 2022 02:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20220307162142.066663718@linuxfoundation.org>
In-Reply-To: <20220307162142.066663718@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 16:00:23 +0530
Message-ID: <CA+G9fYvuY20t+wEbNBUTHcMQnAOLVee0bqora02XFd+5xbryOA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/104] 5.10.104-rc2 review
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

On Mon, 7 Mar 2022 at 21:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 16:21:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.104-rc2.gz
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
* kernel: 5.10.104-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 79bd6348914c7f6f715fb706a7dde1de833e6fef
* git describe: v5.10.103-106-g79bd6348914c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.103-106-g79bd6348914c

## Test Regressions (compared to v5.10.103-105-g959462ebd29b)
No test regressions found.

## Metric Regressions (compared to v5.10.103-105-g959462ebd29b)
No metric regressions found.

## Test Fixes (compared to v5.10.103-105-g959462ebd29b)
No test fixes found.

## Metric Fixes (compared to v5.10.103-105-g959462ebd29b)
No metric fixes found.

## Test result summary
total: 101847, pass: 86386, fail: 912, skip: 13610, xfail: 939

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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
