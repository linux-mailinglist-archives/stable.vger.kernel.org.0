Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED38273A78
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 08:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgIVGBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 02:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgIVGBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 02:01:11 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B835AC061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 23:01:11 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y190so9602596vsy.1
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 23:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kzL3CzOff8MBz26GeJxOAyRJCscD/qLXrOQlK2Qv4e0=;
        b=XAa2VtjVIYUMA011qFDg7izJJAOGiUI23XCEw7lcA1xvsTiLvAB7WtLBy/Agk36Abw
         cO7fG7bYUlh+/i6GOG9+ae73tpvP/SsfduPbibd8Cm3nJpAnnmeKHQravWg78/VApR68
         /dEcB3sFgTs8lwksrQTIytFIyjKzikyJePFNEsF8pt3uTJYO+GQ3JXG0KwkLND+5Qnek
         ZvuGo97nIy8QFA/5LzNUnl+1HWdtaBhk7gOV4VQf3ZIPokUFHoT9dh9+3GeC2bY2Fh9G
         VTZ7FzbsWyP1qDmY/nncE3c3yaNCHjNBjuRkG6jfKL0U6GvuaZgAp7x4R0eRJhdCq8dj
         1jNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kzL3CzOff8MBz26GeJxOAyRJCscD/qLXrOQlK2Qv4e0=;
        b=BeK+d1I5BmT6vdQxEUPw9+RW23X2dWdtZVSbBB54e4RHGEjb6MIj0YlwBZFk4QRu6e
         NDu/o/0NqlIkZ9fTMQQGmAKclUBTtDnguMAayDQnx8Eu0gQwtmsKFL1P4plT+cFtuBEp
         D1cR3Bic/wxCEhjOhvlouu7tlmk7esqfpvdJU28cypUUMxxuAaJ6/o1poTt/hoG655Gt
         BNVZOyTQ00XbjjcsFIeW4OdmFSiqdwgzvosDCh0SE/z6sGWtf9aBacwlyBKIDEJrYSKH
         c4jzpM1kgRRjZmGVsh4byTxyKiCDF9odVsbQa2SK7F7LascdreTpGgu2myBGctx3mCTE
         nQkA==
X-Gm-Message-State: AOAM531QgF4unZ2tIAwaSnGsL4ZaiT6YvIT6p9IOfGHe5WoaC73y5wwg
        KBW5Z8qvk97S3XNV4oQqLSRKSCOX0V9XohEvhXRbQg==
X-Google-Smtp-Source: ABdhPJwdA4nT67j7NbswkNejEayNrm96szzUu9HEkAiJKlKbPDvihRq/KV0Fli2m0puXecNShUJnTxnai9F7y4o5pWE=
X-Received: by 2002:a67:3284:: with SMTP id y126mr2318007vsy.24.1600754470723;
 Mon, 21 Sep 2020 23:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200921163121.870386357@linuxfoundation.org>
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Sep 2020 11:30:59 +0530
Message-ID: <CA+G9fYsnZ3S3XLXJsPa=89yiUPGkgFDCXpEV4nV9+Hy3pybzUw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/72] 5.4.67-rc1 review
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

On Mon, 21 Sep 2020 at 22:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.67 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Sep 2020 16:31:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.67-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.67-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-5.4.y
git commit: be4995216657106594a642263c66b9f043323177
git describe: v5.4.65-203-gbe4995216657
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.65-203-gbe4995216657

No regressions (compared to build v5.4.65-131-g0d8c7a7aec77)

No fixes (compared to build v5.4.65-131-g0d8c7a7aec77)

Ran 37283 total tests in the following environments and test suites.

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
* ltp-tracing-tests
* v4l2-compliance
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-open-posix-tests
* network-basic-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net


--=20
Linaro LKFT
https://lkft.linaro.org
