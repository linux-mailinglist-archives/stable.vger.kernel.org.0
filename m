Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97898B66E2
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 17:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfIRPRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 11:17:19 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44197 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfIRPRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 11:17:19 -0400
Received: by mail-ot1-f67.google.com with SMTP id 21so136641otj.11
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 08:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6lq0lYurINATpp8xIQUOgVFbmqCucWqO81bf2yKMZzk=;
        b=zmWiySxu38lvbpVzLq/iiAlKXEyAd0um6EsiP6V+5xxldbnHiYcw8Jn8a+1EipvJVL
         xZw6hcZWETvwpakGwb6LCIG4RkldEEWv0n+ArETs0WIuWcDDIOKynuXk8bHMmD+v5FKc
         Z62iCUiZhnTMXsMFxMTar1NNaEbCCoj3+RDogMDt4P7sbYNUqMrmCzN1cMWujpOZUHTY
         IQyWg5SUIpn2ZOqchcuqZ+GaaMAN3neDxE7pbN1MrZddrQp/P1yKF5+I7f25EzsQQ4Kb
         T5DHiExKpIGrgmj16CuGdAbi2bmmO5jssJydd69aK7Wr6eT7mZF9S7avLTO1ZxkgQO+r
         xu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6lq0lYurINATpp8xIQUOgVFbmqCucWqO81bf2yKMZzk=;
        b=htb5n77nqbwMW8QxtPzMrMKaRXKOLTZxfVaDPaxqF05PNeJDmaR6zLtL9ryYl+9uFW
         NI5FdO/NBB4ceCM7HhuPV0TDaEIYqgHU4US7q2LW1lZ27ck5zJT0fPRtj4hOBX6/RfNZ
         QGuUm2HIz46TKnsyEyc+1WlGE3wH62HMoNVHTYZh67rUjmq/cCeLA0HDKlAY4QAK0Ihh
         /AFx3yj44wZWVPG6Skl9HvHcVJbXIGRAEaa7wTo+wMX49G4Et8MXPtoiwZwtbKnLnUjr
         Kcvp6v/+f59beSBLvsMSGYEyyDlWRdFBwHsqOrzOB0+kyuHiTH0uxGbX50z/TSUcJS4U
         cDxQ==
X-Gm-Message-State: APjAAAX3XIecPnBikRulO+w8+SNIxiejPDhlTGXrDIbfriS7HExHdexo
        +v9SzJfJeH0Xix1cm5//n+GB9vo3k8mOn5HOi+orVQ==
X-Google-Smtp-Source: APXvYqz0QR6SJaNIhvSu/VkzRkNHOh8txTxt3D52o6x/Me+sYvw58nmTfgeRetj55l/Q48sryWr2/RjZyZxOOp9XaS8=
X-Received: by 2002:a9d:7b4d:: with SMTP id f13mr3053903oto.365.1568819838147;
 Wed, 18 Sep 2019 08:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190918061234.107708857@linuxfoundation.org>
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Sep 2019 20:47:06 +0530
Message-ID: <CA+G9fYtke31TKiWz3UBmUT5EgUYcB4g47VURxvrWSz-jtF+=Gg@mail.gmail.com>
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
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

On Wed, 18 Sep 2019 at 11:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.2.16 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.2.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.2.y
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

kernel: 5.2.16-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.2.y
git commit: 2f63f02ef5061324ba168b1cb01c89fd89a0c593
git describe: v5.2.15-86-g2f63f02ef506
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.2-oe/bui=
ld/v5.2.15-86-g2f63f02ef506


No regressions (compared to build v5.2.15)


No fixes (compared to build v5.2.15)

Ran 22511 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
