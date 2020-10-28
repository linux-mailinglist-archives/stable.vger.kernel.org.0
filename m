Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD9929DA11
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgJ1XOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgJ1XOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:14:10 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF190C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:14:10 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q1so1205583ilt.6
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YToQUTVQ09XcyKdWO31z31+xALqkDuhVF6HNw4N4sDc=;
        b=WHIlujXaZ5uwvtLU02qMIjRljahrjt3c1E5QjcRO5tRcMVM2UwMQ4krT6t4VLYkhXS
         n7ElE64JRea4S0a/FHAyWFpCN6K5AAHFt8sJcDBsvNOUXYplpk11J/hABPspxYQzNb35
         a+UtGlleUOGa89M5x7kNe7yXJBFpuzhbz+xOPENPat57vE1pVkLf+3sjCJx4uatVN/4x
         TFtMGFxXJ+FJ18O35XGKXHpl8v9LWfNpYdrYtIP7YFKUyZHrJlOCWEqJxuJie8D/UG2E
         BNc9lFZavj7q+jDrGAslWpfaH71IVvgzvJ7zjDRX6FFbtB+PgS+pQRU9Q5h68hSHfCpw
         WRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YToQUTVQ09XcyKdWO31z31+xALqkDuhVF6HNw4N4sDc=;
        b=Lp8sJrw7ZOQMKq90KFQf2/WutZSP4iiQGesUN7EwjvTXEfo9elftwXWNB0RfIFgb5o
         oZbfkA6XXK3fnw0rHOQYNhKZKa7T0lX7WElzlCe9GB2FZBnRqsyl0x5NprZGEMT+O8XX
         q7cRP9B1+BRwzcTht5DSaGSqerYgObaDOEpT9iMtS9OFshbmzyAg6dE7cwv7TYmeD4ho
         nRRcuVaeSRIyRP+gTyWgv534fZIB8RTDvl7w5WGRLaRCAC+im1vRoUDx+TQihmL+vcWH
         6gZMZJTr7bEiAvzBbEXODLtwjYoYgKeSMDE9NHWZnDaPQvLdlmDTV7S3ocwz6FiN8p9E
         BuoA==
X-Gm-Message-State: AOAM532tJ88N3mcH0u6fR1qH9XOV6CnffCCC/3pR6+2W5l4U683Bp/9g
        2lfitop+ZKzFq1LG18woMBPRZuuf2iok3kA/2NjMEYsbiZKKAGv2
X-Google-Smtp-Source: ABdhPJxNVMC1idrRiP5e0TM7gAYtaD07NbFp/0bCqRmYUYKUx2sOy7Nr8+NWoSBBTpDAYec+rGetFcfm0vocgrI2LWg=
X-Received: by 2002:a5d:815a:: with SMTP id f26mr5973419ioo.111.1603889022673;
 Wed, 28 Oct 2020 05:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201027134909.701581493@linuxfoundation.org>
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Oct 2020 18:13:31 +0530
Message-ID: <CA+G9fYs2s0JjpXsn+SLxKZsdiRc3hrjT8DoXQeeHo4ezkVcvZA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/191] 4.14.203-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 at 19:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.203 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.203-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.203-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: a42f5f48c6ae133fc827daac1a64c70c300e32bb
git describe: v4.14.202-192-ga42f5f48c6ae
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.202-192-ga42f5f48c6ae


No regressions (compared to build v4.14.202)

No fixes (compared to build v4.14.202)


Ran 21826 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* libhugetlbfs
* ltp-containers-tests
* ltp-fs-tests

--=20
Linaro LKFT
https://lkft.linaro.org
