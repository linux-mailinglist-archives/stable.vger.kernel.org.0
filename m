Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4F11C56F
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfLLF3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:29:10 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43783 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfLLF3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 00:29:10 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so770141ljm.10
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 21:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0onU7gVBFHeq7m2PLrQb4rE7g9Cdls/YcARoJxqQZoI=;
        b=ga4yxtjFyobGLmpt6nUXe+vKPDmcBpo+Oa+ePkkrrwEtHlYCij1VYeYIoKPzPS5LB9
         rjUeSbNzN/qEuRfieM6EPYqQLixxBM30sgiwtwIXFdtur06H673NQNtY1Uw6Gk6EQpH1
         y/s5ddTuejuECIutiOgC7akr5NCzsBKYm7IeesuHCAO2xbF2m1cUU2rJ4G95J2+7Ji5e
         R68lsP4qTBUKakHfXlXZSmscQxnpc9qXue5TCxVv8E6xPKke19OYMeefcqpyAcmx/FRJ
         IDhElqNUFmwyM+DPjHqKu0LJU6F/OYpmRMt0taNNj5j5dhUBipkdODapRENIPmSEgpqP
         s2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0onU7gVBFHeq7m2PLrQb4rE7g9Cdls/YcARoJxqQZoI=;
        b=X9HhqqQ47Nx541n/LuYZng5CceEV7Bqhnv0yR32+/yCbPHToF4gjv7AE9Q6K3r6Uja
         b+e2DwayyDG6+7XbyRgPdTL3h/W6Kbs0SV7acCIZ0DRZoC/unR1YcN2k3kXevIy2zV5x
         zr4h9ON+b9JtrrR3dJs0yqux/kZrniIkISBJqiJVw9TK3T3E7cuQSynNt0KMYHlvuydu
         aRFD+gEqR7evZFeGNOChPORQlLJdCjeg2zBtttDGDxYNe/qBhjSFWVlsC3WiRl37K1YL
         w7gzgvckt+CD5XAzSeYjorpkcRp9EVEqX8b4dhGjuVbv/bIs2beuFicK+3FyJIEgNAU6
         umBQ==
X-Gm-Message-State: APjAAAVAH7trjOAgDFFHFyma+mja4iJXczEcm1fa7wwMnEPVID65ZCdh
        boLXck6zWz0nyQ7j0MpoZ/9S5qR1OfIx4kMw96YWyg==
X-Google-Smtp-Source: APXvYqyAi8Y/18qIYbhHxpG5xltgaOPyxUWdx8tLUS0muB40MfO/04uqosm6BUTKxuHVGg7aeT9jHuEH7RoEta9akvM=
X-Received: by 2002:a2e:a0c6:: with SMTP id f6mr4526081ljm.46.1576128547783;
 Wed, 11 Dec 2019 21:29:07 -0800 (PST)
MIME-Version: 1.0
References: <20191211150221.977775294@linuxfoundation.org>
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 12 Dec 2019 10:58:56 +0530
Message-ID: <CA+G9fYsnFnAimAAusrOYtOphC9fnXbwjvi1St0hQFdHKbVZdgg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.3-stable review
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

On Wed, 11 Dec 2019 at 20:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.3 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.3-rc1.gz
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

kernel: 5.4.3-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 6b42537b2c8927366737f1d297ae4e91fdeba6ea
git describe: v5.4.2-93-g6b42537b2c89
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.2-93-g6b42537b2c89


No regressions (compared to build v5.4.2)

No fixes (compared to build v5.4.2)

Ran 23952 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* linux-log-parser
* ltp-containers-tests
* ltp-cve-tests
* ltp-fs-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kvm-unit-tests
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests

--=20
Linaro LKFT
https://lkft.linaro.org
