Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89AE1B1545
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 21:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgDTTBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 15:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgDTTBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 15:01:22 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D02AC061A0F
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 12:01:22 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id h6so8967244lfc.0
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 12:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JPDxZ35YhSDtdOqqcuG1GknV0AmkW9OnZBjcUYDVvAQ=;
        b=ltMrqHyqmVeIIcMgrdMkvE80qq8utVkchVTVVpk+WA95Bg/XMC2rzu5o+1ujyrHhNf
         xOkncZckNhi6nDG++D8Zxks+4W80xemqG4JHN3NymWradim6QAgTe+I/WSxs9Y1AULAb
         wHyClVT7y7NXUGwr/pZoQxK3jaN3SKl/tX/I5ZgXCxO5pzAjebkpeOxEQTOToFT2V/kq
         5aFPXnPngpL8bcENGI+UFr8x8c0TAnnLLPb6zbQ7gIeOMt1UJLkhNmfIVknx6+d6KATT
         zPBo7cd0xMtd1Og/EBq3xcv2y6Qo4BjkZpwKUel6aljDisEEh+eV0VyuZfojjqV41dm4
         znTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JPDxZ35YhSDtdOqqcuG1GknV0AmkW9OnZBjcUYDVvAQ=;
        b=do83l4pUr8T6UzhTPNxVO0WejjKsePXlCW09Y+jO5/YXCj0g+f7zCl2vIlbjbTkTKD
         74x34pq8Hxyq8iAqD27Y8LGWWeb/GckwJ2mqzb5FgoijZQkAbE54tMk3jJHbmoFh807x
         Seyx78xb37v3fulGbarRX82UoEEGcSl171gADf+jL/zXEy9Zv86uExX6Ixf+PAslT74u
         Zwuc8K8RqSz0er0g7Qd9u8bCQMTAXFfkOLb2JCbjBWuZgw6W5+V0jZT7XpwvYl6OPVs/
         DpjsjyCWUcsRHyoA5qn7w3eX/v5flQ/BAgbih6WjxCuxXU/0pTJe2rjNqn+tGBIpmgoL
         Q4cw==
X-Gm-Message-State: AGi0PuZLn/NcU3s7rsKafdz1d3RPPXUqwSJi1JSCh9Hv+mE/KfHrr7zb
        USrJKkixdZrEoSVP7y24N9h4UpCZ6KbKYtiYjulwFg==
X-Google-Smtp-Source: APiQypKvZDFeAH88trRY5hbjiEyo/WSoZIDlUIn5nMsjWZ5/SK85m4q4TtX27h9bA4QW43Ip1vxt+Sl3sdaEqj0YFXQ=
X-Received: by 2002:ac2:5559:: with SMTP id l25mr11510674lfk.55.1587409278356;
 Mon, 20 Apr 2020 12:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200420121505.909671922@linuxfoundation.org>
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Apr 2020 00:31:06 +0530
Message-ID: <CA+G9fYtqYxLBsuaMutT_H6-UfY-ozCOt94n1V6BuaPTU6d8ZYQ@mail.gmail.com>
Subject: Re: [PATCH 5.5 00/65] 5.5.19-rc1 review
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

On Mon, 20 Apr 2020 at 18:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> --------------------
> NOTE: this is going to be the LAST 5.5.y release, after this one, it will=
 be
> end-of-life, please move to 5.6.y at this point in time.
> --------------------
>
> This is the start of the stable review cycle for the 5.5.19 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.5.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.5.19-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.5.y
git commit: d1734e95ac8cc324fd5c8950da67a9ff685ec6df
git describe: v5.5.18-66-gd1734e95ac8c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.5-oe/bui=
ld/v5.5.18-66-gd1734e95ac8c


No regressions (compared to build v5.5.18)

No fixes (compared to build v5.5.18)


Ran 29200 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kvm-unit-tests
* libgpiod
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-syscalls-tests
* perf
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* libhugetlbfs
* ltp-ipc-tests
* ltp-open-posix-tests
* network-basic-tests
* v4l2-compliance
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
