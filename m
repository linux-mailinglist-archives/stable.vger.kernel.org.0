Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456D4571222
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 08:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiGLGKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 02:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiGLGKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 02:10:03 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75D3422C2
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 23:10:01 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id n68so6952099iod.3
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 23:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m7VnoSWJT9RJBnDpFfYHT4OawmKA68NFYkt7w8TDwQQ=;
        b=IyAogoFazuz0UkBu4VDNvrJyFOcMzfraVZJ07l5DECCrYicxIU5u7MopaDo8GIqOZf
         zUQ4nqvcuM3h0Xj+Ura9c9abRRZCfb/jxWcykD96oFFQ9SI7Ee613kzvLT/2Drq/dG3R
         mQ4Zo1n7nw7Vdk6Kevoj5M+O0K4j4WuOWGxReVyvGdFRADeWNZ5qRIUpCu6RyjK4BWDQ
         3doLdlsjUuYx0Zpa5UmtfH3zePnvzZwEGQv2tA9xcADdLZILJQs42+uzEgjWth/0+y3X
         2cv18OXlkNGtTiTiQB5XyUrPiMHk/yb7fFO+lxWGuThw5OujMFuEq+miyW7x8Wz85xUO
         KKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m7VnoSWJT9RJBnDpFfYHT4OawmKA68NFYkt7w8TDwQQ=;
        b=u+OAZ1k5oLAdj2pUalKyErJRgGA2t8rnPZs8AouQC/LWijq4+p8SFFJLXdxE8WgY4k
         gFQHE3vEwwQKcbbtq5piME6nCqzBt/Fj+0gFEiDVK3xwS1I9cHNOIub8uAE0OK/ZG3Ok
         wLenEiZ9Y+FbRIWxEd2oUmLb9LPfWCFX27mqm81qqwBZQAu9TUucFhag4F6k1aF63LGH
         aOVhXBbF4cwcd4vV142oNDjM2KWozP7inlOU/vEKVoVVm+CdwSOFf8iA4Wt+k0pY53PA
         WWxb+wGRb3vVaP5kR3ev/X8DmkSAh+S07ZLGbGnlVmflWPAX/KpbUtRCCcE6vzqddBC9
         Jn1w==
X-Gm-Message-State: AJIora8FYmYvX2aLzw7cQN/y0R3KnyrD2ABEwqoIX/MGIY9IT0KJU8ZO
        GHBvA998ykV9AdIDhNBd80TAlDtX8qgZ/sQk1DTelg==
X-Google-Smtp-Source: AGRyM1uyqwLnSEwYJEiteciR1TN2aShzRZR4i9bjhcSZi4srcpnJZvC1JvvJEIfNIiWywfb3zEWGLhvxpm1X5+x+vik=
X-Received: by 2002:a05:6602:14d4:b0:67b:8670:9b86 with SMTP id
 b20-20020a05660214d400b0067b86709b86mr6241505iow.70.1657606201179; Mon, 11
 Jul 2022 23:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220711090537.841305347@linuxfoundation.org>
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jul 2022 11:39:50 +0530
Message-ID: <CA+G9fYsxKWneorr043z63eg5_ODFnWxJK8QgiPkWiBOFq2g6gg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/31] 4.19.252-rc1 review
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

On Mon, 11 Jul 2022 at 14:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.252 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.252-rc1.gz
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
* kernel: 4.19.252-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 72d6154340a122052ef914485fa4176f1c50464d
* git describe: v4.19.251-32-g72d6154340a1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.251-32-g72d6154340a1

## Test Regressions (compared to v4.19.251)
No test regressions found.

## Metric Regressions (compared to v4.19.251)
No metric regressions found.

## Test Fixes (compared to v4.19.251)
No test fixes found.

## Metric Fixes (compared to v4.19.251)
No metric fixes found.

## Test result summary
total: 109848, pass: 97331, fail: 268, skip: 11146, xfail: 1103

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 286 passed, 5 failed
* arm64: 58 total, 57 passed, 1 failed
* i386: 26 total, 23 passed, 3 failed
* mips: 38 total, 38 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 55 total, 54 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 52 total, 51 passed, 1 failed

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
