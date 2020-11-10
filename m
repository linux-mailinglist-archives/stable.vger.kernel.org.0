Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394C62AD31E
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 11:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgKJKEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 05:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbgKJKEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 05:04:51 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C48C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 02:04:50 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id za3so16674573ejb.5
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 02:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zJ2p+bzibDOpbdVH1n11eTi5E30Y4plUc85rtPd49kE=;
        b=IGoPXQ4WJnOOdmq/1uW4fwMfU8+dWXMomqqukWkATTVyf6lLUXlKrS+zJa8tNuzNVj
         2eqjpVDhU0bQdnAYOsahp98SloTQiQLrw3rhux12+vICQBn9ARCXTmqp9JjvyA9rKkD7
         coRp+f6/JMHkLv5f+IzEgGCpSbNA+2Gqq6Y8kjVkBwgOpgkbcI90vJLzwD0fCf3pS47e
         L2yfWu8ZEnPBs3BTb0XegSU/c79K3UZZWcUwvPg3q9DguNJAO8S2gichLuculw3gl0NC
         x6cn/XUjHvTgS/N8fIWs4qg04RCvH3c68AvhD469ZrxjR/rqo31evGakxTD6XOzV2hdB
         YReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zJ2p+bzibDOpbdVH1n11eTi5E30Y4plUc85rtPd49kE=;
        b=tD0M79lynAuhhOCqx288AoPQNoxUD5dj4ARYVEbHE8b7M9nxBvp8zQWb+2r/T2SuMm
         S557c4TVBYurBAwSoHWm6pNBLU5yv1OuTxsMv74IiN7XMeK7CRz71wvBqOIjlgCuDpuq
         e03y/gcZdQq9LrRNX8TUXeA3jjqcjz/on6lZsHukVFIjl0zqn4cOrrggYw3SDmCeXSmj
         bvhIzzOXk55xAbKKFFcXbwch6xWIuCWhSDsxW0gtZE47ik1VgHzJPQ4lVudiNnM1V4nf
         m3m7UrPu3s0bbR52hOZTrnr8X84etL3AvLTMy6t0FaI91JVSB/T3zXDa7lYOlEUQNLoQ
         L+Hw==
X-Gm-Message-State: AOAM5315FQJ6RwthfZGVnL54g9pGUF/OnL2xPLQIcZNwNlppjqxuwlR9
        ggriyw4mfBBNI79+vRx3D3GRkghF97PGeVPV03AUKQ==
X-Google-Smtp-Source: ABdhPJxxfRUZBDDJ5o6WfYg+WNz+92APZKwQUSsqd35YQB6uR/7ikrLQVZdEw5v3H++8Zi8DsLIUx4HavKh4NUMoUJ0=
X-Received: by 2002:a17:906:5247:: with SMTP id y7mr18841264ejm.503.1605002689425;
 Tue, 10 Nov 2020 02:04:49 -0800 (PST)
MIME-Version: 1.0
References: <20201109125016.734107741@linuxfoundation.org>
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 15:34:37 +0530
Message-ID: <CA+G9fYvixPJEoa1VyaRf5CiRVUP=S0zUqOi+6ZPaEPEHWMf-9g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/48] 4.14.205-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Nov 2020 at 18:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.205 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.205-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.205-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 0c03e845a8b978ebed2508e862d6a115d48abd7e
git describe: v4.14.204-49-g0c03e845a8b9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.204-49-g0c03e845a8b9

No regressions (compared to build v4.14.204)

No fixes (compared to build v4.14.204)


Ran 38548 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* igt-gpu-tools
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-open-posix-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org
