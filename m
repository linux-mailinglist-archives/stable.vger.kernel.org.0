Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15302247E2A
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 08:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHRGBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 02:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgHRGBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 02:01:32 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CBEC061342
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 23:01:31 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id n4so9503464vsl.10
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 23:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0TdEL2s5heQf75vwYJNfnjXqieaKBtucNXTrsuJPeQ0=;
        b=koDs5S7+XZMJddWqtOyc69D9o31EFTwKRwLy9ykOrV+Wqp1gqeGY90tLPCpxl7+625
         cVcwZ3TqptCJ+Q6Vhg5KOV6v3glJ7dqFwMfSoty+ERhhYf/EJtlAbS35uyIpZajiqqzn
         QdMu201Omd87V06VVt89dN7xNqiqSs/kzOm8pIAo6P8Rxl2hjfPyXx/peetzoGWsL/Lo
         tQ566JlG63tYHEbZOlMsWVnoknJL+RrPlKzlIpJq6T6kbIqfo1LTK/UtsUXE2mQbBw6M
         DZqJYkAEEex4fKPWTPW28/JklJ9Zfr9Gf3f7ioFhSxbBCUfTfSYfQHzfcnkcZiC8U07y
         ckxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0TdEL2s5heQf75vwYJNfnjXqieaKBtucNXTrsuJPeQ0=;
        b=DtNnstuP+y+rH0nDaNZL3YnImXlBXagfP059qihqH8zAT4SKfFETemphswPRhbqcXY
         Z0QM4YLHRdd6sn2IaE208t2xSJMjEWLSLAA3QvyF/SiZB3RSYrkhlKA0hyqYyJtqwWdh
         vXZWKPhMK58gbqEVZqlgEixSYxfz48Nw28AqNmqvf916uXiT7FRzRKN0qHD6zf/KZLmw
         hMqqcBdKh/DxalfatVjTF9GBgFmUzMGqb50zysd2wUmwgzCxDotelY6UnpDd9UqFybGj
         yHBu5G4cwcspzv/irS91/zEUQV8x49ABaW7MJK1UGjxiF+cutuszMtyKMMWlqoh/KJia
         Z47Q==
X-Gm-Message-State: AOAM5334Hllq7VW1xFIeE4LwANiyXzKMWXvy/O1FF1AjfF/ROX8nA9yH
        6gaVBEJzQ0PK9O171Op/fVj6uPdGb/xFBinbSA3sHA==
X-Google-Smtp-Source: ABdhPJzo7tafMaTv/yDE2aoIjuAX18/1G22S96q7B0osOCU9B3d9xF2OIt2YPGUF59iPzOsR1lNvjL3TbiLOVqXNTxw=
X-Received: by 2002:a67:d84:: with SMTP id 126mr626997vsn.69.1597730490437;
 Mon, 17 Aug 2020 23:01:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200817143755.807583758@linuxfoundation.org>
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Aug 2020 11:31:19 +0530
Message-ID: <CA+G9fYu=TrfvO9soJJfwBKLV2VYRv2vJ8MQ37sqdaz6tHGDSyQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/270] 5.4.59-rc1 review
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

On Mon, 17 Aug 2020 at 21:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.59 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.59-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.59-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 6982f544144f32263ec02a0eb61a60148824b853
git describe: v5.4.58-271-g6982f544144f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.58-271-g6982f544144f

No regressions (compared to build v5.4.58)

No fixes (compared to build v5.4.58)

Ran 31881 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-containers-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
