Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A519D2798E3
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 14:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgIZMj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 08:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgIZMjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Sep 2020 08:39:55 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE4EC0613D3
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 05:39:55 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y194so3040831vsc.4
        for <stable@vger.kernel.org>; Sat, 26 Sep 2020 05:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1EOa5aX4i5mBZjpQ6HlNrXTDh073W0DGOBF91sDN4zk=;
        b=fbNEH7HqCVNipoH/d+9WzfRO+xTYejLdVmTXlJ9ubG7uZRsyuTTHW0/S4QGvrywy52
         Z74BLvPk/SasJjIfSGyscWa2HEXO24pJHnJjrCNpFalLv6NxIZ/140TRURCruikiXGOk
         bJ/Cp6JLIPV81O7D7D68ytBO0+qHNZPJG+7B3lnL8h7nKi+eeQ+KYeLzuY8DjgHbviJc
         6Rgzsl6eAwH9OkvQjIXD+AU+X949Gn9Ntchae2+RYgDU7RgZ3SLsKSOi2bf7BT9Wlh2l
         Q7Wr+ioY018GXGLWje6NMa/sUDIJe05oupGi4NNhNkUiRBnT9HPKNQQuoj9gMNqc9EvB
         sJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1EOa5aX4i5mBZjpQ6HlNrXTDh073W0DGOBF91sDN4zk=;
        b=niM3DHVfn4tln+y4HPcGdnGs51RHq32iITbJAk65qWfNxNQYR86r3s2E8YBfYbiUBw
         eXu8ULvYJ5euoMsvUplnvZSayvyDYY/fdAgky5WgJh7srZX3Z9FLOAyym/WLpohlCcMn
         ulYK0K8NGI7YfLaDqkNd0uhWLMn89AZetKtmMqWB3fvXksA4EdYZWEqEXI5ot2Lta4Hu
         u9Y/EcBpyhawaYv6yhocMiwu+ah0tcjwRCvAThYYO01o9yf/3jy/rH3/lPEDS+VzBTe9
         WgHyhzVYOHr+Fowe5I0AEdzMTThXGdVGKGjF7FRSAVyGnChDBim7TF8Q7rJjNihg08Yj
         2+8w==
X-Gm-Message-State: AOAM532wSQLZK8PIZkMwDNsUvmkNsiRWjJEHYYJb/NF4PoaoAvUEEF3H
        OYWY6X93uvWXhH88eE9CjKfhpA/AKAH9t0QpRefzXQ==
X-Google-Smtp-Source: ABdhPJx3X12OKLYMDP9UWFGIvTLFZvharyRAXi+kCL9U9xMPcbc4pqc8DpFjBGMDZMn349fhD5qbUkJgV8lfHdG0oVg=
X-Received: by 2002:a05:6102:2085:: with SMTP id h5mr1512316vsr.26.1601123994866;
 Sat, 26 Sep 2020 05:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200925124723.575329814@linuxfoundation.org>
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Sep 2020 18:09:43 +0530
Message-ID: <CA+G9fYtSmh5sNHZ77pE9FR0BHFi3kgKi1-hDHqNtk2v=XuaKvA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/43] 5.4.68-rc1 review
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

On Fri, 25 Sep 2020 at 18:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.68 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.68-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.68-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-5.4.y
git commit: a6d2801f4120fe0719556290e85ca7402b7c1fe2
git describe: v5.4.67-44-ga6d2801f4120
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y-sanity/build/v5.4.67-44-ga6d2801f4120


No regressions (compared to build v5.4.67)


No fixes (compared to build v5.4.67)

Ran 33349 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-syscalls-tests
* libhugetlbfs
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* ltp-open-posix-tests
* ltp-sched-tests
* network-basic-tests

--=20
Linaro LKFT
https://lkft.linaro.org
