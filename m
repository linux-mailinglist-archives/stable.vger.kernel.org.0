Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB87583825
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 07:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiG1Ffp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 01:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiG1Ffo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 01:35:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AF14D81F
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 22:35:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b11so1248311eju.10
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 22:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MGHVJwwOXD4TQwp5bJbQCXJw0h6HO1k8bZrkAoBMUJM=;
        b=lRuE+5Z+z296kkBmHZxRnNydOscEZzjLsh2H1pj/ht43dnT8q1t62Kk50s3S+vgegk
         S8pvqSdmL4tMJoxndMsksyYTTEf01qWcqvEm0KbP76JsH4MIkWNPZJcIJoqA3soHwT4e
         QmlPhuNB//pm6y5hsZ+MbsqIqsvaamSNNg2kgzdvGDp54svuDhXOiFTj6oAN2QUHFkr/
         i2H+qCa3bDdn0ZbrH1gshku72DhvjEaeTY/Cfv6DVgPJ/98mcsRYxjrLZgQC1v/bRxAG
         B+e/+vVoor9hwru4gikTRNQG6cEcl/FHelxkja9PuFokO72v+UJS3xVYJzKGJLUdIj9u
         wzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MGHVJwwOXD4TQwp5bJbQCXJw0h6HO1k8bZrkAoBMUJM=;
        b=V6Fa2nHCC7RbiLtfcrzuwq3JXmaQrkcxnKP21mEBU2ObG4PDS9zDTipHc5Oul7W2X6
         O6zKLMEgy8ul/19BqvlClQ3aKpuS9bDGOdmRTkiKHU7Xnp0Hm7Tf1sUT1sJ1MF+Wenhl
         hAKoLk/RsLkxUGUPMhLFUPasJuXOPunnOspEOHDb0VcLsQ98SGe9uNxHjy8vrnb0ECe9
         O17nuMTgFIut38gtJJmVTyM4nVb5NXLIS0mKHiXxFyHpNwJgrNfbT9bdOWkIkF0U2NBE
         MDDj88kemygx4wnhFkt3v9WuLGIUQ+tNS+JDncKgLPdFTS96kblCjouinbTiTcrwrwbd
         /MRA==
X-Gm-Message-State: AJIora/VHvPU9ae0fZejxf2ReIvuTB9x2uD+sUEeFSczeQlBu7pYqu/J
        6xrR2UYFz9oj2K9S9XsE5uZ4ybFAHg9YQZrjm3aBUg==
X-Google-Smtp-Source: AGRyM1tXRDyfHh0TXjI8zkFnSeBcVvIPtaDHTeDqg0sFdmg590UdpTeQ2QCs1SkEBd0ZxoasUw65usCBngPK9cGzYbI=
X-Received: by 2002:a17:907:b0a:b0:72b:3176:3fe5 with SMTP id
 h10-20020a1709070b0a00b0072b31763fe5mr19862421ejl.48.1658986541190; Wed, 27
 Jul 2022 22:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220727161021.428340041@linuxfoundation.org>
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Jul 2022 11:05:29 +0530
Message-ID: <CA+G9fYtpz_MgLUoxrmXpy1L9Ky8mNYhpU7_rSJpFUCZtZm_LzQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
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

On Wed, 27 Jul 2022 at 22:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.18.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.18.15-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 63d1be154edd5513bff11d778954f7ec7cbf50c1
* git describe: v5.18.14-159-g63d1be154edd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18=
.14-159-g63d1be154edd

## Test Regressions (compared to v5.18.14)
No test regressions found.

## Metric Regressions (compared to v5.18.14)
No metric regressions found.

## Test Fixes (compared to v5.18.14)
No test fixes found.

## Metric Fixes (compared to v5.18.14)
No metric fixes found.

## Test result summary
total: 131463, pass: 120143, fail: 902, skip: 9686, xfail: 732

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 307 total, 307 passed, 0 failed
* arm64: 62 total, 60 passed, 2 failed
* i386: 52 total, 50 passed, 2 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 22 passed, 5 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 54 passed, 2 failed

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
