Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728292D754B
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 13:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgLKMID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 07:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391588AbgLKMHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 07:07:37 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B8BC0613D3
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 04:06:57 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id k4so9106564edl.0
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 04:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oXxORYWlJeTJ6foPxfuUrfc27BGi4BJpM/a57Gv3x/Q=;
        b=OtulTNkb9jUEHUWYERO314Xq3VcnpUxkSZ27ReRfNqzilKFzEQM4u7gU6zXyePxAiP
         6Kijhg5cn0EEogincBwMpPq6yP0ZhPxlQuNw5zWtBd6ayKOIRW4Qdo9UD6ajQHtmBKMm
         g3Y/n8K1otP7EfX1rLCeJa2zcITGlSQYJS1QCdL/jSt6vKoOdUxc4oSC/HENrNxVK7A4
         15HAmBzH7g1xtynALWCnSyubvWUd5ocR6/E8A0bORLTW++Uy5wJ47gX7kEglPdXajb0A
         WtipOvrTrpeWDjSTLgFb54iQZkzkynvRHXRWUSkodu55dqyG/dEX4ej/JwuaM3wPs+pc
         5Z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oXxORYWlJeTJ6foPxfuUrfc27BGi4BJpM/a57Gv3x/Q=;
        b=VuRkaCnGoiSRpzUr34j0576fGkdZSL3bdstJdHfRKcSrwn9STHap2rqW3dxG8RtT7e
         mGJkh7B2KBXQAz5Vqs5GdBz0cWZxfjDNn0bqk+RF8UMC8GPDrNFnSDrH/8k1KGdAHG2J
         v/+AHmq6rSNxDicOkjZQpwwKvPthJkweDPcVBGegmPN3CcTbEjiOmTIuyPfMBaEFfjMt
         THDXC6sL7pESq8nNVexMnXeOOkKgJyAt3ecoYtyngC8wtuFnIGEShDZ3X0uk3C34zweg
         UY9FxjNn/VgPLHV49ywQ9ntMxJv33XRMvMYFK/JPDS6S1g3a9nIZ2KGhJzBNm2NTkCJ8
         uI1Q==
X-Gm-Message-State: AOAM532Ek119BfRRcZXimDvYwBlq6CJK91LJWNorQuKJILnmtrxGPrIY
        FYvuy6yXwPifScyPZoh7nDth3lNwo58FE/REQCRrfQ==
X-Google-Smtp-Source: ABdhPJw2UZxXj04msNF7iASVrNltc93EVvXNIASzKCjfhmaWhXIAkSLAPw43p06JR23HXeJmtOX5Cpf5WITV4A57uYU=
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr11440278edb.365.1607688415899;
 Fri, 11 Dec 2020 04:06:55 -0800 (PST)
MIME-Version: 1.0
References: <20201210142600.887734129@linuxfoundation.org>
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Dec 2020 17:36:44 +0530
Message-ID: <CA+G9fYs_5xr_yzQ-ny9-x_e-+x+sNmWAbU9BbmtnswVzuZDuxg@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/39] 4.4.248-rc1 review
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

On Thu, 10 Dec 2020 at 19:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.248 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.248-rc1.gz
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

kernel: 4.4.248-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 6564de77497b736985693950cf537add679bfa21
git describe: v4.4.247-39-g6564de77497b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.=
y/build/v4.4.247-39-g6564de77497b

No regressions (compared to build v4.4.247)

No fixes (compared to build v4.4.247)

Ran 12094 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- i386
- juno-r2 - arm64
- mips
- qemu-arm64-kasan
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

Test Suites
-----------
* build
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-controllers-tests
* ltp-tracing-tests
* libhugetlbfs
* v4l2-compliance
* install-android-platform-tools-r2600
* network-basic-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.248-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.248-rc1-hikey-20201210-875
git commit: 16dc859ce8a7a0d97f1a9f71ecb185b4d5cf574b
git describe: 4.4.248-rc1-hikey-20201210-875
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.248-rc1-hikey-20201210-875

No regressions (compared to build 4.4.248-rc1-hikey-20201209-872)

No fixes (compared to build 4.4.248-rc1-hikey-20201209-872)

Ran 433 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* spectre-meltdown-checker-test

--=20
Linaro LKFT
https://lkft.linaro.org
