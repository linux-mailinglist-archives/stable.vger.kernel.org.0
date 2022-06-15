Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C432254D07B
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 19:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347636AbiFOR5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 13:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345731AbiFOR5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 13:57:15 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AA1544C9
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 10:57:14 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-30fdbe7467cso69372287b3.1
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 10:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RZ4j6+UZQmxdYRalU5SjpHfrfkE6Udb2BhN1j/8KSKg=;
        b=KF4FZg8X4Jv4NMEZAKO/4taSUCxS43l1wQWkaiLCXkLec5w4y6eWd9rpbEnxn1j4wx
         jSL8yRwL+mEoHeNkWi2ky7kVV35/AOjtxxNe6GOQJBFMUZhAAf1vtQThEWkUqYSPEX7k
         2w+6fdLpUBQFPhuyZSm0R5sj1UjeAUPRQZeSGHrq4R+c+DWRi/mL730vjiVyi9sxqM9i
         Wl9/JTJXIXwVAt1HWeulmXZRamc07/gX9ZapXpAhFehJEsfZ8a1T5A5VMFeGkVOcYKWE
         /wQHuyeof+qT42qYRvavigeXQeU8xu8zpdnXRlFhiozyP6CwYG2B8S6JrqnPlgCJFe6u
         W0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RZ4j6+UZQmxdYRalU5SjpHfrfkE6Udb2BhN1j/8KSKg=;
        b=4JoPgljPmPZDnDRMheELM/nUc6qk55yht+l3qb6iIcBwomyrPeXzXtECcISQhzkdzh
         yRJZinYbSYouF4aiRZNTRtLAJnE9MTmgNC23h3/+LHf82iPpay3HkK6Q06F09HOcMSHV
         BCNyOzISQZXtOpGysuJlrHJSNoXdjXfSXFUXY3Fpu0YT/w64NMYPoFvdgLMKIO9kH3Rm
         yKPGMJZStsfWo/7eTn6CyXfqjS0hWyXXDyHbHI0w64rawVZvSZe1MVetmFTWGKjGDluv
         UcogZneJGs/KyNDwKJ0Lp5ARaWeFYwfrrMbPBCXNPj9X3lrFIGv6zrNJMpe47zUr1dOQ
         iFaA==
X-Gm-Message-State: AJIora/6KCk/U4PyQpUUl3Oia22acHkFv3ojXsU4vicbqc7tJt+kPrbs
        h0Ny6WV2T4wL4I4HIT+ddnHqMoK6ZYYCyVgYuLJSvA==
X-Google-Smtp-Source: AGRyM1uSg4FBVLtypacBG1ovM8+4v+aoJP/1QA/fc/TH2gumJq3Sfr6vgDtYLnuEdjSiVBOr0kL2aB8yLMxpetozh1Y=
X-Received: by 2002:a05:690c:442:b0:313:fb25:3a6a with SMTP id
 bj2-20020a05690c044200b00313fb253a6amr980054ywb.376.1655315833863; Wed, 15
 Jun 2022 10:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183719.878453780@linuxfoundation.org>
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jun 2022 23:27:02 +0530
Message-ID: <CA+G9fYt_7QO+ZLMxPg-xbYgOtCZ0UPdgrKB4wYM2m_jY3zxRRg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
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

On Wed, 15 Jun 2022 at 00:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.123 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.123-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.123-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: f67ea0f670870facb37c20f19e483ec74a2cba63
* git describe: v5.10.122-12-gf67ea0f67087
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.122-12-gf67ea0f67087

## Test Regressions (compared to v5.10.118)
No test regressions found.

## Metric Regressions (compared to v5.10.118)
No metric regressions found.

## Test Fixes (compared to v5.10.118)
No test fixes found.

## Metric Fixes (compared to v5.10.118)
No metric fixes found.

## Test result summary
total: 123351, pass: 110941, fail: 243, skip: 11563, xfail: 604

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

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
* ltp-sched-tests
* ltp-securebits
* ltp-securebits-tests
* ltp-smoke
* ltp-syscalls-tests
* ltp-tracing-tests
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
