Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4C45F3EEE
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 10:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiJDIz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 04:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiJDIzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 04:55:53 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB04E2A24A
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 01:55:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m3so17903291eda.12
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 01:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=SHSR6ZJe8dWMfrlVJj2iKz5kELlToBlFcEU948srVOw=;
        b=W38LZIl6Q9RXm2x0ek1HdjyXxVTdfWM+ylL7B0IoStZ8q0isxhbog9giyuyqyDDf7J
         CNL8cGY3l52aCOhgAxuPYYJNPr0I5W/l5luJd1+gALd0nlpq8aTfB5vqWFVaIQv9M6/z
         /wo9pEz1Lv7GyLum8/e5noqtC+GWbNw7SDA5w42BcADMt+FQgPdJm2UCaqwaAaxEc0Lq
         N4wAUFHz00uY9XwSdyZjDLf8QLLcHMVmgXacr+nSedBZd49+X1IY6hratNkKP/OC0FaP
         DLdhw+mNqIpRLxMacDgKvGAb8vdljfB512tMPARAJRhd3uG3jL5TZdWZJ2lo8w7qlW9t
         LObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=SHSR6ZJe8dWMfrlVJj2iKz5kELlToBlFcEU948srVOw=;
        b=ilrEU4e/cvNuBAX0RdD/JH6BfWBLZYPA9neRQHsX8bvS9CgjoKR0oI4BB7Gw55FYdV
         dd40VtFFln6wnvndLIPCmE4Z88cXmWzA7NR8MYAJsASztGuYn/elaMV4J+cUPZoh54ry
         eTCo7r9sasL9nkrhKvFiKV32drcjAlLWXYqhPdfZpfho3FHNFiydRjD/QmQEVmIy0yqx
         Iod43/dbgj1v9Ez7OZ/hXMOVX8skW1vY8d7XyQ0BRbiTNkk/gwdSrbKlAYM24nOrsRxE
         aegGV4vl1Hh4q0o3C7AsStJNPE2+g2SR7MFcQoj+hBjNl4gQnR80JR4+0unis46keI9T
         Odqw==
X-Gm-Message-State: ACrzQf1p5AxPppLy00AEFDfTzUDA5yjOTjsoch0myjKK2hptg0S/FpyH
        1Z3/jq8O4yYIuodo6NmymD+SJu+bFS24f7DhODlHDg==
X-Google-Smtp-Source: AMsMyM5o3EC+IoRieMddawG5G8Zp0J4Iv69ZZmSrXEoKsErlkdHtoA84z7hUwiz+4xqzEITsTfuurIBgSMRDcIn+QOs=
X-Received: by 2002:a50:c31b:0:b0:458:cc93:8000 with SMTP id
 a27-20020a50c31b000000b00458cc938000mr12262176edb.264.1664873750784; Tue, 04
 Oct 2022 01:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070716.269502440@linuxfoundation.org>
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Oct 2022 14:25:39 +0530
Message-ID: <CA+G9fYuN0HN=4R=2y4-B3YJN-QFdsjenormRKc2uV1TM383Wcg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/30] 5.4.216-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Oct 2022 at 12:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.216 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.216-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.216-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: d69f2dcfc489105c21e2323f5a9e8f215296ea31
* git describe: v5.4.215-31-gd69f2dcfc489
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.215-31-gd69f2dcfc489

## No Test Regressions (compared to v5.4.215)

## No Metric Regressions (compared to v5.4.215)

## No Test Fixes (compared to v5.4.215)

## No Metric Fixes (compared to v5.4.215)

## Test result summary
total: 95444, pass: 83176, fail: 739, skip: 11127, xfail: 402

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 332 total, 331 passed, 1 failed
* arm64: 61 total, 56 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 53 passed, 3 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 57 passed, 6 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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
