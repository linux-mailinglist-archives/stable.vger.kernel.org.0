Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F34BD2F45
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfJJRJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 13:09:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38025 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJJRJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 13:09:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id b20so6996055ljj.5
        for <stable@vger.kernel.org>; Thu, 10 Oct 2019 10:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=07k4TlcKY0H7BLbXRw8BDYAuoLrXRbYHdEv/KYsqSU4=;
        b=vFJLATR5phjST86akF50pwuc+J9KFiVUkfzWYX6w0FfuZwKzxtKafM5wRV3MkXQ2lN
         dg4UQH4RKYQvZV9N/7qlBeAlewyE8XSm5aprbAWf9z6Ea+7ZCjSix3jFa9eaXy6kZ8sf
         cmSRhxZR/pCzv+T/ofyCa/gUVJBV6kx6BPlM195wXCdK3++s+A3UjD5oqjbqTENhFCM4
         Nf2y5HWrU4IGa3RSCXshIADHMup8SfjK+hjIwSr025AtgjMZQCLsJIekVDPMwoKjfa6+
         8DzYnycxGecjC/ui4KRy3JfE01AdRSqjksu0JMm4dnFuEKjeuCDsWm4tBxG8eM9IZjmf
         yFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=07k4TlcKY0H7BLbXRw8BDYAuoLrXRbYHdEv/KYsqSU4=;
        b=jJtL/Q/DOlglj5if0BV4CzGzdhOG910dLP9RGHOxy9EvrZphyhicrQdj94uM94p5ih
         3AFIztZUWOSyHk2dEnU419rWe79DA0913DNMETEtRQWuAZ/XAgAiiXOeB8YJInre5cFJ
         MKep0ZFmNmr88JNgsik3iDgbWo11Pb0RX5fSjkC0MZRT8R6wEuRCbl9EzF6h0l5Zp+Rr
         D5wOP0k8Im2uiYXBfy5cNYfPZUAX4+YGGcN4+7d/yT1IOYDWe01aGN+QxjDxHtT2jmWJ
         8fjP40589IzCifu6h/61g2GCC0Z+heO6CQ6qq/ZGKcGkmu8Hd5mR3E/+SZQxJA7Cwc+i
         FhiQ==
X-Gm-Message-State: APjAAAWJWjLzg2VRvSQdAPJaYLAoqmws7UiRHZAYEbxuKl7jX/zwCzzi
        Nl881L9lYp+GToXGLO8v+9Fg73lBytRTPxJXrQUb9A==
X-Google-Smtp-Source: APXvYqzkiTFz9JxPgxjfcvoaXi9BhxI9lFB1zec6ECI6cqMgVTmmfo4fX6mRQgPvTm7htW1vk/7U5Q7/kFuTjD+RbyQ=
X-Received: by 2002:a2e:8602:: with SMTP id a2mr7211268lji.20.1570727376267;
 Thu, 10 Oct 2019 10:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191010083609.660878383@linuxfoundation.org>
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 10 Oct 2019 22:39:23 +0530
Message-ID: <CA+G9fYsypoQHnYTeZJgeYecwTtbnVyRf=0y3Gm5EuGwLr2PKrg@mail.gmail.com>
Subject: Re: [PATCH 5.3 000/148] 5.3.6-stable review
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

On Thu, 10 Oct 2019 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.3.6 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.3.y
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

kernel: 5.3.6-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.3.y
git commit: e863f125e178f8d2edf7a3a03e7fc144d3af82c2
git describe: v5.3.5-149-ge863f125e178
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/bui=
ld/v5.3.5-149-ge863f125e178

No regressions (compared to build v5.3.5)

No fixes (compared to build v5.3.5)

Ran 23503 total tests in the following environments and test suites.

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
* spectre-meltdown-checker-test
* ltp-syscalls-tests
* ltp-timers-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
