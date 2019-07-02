Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4335D561
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfGBRkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 13:40:01 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39859 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBRkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 13:40:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id v18so17769233ljh.6
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 10:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WgB+9uuiwuE9iCPhDcp1r+yxpmY9+6ZZHpbOM7YQ+TA=;
        b=T37MiJh8nO+YDgjXezLnaciz5dqZad77dEPrp9dUeBYTRXYgKSmhw8zElp8hYaWsCp
         /KdJvPoLny0Dg2Penje3iLPexUQZo/Ph09iKzr/0Vb5Ik6k34GvrOyxLokJoSN5KdPrB
         znI7l1+1y9YLTXhpzqpl1qAULYPP8G0ajTlGNzhu/DYfAjmY5TU3YhgqsR4ma5lVYuz0
         VjAs/aIKd//X/r5mJPHr1/p9Un58OzK0wGwUVYI8DvH1NoXRnmLpeCmOtOutGqzs0YYl
         40oSh19/LccsP6+XpQWs2kiPQABUCJOEcazrIbBbFMGvpnD4jmT98bgQvzCNMZdqh67X
         BC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WgB+9uuiwuE9iCPhDcp1r+yxpmY9+6ZZHpbOM7YQ+TA=;
        b=X6c/XhqlUH0hnPg4437lwdtC7dOprbvAb0OFdtFLDwbdDb9UEw0VzI7p44SPmJHfPF
         baP0PqnXlnhu7wABDQhVWYJOfOhDWsJdpijGV7YtBBj27LeV3TIlzW/r11fU7SwZDf3m
         ZNISsdLgmD02693brpoR+sLSWOKobYJlx7VwzU5sIjNf2GkKbioCyV3la8fhT0fZQcTQ
         e3WsH3WLf+DRhZ+dTZ8GVnLveR69GOq6FNteDIyuMtQ+ddxgAGQiD7N+NnXOgrtAH8wI
         Vojh3kRGY5vzb9k5CcuBY39BmYrBmHe1ZFw7B0PPZ7NuSOA9r+KM+Mm5gKjh31c+7sid
         ei/Q==
X-Gm-Message-State: APjAAAX0qQdg96lSC80ycx8ANcGv5bEY7UuRt/qSN/tXhntEOV32NxdQ
        tudMPn7LOUADHV3/tbcpK7dkjwf2NmjKzYlvWStPxg==
X-Google-Smtp-Source: APXvYqx5fya33C0VkYYC8y7sQrZrJFa/B4MLV/ngGgJ/0WV4+e8DE5U3frO6+aYycclUGEd2lfUQO7TZPOu6kzX0J+M=
X-Received: by 2002:a2e:85d7:: with SMTP id h23mr18348940ljj.53.1562089198721;
 Tue, 02 Jul 2019 10:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190702080124.103022729@linuxfoundation.org>
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jul 2019 23:09:47 +0530
Message-ID: <CA+G9fYsJjfb2HakVDzUyuf9G9cQeO2DD0ErPQNHfVmKCv47BTA@mail.gmail.com>
Subject: Re: [PATCH 5.1 00/55] 5.1.16-stable review
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

On Tue, 2 Jul 2019 at 13:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.16 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
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

kernel: 5.1.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: be6a5acaf4fb84829cc456c77af78ef981fb6db2
git describe: v5.1.15-56-gbe6a5acaf4fb
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.15-56-gbe6a5acaf4fb


No regressions (compared to build v5.1.15)


No fixes (compared to build v5.1.15)

Ran 22032 total tests in the following environments and test suites.

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
* ltp-containers-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-timers-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
