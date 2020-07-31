Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5E23460B
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 14:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgGaMnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 08:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733292AbgGaMng (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 08:43:36 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB31C061575
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 05:43:36 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id p25so15648005vsg.4
        for <stable@vger.kernel.org>; Fri, 31 Jul 2020 05:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ptzHG9zuPWMQjc5H6HXuWxoVOZ3lKq9oK6uYzGg8CWE=;
        b=OyGuLvWYglrPqj1bn2UfJK3DPkvax9NvfZpJhSfaZ8c2XlMVqv1IxIQg+++id8xno6
         dN9wySfrTxHGwo+xAdZJiURwdC/o8pdR/vUSpSjFObuChrBeEPXTaqdAXwnhGLXKVvIh
         we+iUV7F52h6slJu716ntxoyV6S/Kbl6mljo8WEAHysQLTFXPDPmAvUI1TmQU2ImZ9+e
         AvPPSYjNdehiEGB/pDog6v2MAJucjF1EG05MFmxPJk9naKibwDdi9RqsfZG4KbFlC4Jv
         1JRpR2xl9y2CQ+908teHQnxyCd6qWS6P7vQVppOSlJzBnRT1M9iTJtqwl85GQxydqO5i
         WpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ptzHG9zuPWMQjc5H6HXuWxoVOZ3lKq9oK6uYzGg8CWE=;
        b=h+7Wd1ghIDdcXrzeh+rRwxCnedKbCbz6Ijwc9qKA41RTaNqDzXEZTsgCWuWdGmHj5G
         EvSoteKFxA2qHkq+oDQEuR8zuMOode/50lOnehkvVNs1x8YVEmuPSb6NwJBUqRagmyBV
         TdYocd5pnTbXtu21gmzzHuJSq+sbodAfEz+fFkSYKM0PH5YKgKSHiSWXoU5EiJrQ8qvZ
         ixE6LXuWalx2xIi+EzEfBecf8LUn4s3KsH74mBGwPl8NMXjcb80/ZHGNu0SWoCJDZfVW
         W3NwH9VwVb/53q2VQzwi6o2KmuOZ28ayL2vJuOS6sZ6wLAw75zb0yTQQNEG+ZPtuNnJV
         9nlQ==
X-Gm-Message-State: AOAM531dVlgvj0YJnFWhhcADSrftk8AHXKeG47moY4FhikupMcfMMTHP
        Z9PN63cJ1C3b6gM7HfR7PbbFJEaXSZDYCc9MpgHE+g==
X-Google-Smtp-Source: ABdhPJzV5MEWdAdciXvU/+naYoHN+ac+cipTAxRsRkZlp7sFwnJg1s0JE26Ep+6vF6jKCO1j1FAh+PCmUjp3nLitDUY=
X-Received: by 2002:a67:504:: with SMTP id 4mr2937994vsf.22.1596199415578;
 Fri, 31 Jul 2020 05:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200730074420.811058810@linuxfoundation.org>
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 31 Jul 2020 18:13:24 +0530
Message-ID: <CA+G9fYtUAseOUsQyf=iH7kTSGYUeo875_hhdCD1ayhddNn0PaA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/61] 4.9.232-rc1 review
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

On Thu, 30 Jul 2020 at 13:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.232 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.232-rc1.gz
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

kernel: 4.9.232-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 3c1be84608a0c22e5b574396a51ed93a7f3206ba
git describe: v4.9.231-62-g3c1be84608a0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.231-62-g3c1be84608a0

No regressions (compared to build v4.9.231)

No fixes (compared to build v4.9.231)

Ran 34650 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
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
* kvm-unit-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
