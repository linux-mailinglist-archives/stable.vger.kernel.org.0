Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED364E42F7
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbiCVP3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 11:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238499AbiCVP3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 11:29:39 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BFE294
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 08:28:11 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id u103so34257826ybi.9
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 08:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5OphcbqCvpsr6M8Vdm3IZvaMniCBLLpqro87f20by7I=;
        b=cP5l6kuOhGa2NIFX0lSgTv3KX7wNCjukAhamFY0GzHp6M1U8tMNg8hOhUduyo70T1M
         B31mtAuBTrDx9QuHMdlu586g3GeY0umcRas81yhNJ2ncSDPBTpnD9T3LeNIrKZZ0HGrT
         iyj9vQWuDOjpNGVHu92wFCZcmGJ1x1XQGSPDuKavRsCwZU6ixDPg/4cjq6rTPx3esnvh
         k+Sz8niVifCDmHO4aWd9pLT1vIhJvrZ3ByqDRn8vB+9seqyxkgKCjCP6ui+ROuyXxd4X
         tAhZeeBsodNJdR2ZSlGgLXZpYy76EUc6CabsgsSRR6d8J7zZwoQz8mpTsO8pOr+mabdF
         k00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5OphcbqCvpsr6M8Vdm3IZvaMniCBLLpqro87f20by7I=;
        b=STEl4r41m57GkmIYrrBZUa971657SYjOBEzyOKOxHYvsQ5Wsz8t2ptL3nqpxVFhv1p
         hDL9r36FTBw9nlh6BXW6ktGuVvgmgcu7AQwLXXk3BItgX53UZl3g9kbhWP11L+ONe3RF
         xeeaFoLxaj70mx6lzxgOBrUAjbV78dc2KPAgJxCifN3Bsp1M2zn4wnnPwL6zi8u8ghgf
         lZ54G1/S/dRA6xoY150HIof1jABKLtox+FN2/Zg45G148UNKO0gmjCrDfVtQmSpTDLLD
         fxskLdolAbgtkvdguMZ8IN1H2J8KUTQhH7qEGLoN3fm2KDDz3wtcn+JecTk1OrudMKtx
         j46g==
X-Gm-Message-State: AOAM531FHH5Xk125jU2lFE64ear0PexM9ns9e43eDKBjTjSRlEVHlK6v
        CLPqjdamHn+o+AJ0jD2++CED9WO4I7usYV4oMntTFw==
X-Google-Smtp-Source: ABdhPJxX7msaA/OuYVdNFTYBmHmaknr4iEnV1D+ilxqM1QiabCf/srnsbs1GVfF3MZTd/FFt2tAyvsHBarbiJX+lCj0=
X-Received: by 2002:a25:9846:0:b0:61a:3deb:4d39 with SMTP id
 k6-20020a259846000000b0061a3deb4d39mr27437171ybo.537.1647962890736; Tue, 22
 Mar 2022 08:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220321133217.602054917@linuxfoundation.org>
In-Reply-To: <20220321133217.602054917@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Mar 2022 20:57:58 +0530
Message-ID: <CA+G9fYsa8pvVdsnEV9YEkxhcXzY2NYV0ev2v7APsTC3K8KEJzw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/22] 4.14.273-rc1 review
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

On Mon, 21 Mar 2022 at 19:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.273 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.273-rc1.gz
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
* kernel: 4.14.273-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 7d28b4c6f4588cfdd8cd0d45f9183570fae70ffb
* git describe: v4.14.272-23-g7d28b4c6f458
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.272-23-g7d28b4c6f458

## Test Regressions (compared to v4.14.272-15-gd7a314aa75d7)
No test regressions found.

## Metric Regressions (compared to v4.14.272-15-gd7a314aa75d7)
No metric regressions found.

## Test Fixes (compared to v4.14.272-15-gd7a314aa75d7)
No test fixes found.

## Metric Fixes (compared to v4.14.272-15-gd7a314aa75d7)
No metric fixes found.

## Test result summary
total: 80301, pass: 64836, fail: 778, skip: 12411, xfail: 2276

## Build Summary
* arm: 280 total, 270 passed, 10 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 24 total, 0 passed, 24 failed
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
