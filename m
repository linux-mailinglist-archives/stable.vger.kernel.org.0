Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6B94C8896
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiCAJ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbiCAJ6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:58:33 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC611DA6A
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 01:57:52 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2dbd97f9bfcso20419467b3.9
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 01:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Qee/3ouJ9DM4ILqUhdVC3wPnlUxhQ79bmhKE0E3lC+E=;
        b=kmm0zokZtwPnaJC25cBoWna+2xXHOg5cJOmIF5g7nM7SWhRyVmGu9QVjLtZASCmGMu
         PTB//f5VTwuU+u2wba6qTm5tdm12g7VsktrC5t8+lZCv8mQAxp2FQRdgNR7UjvTClg0/
         w0+8o2piKHXotEBLss8NEz+7SvbL9h6kE/95fiRFDaaWfHpJbACTBOt+cicR7s/4Q4jd
         8uzVVz2i0c+e7Y5BfrcaT/My4XfUQr28JWnoiiGbRT2PfUxodEXIkHQQsw86991hdLBS
         zdvtR3VdndofP5UBeib5BhDmYUxx5Ab/E/7Ya9C7lroFPYKWW24XpjmG6Z7LgohuBMbz
         P27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Qee/3ouJ9DM4ILqUhdVC3wPnlUxhQ79bmhKE0E3lC+E=;
        b=ruT3OqDrfkLz+pj1DYUPFUoLgyChVQPDorQ2+tTJCz/4GwxcbIU0tNA+71mxnplRJb
         wQYJq+ZQqq1aobw06m/4t5DF0iUD4kC3MjYjoObtEKP/oIW/1BOhqxAPkQ7Z0riOwMEw
         UMQG7G0kZxwK8c2U3Kx64kgLNHzIHjEU9rlAtwdlH5y2tv0BaEUWNLaZYHHkRN6WF66b
         fkAugTrq3Qlns0+8oiBtOAn1tHxLtn//RCii27LyCHSb5BxZGRoYAf+WQMD0vq+VYwR5
         qkY7U1flsdAiL5ReKy/XecXXWroyPH2KNBn1gd2uiyJx79PvumxvFPwuV6SBeUOATGRv
         336g==
X-Gm-Message-State: AOAM5315U/DVseNcYI48ISkVTX/hAjZvhuFEpSqg/1HkDtPCLVWtxRkr
        dEaav9S0p2u/CfKr37+nLdoQI9l4e+zH1AZK8y8Oog==
X-Google-Smtp-Source: ABdhPJyrIJssRcdkYlbUMZS+1C716nMO9jZFhr4Nr3oJZzh/jhmwZdVZCrmm1B0x8jZcM+3+pNXODlucAQcEdFIkoO4=
X-Received: by 2002:a81:642:0:b0:2d6:baf8:ee52 with SMTP id
 63-20020a810642000000b002d6baf8ee52mr23809916ywg.36.1646128671619; Tue, 01
 Mar 2022 01:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20220228172311.789892158@linuxfoundation.org>
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Mar 2022 15:27:40 +0530
Message-ID: <CA+G9fYtXWn-U=rojccfrb9jK=eK8d8-+Qrk7j-KGahefa5e+Pw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/80] 5.10.103-rc1 review
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

On Mon, 28 Feb 2022 at 23:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.103 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.103-rc1.gz
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
* kernel: 5.10.103-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 3a000049e6a1d04d2e57cd3de7783075811d62e8
* git describe: v5.10.102-81-g3a000049e6a1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.102-81-g3a000049e6a1

## Test Regressions (compared to v5.10.101-122-g6c935cea31db)
No test regressions found.

## Metric Regressions (compared to v5.10.101-122-g6c935cea31db)
No metric regressions found.

## Test Fixes (compared to v5.10.101-122-g6c935cea31db)
No test fixes found.

## Metric Fixes (compared to v5.10.101-122-g6c935cea31db)
No metric fixes found.

## Test result summary
total: 97503, pass: 84163, fail: 521, skip: 12008, xfail: 811

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
* powerpc: 24 total, 15 passed, 9 failed
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
