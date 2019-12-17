Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25F3122551
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 08:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfLQHXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 02:23:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33808 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfLQHXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 02:23:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so9737756ljc.1
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 23:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7yp6TAUsIdw8thMlsv0tuyq0zRY28WxHtDGJ74bxq0I=;
        b=QN3qg+f3x5JpQWErRTa862dvXKNu6gxHlZ+FESaGnE6Xb+e8Xb3F1sDZe87OjT50FW
         ZLArPkMwUDLXv7VCB1t8pdH7nJVQul/tuiVOrdYRrXr6tF3BDPCX9wA8cGtV50j+9mWc
         gDzPUdQe/AgNtRcf0uSn+aOB38d3/uk2tP2v6tuQsGmf2eOTkBF1mB4vBauNqo9vwD79
         CWCpm8MY7lun2qW3Q1rmgi3FiPAnE2Z147jwDq9S6ZJ4Ie5D7RxWni5Zrx/ZSeto6esk
         IKI0hk7ZwemuymcgbKD+J8UYgykNZ1tMKLIc6lKmVaoPnqPuEMuSyRLGoceYZ2A7GUmS
         NRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7yp6TAUsIdw8thMlsv0tuyq0zRY28WxHtDGJ74bxq0I=;
        b=CNnCAnnKypBPJfWrc5v9FN0qdS+VB4CKJmA3p1zpSw0LhVrO7lJ6IrXO3bBTe66+k3
         0iBLug4shAXNo6TTwITXS9kEFDfOUHiRN1zf0FnqVVyvliCL2um0bSfm6eDtWhgN9Rcq
         Ixlq7WuD9YEoGilcAbW2svMsQs3hNI1YmYrptwYqiF/ebEQwMhYe3uiYc10robtPz+sR
         dAoOUuvY/wg3T7fWtfDHSMNlj4H5EVPXxtGzdB13N099qsXgl5eXgiOGCrTqpBzEN1S/
         Zp2nDxLtfFe7ra11Mj/yfXbNYw5uKFVveFNtuZmivE6jwbbaLpdfPa7la8G6O2TZz/tc
         O+Gg==
X-Gm-Message-State: APjAAAXp9WQO91Zjnj6VA4vEu8FD9WrxrBNyeEKIfFjvtrofGy4dkEnA
        06XL08yfPr2VyFiX20gPCYh9YkfYCehxZGfoICierQ==
X-Google-Smtp-Source: APXvYqzTDT0UQWOlnr2jnIK0vU9LiTLc5RAuWqmhQ8p/g3C2TSCDZOYT03VvOey6hLsgvq2WYf8OylaCmvLTrz35Kvc=
X-Received: by 2002:a2e:8316:: with SMTP id a22mr611055ljh.141.1576567428790;
 Mon, 16 Dec 2019 23:23:48 -0800 (PST)
MIME-Version: 1.0
References: <20191216174811.158424118@linuxfoundation.org>
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Dec 2019 12:53:37 +0530
Message-ID: <CA+G9fYt-=ZbHLEEn8VisqAN9ry6rj_Vc-7yFr+bVn3uTwhCxqQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/177] 5.4.4-stable review
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

On Mon, 16 Dec 2019 at 23:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.4 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.4-rc1.gz
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

kernel: 5.4.4-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: fffa88522363708152669b9ff7cab0ebaa937d39
git describe: v5.4.3-178-gfffa88522363
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.3-178-gfffa88522363

No regressions (compared to build v5.4.3)

No fixes (compared to build v5.4.3)


Ran 22162 total tests in the following environments and test suites.

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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
