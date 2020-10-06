Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E6C284548
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 07:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgJFF1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 01:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFF1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 01:27:34 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D62C0613A7
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 22:27:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v8so11715702iom.6
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 22:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tOPnUBSHpiimDo21hqwEcbS1XVLcCOXvPAFDyfbXLuM=;
        b=eCXcq+ZtB79udbCN6OWJ0Dq7d+KSJkTwg8z0rO7cBcuTUGR++tM/IGobgrv4OVYZ1c
         PinzDfuVcYMmItmpo5sWGTNVcmMruzwSpBcgT05EP1BgbsP1mTMPrk7eM1qnoQK7f9qb
         ZUJHxEMacY3OKma49Lp9D7jJMWK5r8aGauiXrABfNYAHSKr8+pK3kWR/vota21YgIur6
         qLUOhvHviWDPEgSIA/g32VeCmwcfwNGf9ylhVKTwql96TtDNnewkQtvuHbMNa28qOJnW
         z+BiNUvQXXrXoKdj+3V+LeiDO4gCJoSBTmaGAq2+KhggZoO7RDXIGDH0ApfBbpclTMi6
         XcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tOPnUBSHpiimDo21hqwEcbS1XVLcCOXvPAFDyfbXLuM=;
        b=W/MA53XtT2o3bid31MOuJsUA2UJD14SQjHVop3ieN8VhmwgF15oZ9yXqrJD5FALYmj
         VoexMIieO0a7xlUoWGJ7jsMCCloChvp5Hjvo4B87SljAL7eM1fVtrt8JLSoaLm41F5+i
         5xQZBRkcREXzZkduixQI9Btpm+SL8ptVAygk7TicUbSDqjgblmnlUIqhp5LVDWAVlPOB
         XJsIYrOaXMfE9ya1jaloxILcmylwCrYwz0MvCOXlxTFzpGCgmqGcX36ZjyF0855FbYWt
         ovS0rHgUhr4v97hBFQT3QqJwE2k2TmL4X++zho+dzwwQyvuhGTOh7DknZTot9/87GOql
         pfQg==
X-Gm-Message-State: AOAM531rZGFwvcjglty0v9WAJveBQ4bUNLj2/ZlMIEnPp4zLAJx9Pnu3
        gUolwhuUZCWR5og8hsopngaRCocgzY/9OafzUPlSqA==
X-Google-Smtp-Source: ABdhPJxWglIG9defFCTau5PjuBV03PRm25XZZi3GD6+RLpcCcXWykKBbbjk0zGaElLkY/ie//IsEoesfGi0JpjpnBxQ=
X-Received: by 2002:a02:7817:: with SMTP id p23mr3030159jac.57.1601962052170;
 Mon, 05 Oct 2020 22:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201005142114.732094228@linuxfoundation.org>
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Oct 2020 10:57:21 +0530
Message-ID: <CA+G9fYuma1oe3GuAjQUtWwqHwshpzZsS-2h0u2R450X-m=mSzg@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Oct 2020 at 21:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.14 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
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

kernel: 5.8.14-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 8bb413de12d0ad809391ab5a965b0fcf1b9bb3fb
git describe: v5.8.13-86-g8bb413de12d0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.13-86-g8bb413de12d0

No regressions (compared to build v5.8.13)

No fixes (compared to build v5.8.13)

Ran 39163 total tests in the following environments and test suites.

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
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* network-basic-tests
* v4l2-compliance
* ltp-containers-tests
* ltp-open-posix-tests
* ltp-sched-tests
* ltp-tracing-tests
* timesync-off
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
