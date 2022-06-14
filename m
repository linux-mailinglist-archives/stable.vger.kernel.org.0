Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE3754A980
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 08:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiFNGce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 02:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348817AbiFNGcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 02:32:33 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD75B7F
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 23:32:31 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id p13so13590551ybm.1
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 23:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VpIsHuvsmQ6fO9MzFRQrmmqqCoASEACic+aRWm6wYvA=;
        b=OECluj3zxeX6oajrLL++42vwI4zYGr5Uum0wXAqN3qMIOrKF5mINl03zN4JZVkAklJ
         OCfTdMjW2Fl8Jm0NTSrzJRq3n12qIe6TLIzLSZhQjSrT/gSOR5HpwurEmnUsBaitT6fk
         sPJMhEy8nEg2NN0/EqQyhkIxHNJBQmYgsNuneS2itVrs2wGaqi6WVgHldHBZLsEaVW78
         HqZfFKjfOZaXqhoD7FRdXVsEIGMS8F34SSBWpf2s1tVxTo+jsIbFPg2dB45bRr0c1EtW
         PqWHX4GvMUst4xa+XTpnTdUtRKQ+UVxxJmdP7ASkL/0IIoMoXxlRC4VjTCZeQTK9pU3f
         GAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VpIsHuvsmQ6fO9MzFRQrmmqqCoASEACic+aRWm6wYvA=;
        b=SJioJED5IGSfZMlLG4WPE9IjdigAg/X5x74CZSbw1y3mLy23z682GAw0Nsxkvu15Ia
         Q1pv6jG9N9siAkWo+6m4/PWx6WUBBMjf4oiwW3dtLK3JpM3aVhebIUrK/Kd9y9kW+KQb
         o+McdlMSp4uUFQtu//55OMkLiEwcGxiSpKy0ejBRp4aZonCKxwK021l0Ud8tonb/DmAw
         fT6ukn1GmpVx+xuMftmAqf2DEWPPhwekigWXL9dlBYbXPhWk1tSb9DS2FfeMXwnes0cC
         YejEl4ktVGjyetcGFCf+3nEkiIcGP6/f7MJBntn6PzSUxURa6DEKoPZtaBQtooxptgYJ
         xJEw==
X-Gm-Message-State: AJIora/34q2ehynGBaq7PDzuWUcME6fpfLCw0clP2sXpvuWn4Wp6qP+D
        znNoJkPGN+X9zYjx5NfGrvDd8Nx/rKvu9f6vGS3g9w==
X-Google-Smtp-Source: AGRyM1vJ2yJSLlODQRKX6yHJm/FaORat+4fJUwWJtLPmaFpg3zWUTHhiol7P/dLsdoS3gAkITyyrnTDOf7rXfQ2lbEM=
X-Received: by 2002:a25:7645:0:b0:664:70b9:b093 with SMTP id
 r66-20020a257645000000b0066470b9b093mr3280532ybc.480.1655188350638; Mon, 13
 Jun 2022 23:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220613094923.832156175@linuxfoundation.org>
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jun 2022 12:02:19 +0530
Message-ID: <CA+G9fYvQY-bxTL9LHD8nD8c1Xrhyyb6TvWX5HHWddhCSSHkCLQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/287] 4.19.247-rc1 review
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

On Mon, 13 Jun 2022 at 16:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.247 release.
> There are 287 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.247-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.247-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: cbdd85f3a5c93a3948c77f3d3016506b65276ca5
* git describe: v4.19.246-288-gcbdd85f3a5c9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.246-288-gcbdd85f3a5c9

## Test Regressions (compared to v4.19.245-31-gfb313cec37d7)
No test regressions found.

## Metric Regressions (compared to v4.19.245-31-gfb313cec37d7)
No metric regressions found.

## Test Fixes (compared to v4.19.245-31-gfb313cec37d7)
No test fixes found.

## Metric Fixes (compared to v4.19.245-31-gfb313cec37d7)
No metric fixes found.

## Test result summary
total: 104198, pass: 92268, fail: 261, skip: 10762, xfail: 907

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 298 total, 292 passed, 6 failed
* arm64: 56 total, 54 passed, 2 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 51 passed, 2 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-cap_bounds-tests
* ltp-commands
* ltp-commands-tests
* ltp-containers
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests
* ltp-fcntl-locktests-tests
* ltp-filecaps
* ltp-filecaps-tests
* ltp-fs
* ltp-fs-tests
* ltp-fs_bind
* ltp-fs_bind-tests
* ltp-fs_perms_simple
* ltp-fs_perms_simple-tests
* ltp-fsx
* ltp-fsx-tests
* ltp-hugetlb
* ltp-hugetlb-tests
* ltp-io
* ltp-io-tests
* ltp-ipc
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty
* ltp-pty-tests
* ltp-sched
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
