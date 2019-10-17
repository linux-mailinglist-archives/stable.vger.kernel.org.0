Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81691DA567
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 08:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404736AbfJQGVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 02:21:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33631 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731726AbfJQGVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 02:21:22 -0400
Received: by mail-lj1-f193.google.com with SMTP id a22so1247944ljd.0
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 23:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vJwljksPMBM6dZICB00B0fndAGErly1ln+LuF+3T1Rg=;
        b=zjE7WN8Zy0vPZUWHzZrqOD97ssZvZUOaL9dpeEI7xBaaBeXQE1LJKoBDcG+3XDkUhB
         DIyU5B/rVpwBFbyeDFMMYA9A245D7hrI30lt2yrK992oRHIJKoSuA/rzidJ/VLg+ptit
         SZYkPIJ09G8CKS/J9IPSZrAaQyokbacW3FpTnYSzMYyjFroLtsd7zVzVM3LHjJsyKxCb
         TVu5nTiE916jxYnqkGbsOoK+OUo/muc+Pfr9kwd0ImvQVO6T8OIQBN9ViPn7evumH02I
         Oh7HN9bQnu87n+Y+JIpxuAW3QVdCu1Gu+YA+7FKjkknUoSjqY3DZ2PwfwOgLL43QKeFk
         7BFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vJwljksPMBM6dZICB00B0fndAGErly1ln+LuF+3T1Rg=;
        b=gfKdQuO9WnWmETGcMmPc8KP+BsP5V2lwOZ01H/gB+uV1xktNKUd6XXFtkbCHd/Mfk+
         YML7cCQnoE1Q2aSTxuazULCMwHNiwGJJKFPDnGxCYe2N3M8Obr3WBuMJ+yEyNTmUNHOT
         BCL4lhGNX05Dc2BBGkBpcPCwei8MmXW61tQYT0iGxi+nIgF5tlAu3zK9Fk1GxZNfiPpe
         6hT0teDoMvwmwb/afUX8NaYJ536atDidQkVU0KFWxGyj0UmlVbqozmxuci9dN87ADEH8
         sKf783qDb+jxHYMNiwViuJ1LWS8dDUJBqpNOfj1geHUAq5HxbMrSKuYauRYZpXqjJnQC
         94vA==
X-Gm-Message-State: APjAAAVX2HvLlSWooOP6qVr1cR4M7zWuwDhr56VEZfz0tkQ1nHWaT/Ll
        g4xZVurUs4oDN6+EMWzJcuGA1lQCwyB9mJJeR5Rg6w==
X-Google-Smtp-Source: APXvYqxmmTxaeIoGxwbq8L1+RJyEQesoPePa6UviAVrooX49W5WsmJeeGXHxaWGK4+b7b5GbWQsKJ7zgLPRb3H0J8Fw=
X-Received: by 2002:a2e:9702:: with SMTP id r2mr1116080lji.194.1571293280339;
 Wed, 16 Oct 2019 23:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191016214759.600329427@linuxfoundation.org>
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 17 Oct 2019 11:51:08 +0530
Message-ID: <CA+G9fYtYEcvwRGpXFf+JnqZz+P=pgHZ4R9NAVezpSpq0BmEZvA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/92] 4.9.197-stable review
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

On Thu, 17 Oct 2019 at 03:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.197 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.197-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.197-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 5749cdc967d4817de5000f6054619fb41b4f4333
git describe: v4.9.196-93-g5749cdc967d4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.196-93-g5749cdc967d4


No regressions (compared to build v4.9.196)


No fixes (compared to build v4.9.196)

Ran 23358 total tests in the following environments and test suites.

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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* prep-tmp-disk
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
