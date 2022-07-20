Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350A057B4B7
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 12:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiGTKr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 06:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbiGTKr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 06:47:26 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2474666AF1
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 03:47:25 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id z23so32334884eju.8
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G1h5HG2+vqxnIBWwGhwq1fT3aCH3eVF1Bq0cjh5HIgE=;
        b=zm/Eu/bRB49zto7IXIpBzZc/wNdhHXkpCNptxd4i0dV/dMsEZjNM7TmXULN/B7Y6WK
         hN+mw0lq7bHVE7ARXuJ3IxpV5zdVCgDecD15u1HD3vXpECAozUKutVQWmRCf7Novg0RM
         4rRU8Ki+koHu6QySH4mDGV/WtDfZ3e4hobAARwbdEAdhLoYnNM7SbU1A3VMgH43oTSsw
         oQhoXlfokv0W1Kr7aIVqv5Zo7Njh4QhlBGot0AkGqXtfyo2R+8LrQ5dbo1A3vnEwwcp6
         llJKelauM/q4tHF3M0fbWd4GoiLGL4CVTn18Q8icFrfkao1iZm4JmtlLixnPUeXjIbfW
         cBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G1h5HG2+vqxnIBWwGhwq1fT3aCH3eVF1Bq0cjh5HIgE=;
        b=zitUQ0Wj3KC9Hrp1AgbHEoxQ827TPJsFN6j6dpGHgVvLCGrcwo1UfSd/X65DIpHDy+
         3Amd2abmRXg2z8hvFzjic8tDm/K77bRHIhwqwFDHnphRvMiALt/FRqXiE2W+8Ai6bkoW
         rdCCs0mJE2hnYRTq3Aco/aa/pa60ZYct4WwkDWPWeuthC4aM6ikB7IxzrruOhsuAS2VQ
         DtAIyiTj8BOUG0/Wqqs4zaVAQl0didPBUaUo1icY4Sc/z/MVL5Bgn2QZvFAci/42lBkO
         K6xYftEt2WzTr1kqTbvGD8DCTgSlkZ6LA8uYnjZgOyu5/UDOVDZYzjW74tXIaDoZzxRc
         NB/A==
X-Gm-Message-State: AJIora95ZFMrh4uFipDSD41QI2ue3Cc0vI95UDEjxokTyzLrESYggnJu
        SYBt1MI30eLReqvT5JyLFACIgyDTSu16Yffban8lZQ==
X-Google-Smtp-Source: AGRyM1vQOJ04dwFoJLdJJ7c7BF//QAtWpw78JGEBaGUDuYnD+imzVesCidpq2AJk33vGE5WOR9ZNWld7OnbgKKt+YmE=
X-Received: by 2002:a17:907:7604:b0:72b:4ad5:b21c with SMTP id
 jx4-20020a170907760400b0072b4ad5b21cmr34040885ejc.412.1658314043586; Wed, 20
 Jul 2022 03:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114455.701304968@linuxfoundation.org>
In-Reply-To: <20220719114455.701304968@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 20 Jul 2022 16:17:12 +0530
Message-ID: <CA+G9fYtvRzyk+7J51d9rLSJDc0Nq1uS6ehQEz=g=k1bhdhrqPw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/28] 4.9.324-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 at 17:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.324 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.324-rc1.gz
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
* kernel: 4.9.324-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: fc1589ab23915836383ec0460240b055fa41d304
* git describe: v4.9.323-29-gfc1589ab2391
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
23-29-gfc1589ab2391

## Test Regressions (compared to v4.9.323)
No test regressions found.

## Metric Regressions (compared to v4.9.323)
No metric regressions found.

## Test Fixes (compared to v4.9.323)
No test fixes found.

## Metric Fixes (compared to v4.9.323)
No metric fixes found.

## Test result summary
total: 99983, pass: 88018, fail: 339, skip: 10469, xfail: 1157

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 254 total, 249 passed, 5 failed
* arm64: 50 total, 43 passed, 7 failed
* i386: 26 total, 25 passed, 1 failed
* mips: 30 total, 30 passed, 0 failed
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
