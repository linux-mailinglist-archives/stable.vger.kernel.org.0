Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4F11C5C8C
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgEEPuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730118AbgEEPuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:50:51 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95485C061A0F
        for <stable@vger.kernel.org>; Tue,  5 May 2020 08:50:50 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id l19so2131490lje.10
        for <stable@vger.kernel.org>; Tue, 05 May 2020 08:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UMlhFVIhuG4BQg7+7Jtw6J8Z8dON//8paovs3+Zex2Q=;
        b=SodFMjn/B3pxZf7ZVhD75mEIZqjH+1/ziV1MYUIyyEhqLSS+pHK6Ws2DDP75ficdWZ
         y2dwj3f4GsexWwrhDb/xpiaXozxhNFC1dfdBRQr3q3qJunqnJSz4UWC88zC7pp6/aUaM
         38TWj5D6S5OquaYo9tEpkI0KFaKSzM1yU1sD/rmu9rS9dMrL9srIuyw/lSZ4G+ugMO0B
         e/xLlYS16fd24RVaBObENrdBDL+xC/zslxwDzaGlAdCeCc4ScLEwEJo+hGza6P1f3Xsf
         cMdrJwiU/Jopoc5LTnA1cDyrwwGp2qmiVwhFdGNfbbiJfv+OFMwokRyQ1zaLSF6pP2V1
         lO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UMlhFVIhuG4BQg7+7Jtw6J8Z8dON//8paovs3+Zex2Q=;
        b=OHdbJ/KtuPc4s4F4JHL6pMUWeD4slsk+sB8z+ZjhY+haVTTR1gb+f8+HzN2U9RA59K
         36UzEIEvPMwyj016Uy7N3MlyUmgL9TT9FloeH+D+/kUeEbHqw68cm5xOlv+3jP7iwe1l
         rYbO52M6zWd0ym8D67OKB7PXpd9X2o1t1CdK8jQKirYJyrSnaKfs+bTZ6HLe+1sRtzDx
         9iig23cXRClti9rwP+o+9Q6JKZw3XjrSrPyXIO1CysqDIVnw2KA2J91ROXhr4saWQp9G
         Zp33yyLgKqiawPZMMPnjYJONcEP4a5uw4QgkTyOeBANdbxyLWB/tloFh9hk+95wGswrx
         pUkw==
X-Gm-Message-State: AGi0Puadwf4mrxLQi+nuPzS9zW3u1a2aIfVP2FnIOV4/ReY6/Mwj1PrM
        VdxFY1l2gX4sdAzY7oV6istvVxD1c4/g/YPtuTrXjQ==
X-Google-Smtp-Source: APiQypJb36H+6c8IlR0vTi9BXuXjJwwJvUVMzH0fBvWGdbfdEfk6ThGBEUXGm4auATlQOAa5YDCCxoc4uf0XtlhLTSo=
X-Received: by 2002:a2e:80da:: with SMTP id r26mr2228163ljg.38.1588693848821;
 Tue, 05 May 2020 08:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165441.533160703@linuxfoundation.org>
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 21:20:37 +0530
Message-ID: <CA+G9fYuXiDk4Mhv2KtkjD3VU-PFdibMNbnEpgDBj-S1bKNqUng@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/18] 4.4.222-rc1 review
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

On Mon, 4 May 2020 at 23:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.222 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.222-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.222-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 2f5149253281f474194117c5fa97972cf76c84ce
git describe: v4.4.221-19-g2f5149253281
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.221-19-g2f5149253281

No regressions (compared to build v4.4.221)

No fixes (compared to build v4.4.221)

Ran 20159 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
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
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

Summary
------------------------------------------------------------------------

kernel: 4.4.222-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.222-rc1-hikey-20200504-710
git commit: b9d78bbbdbd389fe97e31f51872b6feeb6251466
git describe: 4.4.222-rc1-hikey-20200504-710
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.222-rc1-hikey-20200504-710


No regressions (compared to build 4.4.221-rc1-hikey-20200501-708)


No fixes (compared to build 4.4.221-rc1-hikey-20200501-708)

Ran 1766 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-dio-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
