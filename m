Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA658E86B
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiHJIIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 04:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiHJIIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 04:08:44 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EA381B39
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 01:08:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t5so17991049edc.11
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 01:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TbjshjjhQ+T1uLO0OvTUlM6OMRUql8fN9DD1k0ZnfXg=;
        b=pQFzLHFC2OVQpoCL4sJe6coUv/3uWYYKEgX/lGwof0rX6wYxqsXcSa2toYl7uJ2D2m
         u9pw5TzVNjaT3zUG0NtAerHjQ3c8xIgQk7RRTDwfo0gtkrHDRkzH7Wm6xUB1fyb2Uzk1
         JfgogEdL3/IoP5OT3KVDDHU0RdFdIlv1MfdSQwhyQDRd0TKT1b7v5czyu4HZ7WfbXbvN
         BuHIXWQsO4seuSgjV4vUp6zSfvSPR5L7xpASp7Lcjf+zWNkjBNiO5+n6KYQAW9MwgltH
         K+JQS6RwXjRPGBOrkOWaExd/joAEEPFPJTJub4JwQ8nOnaMjooq4hdOA0UODvfvsnEKS
         cxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TbjshjjhQ+T1uLO0OvTUlM6OMRUql8fN9DD1k0ZnfXg=;
        b=5qKklrt6JMs6L+d+h6hZdgaBSkrHJ9hNjvdFF/3oLNYJwq1wTWKbq6uBjOQVkbjF51
         nwFvv6O4mCoE2kwF3F6T2s4egaWRA7QpebHksisyliMBSAH2xDLqAigO/ZiqqDY0IaY7
         lprYOoRb9+ZFFHwtuBqQs0L+rMqGfV4ZJE4wUhrcqpdPTWct3Wam2mWM6TveBRCoQPEX
         /a7h9jx9Lofrw3JM92ibllb0FE/aiwH/7Fb3j5tcKqh/CMNTUSWEQX9UohVdWiuGgWO7
         kcwE91qN0+U1hhN0kkMDTp8vJsr+gVy89RYplp9FRbUM7oF7et8ErhouW7IDwI/tWiJZ
         N6uA==
X-Gm-Message-State: ACgBeo1QhQrsUCsEJ/cXT7OfB6ru+EjRNv8E8UI2xcCBy/+W0esfhLly
        oPOV/0ZT0nsM/hCMeVIY3IJkuYc8FdQ/kn+P4zK5Pg==
X-Google-Smtp-Source: AA6agR7vPgRitL6W2ZV9lLZzL1QaUILmfY1KsZcXUUs5hkxIBOCRRdtXtFKC+RR3SWOnPkn5RQDTs7zufuAx4DvFWxw=
X-Received: by 2002:a05:6402:32a8:b0:43e:5490:295f with SMTP id
 f40-20020a05640232a800b0043e5490295fmr25401868eda.193.1660118921614; Wed, 10
 Aug 2022 01:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175514.276643253@linuxfoundation.org>
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Aug 2022 13:38:30 +0530
Message-ID: <CA+G9fYur1ndfYHyRdrZYbK2J15xQXrcmSSTXPsf15MKx8Y=9ig@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/30] 5.15.60-rc1 review
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

On Tue, 9 Aug 2022 at 23:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.60 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.60-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.60-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 9c5eacc2ad1f605c31c69d9e2436823ada99f1dc
* git describe: v5.15.59-31-g9c5eacc2ad1f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.59-31-g9c5eacc2ad1f

## No test Regressions (compared to v5.15.57-273-gd676d6149a2f)

## No metric Regressions (compared to v5.15.57-273-gd676d6149a2f)

## No test Fixes (compared to v5.15.57-273-gd676d6149a2f)

## No metric Fixes (compared to v5.15.57-273-gd676d6149a2f)

## Test result summary
total: 138024, pass: 121969, fail: 720, skip: 14555, xfail: 780

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 53 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
