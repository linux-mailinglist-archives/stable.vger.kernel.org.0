Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB491B5727
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 10:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDWIWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 04:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWIWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 04:22:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C07C03C1AB
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 01:22:17 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id h6so4073726lfc.0
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 01:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ub0q5NPbZDsNxSsJk8eq8RrBvXG68eGB0APkodVuvvE=;
        b=DKmzfA7qdqU9K41fVBxyhWU6c/JnawnEVMmRlUZhlG4ikHVdF0BHhbXndHvyAL7zJ4
         SkjqXy8h9zy6yxopOY60xXirrTf4ls71CQoErQ/uh3DTVlO9c7wPMGP7EjARKbtv1Gxf
         dAgesSwWXDKag7B6ZsHCkWlTsl5hDnnPFTJ1zUBEsxF6/vDsZRJDzYIySCOf+HB+2NFb
         ekMlNwAYDa+uqsBWYIYWZf/Q8KwBixb9AkT5+NN5b6eiYGIlmCVy0N3MTzbTKcH8APGX
         K2yPAObhFV6iHNgFp06XcpU4HuOfZfFdXHk4oopKuNJxE1TWkm6xhN28ux2MIntRqw82
         RQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ub0q5NPbZDsNxSsJk8eq8RrBvXG68eGB0APkodVuvvE=;
        b=ay2ShbzufzrHMUwhouhobvvQ562QarOSXVByQxnpMBAUcmPdDkUDHQNeusJMjh4MtQ
         cbfQmgUvqtCmpX/QnYs1Oqv+F4eTdOIMfjrZV7tXdk60iyxkw3YiB3lEgS6KVS6WCCV2
         QAk2IgJ7goM4f0Du+j/W6VPJL3BQi0eUUGyW0Ueqi/XVclZeKovyU1mItZLx9uic+tKm
         MvuT2q52NmOcE8L/g/SKWTb7ulpKCFqYFohAELrXY7dnQuJ1TzpL2IlIikekYRYS+1bv
         87YkOaUMweJ+E/R2ElOtHEF/gMIoU11/oGEk9l5t9RK+PMp+BsAfkAi0V57dESw6wwda
         5q6w==
X-Gm-Message-State: AGi0PuYEjMZQzR0yJpgqdEtCWV9+z7A0gsYxBposKVfRaUvvGbo/F0C7
        Eu8W8OgAEArLVJJbbfUvlnlXt9wlGJb+bcFYyjM3Vg==
X-Google-Smtp-Source: APiQypJChGVvNGQ9siEQewL+Ngm3zRQEKXs3Y+1CmUn+i1Yqc2rYikuFbZxWNRoKm6d0qWUjC4+nqvo1ycGzzXmc5XI=
X-Received: by 2002:a19:c602:: with SMTP id w2mr1577889lff.74.1587630135322;
 Thu, 23 Apr 2020 01:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200422095008.799686511@linuxfoundation.org>
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 13:52:03 +0530
Message-ID: <CA+G9fYspEmKLZJs9ZFhUsGvd1kq2pbk=i_xxnptnvkmDmqN8mA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/64] 4.19.118-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Rob Clark <robdclark@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 22 Apr 2020 at 15:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.118 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.118-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Note:
The platform specific issue on qualcomm dragonboard 410c has been reported.
Which started happening from 4.19.115-rc1.
https://lore.kernel.org/stable/OSAPR01MB36677B25C6FE12897832B3DD92D20@OSAPR=
01MB3667.jpnprd01.prod.outlook.com/T/#u

Summary
------------------------------------------------------------------------

kernel: 4.19.118-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: b5f03cd61ab67da20381e80c220d6727b914c3bb
git describe: v4.19.117-65-gb5f03cd61ab6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.117-65-gb5f03cd61ab6

No regressions (compared to build v4.19.117)

No fixes (compared to build v4.19.117)

Ran 33561 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
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
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* linux-log-parser
* ltp-cap_bounds-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-cve-tests
* ltp-open-posix-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking


--
Linaro LKFT
https://lkft.linaro.org
