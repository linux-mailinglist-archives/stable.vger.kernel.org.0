Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B442204F1
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 08:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgGOG1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 02:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgGOG1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 02:27:23 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B247C061794
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:27:23 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so1232067ljj.10
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PJzQ6C5etwDQHSi7DhcVYIwc+Qw2lPx1DzppZhJZzF8=;
        b=gFQ0jjKdytUBmHCTdUeIywxJqRPut7uAw/seKwSMTETRW0zuBPA/3c08CXMdM7pVs1
         3P3Yp1z0JBYtOUZy9ks0rASnRoGZNwFZnFKu6U3PikDaGoXlKiCjwxlnX6oviP1HAk/h
         tbA/sQ18KLZWwmcAPOBgXKchC9q6N+8n/bzJTUdiRdazQIL0oOJ4ytfKLm1QScpma+3U
         jomrtZiiZM5aq2ncdgRHnR2p+PXv7fJRAoxaZ3WPJnE4tBAhqx6bsh+aojr8BiJwGLKQ
         XJaB0EkLFY7FaWC4S+xB4hOavceqQIhVfH98Izk2tIIHb9o5XRI9Tre5gVkP9ZSPRHuP
         iCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PJzQ6C5etwDQHSi7DhcVYIwc+Qw2lPx1DzppZhJZzF8=;
        b=DMaCuSB6uI4ajhhtsB5tVfE5XGg10pBku89qwCBABrs7GodsxVvbrfGv1rWkFNBWXB
         i/MF5Q/TbOURRBydmN1QvbWyf45WlMW1BSueoKmjQSqCUcm8HeAPU7ugcT486zfhWmrX
         iQoUUMSTWVej3cRY2stxWO1LtjztP+KfZNRoMPKRRhRqnqsufDO+okGDNWIDzDpcGXnR
         fOQS2REqi3wY1YsDwdelFN07237b6tBDRZF3PKO8/qJAAm+Q6EqhC96ljjLyVB/4qbLJ
         0vunRHHb7is8MB9ynLg3Nrg5g8YkaIWY84N0tgwP1h6F0eSotpp91PBriqz4Kwk3qqmO
         SWjg==
X-Gm-Message-State: AOAM533aXRzrxmFWss1CQkvMooC+EMXRR7cQWcxJG5uKTCPTLv74Rtax
        92MDuL0QQ46xn0esyML5pdDlvNKLqyEMCboJxvewHw==
X-Google-Smtp-Source: ABdhPJxB/h5ZZI6qtvUaf2IQPkAuV1D7Mz80yAR+8Beqkb7bSTeVTs7ktXvRmAhPgHpKS9QvSqW2OFczUFpTTF0rZdw=
X-Received: by 2002:a2e:9857:: with SMTP id e23mr4226879ljj.411.1594794441480;
 Tue, 14 Jul 2020 23:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200714184115.844176932@linuxfoundation.org>
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 15 Jul 2020 11:57:10 +0530
Message-ID: <CA+G9fYs_6hgdEUaM3hJ9QzH0R0_qvXkQ4a0oUVMPGN9qfMdGGQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/166] 5.7.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Jul 2020 at 00:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.9 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.7.9-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.7.y
git commit: c2fb28a4b6e42b090d478b30aab47f3fef177964
git describe: v5.7.8-167-gc2fb28a4b6e4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/bui=
ld/v5.7.8-167-gc2fb28a4b6e4


No regressions (compared to build v5.7.8)


No fixes (compared to build v5.7.8)

Ran 33472 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-math-tests
* network-basic-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
