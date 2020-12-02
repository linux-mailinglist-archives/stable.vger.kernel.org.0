Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A052CB4D4
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 07:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgLBGFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 01:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgLBGFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 01:05:50 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90084C0613D4
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 22:05:04 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id pg6so1329676ejb.6
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 22:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ch0JARWu/AHIX0r3TzG/RjWXLohfVfCvWUEtdQGQRYI=;
        b=kTSJfU9xXPQZfkXPVEPDgHCNSS2bq03SMmaessGdwQYO7j3PCpFFbQVHYPvVDeZmhM
         04Ud7Fwf2JfNRtkbB5gOAxK3CgukTwU8+mmAx0x1QZ1ICK/NDWfJ1H6VE7ST7SHGM7xo
         NxccZ0qAUXT2NAiX/I4y8xsYOdzMcPcopBj2TjBUIOcsMijPIyxXMN449zvRNXZnQmjN
         7pI2MgBNCGyXWqE9PyoAuMN0nzJGh6z8sGb4TUmrqExu4P1B1GYMvp03F6T7YJQio06h
         P6C9YaH/CQgQhcm/rvbdkoiher6qqn+JEz9GcTKwJapXPbz9eUxt/45kuFkQXaVRyTto
         Fk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ch0JARWu/AHIX0r3TzG/RjWXLohfVfCvWUEtdQGQRYI=;
        b=XgdhA0KEfiUNp0B9+tZyYSnVmmYM0qLZr/oJWMlv9UuAVy8JEXWozuEM14WVKcpzXK
         fWbPR3a30bJpF9M+H1KeS/nesns/2QOHUO7374F4qpQiue/2WVQ7FJghJNyX1ligf5VR
         iq+nFm1NPTlmFJPFfB+kp/VJNKD1GoBTb4A8ytmyAS23lIpmPJGI54O03i41d0QE1JtT
         GvLYjbSd0yZjqA+Z80hEd4y1GsUyRa4AA6uvszkLaDRWfMaIUdjD7vqpcAaCZTfudoDZ
         EkuUT+7b4RO6+8RQIYGm0SdisRU3XTgj3ItO+3HI65xl8MTd+9SmWuci3DD8zWJWRNs3
         dnLg==
X-Gm-Message-State: AOAM5300F78S5FMJyFW/957MYPaxiajw6OVBhVfwy0AW0vJ1DYo1v6jO
        hLvBJwr0Hr8PzIf5320FCflUCZJJG0Eh0tlhE435vQ==
X-Google-Smtp-Source: ABdhPJw0Wn1iU0u2aF3o0Wq7dlWytmNM4xAqr12lJKAM0rjmChMU7C2l/afL8YwXShc9/s5jhOUqZlaAfrga6cfGAIQ=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr802460eju.375.1606889103122;
 Tue, 01 Dec 2020 22:05:03 -0800 (PST)
MIME-Version: 1.0
References: <20201201084644.803812112@linuxfoundation.org>
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Dec 2020 11:34:51 +0530
Message-ID: <CA+G9fYtQhPonn_fAgb3=vXdDDWRW-t4ykfDmfrfrPVSZ=s857w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/50] 4.14.210-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Dec 2020 at 14:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.210 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.210-rc1.gz
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

kernel: 4.14.210-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 07930d77d7baeac481d5ec4b88f8b26ac810c4bd
git describe: v4.14.209-51-g07930d77d7ba
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.209-51-g07930d77d7ba

No regressions (compared to build v4.14.209)

No fixes (compared to build v4.14.209)

Ran 35483 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-kasan
- mips
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
