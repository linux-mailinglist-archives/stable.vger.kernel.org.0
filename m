Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7625529D9B8
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 00:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387814AbgJ1XAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 19:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389863AbgJ1XAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 19:00:34 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD198C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:00:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u19so1324137ion.3
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 16:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=054hj5bRhsBBpQGqDGnOENO4BZVXs3o+bMg+VpLA5ao=;
        b=DJv9keGHpXKt0BGay4aRS3RrETxtnpW8y9bzWUbJME9+QhC64U7xCZM+HfBN/+xrCL
         jQqfXy4wGKh1lEHs9451SSLulazmsZLHBXhPzI+rFGigabYCY9Yps5e13cJVIZ/oX3sD
         OQucSdMXRmcamtkcmtEmcJvp7kCHMR76ETcx8sPMS6ZCd9jbxDeO4ogJ6XMkAMI+JCkQ
         QqwGksvfE3J9xcQ/0PAZquLkiGx7DXtbjmv6EosGmYDpPiQhlvYqB2Yj58UPkqwo7HGP
         ej0Rif+cIa/PT6neQXM6kgfZtaxlXkctJrFI95WUA+5Uar1LZ5Yr6l0PG8M+8ddBCRHO
         kkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=054hj5bRhsBBpQGqDGnOENO4BZVXs3o+bMg+VpLA5ao=;
        b=EeTkRuzuB365CyMpqeF/FFr965uc7FmNR2cPdfldeQXgpcq4H/N36TKwpJtrtApJYl
         QAPaMbl8oYGhD2iP4rYZhhX748WI9rOd3XNaOM9tXrt9233te8rQmSRpZ4bI9/N3Ch8v
         Ka05V7+HBmLJy4WD90Lfh7WwiaD3UlKzw6uGJyZvG0PsiRCrOhbZuxGnIMGjmn+r+LAS
         uXsov5OQUJ7B6oMg5CSGCDr8rOva/6RQOIFTOqoXyZ73vMSoOgsjpkvIPHFxOtl25bmB
         JpkmLABxmvyztaFkpt5achWfTHkIwjLWuTZyuO0k2m+zx3IlOibU0uklgpv5wYdXJ8+l
         VkIw==
X-Gm-Message-State: AOAM533DzUzVQ2nWLsCARf0Yul6JWsDnFSmqToH+SDcKGFC4Q6UTyC9P
        oJzYu8C6b8Uys2P/EnvMQBB6piQGgYhQJqNUFy8gHFxryMbp149S
X-Google-Smtp-Source: ABdhPJzt4+vQA+6BHCM6hpKI3F3ZiG2sXnhZTlRpfzdTm2LhlwuR0v0JM0bLECmDTrISM1aR7D8OeiFhrH6ZscLKsNU=
X-Received: by 2002:a05:6e02:106c:: with SMTP id q12mr4563792ilj.81.1603867998466;
 Tue, 27 Oct 2020 23:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201027135455.027547757@linuxfoundation.org>
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Oct 2020 12:23:07 +0530
Message-ID: <CA+G9fYu04UQYmcmthXhHEcFMk=jOZY5HUj-VRRep19F7tYPXEg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/408] 5.4.73-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 at 20:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.73 release.
> There are 408 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Oct 2020 13:53:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.73-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.73-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: ab6643bad070b82c2f3cf336bc18c87eaa5c92d0
git describe: v5.4.72-409-gab6643bad070
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.72-409-gab6643bad070

No regressions (compared to build v5.4.72)

No fixes (compared to build v5.4.72)

Ran 30609 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-commands-tests
* ltp-math-tests
* network-basic-tests
* perf
* kselftest
* ltp-syscalls-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
