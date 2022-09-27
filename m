Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528175EBF6D
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 12:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiI0KLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiI0KLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 06:11:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A767E32A
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 03:11:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hy2so19585229ejc.8
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 03:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DJwulReeAW80Iu6JquNPcionRqdhR/tHVY+P8As46JI=;
        b=E/+an8NIxLQWVKoMYdFN9yZbTRBvStZXyenvfc0dE82TJpiYyTHv62S7IA0RPtzxVr
         koVlCg0BAIy6AzGyLs1xqGXT8j53NcZ5gobG7dYpcFh620TuZScg0xZUH7YAL7sbgoFC
         MKpYENs+3UECJpORq6F1KF2g7tocYVmAt03DxCrDnF642b6wwsuaeuTrcm1D+xQ3kHQ4
         XpIJU+4FE5a0MADpyJrxkWpgT7hSRV2UPTZ1pGrjwNMYUeICkPIcmegzasHK4vaBgW+g
         vrtqDgc5llXaW+X30WiLhse5CH31FJhPvxz3Wdk4gQtkdMdCfiBKDxZQcQIYFUW3tKYp
         RB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DJwulReeAW80Iu6JquNPcionRqdhR/tHVY+P8As46JI=;
        b=F1FYWb1Kfzu0L3W6ABJcyLVl2bEzrN6IfaA7C3q2Km/38CQWl+bwEK+sSCE5IOPqhV
         keIcovnWH9NrobtT1lUEvznNS0vBqUNgHR/eim5a1yNHmfZrKDgv4bRmn1S6QPkRMA7n
         5hmIxY+C2sPXJO8xk//uTjVfUdCk2XNwuVLXOG0HEbpFLSHGoGCg25cnv8mAtMvQw275
         qeG+9wHVUKFU52xEjQaDgdyconYuvelV2tnXs/JHlWsJX/5Y2sj2wWg+nqTdXHbYf7vS
         ASWBndrjvNCHdcYDBbe1kJzeWi/omIezteH9qwXlU/+zwZo16ejyz53yPvyIfJfAoiNJ
         KX/g==
X-Gm-Message-State: ACrzQf18t5cOLpeJsJ6xJA3cil/clAJWuZVNFQZWcmUpTepbO2Dacak3
        WsRk0jbPQP6b4ye5vO6G1/nAy1YBqa4ZWdp9aReYRQ==
X-Google-Smtp-Source: AMsMyM7zrJFcZWwUIxgHfr2zGXKyJqpuTGuBpB3PHSuEOBcL68oP76M5RRNlEdicQquCaPfrSdPe/jDsK174MM4EFrs=
X-Received: by 2002:a17:906:fd85:b0:77b:b538:6472 with SMTP id
 xa5-20020a170906fd8500b0077bb5386472mr21704831ejb.48.1664273500965; Tue, 27
 Sep 2022 03:11:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163538.084331103@linuxfoundation.org>
In-Reply-To: <20220926163538.084331103@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 15:41:29 +0530
Message-ID: <CA+G9fYsNrySe61zx-WvM3qao8PBRBruB0Y6pOhMuY=Dphy741A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/55] 4.19.260-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 22:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.260 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.260-rc2.gz
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
* kernel: 4.19.260-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 210639ab50c7449960634116a955bfabafea82e7
* git describe: v4.19.259-56-g210639ab50c7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.259-56-g210639ab50c7

## No Test Regressions (compared to v4.19.259)

## No Metric Regressions (compared to v4.19.259)

## No Test Fixes (compared to v4.19.259)

## No Metric Fixes (compared to v4.19.259)

## Test result summary
total: 77920, pass: 67899, fail: 614, skip: 9006, xfail: 401

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
* igt-gpu-tools
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
