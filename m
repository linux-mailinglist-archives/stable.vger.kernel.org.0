Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461CC60D23F
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJYRH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 13:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiJYRH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 13:07:58 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EC2108DD7
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:07:56 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k2so14330641ejr.2
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 10:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AC1uAuVt0BevV1hXaTU1Uc4K/3bo5jaK0nilJIQDNPs=;
        b=lYp5I8az47ZXp+iQT2xHj8wjnds3sQrp19gPb2X96V90OoHMnW299aQ6j42w1AAbNf
         6uKKqGBUNb4U2WEzBXPLkEX11qEdhK0oDfiKQ/3uUwdyXU4SOamIcvY7Yt2EGav6525s
         qnP8PF+yj4x/Pt+tBIeT5GkLxKUNE4ju0a3f+L0z6IdRtIpoQHWbj754g5hCbT1OXln6
         6Zl6ATBRYh6PympCdZgI7d9wbOk8SdCSQJsBNf0BurNN7Smd2pfYmNbeFNjSsoB2vCyN
         5n+s4+MGFft420Uozm+UwBwHBkA+qI4HYC2B1UIwlEOCUzPgOvd4jBj3VT5erloIWCsK
         8ZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AC1uAuVt0BevV1hXaTU1Uc4K/3bo5jaK0nilJIQDNPs=;
        b=FFZ7CBzBj0LvXn08HvOW7NVBDNIOhFRLLwgdSWDn6PM+SQe759NA7QgcAQuzfXdje9
         WlUF4jqB7TEek1x4MvMpI+KuDRlpqQuNpgWL2rJggvKCmFvhIbaPLtmHwaOwzYNU/SyG
         RdegAZgy6/yUlhA1B+8wtqeeYlAaNEK6UvKnkif7IABu4EMFv1i82IedXadpviQbRLGd
         ZTjiM1PSSiYb6Z3DDETOt7e9+6t1gi3H68B6PtNLQ2kc133ztB2+ndDYE6o+9cWyGqc+
         CD41vjwi1BqBQoRGAEm52GRV2OAyRoaxdO/ZS4loJA6qJLxowA+2LNFLX83YcQxoF3HG
         ewjQ==
X-Gm-Message-State: ACrzQf1EtftdTop6xnL5+kX7/XpPtyL4m8CQKAs6kudOzSzImkE6fPVL
        UU6dS0Mx45IOO6NafGWFLy0BucDNCa+9tu8pU0W9Hg==
X-Google-Smtp-Source: AMsMyM5+cM7THsirIfJ10IYZBSKVJbxS6df7eMLY+mACvZcOAjzxndRAS5qcMbtd7ct/wpM0jM7Pi9x2RnpZKe++EZQ=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr34004170ejb.633.1666717675144; Tue, 25
 Oct 2022 10:07:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221024112959.085534368@linuxfoundation.org>
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Oct 2022 22:37:43 +0530
Message-ID: <CA+G9fYteLc8VuPqLtgzb1nKGbO1NChbYeLkUxhb-JbnboAEwJA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/229] 4.19.262-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 at 17:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.262 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.262-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.262-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: a838554008fbadb75c035d3c473a2d9e26080a33
* git describe: v4.19.261-230-ga838554008fb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.261-230-ga838554008fb

## No Test Regressions (compared to v4.19.261)

## No Metric Regressions (compared to v4.19.261)

## No Test Fixes (compared to v4.19.261)

## No Metric Fixes (compared to v4.19.261)


## Test result summary
total: 50296, pass: 43870, fail: 595, skip: 5348, xfail: 483

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 318 passed, 5 failed
* arm64: 61 total, 60 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-zram
* kunit
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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
