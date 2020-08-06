Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3577123D996
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 13:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgHFLEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 07:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbgHFKgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 06:36:45 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AB8C0617A4
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 03:36:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id w12so35431427iom.4
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 03:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hj3R0tIfcIkpZhk/MOW24yuwzJti3fMgCq+xlKWe23s=;
        b=any6vJdFKrdkd+a4fKkNab188WSeW3kDjNjijmxdqJ1Y4AwYn4FLR/iQrpMyExolkK
         66mFi0t5w16+fsEhYOsaXPC7OJVlsPhTg+WoYRWPK0FdQfP7YIvZg6ds7gMUG92eJGlf
         QR/wHYZ3/YvNbqgsC9Df7dIJZMcVh4kmPbXY766NOOS+giXcztD5zCFd1TqLjGdL+pVO
         Rk1DiDsxHshnBfVWwBD5pTA0mCuqTXK04NlevzeDQqxbwa63QWFviu1CKXtu3YJ1qgJr
         2x+ZNON385FtWrcjVdXr3Pb9gwapMQ9nHVmz2lZTKPRtnV0lpchJrHtdsXLPNJk1IEsU
         K8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hj3R0tIfcIkpZhk/MOW24yuwzJti3fMgCq+xlKWe23s=;
        b=j2YH7bHaF3UrxF2+TELhfWFTGvTnRVQijQ1I18EzuP1TcE2+B8pO1hfjMChOMNSsIV
         Om4G1fge3Kyg0KnjwQfLszQMPc7OgP6CH4s9jnRmsiDRh82aMbMU37h4ob4i6ZfToSUj
         SnMq9S8YJbs2wifFuHltaY0bviVULtVO3zMbwvMaMGDpkCnMWt90+ePzx+aoF5d0C/2p
         4ZNCHsaevwPi11lZv6YwylyLpoCmT8ssmeb0O/gTBIcN0TG9hKPYOAQz2PHtPzXATvAa
         5pts4fCvk6rKsksjvwgknht8JegrVEiUoii+gF6kQVm/kel3IIA03jrtBXfWyzRS7sRz
         xxwA==
X-Gm-Message-State: AOAM532zJG7mSY6v79Kjh6kImeSWAq+WXS94Wuz22m7x3K/72loX0HUm
        4piEggoLylENzzQqo9TtJ5mKZ9Ea4zae6j/v2vbRg18Fe70veg==
X-Google-Smtp-Source: ABdhPJzHUTWPq7F01xZd1/4hqfefGb4XRem0zi/X7ZLbxaLwgnPaMNDxLcsPytmk4P8gwPB+ZN1V8Vf8ZJycfMty5SQ=
X-Received: by 2002:a5e:d519:: with SMTP id e25mr9126780iom.36.1596710167873;
 Thu, 06 Aug 2020 03:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153507.005753845@linuxfoundation.org>
In-Reply-To: <20200805153507.005753845@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 6 Aug 2020 16:05:56 +0530
Message-ID: <CA+G9fYs3szBM=oz5f-zJudALL0Um_X9xR0cQKzq_HQXqrdut-w@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/8] 4.14.193-rc1 review
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

On Wed, 5 Aug 2020 at 21:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.193 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.193-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.14.193-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: e8ffd3efac224a0f72ae9ddffc0522f6b2e169ba
git describe: v4.14.192-9-ge8ffd3efac22
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.192-9-ge8ffd3efac22


No regressions (compared to build v4.14.191-57-ge8ffd3efac22)


No fixes (compared to build v4.14.191-57-ge8ffd3efac22)

Ran 25279 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
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
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
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
