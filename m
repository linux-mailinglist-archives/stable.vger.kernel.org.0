Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEF13046F9
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 19:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbhAZRRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389714AbhAZIMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 03:12:09 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C1BC06174A
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 00:11:27 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z22so3961431edb.9
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 00:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mjSxBujVARo+QaijZugtt/OwixE8PM6p8pEdlBa4l0Y=;
        b=SwoanvFuO4q5YeAT1QOcDsEAyfEPUYgS6jCNDe33z3wdN2h+e9jFw3cU6o7o9oubU+
         Iyi8WH7k0sMdXSG72WYE4/HmdTkH7768BlowO20d8o5arHsvMAr/zPUD1C7F0ieadwsj
         oFZV0AiZZBRn67f2EY+sK3s4ly7DW5O3nM9gk4+QjQPnaDaqK4rXxHIXOBD75/M2JdcQ
         yzxrloRspikWsf2dirrybsK3V8lkJJknBQr5mV7UscxUUz8fb8Iaq0VM3S0QOWcCk/O1
         tz6GkhJYqk5b+pbanNcUJ95IbZQ8nsB19H5PJhiSDAAbwm9TQzZUYEnRzwsU8HHMTNi8
         4vYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mjSxBujVARo+QaijZugtt/OwixE8PM6p8pEdlBa4l0Y=;
        b=Td+MfPmYJOrPOOfb15zb5OqUz2PujM2BN2M+LasezIPfd3plXCB2WPIRsuF8IpcvfT
         0OWhTxhvrOP8xlB3vOFshjBMK3/HI8ok3dH3zbfY2QcXQuAyDpGe+Cn4CtpMu2oA/NHS
         vuTL1bijgqkTPZRzpXCk1SeTBECs/fnLupB+V4cvNWaulr4yUntvwHCxFz/gmag0BSby
         0irz/yAohwyHmCZZWllH4YuoCHM4C2aKTs+zZVStjLcFXzjQffai8j4RFVdqXxEZ+yl6
         FgWIiNIi2H+0Wcas1pfGW9pQRUEHxfLPPL/YqbjRfXdRQUFjflPr0tvXkKsoVKa5B1QX
         +tSA==
X-Gm-Message-State: AOAM532rd3uw4axrE0rU6UkSA04Qh7nxvR2lmq86afsAMABqC57N0+O3
        4QmmxEdzygkhTNyTtvNYv2uAd6wqQyKGf7spAOD9ERPgFdvFACM5
X-Google-Smtp-Source: ABdhPJwXtpWI1CE9MpaeUPaWUTUWY/N7Daiw2l3vGgEE0JYI4PC20eke3VA8O/uYmjY6v/ZlXXxJA/PQSl5oEJK+9bE=
X-Received: by 2002:a05:6402:3088:: with SMTP id de8mr3539602edb.221.1611648686529;
 Tue, 26 Jan 2021 00:11:26 -0800 (PST)
MIME-Version: 1.0
References: <20210125183156.702907356@linuxfoundation.org>
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Jan 2021 13:41:14 +0530
Message-ID: <CA+G9fYsQi5x1QqgC0GvJqUO2BRwTdD6P9RskhH5UzXOxmj9JnA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/58] 4.19.171-rc1 review
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

On Tue, 26 Jan 2021 at 00:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.171 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.171-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.171-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 9b9e817bbee7dcb514ceba2fe100ad324cb7179b
git describe: v4.19.170-59-g9b9e817bbee7
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.170-59-g9b9e817bbee7

No regressions (compared to build v4.19.170)

No fixes (compared to build v4.19.170)

Ran 45655 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
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
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* ltp-fs-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* ltp-tracing-tests
* kvm-unit-tests
* rcutorture
* fwts
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
