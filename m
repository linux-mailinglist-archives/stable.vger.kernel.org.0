Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BBE506322
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 06:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347386AbiDSELG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 00:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243843AbiDSELG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 00:11:06 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B5225C62
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 21:08:22 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2eafabbc80aso159010787b3.11
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 21:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RxUGvhohRZMIeX9k2FsUNWTiAWQS4Lj8VHpVf2o74vc=;
        b=rK6n5jnhB7DrghnuvgvGSPpe3RiXShW0iDaNCCAbDamjvJ/0QkzMqhhWDSd2QTM5zN
         EFiOAUPZ+v1cLMdvTJV95twIzof8Xk+HmS1LboIzSlYA3IxQPJyFuhoCFtTQEbhxeoxa
         nLh+9A7M5CjIWYMINNhG8E2ov24+viameJm70+UdsiPFSKmSRPm5GgKU2+Yz2+1RuVUB
         z2vT70qwVhQT3bFkpMixZ7ZqK3bzNXffTIm8e9NjV6TFm0F5FIpJlLjD7AagKSwBt9FU
         su8d6ZFqLqg4N4wsDPjrMyprLK3g9ji2siBlIZJFRR7ILDNteTm+8u+3mVa4meGW51C1
         1jHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RxUGvhohRZMIeX9k2FsUNWTiAWQS4Lj8VHpVf2o74vc=;
        b=vCZmqJ/Zh/H89kSTmmnt+6BimpY0z2E5KONc8v/5zicuFnLKD0RHQE+SAtSoEzN8W+
         0Ck8NAlNCIP+RcaFnCa7o3r08frtSNAZIkYJIuvFF28JJ7oCOCioc1iaBmKQluCOwOgt
         Pe9PTtka7y4UfsDV4EcgpqdyXfnkJ5Fy1CufBOzkgXo7VnCC2QBS9RZ9DL+KMMfAEBBs
         UZ5vcAr3iMBnxsxNhCSeY44XIsL4HO8hKtq0BZpULQKuR80MSNznDr/F+jLIDB++tU2F
         rHZn+22hjEBNOr7SfUspzouL+U5fcBYPd9ORqnaoHgmtvujZxKKiTCKGsnUcsgCrOaiS
         vIwQ==
X-Gm-Message-State: AOAM532I8H1TibgvPoQnHWIF+ClEQaJP946HB6COhrn1SVwktbpehaec
        Ry/wZnIFx+C01ygg+KB6tVwHg0UX0DjSw3OvPhXqCV5G4xfZsi2V
X-Google-Smtp-Source: ABdhPJzPeb0inENKSoaL9o+dm6OQC6zVJQXzkSSrIk/VVrICYu6dtVAnu0nLbyctSyP31xlz1JVwD/g8QECquLJzS1U=
X-Received: by 2002:a0d:f587:0:b0:2f1:b1ca:287e with SMTP id
 e129-20020a0df587000000b002f1b1ca287emr4936406ywf.60.1650341301128; Mon, 18
 Apr 2022 21:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220418121203.462784814@linuxfoundation.org>
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Apr 2022 09:38:09 +0530
Message-ID: <CA+G9fYt-DHhCDjnGfXi1=qn3JdQ-w=UnOXr81bZX1pvECPtD9g@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
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

On Mon, 18 Apr 2022 at 17:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.17.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.17.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.17.y
* git commit: 12e5bd3d067695aa29a9780ccff9fa9d1e761337
* git describe: v5.17.3-223-g12e5bd3d0676
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.17=
.3-223-g12e5bd3d0676

## Test Regressions (compared to v5.17.3-8-g8a239d5c59a8)
No test regressions found.

## Metric Regressions (compared to v5.17.3-8-g8a239d5c59a8)
No metric regressions found.

## Test Fixes (compared to v5.17.3-8-g8a239d5c59a8)
No metric fixes found.

## Metric Fixes (compared to v5.17.3-8-g8a239d5c59a8)
No metric fixes found.

## Test result summary
total: 90780, pass: 78715, fail: 220, skip: 11125, xfail: 720

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 44 total, 40 passed, 4 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-te[
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
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
