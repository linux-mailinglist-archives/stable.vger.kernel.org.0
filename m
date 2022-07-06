Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16406567F05
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiGFG4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiGFG4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:56:06 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FCC1BE8A
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 23:56:05 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id p13so8690866ilq.0
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 23:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YFNQb7b1KCsmQRzxr93CIXPIla3KWLn6zmSX1Y0R8fU=;
        b=chEdrQ2KkUcPSmiE2c06PqmFRcX/+J/ozDM3YotO8fOVVIZqIyVSxNFhq29PwUY0Em
         ThOXuJ8axs5pxRxZWcRECV+zwOLllRql7f3spnr/BMvT88PuL8bVexOkVkLTMUs5rTv9
         ekT05iDkTxWG8l0eFUAlDcdvvYrahBBMDNyINXiZMUzdGu83qbZ2gTeL5Y0fnNa7wRpi
         l2FYNTJrGz58RjSYLzKfQOAPX0bvALteMfrWpqOfe+1mNs1ROS94Fh7n8DpYY07UBICG
         5UQvKebkK8goHufdaC+qFxsF2tgPcPIcubD/UuqyeL2+Epz7oLoxR2Uc6BtaGMUTYBMN
         0twQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YFNQb7b1KCsmQRzxr93CIXPIla3KWLn6zmSX1Y0R8fU=;
        b=sbGIEYG0IkPpLwFGo/jKh58DwULCIqxJhwlSV/D0sHQQtO5XxPPva38iNRHDeGWT5i
         aO/xCjY0XEKPYaOGWI5+qBJmhvEvkomh6dFeimY9Lbd+yPAH7A28wvKWQqPZUnW/uS8z
         jltThGe6PAmj73wq2Mrebmt1sH7kai7Tc72OQgZKpESyUbHMEazErNpE1AOlKAZmNP/9
         4/PWaf5+6qLtl+W2WiTXsPznwiBsvPHZNU/erTQN75DAB09tSuyQmMtXONW7dlGdCiHa
         5lmyVs2rI0PHufSQNP1lXcjqotncNIqn5iE1p693mgU57aQ6s+BO+BCzEQggQXXyVRmk
         TpIA==
X-Gm-Message-State: AJIora9ZkqXUvB2/PlmpUFni/yEsHuH2rHreW9DW3K2RU0sNb89590ln
        x/UA6XldmpiMw87CkzYJu1BsMk62oB/t8JDdVfEl6E+bxJSzkg==
X-Google-Smtp-Source: AGRyM1soHgVS48kFwmmwTHhWAsyaq8JZdKD0yeOo508CIlLAH/onAdt/4q+JwrPyk3J4PH3vhtrqOaDDZ8QlBJTxAs4=
X-Received: by 2002:a92:cb0e:0:b0:2dc:240a:3149 with SMTP id
 s14-20020a92cb0e000000b002dc240a3149mr4326727ilo.55.1657090565135; Tue, 05
 Jul 2022 23:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115610.236040773@linuxfoundation.org>
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 12:25:54 +0530
Message-ID: <CA+G9fYtXD=L3JaBVDMoVg8ChmqcewOr+rJDy=G-wdegUs0JYcQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/58] 5.4.204-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jul 2022 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.204 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.204-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.204-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 0f4cd7014f4101204454b404e03101579ef33481
* git describe: v5.4.203-59-g0f4cd7014f41
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
03-59-g0f4cd7014f41

## Test Regressions (compared to v5.4.203)
No test regressions found.

## Metric Regressions (compared to v5.4.203)
No metric regressions found.

## Test Fixes (compared to v5.4.203)
No test fixes found.

## Metric Fixes (compared to v5.4.203)
No metric fixes found.

## Test result summary
total: 122576, pass: 108899, fail: 260, skip: 12381, xfail: 1036

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 307 total, 307 passed, 0 failed
* arm64: 61 total, 59 passed, 2 failed
* i386: 28 total, 25 passed, 3 failed
* mips: 48 total, 48 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

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
* ltp-filecap[
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
