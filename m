Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5B05A02EE
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 22:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiHXUmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 16:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239493AbiHXUmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 16:42:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C05F6C76E
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:42:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 2so15543086edx.2
        for <stable@vger.kernel.org>; Wed, 24 Aug 2022 13:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=br69d+7ymucGww4aAsP6ibWtAg7r86QRawhRUVPh24M=;
        b=X4vC6f500acsLOb7Eh7Bbfji+Uhr/3rF2ulUzhbpgdfyeFI9DbrKce3rg6oaLdWWGY
         JRa/DZq2f9mFZMidAdB7JcnsJ0ejHNNbRqIxy3iN6gw591++dzI2KDMh5jDC+flXHke6
         cS6vmrBqIU/jMsX4GbQIKNqUCe3L3aBUu9W6I4Fe63sX9ix/ZJHjrmvZou81i63cjgCv
         OD0AtisE0MWswmYzoDICJTdVM3PGXS6aONWs206pZaGqjpIGGQzRw36VfMv/RZaljZgk
         d6XmGtBs5U9C0Ks/hTBnZBpUr2OJRy1Uf1coUKyfzVOzLRsOihxCkgO6oXvCI5JnATP8
         WxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=br69d+7ymucGww4aAsP6ibWtAg7r86QRawhRUVPh24M=;
        b=2MPrF+OyJXLzuzJBM918F0kefHRCIRB7QFyQcCcvpQum41mLNqGt14VPzZPu3oj45i
         ID1qYMr96a2SqjzuRssF0hbBSlSEGUgRTF5z4F6Da6rH2VqnN3Hr9NHvWrsytoGfKZt+
         kjLI9c1t1le0+jJbzlXkqHqDEvySWxUypm5zBW6RxGlGnpNJPrAREw0O1m2I9NAemEVq
         T2CpRjrs3nUQRwfzr0fZLiXgYaHVsaj1agoFYqrOdtB1yflP5tj4T+MdcU/dO3b6/sNr
         gtb4xAFxAiCQQfevSy4egpbKHvrZvFDXWBd2YoGFnAyMKyyj1l57lSFKrinJk2ermPRo
         49yw==
X-Gm-Message-State: ACgBeo1aEmkktBFE3ojY9oPvrBdVYzl7Jvdt3xuzJSzWIR3So+8OMK8Z
        1ST7rcPcENQxF3aKzWJVzf6vrTVTfX7N0LbR9TMS0Q==
X-Google-Smtp-Source: AA6agR4bAYLqiK6baFhQ57kCdRMC/7XyhhLf5+tWFOReeew8NIneOtzyXHmbbhgKonRFmXw75Us4aHWY/pf3wUYYkwo=
X-Received: by 2002:a05:6402:447:b0:440:d482:495f with SMTP id
 p7-20020a056402044700b00440d482495fmr640160edw.264.1661373771051; Wed, 24 Aug
 2022 13:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220824065913.068916566@linuxfoundation.org>
In-Reply-To: <20220824065913.068916566@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Aug 2022 02:12:39 +0530
Message-ID: <CA+G9fYtUxnhhCfDUmOj1R2ApvLZgn0GZ0VKpF2phb2O801LuWQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/242] 5.15.63-rc2 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Aug 2022 at 12:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.63 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Aug 2022 06:58:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.63-rc2.gz
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

NOTE:
The following build failures noticed on mainline.
x86_64 and arm64 clang nightly allmodconfig build failed.
sound/soc/atmel/mchp-spdiftx.c:508:20: error: implicit truncation from
'int' to bit-field changes value from 1 to -1
[-Werror,-Wbitfield-constant-conversion]
dev->gclk_enabled = 1;
                  ^ ~
1 error generated.

## Build
* kernel: 5.15.63-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 5137ebd6fd586a297e4b9c89ea61ce5b210ba9c8
* git describe: v5.15.62-243-g5137ebd6fd58
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.62-243-g5137ebd6fd58

## Test Regressions (compared to v5.15.62)
* arm64, build
  - clang-nightly-allmodconfig

* x86_64, build
  - clang-nightly-allmodconfig

* riscv, build
  - clang-nightly-allmodconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig

## No metric Regressions (compared to v5.15.62)

## No test Fixes (compared to v5.15.62)

## No metric Fixes (compared to v5.15.62)

## Test result summary
total: 105556, pass: 94891, fail: 886, skip: 9641, xfail: 138

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 306 total, 303 passed, 3 failed
* arm64: 68 total, 65 passed, 3 failed
* i386: 57 total, 51 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 61 total, 58 passed, 3 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
