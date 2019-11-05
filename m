Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4010EF59C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387504AbfKEGoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:44:30 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37168 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbfKEGoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 01:44:30 -0500
Received: by mail-lj1-f194.google.com with SMTP id l20so1773920lje.4
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 22:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ay1Ixq6cBI3gofXGdK3vO7GoRuVXJrG/NFv3pprP5dY=;
        b=vI7sjVF0tlXBMi9wFmmvp5jnbgV3s3+rlj1FKrSklCwVdBQLtS4zdWwRuCR1W8jxw6
         iakRD2RSwsIHs0/h3XGlwMlHYcQx8vvKYPT7AQqX7PsCqpI5Uf85uNsT8EBn1nhNXr5y
         ji3p7eK3lyib14HVww8nQfG+hsoPnVf6bWyZMEAj9B9Wh83QNrJHHp01bjsYkmeSrxDh
         UwDlKglGkAK2dUDVs+Ej5IKrfl5fUpB/4tKHWeLqWEX6V8D4QBoZDHkduAA7CDD9/8Ng
         CxgXB8ejQVyEnFMUaTlgZtrnKE8ljlv00pex3TMSVYk3O1vEYV4LKlLVvNyCjVD8COVo
         eN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ay1Ixq6cBI3gofXGdK3vO7GoRuVXJrG/NFv3pprP5dY=;
        b=cq16qREux+MV54wZkVc962ibB+BG6FDCCM04y/dLHCl28nYkxBeWJ+e2DgC+wvMS20
         jvinlKqrvz5v6OUo3t5DWTl11rdcqeh07uw7JCByH46OE9ytxuppxC1YS2NkeUiF6g3o
         VL9fCTQgN2heopqeXwwpDyI+vj5VdqRWgSetkG1ir9XWT7oM9jZiWng8KOfkGapBLJE3
         wbhSUqFbfkK40j498aO6jiFSlPlIfxJkrhVaLK5Sk/UJwjPP3ZsKuJx8gGOM6Z5b10Fh
         gfLoiJgfAJVJLIqAVwG1BeVmR0TKbWRxxUB5CmF3WYGTduFfOn9Qm/vucdiSc5/ikrqQ
         NKpw==
X-Gm-Message-State: APjAAAXsrBIRutlK7Q79vZel/FSNgsVhkYZxEFMB+zYXBjvZIXpAbFD0
        bhJb6AWHCKM7rUdIOsaXHsnwcO1bg0PefkVvZU+VRg==
X-Google-Smtp-Source: APXvYqyFVApwX5OvBrSu/2aPO3qVvjflJUgzMfUvgSM0MHuLQvf0xNwpsrlKLH9dBEjYAntXuviZrViRrV2wRgMuUAg=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr1499687ljq.20.1572936266619;
 Mon, 04 Nov 2019 22:44:26 -0800 (PST)
MIME-Version: 1.0
References: <20191104211830.912265604@linuxfoundation.org>
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 5 Nov 2019 12:14:14 +0530
Message-ID: <CA+G9fYv5K7S6VgKO8vjmKUeb3RwHi56deGfqzoJMUJEvkPvfGA@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/46] 4.4.199-stable review
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

On Tue, 5 Nov 2019 at 03:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.4.199 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.199-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.199-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: 1e0d280e1f8dbd21a713507c208e2ed524c18257
git describe: v4.4.198-47-g1e0d280e1f8d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.198-47-g1e0d280e1f8d

No regressions (compared to build v4.4.198)

No fixes (compared to build v4.4.198)

Ran 14764 total tests in the following environments and test suites.

Environments
--------------
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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest
* kvm-unit-tests
* ltp-open-posix-tests
* install-android-platform-tools-r2600

--=20
Linaro LKFT
https://lkft.linaro.org
