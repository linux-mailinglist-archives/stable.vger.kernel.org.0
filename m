Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37280291098
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 09:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410922AbgJQHsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 03:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388175AbgJQHsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 03:48:09 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B98DC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:48:09 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b15so2956569iod.13
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Nk2Tohw6NCCvXiOsUkCOlP7Iz/O7h1IBzYBVlyxjaMY=;
        b=NWcDOwOFcNUpoYm9vpmU62kuACvZqaQiStyue9vgBjOwScDtf9IrQdg1MmCqvk+JG0
         9jr0gfy6xfb8e03O9MaP8tlu45glV4ol0dqTzfeQtbVIu5BY5/sP0kNtTmeJrSOskzMd
         WtZeoB1RlOXpCd6jupYGM23JWB8WEbBpxW+kgQT3Sqeo/Dr1bHA8czm05co1ewFLm5Lk
         xqrvZP7TBsWJrg+sPeaWslB3hoohp0iCQbRN2zDY+xyhMtGP6APgjOwxOp3WWZHbqC9s
         vjL3cLP9EPRLOuh6Hx9fM4VEAgn3O/pwEFmBJXIhE7XnBNjoF3k40IxpTuM1OxYC42Am
         7CvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Nk2Tohw6NCCvXiOsUkCOlP7Iz/O7h1IBzYBVlyxjaMY=;
        b=gzG3pmwF5L65rrsGV7NQwne4AwcC8SEbW8ZVYVW2zme8GU6y4zSYWVd8zsAW5bbD+R
         /BsuWRbjOfiyB3bEYIWhdoPAHSaER1sIYZRCmLqxPAB7ZLlZyNkFua6xFezgyy5pxTjK
         /kKGzD+90fSu9xFJm71mEAIBxxBiXqBCQ+qyftzpIzkruU1FPGlhu3qmLqciKshXBwds
         2smD4hlNYPOhme4YjrdlT2zH6AkkjEvoRZNt7NgUoVQmQ69vlgL2DsK6dhCcFji+Sv8X
         U3wVoViOh1aFheyJTTgG06Dv8+wiphiWcOaJO0Zt3dQiGQFvMTbKfIP1j8E4HeASjcaV
         Eg5g==
X-Gm-Message-State: AOAM533jBT+MKhvmABeqo3OSSrUlNisLVPrqFYjVjeUXhHvkshz7+Mu4
        uz8qEdSaCNqpsHiJ8Hv7+1z+1FLKdbMb1UHfu3Sv+Q==
X-Google-Smtp-Source: ABdhPJzPswgkEYlyhEqit8jKlTgPXKpKCLycmYhlVMnijzmjpO33n7Gh1HFVeYY6xpjoRbz7D3lTetPW8JGTRq0JyFw=
X-Received: by 2002:a5e:9307:: with SMTP id k7mr5201085iom.129.1602920888548;
 Sat, 17 Oct 2020 00:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201016090437.265805669@linuxfoundation.org>
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Oct 2020 13:17:57 +0530
Message-ID: <CA+G9fYsYX0rQtfXMmLntcx5nuWEFq9ZDVS4Y4_S5vd1V0kSC8Q@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/18] 4.14.202-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 at 14:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.202 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.202-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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

kernel: 4.14.202-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 7d10bbd1a87237a93f881d8cd84dc686b9212378
git describe: v4.14.201-19-g7d10bbd1a872
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.201-19-g7d10bbd1a872

No regressions (compared to build v4.14.201)

No fixes (compared to build v4.14.201)

Ran 24934 total tests in the following environments and test suites.

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
* build
* install-android-platform-tools-r2600
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-ipc-tests
* ltp-math-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
