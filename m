Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C430567FCE
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiGFH1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiGFH1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:27:41 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E422536
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 00:27:40 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id v185so13235878ioe.11
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 00:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z42Yq4p3a/8ZNPXXetAGi/YqdHiE8zz9pG0iRo2on0s=;
        b=gOeD008ucnQuUXjTa3Ayigus4RjUCjSTCtGWYVsYUQY7zudq1VWTTfFblT+GXwYLjq
         mwQz8o5cAYx/Ao2CevqjQcEKO6jM3wk70IIgmvmUvVHKQ1dwm1fH1+TpDGCWctoVq1J+
         /vBrQAyXIq4VGvV6ujkjoPbRP1PXRc6d+5iA87XQcIfxfMzqRxBlL3Iy4Cjinu4QmgPa
         X28zyyJvFrlbE4xiGv2HS1iA7Y1woNhyLrv2yT38TQnaBgyK+qiRN3qh1iTOIfbGQrOk
         bOMn/5Ta/L1k+pgkNAX/QQYch+PIKEowe5sWJj56bKr2jbE2ZOUH5BFjKCymDrxahOEG
         nitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z42Yq4p3a/8ZNPXXetAGi/YqdHiE8zz9pG0iRo2on0s=;
        b=fdgkMwkhLY6pWtaYFM7Bv8rr4NZRy+vyQM4WPI94Li+ikMr4h+53Ysd7EYRybi6bWE
         G9NNb3Shom9miqYuVA2ZPhTB++Yjtsk3Sw21y4LVfdhqfEivTF4aQtzOffyGn5SAauEY
         9Saib/GKI9prmGf660RQBXK30H+sTzPcftQod0GhANqQ0tZP6UFt6RH4DHcthuCQIhsp
         h162+eFvZzDvsJ3oN7FYcUfeMRvYh6dgqZQfmHW5+e9Cm2LlXyA02Hg0pOn/kXWD1pSE
         j2qTCUGe+o6vtxiCtXsUW1jd1CsWKzv7ifkQ99F/IFsUfnRJY7LGsupmWgl/KIfc9+lC
         YKyA==
X-Gm-Message-State: AJIora80gOh/HTtZEVKImBy2RV9Q5TNR4kkNEW2CiNUvKU0Vgu/xx1Oc
        gtCgf9LvQrnhjzeXTucI50pYX9YTX7q1C4b/QFO2tqGzen7Lmg==
X-Google-Smtp-Source: AGRyM1sQr9SevlFDyBBoYKwKLtwH0DJSFOKoz98m6Z+jmLezovOzt8RcYuaxLU/Ub+sQlk1u02wIRDSyFPWmwPpZAgQ=
X-Received: by 2002:a05:6638:468e:b0:33e:be92:ec40 with SMTP id
 bq14-20020a056638468e00b0033ebe92ec40mr12492484jab.74.1657092459946; Wed, 06
 Jul 2022 00:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115605.742248854@linuxfoundation.org>
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Jul 2022 12:57:28 +0530
Message-ID: <CA+G9fYuxCLC=9UpCLNJxVQaVzeKQo5iT=8R7ram2hxW44r4JYQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/29] 4.9.322-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jul 2022 at 17:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.322 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.322-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.322-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: af28a1763ea89ae07f1fdbcc0b07489a876718c1
* git describe: v4.9.321-30-gaf28a1763ea8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
21-30-gaf28a1763ea8

## Test Regressions (compared to v4.9.321)
No test regressions found.

## Metric Regressions (compared to v4.9.321)
No metric regressions found.

## Test Fixes (compared to v4.9.321)
No test fixes found.

## Metric Fixes (compared to v4.9.321)
No metric fixes found.

## Test result summary
total: 96765, pass: 84217, fail: 210, skip: 10851, xfail: 1487

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 254 total, 249 passed, 5 failed
* arm64: 50 total, 43 passed, 7 failed
* i386: 26 total, 23 passed, 3 failed
* mips: 33 total, 33 passed, 0 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 36 total, 16 passed, 20 failed
* s390: 12 total, 9 passed, 3 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 45 total, 44 passed, 1 failed

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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
