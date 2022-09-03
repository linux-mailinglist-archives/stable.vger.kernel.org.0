Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB70B5ABD55
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 08:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiICGHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 02:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiICGG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 02:06:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1802DB7DD
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 23:06:57 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b16so5198622edd.4
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 23:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=kwgy+XDrA57MMbjThrvYbJk8Y1IFs2cK2AvfgxDIj0g=;
        b=suIuh9lqktOCncoWboxEwb/7NDU3P2WbV8cVkx0TQpVmv0xZf4WnamvidnSf8gy4U9
         sDY8og/TNSwSr2TWNXBZlrbdUIMQIelcaSDh+CSOW0ziA05ONpy78tw3xFGAvAalJywG
         jMYEbDu3P5oCI5OsbLgu4FxMxnmF0UCFfmkvPNbq7dAAWATlhj4i+5WdfaEWKoqIjgn4
         PGlF0Z5/5pSRGOE5g8zmXvrJCRvF82tYpb91JCkbSZz6t+PIK3aQCru+WuLqnzC5+w8c
         86trhJnLmCMRHtasEaVI4aQFKDrNyj+Nt14Zs09F2/JL39ONj1l8VtPQvWot0Yv3OXIq
         YSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=kwgy+XDrA57MMbjThrvYbJk8Y1IFs2cK2AvfgxDIj0g=;
        b=mpRyYnHE3ASNoiZjc1kMwpT2nj7pByob/czMIeV4UnJOVE6DMBg3pWEmrIdkdqlrhz
         5tEZJSB6JylaFNlzGHa2u66x0uFQnJRVX9B93t431T1Bun/uwBnrm9XIMTHqlBLIU0Jq
         LWb++XWR3HY92AJnUzLy3jx7uFJf07N7NQ3lOxF7Kn0NfzDl8YovMNUcsFKOoHPNzFz/
         L8zILuYxLh3MBgqla++2g73psLngEtNaO+AFBMrdUnspYzzVIxaF+CM6jF729lfQPb39
         lwKdIOtqXStDa/WA8HSbiwPnO9zi4c6b5CV/zXkqtDMbgH1cLPJu0DjNLW6ZfDmCg0y0
         z5rw==
X-Gm-Message-State: ACgBeo0o2M3/ctga7W8zq9kYEvMtdQf8xQekWZd5LdL9WD+w3L3rTrgJ
        4zMYjJQ3XsSmGzTTu7BL8GilU26Jg8b7CTdyhh42ew==
X-Google-Smtp-Source: AA6agR7P4tstuc2eGYHW4VV60iVI4Sif2oN2CddsVkE+1auntCgHTjNiQOHFZ3akUpcQZnPQXHZeaXzovurCSdfdwrQ=
X-Received: by 2002:a50:d597:0:b0:447:96e8:9f25 with SMTP id
 v23-20020a50d597000000b0044796e89f25mr35653370edi.208.1662185216081; Fri, 02
 Sep 2022 23:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220902121359.177846782@linuxfoundation.org>
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 3 Sep 2022 11:36:41 +0530
Message-ID: <CA+G9fYsdUnGgxb43DvkVU=ZeTFVc1yq6DeRUnoHBsyMYbg6ErA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/37] 5.10.141-rc1 review
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

On Fri, 2 Sept 2022 at 18:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.141 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.141-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.141-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: c59495de01edcd0308359d774a43086051b028ce
* git describe: v5.10.138-127-gc59495de01ed
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.138-127-gc59495de01ed

## No test Regressions (compared to v5.10.138)

## No metric Regressions (compared to v5.10.138)

## No test Fixes (compared to v5.10.138)

## No metric Fixes (compared to v5.10.138)

## Test result summary
total: 104624, pass: 92085, fail: 766, skip: 11468, xfail: 305

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 301 total, 301 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
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
