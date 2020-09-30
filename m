Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEF627EE06
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 17:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgI3P5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 11:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3P5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 11:57:01 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE96C061755
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 08:57:01 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id h8so612365ooc.12
        for <stable@vger.kernel.org>; Wed, 30 Sep 2020 08:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ci9ZCjxVBxd29K7YcHD/doaBSJTqujx95brcxvxl6t8=;
        b=Hj1XSQwQKzS7Hc+toawQfniOOnc6Ogr1LAE/g2szmnNsFmrOdnfgmzpQCrdAezAtTO
         SQ2VAx7+As4+qtuR6gAIiqISJrjVUNycta60eE3BHsj8rpT3StjheGM5sSBD23/QvdOh
         3jPC+h7CaEqvwqxypfurjDoWCehSrD+RGFRufetP0qquBWxdoExadkwrLUiUQ4XFHBpr
         RvIR0/IlNYp28eKrC0U1knfno9nOj40DkfJWu0Zj3jJkeqb4hfE20ejHU3V5mR2FOBHP
         5hi7ZtxL9sHaD6/KOt4IuilQjUkg0A9xTqSm+PKDsjgFBLhhq+JkyQVTpDwAU5RPLTxO
         7DYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ci9ZCjxVBxd29K7YcHD/doaBSJTqujx95brcxvxl6t8=;
        b=tE1G286wChMl4vkkHscugtsslqL/Qoht5og5n3+u15HR8X9bkOpcgX6ip2C5vxVef6
         Ho30ujaX+As2vr1AoSBQLajbH2e/k9hEsTp7v/LhRi6+K8N1F2DstO1mWUHC/BHsMtLJ
         gfTqneY83X4n2LrcyrNqMTr3URb02lfKE3lIm+VNqZEU1XJZcHsKVZvgGxFN7MfwDo0E
         JDXgfPKt7YGM6xTeLOE1dzA/Ec8PGX15wIHjyNd8M4wPpNvEeBqxm29xXzwYWa/USaLf
         jqG5suijd1UjTmayBkPq2udK87PVClATkS7jhZbY1KFGeb5JGdrowqjB7DpVdwVLwhhB
         vpsA==
X-Gm-Message-State: AOAM530fQzvnrXOjSRpX+lojZdrLYztRQ3SMLURastqJ9+8p9NUFy7Uv
        s6jFmuPlaYAa5ENiqRGDy67/jO0Bfntt3GK246xFNQ==
X-Google-Smtp-Source: ABdhPJzp/IB64gFwxF8qSk9RJC7rf4HZmkiChirppE2FNBVA45dgsh8vr+RflAPRdKUNkuWnSpIQtuXb0qU3ChKNaqA=
X-Received: by 2002:a4a:95f1:: with SMTP id p46mr2288291ooi.93.1601481420233;
 Wed, 30 Sep 2020 08:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200929142826.951084251@linuxfoundation.org>
In-Reply-To: <20200929142826.951084251@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 30 Sep 2020 21:26:48 +0530
Message-ID: <CA+G9fYup1i8WnQpcg28hkq9jgQTTkuiiEfOVSnm_3wS-1sijiA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/244] 4.19.149-rc2 review
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

On Tue, 29 Sep 2020 at 19:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.149 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Oct 2020 14:27:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.149-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.149-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 78ef55ba27c378ac3e6106230e18472fc48e6851
git describe: v4.19.148-245-g78ef55ba27c3
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.148-245-g78ef55ba27c3


No regressions (compared to build v4.19.148)

No Fixes (compared to build v4.19.148)


Ran 24678 total tests in the following environments and test suites.

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
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kvm-unit-tests
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-commands-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-containers-tests
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org
