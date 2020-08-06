Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6D723D823
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 10:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgHFIqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 04:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgHFIqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 04:46:38 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEEEC061574
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 01:46:38 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j9so36368686ilc.11
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 01:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AUV9gwNNNAz81m3MmOY2nRo3UHjqXanOCYEOS2ok5fQ=;
        b=IB6QoC49uRVwqBk5+hSBpu3XAUc3D91Th49QxMSL8T2PaFqfDo6+z36IM+FelVoZr3
         VXZRTp0n9P+csfMH3xmk2W3D/Ugme45j+R6/cJ+5p8nYgnEHqb/pAxCUcUkjmcammuwv
         J3z0cFopM8PQUfuO4eebv8qK0VrAYpUCLTkvKY0bIkx7mJNiIlVLjwjSUcmtj/bGj2w/
         DWi8lX7oRLOIdN1Z4d42y+d5bUn333dJ/UpcVx+BZSvS11GFuAYANr8VGHj1GQ3Udjc1
         N0Srczs+PVMsenhEsWOuqBcj/pqmTi/P2Bn0i5TtsZvxOcu3Z4bOFYx+0jw9EdbR2APp
         LBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AUV9gwNNNAz81m3MmOY2nRo3UHjqXanOCYEOS2ok5fQ=;
        b=XKMz9eTXHbW0GjVHG+1LMAtrjEIlXeezZW+cbet2aNsCybUALw62xbn5gSBJpohYs7
         zBDO6/SSPucdP0EVCzQNuhry6jiZf0TIifHZjTcxah7iR8M8gPtTtamcHldzF5hzYBiL
         DPGqlKg7AQgfJS1sEdNvgvSC5ZmAiypnS41Ba73sEX+0oHeOi2SW4CpG+TfLiD84Tt4n
         wq5Fp5KdEOCcbr+BnL7rRqg7KdLyQP+KDmAp7c+a2Zf79GPezylVSS1kzAVynAP9g/io
         YleM1vCwjNmsun+WbhkrDBUm3yycayrUlAh7nc3AsYcF7LP7R4jRQpVqDqTAv0/xMgc3
         lPJw==
X-Gm-Message-State: AOAM530LtiF9p4MXXwCPx2GUzuKalyNRfmxIVh/1E0sj6lqwSa5Y9nMS
        UKhSWluIe0Xpq+FnccGRkjAcyofS38SSfv7quaMoxA==
X-Google-Smtp-Source: ABdhPJzLlBUXOZ0bsydfJN0TKPYyEaw2QrCqQUV0BErxjUj2+aqp7Si1oKDVuCs402dztEcDZAYvsNfO+dcnHrmskOY=
X-Received: by 2002:a92:96c7:: with SMTP id g190mr9039730ilh.252.1596703597262;
 Thu, 06 Aug 2020 01:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200805195916.183355405@linuxfoundation.org>
In-Reply-To: <20200805195916.183355405@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 Aug 2020 14:16:26 +0530
Message-ID: <CA+G9fYs-vNeH=BCbFZAA28-C=dE+iajWEF+0vvgZMwr=yw-5xA@mail.gmail.com>
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Aug 2020 at 01:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.14 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.14-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.14-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: 0ceaad177e510974c093f79a5d1f3bb058a4fdf2
git describe: v5.7.13-8-g0ceaad177e51
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.13-8-g0ceaad177e51


No regressions (compared to build v5.7.12-117-gd3223abaf6fd)


No fixes (compared to build v5.7.12-117-gd3223abaf6fd)

Ran 30546 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* install-android-platform-tools-r2800
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* network-basic-tests
* igt-gpu-tools

--=20
Linaro LKFT
https://lkft.linaro.org
