Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9A6241728
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgHKH3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 03:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgHKH3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 03:29:35 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFDCC06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 00:29:35 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z6so11638078iow.6
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 00:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oALjbI7kgdJmP1tsUZKu05JrosdPfu9riFAgnpfU9SI=;
        b=daRqA1yFCjZvypVGeTcvXZoJspABhtS+zLB+o6WIf3uSiZhT+lWtdsNYRDd+I+gRvD
         6LL5mJ2EijIHHiPkJYllNejiz1qpyNs4hqbNblX8gQVYsxuki98mna5Yk6QciksR+MGc
         dKOz9E9a8SpWWj1H3a3PWXuyN2i8Fz4XHf430tYyH/tXdTSWic91KL2jW4mu6D+sGY/S
         oPvYK6jXRpNSZtPaNICBZopQAT0QopyfKElT8wXXEpWDbv2tToUaGvI2dQMiNzy5itJd
         fY5qkqzCM3a6oE0y/XmtCTsxup21MRRkn1C7L5EwObsuZyBiiUpq0A6yRb/eKUIPOSV5
         Vtlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oALjbI7kgdJmP1tsUZKu05JrosdPfu9riFAgnpfU9SI=;
        b=TDiytbuLKQf+lQOXMYDg4E2q8mwNa6m9dwS/iRHZ0tslgMVpMMGN8p4Z60FoodOJ4P
         GBIY+ZDopwaeo4q02Tw/XPGCUaNjcsYtWiCb/yUfTuvkic/mEs/lY2RanGP2nn9clfba
         Zzz8LhwVhx2XU8pO1V1JdCE8L1aHFlf/6tOfJxutD6HVrFlxZq65QdNDXm0yN7+W+G+0
         SLkiGSNThPFm5zBXIU9VbI/O8ZoJZpPKTrqsSS2EjOH0Q2U72ksurCCVGUTeeBGVSAnv
         xX+CFlWw6V/+6DgCrhnWbwToMQ7WhWeowVsv1jdA3sQGvJJcX90BTXMoDjIz8PgNpk8u
         fcVA==
X-Gm-Message-State: AOAM532Lk8TiiaHLZ2uKxQ9dxfjMxXmKww5dIOS5calysxUfqBoQZpNB
        UA2F/xHtss8tonMgmt5SY5rY9aqCZ39c0SLsBgTd8A==
X-Google-Smtp-Source: ABdhPJzGSaif8uqnWB55Xj9CII0UqImGQLs9ZIXfBVW/tdMefBcrAkSz8PhNrNu3D8ZWTv1p/je3VrIN2oDNeanQjyk=
X-Received: by 2002:a05:6638:1129:: with SMTP id f9mr23792695jar.35.1597130974214;
 Tue, 11 Aug 2020 00:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200810151809.438685785@linuxfoundation.org>
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 11 Aug 2020 12:59:22 +0530
Message-ID: <CA+G9fYtXpq2rtpLVg8WH-GsBUdkg6n8rqsP-fM0WMTZZAMFL4A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/67] 5.4.58-rc1 review
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

On Mon, 10 Aug 2020 at 20:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.58 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.58-rc1.gz
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

kernel: 5.4.58-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 133d9613b2c88c60658eda244e2658dd07294b5e
git describe: v5.4.57-68-g133d9613b2c8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.57-68-g133d9613b2c8

No regressions (compared to build v5.4.57)

No fixes (compared to build v5.4.57)

Ran 33402 total tests in the following environments and test suites.

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
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* v4l2-compliance
* ltp-controllers-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ltp-sched-tests
* network-basic-tests
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
