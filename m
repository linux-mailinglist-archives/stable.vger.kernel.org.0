Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B6D59AC66
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 10:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244923AbiHTIFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 04:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243060AbiHTIFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 04:05:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EF8B7761
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:05:10 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id h22so2307785ejk.4
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=C12ECdGG1RKxVZ00Sm1eAbakDJeM+iWoj3xaGjwbf9U=;
        b=ulgurSA3DEgNLfIkCnnkMM55hIo5jwGFwLK/9lUH7SHsnJIjY3E5O35RnTs9YeJw57
         3UIN2LZOvna+UWAlJHxYuuc3RY1EKVlxQ/v8QctYGdWOBDAhL0oOykjt/q3N4Gjie64m
         /dKQKAQYlvRCxXDBIP0Q5SeWzadvRYn+X6WoUMlqiBlblmkFDsJ08mnEBVuUy0cje0Qw
         CgPlnjVhULIYyH3pIijIXQntpn5vKC3svEoqm38MEpAW6TW/2Z3QgPsxWJdkUGdDu2/z
         1q0jayA3F8Hpeqws7YUrmSfWHrozLZIooXYt7F5xuovPeMLzxXsgi3D6V972nTHSIeWv
         SJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=C12ECdGG1RKxVZ00Sm1eAbakDJeM+iWoj3xaGjwbf9U=;
        b=esa7RmvZnlQxPdGKSt5JuJQeG44e9c6q/WMnSVe9c73/7QTwpL68KeeQGsfzTVSOXd
         xLRim6YNK9Apn3PhNcG/zDvYJP2YFbY/BOz0isiJZdTvOehjIRMVs68wJh+qSKZbNGtq
         DcrOR+dicdpK6HfZ2zfHfhOqMl/FNTE1uERynVSuO5zYG14houO+R8/6Xhensms+0Ue/
         7aZrFIF68F/tdy3WTdQHpkuz1h43XwBnKam68AGg5bFJnpdMFzb6j58hrmoImpWrtXe2
         gxFp9IxNIl+KPjENnxiGc8BehVTyNjxV7SpUi7YfUEEyP5llW0w7ypv+fjEe6EhM/mQi
         PgSQ==
X-Gm-Message-State: ACgBeo3NQsOa/GS/Lra7ka4ye82PNW2m0fUiiIgwktXPkH80qRkjHQI1
        Xz2LbcdNZmotJh0zJQgy5iS2m6VF7YVE1RFfTJhl6Q==
X-Google-Smtp-Source: AA6agR7axdTBDNz5k1m9wqa5h+vTpUmPATrp3i9tpIvKP7B2b8K0bO9NoGU6orcc3CmM/DDxZI5k7SNUL0qNmizMdwM=
X-Received: by 2002:a17:907:86ac:b0:731:5180:8aa0 with SMTP id
 qa44-20020a17090786ac00b0073151808aa0mr7030817ejc.366.1660982709229; Sat, 20
 Aug 2022 01:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153711.552247994@linuxfoundation.org>
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Aug 2022 13:34:57 +0530
Message-ID: <CA+G9fYvApY2VQcPdFrLDn8LhuN_zLdUW-yiPFq7TuPWamCkKKg@mail.gmail.com>
Subject: Re: [PATCH 5.19 0/7] 5.19.3-rc1 review
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

On Fri, 19 Aug 2022 at 21:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.3 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.19.3-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 8c2c6014fe886925b313a6e8b6eb46763dafbaff
* git describe: v5.19.2-8-g8c2c6014fe88
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.2-8-g8c2c6014fe88

## No test Regressions (compared to v5.19.2)

## No metric Regressions (compared to v5.19.2)

## No test Fixes (compared to v5.19.2)

## No metric Fixes (compared to v5.19.2)

## Test result summary
total: 167248, pass: 149293, fail: 1211, skip: 15719, xfail: 1025

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 311 passed, 3 failed
* arm64: 76 total, 74 passed, 2 failed
* i386: 64 total, 58 passed, 6 failed
* mips: 50 total, 47 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 22 total, 20 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 69 total, 67 passed, 2 failed

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
