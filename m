Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D991767782D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 11:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjAWKDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 05:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjAWKDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 05:03:00 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4C84EFC
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 02:02:58 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id v81so5682843vkv.5
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 02:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWwP1cHhbrCpT3iVhmhFxFIEiyySRDn6xTntT/tDeLY=;
        b=KRfRNNnL3GG5PjimEaJnuiEZn/gmXiu06OFkb/e/2fS6KcxdO+pCPWXA4v/j5ahtvW
         QKWviSRlzJGIRivrC5kn03iCj4KZWyY6aZCynT5lmWRj8f+50I3ZQKdfmwj2c+/I/WZi
         mJFdw1ypZPIyDfSQUrEZaLWDvGiPlBJnzyqKehGS3C4JcvLX3uNzyKsQ8olOWoYW2pXi
         rDiBI5wb2dYFOAGYnCgKGHqleBGRGgj92TXO//ffb3DZ/2p25rrMGHfAN6maxe/rJXvP
         TgBF69of5DlWA11FmTvNRi7q7H+3e0oAiLQqKa+4vf0Eivt6Br0iD6ybsJnEjw44+4Kt
         DhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWwP1cHhbrCpT3iVhmhFxFIEiyySRDn6xTntT/tDeLY=;
        b=taM0+487Q+tvhwV6xdLdkZ/PQTUwiPKRfk2ntaD3xAYJYmLmOPoMVgyY1oJbjmrmmc
         0tt1m8bXj6nvp4QRhdfnS5c++bm85tHavXAp9xLl4zQAC6tzuxcQI+FN0IAzo6+Xbfc4
         QiFzp0SmSIYx2W+O04MokZPeeE1+eRLR2ZvmA6C4L3cPAImZoMYjXxWMYHmMmGuZyK5G
         EPOGH6mmK53V+OJ1pAfV1qOV+9YeWH1MRUe7WapgpghEEHU9meciPlOExgpoppXENxI/
         i8Oz79g4Qp9Q+svdIIEYHPMB2AZXIvRU0eZeWDjNhLNF1xe+VsdbLre3QzXRDmp+X9BF
         KY4A==
X-Gm-Message-State: AFqh2koWamsYOK7QvCX4BqagV3tl0WSJzhHeKXk2vzs3vsynym1tdHY/
        h0GLDKGbKypDZipw0bhBjIr9Fkzk3YFDZQGM2aB0zQ==
X-Google-Smtp-Source: AMrXdXvVsokGQFtmq/PY97LAzhrox/d9pUNUnm1weBxaXG6sOcPOSTAQvKLqisGUjHCgJasKeEgeMrPZC2KwXUWhk38=
X-Received: by 2002:a1f:5dc1:0:b0:3e1:9fdf:7740 with SMTP id
 r184-20020a1f5dc1000000b003e19fdf7740mr3024867vkb.20.1674468176951; Mon, 23
 Jan 2023 02:02:56 -0800 (PST)
MIME-Version: 1.0
References: <20230122150219.557984692@linuxfoundation.org>
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Jan 2023 15:32:45 +0530
Message-ID: <CA+G9fYs9qWWTjYkf73ok+wLuRoBf6rySQh6mp3Dyw0fzh=Fp4A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 22 Jan 2023 at 20:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.271-rc1.gz
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
* kernel: 4.19.271-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: f9f90bbcdb210bd6d0535a24f15019a5ddccf11a
* git describe: v4.19.269-516-gf9f90bbcdb21
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.269-516-gf9f90bbcdb21

## Test Regressions (compared to v4.19.269-478-g2738270a8760)

## Metric Regressions (compared to v4.19.269-478-g2738270a8760)

## Test Fixes (compared to v4.19.269-478-g2738270a8760)

## Metric Fixes (compared to v4.19.269-478-g2738270a8760)

## Test result summary
total: 112364, pass: 85254, fail: 3276, skip: 23704, xfail: 130

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 316 passed, 7 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

## Test suites summary
* boot
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-net-forwarding
* kselftest-net-mptcp
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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
