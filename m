Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982722626DE
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 07:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgIIFtN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 01:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgIIFtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 01:49:12 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0FC061755
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 22:49:12 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id j3so687201vsm.0
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 22:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P0ez4cWjUUyq1ZAM7GWoUf4wC5G9nmNzRjitsaqGkY8=;
        b=WdrPPCWW3iGd70z716OSVZVu++nHDQLesP+JY/eZaWupfkuM7bDSvtWA9CGqplnU71
         Cdry+dvU5xwbaDuSMr7znQU3X1BNlLfkaYjfPwcem+EAKCQfr7wMuxcfR50TC3pGsUlU
         LNFPF3CXp9TSUlExDCEA0uBOmBjWq2YXA7kgvGcDoexo8WBeuVyBOeHvCJ/ZTZDPB73w
         y7tbpJ0QZA3AtCDKVTjQlq1oFo84r2GmQxSWt98WFvwCjl4GL5jp6eWqWBeMyjANsUOs
         xhF//sPpqSkkMytTLAZfirUVPdasY1bObPLtNNk80UP6Rass7GzuARnqMTmQqWmh2Jfo
         t2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P0ez4cWjUUyq1ZAM7GWoUf4wC5G9nmNzRjitsaqGkY8=;
        b=PdWRR8+kHdqB1nKs7Kl/yb9HRYShWnC3HICVzeIl6x+3zPKJ0ooMGkyyLBR2SN4q9E
         JRl+Viz515pwrZOK2zXN3bqLI/na+u+qqLfTJAZRXjQoFg8iKUr9fQHsytQ7chDnki3g
         TWSLPBqJVCHqfy1uxbnrnDPrZgUWIxsexM71pBjtHS9GWLn4VFo6eOqhTIYHr7nXkSv2
         dPgxA/b1LR40jGKfxOnAWbyGgaDy4zuR6dQrA4GqBnt5eLGgNVpD81ujgXq7YkJ5Ygjb
         OvRpkSq1ryWJs3Cp5kr/8VkTLznNF9GG4w+p8d4V8SJ30e3tOpZ8h1NCi+w/QAx8YxM3
         84Nw==
X-Gm-Message-State: AOAM5312yhLOv9R7Ax03DR0LXBeO6JEynBJSKAcZIOyFGeTBemveMVi3
        ktJXrihCbDKyE37YRAR2Z2n64wfAOgTkmHH9sls1JOq11Xih+6Pr
X-Google-Smtp-Source: ABdhPJwrULB2Obj/3hy7iZLzOkGI1uuLfdZrHtfOjUdl755KUzQU6wr4NrO+94eOhajtmc7n93vWeoYKd49fFvGXqRs=
X-Received: by 2002:a05:6102:204b:: with SMTP id q11mr1639904vsr.40.1599630548956;
 Tue, 08 Sep 2020 22:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200908152241.646390211@linuxfoundation.org>
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Sep 2020 11:18:57 +0530
Message-ID: <CA+G9fYsUF_7qVThy7Q-HcSs19_VsGnqCJCYTcpJmwdx0oBpO0g@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
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

On Tue, 8 Sep 2020 at 21:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.8 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
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

kernel: 5.8.8-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 456fe9607f8f8a55179d2527598b8e90a2591e4d
git describe: v5.8.7-187-g456fe9607f8f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/bui=
ld/v5.8.7-187-g456fe9607f8f

No regressions (compared to build v5.8.7)


No fixes (compared to build v5.8.7)

Ran 36239 total tests in the following environments and test suites.

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
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-containers-tests
* ltp-ipc-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-dio-tests
* ltp-io-tests
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
