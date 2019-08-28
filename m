Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3519F999
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 06:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfH1EyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 00:54:11 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39180 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfH1EyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 00:54:11 -0400
Received: by mail-lf1-f65.google.com with SMTP id l11so936674lfk.6
        for <stable@vger.kernel.org>; Tue, 27 Aug 2019 21:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PQibjh7JdaRE3w2JILWjXEd+ikRK7BFuC5uuZqyvEYQ=;
        b=YtbFmZBj/75nXjibs8/Vf5CJm4WvAniu4rX2rSp1sCOqCr23dg2pZ94V+BosfXaIfV
         SVFiSl0THSwBhtAhlUTtF3yWxffD4oRUztnFIJH3R8ir1Fa+K634jmdIPy44ELy2mOKa
         jp5t6j5SymkX/xaGfWfUpTl+FR3O/uEiqIRb7aTRXJFf4pQWrNjXy8z5QAzBuh/SN3Dt
         cAf17xIp2e0CcTpDt3i3wVd96gNJM55WQYuVTaU+paSlm8QW2byUfz5VV0pootNJhCeW
         peIVUOypZfEkH9pfx48/GZV/bmidtjnukqf119LSLcdTi38A6dnbZ2xtHtfSQx1bJ6bF
         k8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PQibjh7JdaRE3w2JILWjXEd+ikRK7BFuC5uuZqyvEYQ=;
        b=TQEzZeTI6NwHdFLLokla9vCCC0ISfpRVpY+wcCGU4q6DNiKzlSJ/7ynm5TR26NasxG
         olW+CrrtTlCwnFBKY//6pbkRzj7W4ePOaMQahPv8VZv8Tl9/kHbBcnlU5SJBVOq83ymA
         xm8dxKFc5xZ8i/1X4v05BQ7bili/QTcy6txoCDxNo+V1pMyiW5mFRNi5+6CixEbdqnhY
         qeiK807h1hZ60lVYTyIzOUdoSRIlv2KdmuCGeRog6aUYbsOx07g/7WlbCy2DUJNh4gx2
         27IDO+h9g/gweOgoVz+RjDZGLKY4PW5BJM0j1g+eNEKh0KvzpdczrhWbeK7BcX5fobMI
         pSbA==
X-Gm-Message-State: APjAAAUu4ipFkhZiN89nlMfBIeYOr3LohY+G5zLOM+xrcJ46ITyWC8qo
        WyNdUY/eLjZ+QFagkcZBkt/5oL3Tb1hGPePG4zcbiA==
X-Google-Smtp-Source: APXvYqwIWnSqq1yKSSeInH5RAOXeAJWIMgr42JVriha9neQ9DdhsYx3wo/ex86TQNezdSaOEy5ayaBwrxFoDk3enX60=
X-Received: by 2002:a19:5218:: with SMTP id m24mr1275284lfb.164.1566968049088;
 Tue, 27 Aug 2019 21:54:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190827072659.803647352@linuxfoundation.org>
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Aug 2019 10:23:57 +0530
Message-ID: <CA+G9fYs5=xriak4tbbpEWWk_O5QUV=c4_oKEhs4vLu_TNcFAEg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/62] 4.14.141-stable review
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

On Tue, 27 Aug 2019 at 13:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.141 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.141-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.141-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 4e1a19d20000330e767ddc9c64317d7d576a8f31
git describe: v4.14.140-63-g4e1a19d20000
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.140-63-g4e1a19d20000


No regressions (compared to build v4.14.140)


No fixes (compared to build v4.14.140)

Ran 23744 total tests in the following environments and test suites.

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
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
