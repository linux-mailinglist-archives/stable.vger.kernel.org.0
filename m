Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750685EBF87
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiI0KQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 06:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiI0KPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 06:15:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EB0915C6
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 03:15:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so19581102ejb.13
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 03:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=leS/xQaARk95/TnLqpG9/ZFFnLSTDgPqMipin+1cKnM=;
        b=JMx9OewRbLhiyPn7BxqgW0h1HXXCeZ+5JLx6pOO4Ts0WhERZWPiONQ88+QlNoqRrDX
         8ZxMOEGm8WLbdpY91F7hK3d4qaCU5dcUx2RZm8p07Ua8HIvJVrY62/nsTLObYgy+3EMk
         T6ChysaKuF+ysmnEPAyN9lbOwWDORopjNydnrG/UGe4QDK26o0PiEtjA3Abr/Zt28Bvk
         GMijMkbGDKxxbz2vwYtH0fTViMA4LDFqASm3P/nb9K/DEigHUPqI1soExigaxNlfqr7Y
         y+XfyS8FU6rNhEi1ceyLQg74oxZ5SAnIbcsmOr4uCuJzrjiCSdK0lkcn6oxi94dDddSn
         Uhog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=leS/xQaARk95/TnLqpG9/ZFFnLSTDgPqMipin+1cKnM=;
        b=ZMlmaqNaw+xM0LOGsGYGaOY1BpK4qVdBtprJmORx7GS61xA3AgyqnIXlYLVpfLzEed
         CWpsN+u9q+UAVJeOFjpFT1mIf543t3gjN8sOeNyK74+xzVD9ep/XGvMwb9UnuXN2f0Wo
         oKzWL1Dh9b16u9W6Nl6+qr7oorS1f1ghrsvWITiz86GKM9cmtCzpnnVUu0sHMNHIaAtY
         1d9RBX+xDNR3C4T5Q8rK0Qz7b0FHJdhev/9lJVfKltXUqQhjC1Nh4SiHSpgh7sW1mjcp
         bCjNrONA6pQ46ls+YtnGzpMsuUNr3dnq4rJn8lvOuJxFdcoLMgpm6beX2eHrdA4lFdp1
         L8rQ==
X-Gm-Message-State: ACrzQf0G8xgne57f+youvbS+E/wJESgFuCkWST3vWQ4Aie5xOzOJg4Xv
        k1Dgz9ccz8faODW/QB9Q6kB/rYKOFSeTT/p4KG/V1A==
X-Google-Smtp-Source: AMsMyM6JGh7UnuECkqMRnCtdnonnfxFtpFvOPIAXZzlzMJVe++zKMy1exNpogL6xwSEHOHIFaO/ob8/+oZ26P9vej7E=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr22284005ejb.169.1664273735339; Tue, 27
 Sep 2022 03:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220926163535.997144838@linuxfoundation.org>
In-Reply-To: <20220926163535.997144838@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Sep 2022 15:45:23 +0530
Message-ID: <CA+G9fYsUS-D2r7pwMKwVz87g-4vktO=yGjyiMbJTdoE==yQErQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/38] 4.14.295-rc2 review
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
> This is the start of the stable review cycle for the 4.14.295 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.295-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.295-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 82b142ac43600540f1cd9f15d1e6b5aa2f8034dd
* git describe: v4.14.294-39-g82b142ac4360
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.294-39-g82b142ac4360

## No Test Regressions (compared to v4.14.294)

## No Metric Regressions (compared to v4.14.294)

## No Test Fixes (compared to v4.14.294)

## No Metric Fixes (compared to v4.14.294)

## Test result summary
total: 55251, pass: 48138, fail: 471, skip: 6280, xfail: 362

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 308 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

## Test suites summary
* fwts
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
