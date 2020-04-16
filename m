Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335E41AD0AB
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 21:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgDPT6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 15:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728253AbgDPT6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 15:58:18 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BDFC061A0F
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 12:58:18 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 131so6515757lfh.11
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 12:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ybW4LX2vmPQl9JQ2ZwHdHhW1BzV6OYfuo6tWqKcJMK8=;
        b=RMkxcA2wucCF56jg9YbmIp/U6W7PVVV2oHDLnwILZH2o1577cA2Yp5vumHhtlR0R6W
         SbU9o+WlbDtTiVqx4llipZjU8QvEhPE3FQPIwO2xqtIJvsfSCW/l1Bde/jpE1Epz87NA
         Zpi4Nye3fzKLH62JZSysNUGA7SMdQ9muAwP9fdwymfNahESexcL9JaXRskMotrElLg6M
         1d17vq0zcxLDRRJaCUzTKmk1IEYFCmEBWZ0ggvPMfSE0rNusG24TC8R5bAFxzlDKgeZl
         TVlt/1zfpHS8Xb8XttNFbEskCgl8tWTlB/UYB86hGI/CHrgyGtTA7j6d6ksLB/4Fx3mP
         ZqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ybW4LX2vmPQl9JQ2ZwHdHhW1BzV6OYfuo6tWqKcJMK8=;
        b=dNjvSn2WQTVJtFqWDd9UosBKInBEbko6S/zQqEv2dCvg5tLhGh1od8u/yoUTqpuuI/
         8AAetLz4DKBjP86RizkjqTxBotaF+iv7dU9x6gbzDmVmhDa4uES1e4SKHlEP64HIVwat
         74Elze3Uhtlwt701HoqIGgSpomBdvoFvYrQpLUHfP61ytIypm+5+7br2lRZXuJUpj6U2
         Ohf3nDPQQpzdDPNDpV6ALN6R6YTZn55MBZ4SowgTrC/EDkcCSwenbs/f9Z7X+8rcPbLh
         Asg1S1GD+isifZM30qVqWk2zeVtFw2m+er1q4Xbf0KJj8xAH5IC9Rys2NCNXOztMV9eb
         0uHw==
X-Gm-Message-State: AGi0PuZD3sBx1p+3/Amb+EGcLZ6v2D+GY//Ow9Hqb+2WxpifH6y1lMpv
        Uq9IxeILpaYRmbQNlq/Buazw+xUab1FpiUW+m+1xmQ==
X-Google-Smtp-Source: APiQypLYPxAhe8ZN3MalK4SKgwOD2za0gA1Wl0sk13pVf7rjguvqJj4y/slIwyioT+WbDq3QMN8y+T8dqi/pjNhUpDg=
X-Received: by 2002:a19:5e46:: with SMTP id z6mr6503459lfi.74.1587067096605;
 Thu, 16 Apr 2020 12:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200416131316.640996080@linuxfoundation.org>
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 17 Apr 2020 01:28:05 +0530
Message-ID: <CA+G9fYtYhFW1XkJWu-zB1LJzEivDnH4tCuhwU85GKFxOp=LkbA@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/232] 5.4.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Apr 2020 at 19:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.33 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Apr 2020 13:11:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.33-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: ccba204bf567bf5349e9635ea1fb8cd18d23c123
git describe: v5.4.32-233-gccba204bf567
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.32-233-gccba204bf567

No regressions (compared to build v5.4.31-42-gf163418797b9)

No fixes (compared to build v5.4.31-42-gf163418797b9)


Ran 34739 total tests in the following environments and test suites.

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
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* libgpiod
* linux-log-parser
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* kselftest
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
