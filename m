Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2002202291
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgFTISo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTISo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 04:18:44 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF69C06174E
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 01:18:43 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id o4so6869843lfi.7
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 01:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=l9sVdBupCrv1cQPqOx/4ngtnBtI/mnXzU0DrRVBMLaY=;
        b=SnFY32DyDPj1zK0vky409Vn3NqW2WG/GmsMiPB9I18GDMz97DXS+BSp9rzp2aID4Fy
         gS8g2VyoGI3370WkpwNQOefLHWOKkL0NJk4GVADh64N1T0WPC94o6vjTQ7IT2fqK87p5
         xF3tFqvp/Zhboe7ZMHYDSbA3FUNN8cki/+SK/Aolscdj6iRlJ1SejviAiyUGfK2W2qiK
         IwB4bettbXLd6sLwX4tnWruGZALxX/MHR0gHQxdwn523QnCeuPcw5BgQtZ+fh79P2uKo
         t3JRdGV4bxN/DgIA+FlEQThWW9ebqb7mj1IT6pCmGp8mAWn56LZnJheA5lLdO6uvtL+7
         Gfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=l9sVdBupCrv1cQPqOx/4ngtnBtI/mnXzU0DrRVBMLaY=;
        b=mv8CF3EVYS8FmqVIqBn4H+KV7UEipkQTfftSwPcW43iWlmBuHA6zYtNarT/Q0WGhFS
         wvNKfbd+qsVwDMfXOXdBvJfvcW/Z4PWBYapP+k+t5pWEb3ucDXrm1JoocfNbwd28T8XK
         d/PE8nfX7M8piPPo2RDh1T9U6WwpvwknuD0sM9Ium57SNBZk3eZVrsLFK/rxSUEoHGfS
         gsU6t1G5qUZCYljEWY7+itnkdjRuQrrepM3GrzRpNg/C2Gei80Fo4BLJGACrjPtTH9Yi
         Pm/EY/wB02jdV4VUFCS4Oc6d6gHtCzWA3X5iI+47WfpHJ99BowaG1nnVBdKkX4VMQWt8
         z2SA==
X-Gm-Message-State: AOAM531XMlgFSx0LtzSzM8vOLYGjfFLyfbxj5cAqRIvwGdn0LbJoxP/0
        LZ3rfQR/4zzve08akKpB78uOpK0Y3DJ7yx/6/X8tkCJHe2Fh7g==
X-Google-Smtp-Source: ABdhPJy/xCtPGt72v4BxPlSqsZw2Unznj/h9degzI97MENYp9mLuIP04LbQCQK7gt/gt9CP99/+ObkVxw5J7N0J0qYU=
X-Received: by 2002:ac2:5325:: with SMTP id f5mr4071169lfh.6.1592641121892;
 Sat, 20 Jun 2020 01:18:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200619141614.001544111@linuxfoundation.org>
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 20 Jun 2020 13:48:30 +0530
Message-ID: <CA+G9fYu2d+j=2UiP-S5Ok0Ot-biux_EmM7_qcsMUaav5wfM3Hw@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/101] 4.4.228-rc1 review
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

On Fri, 19 Jun 2020 at 20:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.228 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.228-rc1.gz
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

kernel: 4.4.228-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 2e99a284d540ce7de8faf22c51ee8a61deb49f40
git describe: v4.4.227-102-g2e99a284d540
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.227-102-g2e99a284d540

No regressions (compared to build v4.4.226-37-g61ef7e7aaf1d)

No fixes (compared to build v4.4.226-37-g61ef7e7aaf1d)

Ran 18074 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kvm-unit-tests

Summary
------------------------------------------------------------------------

kernel: 4.4.228-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.228-rc1-hikey-20200619-751
git commit: fb3ad9b9982b81288e996643bc191ac4684831d2
git describe: 4.4.228-rc1-hikey-20200619-751
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.228-rc1-hikey-20200619-751


No regressions (compared to build 4.4.228-rc1-hikey-20200616-749)


No fixes (compared to build 4.4.228-rc1-hikey-20200616-749)

Ran 1841 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* spectre-meltdown-checker-test
* v4l2-compliance

--=20
Linaro LKFT
https://lkft.linaro.org
