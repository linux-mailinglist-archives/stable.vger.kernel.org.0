Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADF81C5C41
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgEEPpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbgEEPpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:45:13 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0674EC061A0F
        for <stable@vger.kernel.org>; Tue,  5 May 2020 08:45:13 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u4so1750555lfm.7
        for <stable@vger.kernel.org>; Tue, 05 May 2020 08:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yF0rSv5G8dMiG2t0mZJS418QhuFNKXhIXOuNkoLggjA=;
        b=o75AfWltUD9X/y2+TGKaVDgLD1U3ggtfbDawvA2uueQVC/Qb/RZaIz6B4+WW2k4Id0
         LdT7tgHLS1cRyYtv0Ww64GCQfuiQSFOnTeYgN9FQHNqaxtmv+8pstfmAtPAcixCGziHG
         rtNjp/zd3VQahq6R8KbEsrNgQpYJl2w0kI/stJu/L3FrqMweTpoHlNvyyKOY2yJCRdC7
         bNazpewSsa4eJUPDeR/tG3Z0Q/0NtOGsDxkFC4ibE1GdjtpJe4FmNna034KjjN8tdq+I
         sSnekhNkhp08qhC7Pj4aVz064GhT1W8kEIMBG4TTtibTf5k+tjODCbNyr3DQb/hp0JKo
         ACNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yF0rSv5G8dMiG2t0mZJS418QhuFNKXhIXOuNkoLggjA=;
        b=W7FHcQxn32FgJevWeHrH/BEVt5u5MLPLm3T+jQhk5kyHG9G9rpslFSw0/0AL1lLYEm
         4Gb0YZoT4I65BzQCEUjXfVkMh7uxaecV7K9CWQpoOrmGsUNmEHVaaEl2xyNrZczq6zpv
         rYIDWVPTB10QeKtBzGAlR1r84zR3Omm/wMCqBIY6rNN6J5P1WNYM9k9BVMw6d8jx0VmU
         D9C/uCq+FScg+HFX40KxiHa/C6fpbNMuJBk1XXGYm3vt9nS5hzKg1FR+KA76lEQTXkZa
         S8X7KzAAcQtPbtwKZYYwbbNr99WS59Ejpm8q2Y3qdjLHMzofNlUM9EgutI3yvK5CNfKp
         cwVA==
X-Gm-Message-State: AGi0Pua/m8+SN86IUECkLisK+HLh78/f6DSiLoya9NhqfDrpfpHyq3pJ
        iCjbVLZOuSg+UvLMjLGm6KnmFQRo6Iyk/tj/nLMQmA==
X-Google-Smtp-Source: APiQypLzj3q2ckmPSuxHoT7j0Si2HArFLe4uE91Czny4cnljFLAreRe7/ipkVasASjQusjOm4Q23/VFvqYR/e1fvbGI=
X-Received: by 2002:a19:4883:: with SMTP id v125mr2054645lfa.95.1588693511387;
 Tue, 05 May 2020 08:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165442.028485341@linuxfoundation.org>
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 May 2020 21:14:58 +0530
Message-ID: <CA+G9fYvLpEwde0kaPcdvPW+FU=kmdyKYoGYhnD9OBirWtucmqg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/18] 4.9.222-rc1 review
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

On Mon, 4 May 2020 at 23:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.222 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.222-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.222-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: f8abf65f20c5e9296d6aeb69c452160ab639d8be
git describe: v4.9.221-19-gf8abf65f20c5
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.221-19-gf8abf65f20c5

No regressions (compared to build v4.9.221)

No fixes (compared to build v4.9.221)

Ran 26505 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* kselftest/net
* kselftest/networking
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems

--=20
Linaro LKFT
https://lkft.linaro.org
