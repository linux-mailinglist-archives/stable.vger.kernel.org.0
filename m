Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753AC14C565
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 05:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgA2Exa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 23:53:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35828 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgA2Exa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 23:53:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id q8so12897569ljb.2
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 20:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1lFwndVHov/RzOPqSUZJ9434t/t6x+foxuiqxo1V074=;
        b=rhBjnpU8ZwkReW/Curtm6+L+FYqh24nsm55yJeCFqog437bJfv0rtrR0yoLLUCQEQ1
         5348icdydLu2aFLvVgVUJ9Wz6d2v55RN6II3u/hUU1yNUm2clBgPBhM75pyz5/ds4r5A
         u/wCovtZ+wOKSzKAuQY1Zy79amQMtjCY0N1eC2LM4YTciidqP9gSiNTlO6W8vaEcjF76
         +32fdFkFGJ0T7Uk96oqVBpWN+kZBICIl03VPTs8tOLyzg0CD99/SUXMAZoO2V6X8MFoY
         0aURTQ2tlzc4gzqPx42JbXXjiuJNl72prAdSts+wrVL2udRt9LIPNR966K5Jaxr0crxa
         1AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1lFwndVHov/RzOPqSUZJ9434t/t6x+foxuiqxo1V074=;
        b=jS1shLJ79T5t+Jyjc/d2zsYEErQgORgDwO0+jefPU34BSF4GRnI1p79x6gcDR9b+0u
         bIcRNc/F4yjUBZP/ATEJ1ISdb7Z//2+xRacmbrlTuTui5VaNGcOnfU90a5R4eesuBCyB
         lQaKPU8NdlOQnWyA7A+BRaHCXJAP9fQh+R4j8MksrV4egaGHz/gdsaAWRbHW8FyAHou2
         JPBs/qjiI+VJ/Wt0HXTLb+T61FBy+K5rhRw4995Izkr+SlJC0YC9F8u1CsRIHTcvpPbN
         TG9Eov+qijclm5P9pkB+z1L/+YFSejeqO1beXtAmctblaOEmZ1stcm2iPyVyCIIpMSmN
         IlBw==
X-Gm-Message-State: APjAAAVJqsrYi1hq8liy30GL1d9m1J5DpCvGG5ZVlfSCQPaOATcPoaZN
        PqhGxf7fttLKHQg//d3se4uVGDLnZmRcG+YLUX/aPQ==
X-Google-Smtp-Source: APXvYqx6hyZDnWHUWsmUyXDTjzJUvLvBG7avnM2nt2EqMTfGe7bn+nDEXOwN/BdWmS0lmPoXm/5L4iPkzqLb3gXpMpM=
X-Received: by 2002:a2e:8e70:: with SMTP id t16mr11200922ljk.73.1580273608316;
 Tue, 28 Jan 2020 20:53:28 -0800 (PST)
MIME-Version: 1.0
References: <20200128135749.822297911@linuxfoundation.org>
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Jan 2020 10:23:17 +0530
Message-ID: <CA+G9fYsnSGw0NmV5hWwZSs5OYu18YRam3jYCsg4Sn+KUQJSMWw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/46] 4.14.169-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>, rpalethorpe@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Jan 2020 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.169 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.169-rc1.gz
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

NOTE:
LTP fs test read_all_proc fails intermittently on 4.9 and 4.14 branches.

Summary
------------------------------------------------------------------------

kernel: 4.14.169-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 5986a79ae28421d7027cb4ab78fba7d787a9f06e
git describe: v4.14.168-47-g5986a79ae284
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.168-47-g5986a79ae284

No regressions (compared to build v4.14.168)

No fixes (compared to build v4.14.168)

Ran 24221 total tests in the following environments and test suites.

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

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
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
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
