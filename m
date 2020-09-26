Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C362798D6
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 14:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgIZMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 08:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZMgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 08:36:04 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C50C0613D3
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 05:36:04 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id z193so3022614vsz.10
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 05:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WkEYzL7+hCLzFt4K2qn8C7SP4BdY2Ftf9TiA8GXOw+s=;
        b=R7UksnH+e2uSidseT7iHrEkPqku2vC0PdmFo/B5xcrVDGjrQkMtmwdd5xiG6S3JTw6
         iYSG+Hp1t1LbUs2Zx551Zy8nQ1+aP7XsO0CzpFD36f/hFhFUAx88dbA2C82lsedcYX3+
         02NSR5Ba1Cv29ZSbgnraeEa/1laYhV3v2zw5ua5dcEW2XT8GiYZUIYWEkxsUdNla6HX+
         OQFu9lT8xKpIc8WLEiv7Y/9kZNxjEgcA1pShR8QElEyxslOo4l4ORoy3qFMmax+YiqMi
         r9Vlo9sPqmOGe3karkeorGV5sQFQA6E5nvnfGB9wtymo9KXVzFodw+r91XnAGpwZYyHZ
         pudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WkEYzL7+hCLzFt4K2qn8C7SP4BdY2Ftf9TiA8GXOw+s=;
        b=T7nGyvyQtOoReOC1XGhWGs7KE3irT4xlBRmmzkZtrjC9xvndS2cOcNnvo5PqMnPcBK
         GDUaxNsa1+VxQVOVEqHrOKA1TXtAi1QabaWbbTIq4DNAWL3cPuhrQfwttRThpH0kSD9S
         olX0SCRkk2cRSWbfzs9WLav0rxV5VlLgRex0EQnjzFw3MxSdYaBPKbUouhMN8ZiWDWYU
         4CsSDfdKtpDAENAJLznTs4HOPeSzM78mcejgTCyA9iKcSLno4ax3hCZRaI9PCqY5sV8F
         JI5r3FJW9XUWoYAT89PThxFN7gjpCFJREBYoms6TwSdQPbw/7EI6G5xfZD9E92ZFBbws
         ETuA==
X-Gm-Message-State: AOAM531KdDn1gxGF0opscyTs3EMlk7SHcqzy6/xpOOuF3O4UbMuf+Oe6
        LI3Ba5hzCjfGzTAPCCYENvueSt6NXpHlAL03+acX7eDsh9CjhxiF
X-Google-Smtp-Source: ABdhPJwnyuuggpvoB+ucHf8eDyTUp6nMBSSfzldILEUfAb3Bn6s7uRloFHQAAQFt9Tlbx43V4c47jaknAXBy9HfLP9w=
X-Received: by 2002:a67:80d2:: with SMTP id b201mr1639866vsd.12.1601123763439;
 Sat, 26 Sep 2020 05:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200925124720.972208530@linuxfoundation.org>
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Sep 2020 18:05:52 +0530
Message-ID: <CA+G9fYvaonkXn2reCPWDUU2qhLkFQfV4tYF0HjPdoxe6mCFcrQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/37] 4.19.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 at 18:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.148 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.148-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.148-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 1e68f3302e6a25ff4310dbf4f2de747180d01146
git describe: v4.19.147-38-g1e68f3302e6a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y-sanity/build/v4.19.147-38-g1e68f3302e6a

No regressions (compared to build v4.19.147)

No fixes (compared to build v4.19.147)

Ran 28038 total tests in the following environments and test suites.

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
* linux-log-parser
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-syscalls-tests
* libhugetlbfs
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-open-posix-tests
* ltp-sched-tests
* network-basic-tests

--=20
Linaro LKFT
https://lkft.linaro.org
