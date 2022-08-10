Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C902058E9C0
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiHJJiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 05:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiHJJiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 05:38:50 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2451F6EF02
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:38:49 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k26so26695608ejx.5
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 02:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Rpc1heuT2lTdf2haoFSyi9HX+0SVlsyo53PGOFGRe2g=;
        b=wlEvESgHc817iRkxJfikIheDgY6KLfBZ1yb8op9fkFoU54F7nSPdfh7KvCPFsJEfEW
         kngon2s5Wy8qUSYjbS7+izRz2SC73YrUkoXlRluIAKOnWAryWeF89b37VsVodWphoO4l
         luWlnpJ8j+M16+HKwK4vb4mY0ntQtVjI1T5/VfG7L0OXZ1jLUaXEaFxT0xXo5QZpnEuS
         3aOsJxCT4MoeEl7QM/ZrS86xZ6EQD63Z0hvFJ1ExhPoVj8DV4BjM1XgZwz1eC2Cw7PMH
         SFO4IXplFb/ekV0vBAuZF4c2pUtHX0iIFwRn3fYXMecnQ3YMKzyBSy/ugBnkrE827rZR
         y3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Rpc1heuT2lTdf2haoFSyi9HX+0SVlsyo53PGOFGRe2g=;
        b=55JP9Scvwp/Xhf7Jakv1z+Hojzh/3Mf1T1fHlneqYz3O1qErapavtwJVSh5SF1fOik
         KRDjhqffRqttLdpFfc6Zfk7FC0NP1erV6GsMDNzb7o8SQn2mZhlv+VgbqOESgmZkqfvG
         iopZGpwD+vrMcqVIKrMhM8cpd2LMXXth93P/MGpiObDqPCLQ6JeR6QVxQFXRxVlC5bGf
         uEBphBJtPNrsd4eMXXgOeOynQvjc0Uhq0DxUjrSwfmjHDJOHkQvyh/Fr+7qZvqtNCrzV
         5VgThUQEiLsN1y+hpQnHIL5lK0qwetDQRB2sbuF2RNN06EaGDC+kVOXWbssXFqrnreyQ
         dgtA==
X-Gm-Message-State: ACgBeo3fXYqeCciGggIpOUZ61H9kwOQccLBaa1bgUSGu2qJxJt1SPeEh
        Te0q5heGwb4uzhBrb3UO6jBQ0oSCEKQg1ZQ7h8TR5w==
X-Google-Smtp-Source: AA6agR7hUlP3cvvlEctjDrH/fvmLzvB9gYRrnFXynBOi5/OrP/CJeV01JulZEGnfXXdDJJWhBvCJiY0nyNvUFm5E6PA=
X-Received: by 2002:a17:907:86ac:b0:731:5180:8aa0 with SMTP id
 qa44-20020a17090786ac00b0073151808aa0mr10541617ejc.366.1660124327536; Wed, 10
 Aug 2022 02:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175513.082573955@linuxfoundation.org>
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Aug 2022 15:08:36 +0530
Message-ID: <CA+G9fYtb4o4uxuxO1QYpBrGfse76z_rbz1yh1cStK0fhUu9DZQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.255-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 9 Aug 2022 at 23:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.255 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.255-rc1.gz
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

NOTE:
Following warnings were noticed on arm64 and arm

WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
aarch64-linux-gnu-ld: warning: -z norelro ignored
aarch64-linux-gnu-ld: warning: .tmp_vmlinux1 has a LOAD segment with
RWX permissions
aarch64-linux-gnu-ld: warning: -z norelro ignored
aarch64-linux-gnu-ld: warning: .tmp_vmlinux2 has a LOAD segment with
RWX permissions
aarch64-linux-gnu-ld: warning: -z norelro ignored
aarch64-linux-gnu-ld: warning: vmlinux has a LOAD segment with RWX permissions

This was reported on earlier stable rc reviews
ref:
https://lore.kernel.org/lkml/CA+G9fYuxx3wdLXiKhYAPEs-g6uxPn-OsyaiHQOvjuegVEShgMg@mail.gmail.com/

## Build
* kernel: 4.19.255-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 02c6011ece11c67e9ec89b3d3e0c25cff42b3ea0
* git describe: v4.19.254-33-g02c6011ece11
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.254-33-g02c6011ece11

## No test Regressions (compared to v4.19.253-63-gf68ffa0f9e2a)

## No metric Regressions (compared to v4.19.253-63-gf68ffa0f9e2a)

## No test Fixes (compared to v4.19.253-63-gf68ffa0f9e2a)

## No Metric Fixes (compared to v4.19.253-63-gf68ffa0f9e2a)

## Test result summary
total: 66365, pass: 57931, fail: 287, skip: 7425, xfail: 722

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 286 passed, 5 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 35 total, 35 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 52 total, 51 passed, 1 failed

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
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
