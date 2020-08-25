Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5D325150E
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 11:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHYJMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 05:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHYJMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 05:12:17 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400C4C061574
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 02:12:17 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id d20so3497419ual.13
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 02:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jE7fyxXiyeD/zjyIffJDN6llP2shlXse+KQvtM4Zc3c=;
        b=U33AZncdoe7pC60BjfBybyA4VCU9xkfxbfTh1DJzFO/j7jnlex2b7MYcwaFTV0gCJE
         OOu0aXt7jG3bNfrMJl8MZg16mGO0RjsBxIh7NU7TV9Q86eDv0X5ovj/zVrlVAXVq3z5Q
         ESSjPrVUK73a3yuSr2dBiajlhv6ZXX/a61IqAGL3D1p7biF7NSDmiFnfhT4NJQYTCTrt
         TWdNbwCUa6CmSB/U/eg3hv7B71gCd0HS10L87/0lqQQ+/apzYMSfgHg7dHqUM1CYFTE3
         CtcsB+wqz2bWJqeTPB8kJJ2jYan5tjgqgdzyiHR7SP8XDRJfvsBLYnxKyWMUqsKLb4d2
         KDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jE7fyxXiyeD/zjyIffJDN6llP2shlXse+KQvtM4Zc3c=;
        b=p8vWOn8VR9Wj1akUopZVB1xVN8aM6qrProLzn7FppaYo0zc17iqOhUiZnQF27IcSxW
         +y23N8HspbQHf447/6qsjsNpgcB9l90Fgt3375rB7FJgNSKaeG9ydFPFXVdaAhEwFDC2
         m4S8vYUyf+Q7D05y308RBeCvnN+TYQ+lTHHqFNIGtSCuK7XejZB+0ldElx7pPMegQu+K
         /xMHN1aK9Uxh0ftGC+2QC8q+yKj+LFiK7f63t8jyvaSTwX3vML308E6ocpOiWgc+EZRS
         Bo/elorohw2zpRd9XM1JpkiL3IjfLbxOMTM4IihKtYbp1EflMQpnTjT11KpWmkW+pciG
         uoUQ==
X-Gm-Message-State: AOAM533nhK7sEq2xkwA/M2/V+jKr98mXK4koKJCNcDg0dSXXgaJZC1Sk
        v1gAFc3Vo/wNIGToNt9dBMQCKP4Pc1DAOeO+MnHb7A==
X-Google-Smtp-Source: ABdhPJzMiocbUNDCG4J3XaVWkUb9eExScfYJdhJxXpw9YL8Fi3wrOF1wnwitFoO1uajv2KpjUJTpXWf5v0BSu1rDwks=
X-Received: by 2002:a9f:35d0:: with SMTP id u16mr4584256uad.113.1598346736185;
 Tue, 25 Aug 2020 02:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200824164720.742523552@linuxfoundation.org>
In-Reply-To: <20200824164720.742523552@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Aug 2020 14:42:04 +0530
Message-ID: <CA+G9fYs-iJh6wNPetu=61=TnU4pRTLROY3p7qTxdAh9F3nBhcQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/39] 4.9.234-rc2 review
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

On Mon, 24 Aug 2020 at 22:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.234 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.234-rc2.gz
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

kernel: 4.9.234-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 306b4f399ede253cce971b4320fa85046846fc70
git describe: v4.9.233-40-g306b4f399ede
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.233-40-g306b4f399ede


No regressions (compared to build v4.9.233)

No fixes (compared to build v4.9.233)


Ran 25581 total tests in the following environments and test suites.

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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-tracing-tests
* perf
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org
