Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8211C26F1
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 18:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgEBQYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 12:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728325AbgEBQYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 12:24:47 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24188C061A0C
        for <stable@vger.kernel.org>; Sat,  2 May 2020 09:24:47 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id y4so5416005ljn.7
        for <stable@vger.kernel.org>; Sat, 02 May 2020 09:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EJV2/wCIsqGGDW8Z+VQJmeb42prke2odxbNpHPmIEXc=;
        b=CyMpgS3Yqar1VKXRqHduriri3RYRyoFEJhXlAkzNLrhCYjKVk7NjNrTarO435eROEN
         +S7enGB7vd5FBdJGdLp1oG1p1D3bRrck2hvnWr+k7Oha0hzFd/wr66ejqX+2p2+/L0Qs
         7ZKtyddYUMxkbjXdtshs9DhlEJ9CFpT4X3to2SeB6UYoTY7706Ri4zeg76g0avmNquTY
         V8lLXhtltQPqQCSv0c7cP9BBwkqstPqBmWM/h46el0imZUVw+Qg6C5ZYXFjvsCokHeL0
         gzKmR5AWbonupeNBfxW27v9rmRKtGAACDCBDabQRHmcFBL72Ex6O96eqBvWc6fO+CcJA
         P8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EJV2/wCIsqGGDW8Z+VQJmeb42prke2odxbNpHPmIEXc=;
        b=SjrcXt8VFep7q9JPIqeo9UqlzRhfu1iWTq/CCdiv7QzVSeH0/q5v8ngIcCiwk83y7V
         AsduKzvRKzgDkMMHtH20zuj0K1ZTh1z5Q6eR5Xkaxei51Xmb/prn7x4Oy6WFJSvJjyaR
         0OKJRCUZdBLpJzqGK9iOZyxKpw8Taj5S0n4uKy0trVeZnOdsaDAgqy3jNCSsUMtnYVon
         R030iK0IMX+ak1lywed6i2qewQfDkp/YKzsuufr2uGddxDF3wB6goI6Bf2Go/NJsoxVX
         BfzTcVDq0TV6m4KMbUDrZtlyJfdO9iK4hXTFBa6kVMygavjAlvtMusJNnmaCe4yiw0ss
         Zcng==
X-Gm-Message-State: AGi0Pub99YZmbtrXiJQBJwPu0ZDRwovZ8JdkNsiO161wfb/7kBHetFOf
        p+LTcZMu4xMk+wBaEmhrG7JiHkEY8AKUhZ36mY+QLQ==
X-Google-Smtp-Source: APiQypLFr7XhCnBFHpdY+NaMrVslk8rdRUKd1MsZS54eDlF/GdieE15I8jHTGVTPJgIngmC3AGKceh7Yf+OtFF0DsQY=
X-Received: by 2002:a2e:2e16:: with SMTP id u22mr5709248lju.243.1588436685443;
 Sat, 02 May 2020 09:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200502064242.181724036@linuxfoundation.org>
In-Reply-To: <20200502064242.181724036@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 2 May 2020 21:54:33 +0530
Message-ID: <CA+G9fYu1BNCspjdPtde1PxHwtQa6mbKjD4LL+w-oYx=D1F4GbQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/80] 4.9.221-rc2 review
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

On Sat, 2 May 2020 at 12:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.221 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.221-rc2.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.221-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 6904691aadea8a133a2abc55efce7a5b205b53d0
git describe: v4.9.220-81-g6904691aadea
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.220-81-g6904691aadea

No regressions (compared to build v4.9.220)

No fixes (compared to build v4.9.220)

Ran 23416 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* install-android-platform-tools-r2800
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* network-basic-tests

--=20
Linaro LKFT
https://lkft.linaro.org
