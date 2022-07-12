Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F0557120D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 08:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiGLGAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 02:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLGAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 02:00:01 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF4131359
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 23:00:00 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id a12so4256749ilp.13
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 23:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=78Dsaxf5HM/j+wnHUEMdY2bia6pLh0sH9r1wYBmbtGw=;
        b=Skj5BjArPjt52cyehKj8m5RMEx/adfm+3FYUHYhaew3Feuhk8sJbFQ1QCX3M9IpjhS
         Z7mMVyceyntrM7ZM5DEDYU77G1wM2+hyhX4Dq2+q2M9CjVUEctbqZHeWWqB5xmRE9poq
         l8/xAqQ9gkrZxRLheW0m+dQLv+tnNYINDOalYrAxqrR7+4GdwGyO2XvQ+dzsdiNIDhR+
         Fyy/rsu/6ayZV3omVacghcUGrKQ9K0H832J9V+DhXzlg7QmRoU2OQLVVi+RBNpfidVUV
         2gZuRdo9ehQs4L50JFiGEzrt8+oJchsFCl0DuXabG1c+bd9dqPWXp9HaNryYxNlLxNdA
         FvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=78Dsaxf5HM/j+wnHUEMdY2bia6pLh0sH9r1wYBmbtGw=;
        b=2O8klIjJeV2qBXxXaOmkgIQP+zqRpfBgreMjzksSZTyjVb7QgU6c70gWPibfe0O4DQ
         ZUYjdy4LLZaSEFtJ7jVcqHSwxo4GbIBDoOgLGsqzCknrC6WeWl4JvKCFdhx4666g30ib
         8E/QvsDA01ah7bfDPOuBQUXcTHiA7bFzm1+S3fnhqhpMgIgt0uh4v3cvx2rzZA+mIUF/
         aPqtd2K1mblrDCd8Ettn+9xt0rqFeo/73KzovkfjYhrhgrS7Ssca1KOynLAiZHpF5J9b
         lbpicnTdXU+cJGmgE3z9b+m+Vs54F94G7/WuFxLL9BS1SmQJi+1hwcOohs24liZRhnq8
         9G2g==
X-Gm-Message-State: AJIora9SBb2QlkMqpJBEW6bM4b9DVOsdV+9HYbjIAeKu1brcjUPETZxg
        8VIZ/JQ1ZNVzCu3fKoTabbff+1U9NRalvQPdV8+/VQ==
X-Google-Smtp-Source: AGRyM1uE6AJA0tbPQoI/k4EM5qkcU3Ysz8W4Xa6yq0PStUExQWcMZhRGkn58ylh0s1gjCQCqKLljOTR4+LJxX/hP3Qg=
X-Received: by 2002:a05:6e02:1549:b0:2dc:616a:1dd4 with SMTP id
 j9-20020a056e02154900b002dc616a1dd4mr10708776ilu.131.1657605599604; Mon, 11
 Jul 2022 22:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220711090538.722676354@linuxfoundation.org>
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jul 2022 11:29:48 +0530
Message-ID: <CA+G9fYtpUTmhHO1=Nw+3EaOr=FYozmkKiYifgtqvHrErbNOqiw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/38] 5.4.205-rc1 review
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

On Mon, 11 Jul 2022 at 14:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.205 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.205-rc1.gz
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
* kernel: 5.4.205-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 75045bc7e7ba03881521543dbdcae2bbb912f7cc
* git describe: v5.4.204-39-g75045bc7e7ba
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
04-39-g75045bc7e7ba

## Test Regressions (compared to v5.4.204)
No test regressions found.

## Metric Regressions (compared to v5.4.204)
No metric regressions found.

## Test Fixes (compared to v5.4.204)
No test fixes found.

## Metric Fixes (compared to v5.4.204)
No metric fixes found.

## Test result summary
total: 130229, pass: 116113, fail: 751, skip: 12354, xfail: 1011

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
