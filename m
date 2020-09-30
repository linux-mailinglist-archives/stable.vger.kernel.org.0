Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBD527E296
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 09:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgI3H3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 03:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI3H3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 03:29:06 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E3CC0613D0
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 00:29:05 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id h15so207582uab.3
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 00:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KV1Q/MN5muoTcUd7+lmEw4N8e3qVtX7Gu1utQ2M1RL8=;
        b=pqWvYsSzJ8j/tigIi8DO2D5dPlcBy+QSZqFMzydltWXfPTXmMnzF/si+xhIekKYFvH
         GrN7eDLDXPzq3WbqvARxbm+v9muvFUMvqf0NkWnzIiQ7+jsXxxRpLh1XqhV5cL5Pkwfe
         FDKG7Z/MeQGb+pXtM+Tx+aiHExj8l7UpgM5rxdaxcH2VfNmjiTfsoAI5wid5zkPRE8m4
         2NzQmJ2h+yTi+B8ktk13bQ1AIj/1KXmhhniyN1iNM5ZijSxroaRDuQGdtOGUGWwMIiFw
         5aZxd6KNeX1JdacJcEgqrCWX1KdgFosvAQ97PhesFn7/fCC8g8hJx1VnGxhqGA74xFjO
         xg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KV1Q/MN5muoTcUd7+lmEw4N8e3qVtX7Gu1utQ2M1RL8=;
        b=kx6YuXdltTtFp+NUHg3sp0TR6VXaVdkimwSXlXtVCsjt+2yoeCotZEun8S8jEJtsee
         I+DGJYyBerHgqYFcK6q4z0jpsBlgxutOFoPph0Yi9/PLxJg4yBtnxO+Nr0b6QndDVSrN
         POWxulC8Evrpo0b41SmFxhwLzpkvo91maVdeOMUP0AP8cSTOcRxoiyHcTDeWZR3/u8+F
         kZr7Ruc/Tb5H/lCL2yNaUxaU3hPIkVW1oGRByPP+np57VN+GGA5CVE0/PoRmof55/2kI
         7IgaBMBzba3Muk9g5OLK64Ob3EQ68wMu/Iw2mSDaUbSK4C6wLnrI3Wz9iC/IF31S066k
         zAMw==
X-Gm-Message-State: AOAM532+2bptmm0LIe6cNTp4y/qUdGu9Bkw8LL0IeSd5EkGLHCCde6gO
        dnNn8+kTSFWl95+zw1noU2+sxjbfZ3zvyTGd1llGJw==
X-Google-Smtp-Source: ABdhPJyEQ1/By5zp2yDuSY5ClkiLYd+NbFfY6toW9ssCJ7zCVujczXMnxV8J0D5GdsX717RAUJWeJBMDVjUtvom3uxg=
X-Received: by 2002:ab0:1450:: with SMTP id c16mr591737uae.27.1601450944865;
 Wed, 30 Sep 2020 00:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105929.719230296@linuxfoundation.org>
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 30 Sep 2020 12:58:53 +0530
Message-ID: <CA+G9fYsPwAy-GSD504dt7ooe_ZntZT8esuHvJ8yFdW4tUg-bSQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
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

On Tue, 29 Sep 2020 at 17:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.13 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

[Sorry earlier email was in Non-plain text so re-sending]

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.8.13-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 2bea8b771966a8b5b009c261dfb9c97df1c62af4
git describe: v5.8.12-100-g2bea8b771966
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.12-100-g2bea8b771966

No regressions (compared to build v5.8.12)

No fixes (compared to build v5.8.12)

Ran 38153 total tests in the following environments and test suites.

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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
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
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* ltp-commands-tests
* ltp-controllers-tests
* ltp-math-tests
* network-basic-tests
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
