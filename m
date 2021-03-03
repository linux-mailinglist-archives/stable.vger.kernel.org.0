Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020032BC34
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383224AbhCCNo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843028AbhCCKYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:24:36 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9C9C061223
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 00:32:33 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bm21so21680920ejb.4
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 00:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BqekrOVrolDpMG5/JmcfAVvwbTu8RV0j7Se99VtBEcc=;
        b=P/uquj684daW3A9Yv0Xkt8CYVBwRo6rBr82FZNHKB2DuIJdQC8PDPM/3w45UUn9gYj
         SQkWWvqCBUmN6HhFSCsVTygg7Rs5JqBTo6nfEjpDFz10wooVgcphM0qYiCzvpHt7i5tX
         IqxkmEOymk5/q8KAtpF0bG8WdlVSlahvvPZAjSQSr9VwJOgE9KLeoklPAv08UPQTuoqr
         ZnHyWSXxDul0pcgPraS8bYVyMqdidsx5PhINDgqOpD72W5SYxJxU6uIfdydQ8eZOyNMn
         lrmIdtT6l7RUpsiE5bD9L9cFBNwSXwjFmSBWFlJt9BRF2SqLAcIKtXZ8aars7BmtIhYj
         uPWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BqekrOVrolDpMG5/JmcfAVvwbTu8RV0j7Se99VtBEcc=;
        b=osvGccTxU0T5MXrCxOm/YSsdEX3lBB9WVHXgIPLzUPncOVC1PMU7HSpBhrSGiIa4gI
         rPm6wQ/AkeDSzQKAoj9EmMyufrkXWaz1x738Zuk4S+A8PBjXFdnF24uGTgFIESQIioRn
         hNMJSXoG/GiQODRKG917zCXM/1hNi5XcyXDPBNsbfR72TxRSFNS62PgEyVwMceFuAsnN
         DAqoa7gRaMTanqqvzZaIAXIlc+8wLDj3RF9TWyvBe5wMbKqnWPedFsP/OK4EMHBk7Ke/
         AyZ2G9rwrSWtyQP1zvGfq9D+g6+urKqwooU7NZYHSLUMk07N2zCLbFxY5rgG6Hlw4mrx
         iCaA==
X-Gm-Message-State: AOAM53084tInRJ/XyHkHBvd7uO13GXix4FK/LYZDdmSWJTodm+DEczJY
        pKdP/oEH5mkN/MM8g6Gw+G1t/4PUlfMEG2nzlHKgUw==
X-Google-Smtp-Source: ABdhPJxLGkewqef2ptqvWfzIQC0wsO06AMlom/LK9nRXq1YbtxPiX/brbeeo/8lskFM/06A0G+ZRg92pBd4v5pf4mqM=
X-Received: by 2002:a17:906:b2c3:: with SMTP id cf3mr23862604ejb.133.1614760352304;
 Wed, 03 Mar 2021 00:32:32 -0800 (PST)
MIME-Version: 1.0
References: <20210302192719.741064351@linuxfoundation.org>
In-Reply-To: <20210302192719.741064351@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 3 Mar 2021 14:02:20 +0530
Message-ID: <CA+G9fYvkW+84U9e0Cjft_pq9bGnBBqCXST7Hg+gx4pKNyuGPFQ@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/773] 5.11.3-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.3 release.
> There are 773 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
All our builds are getting PASS now.
But,
Regressions detected on all devices (arm64, arm, x86_64 and i386).
LTP pty test case hangup01 failed on all devices

hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

This failure is specific to stable-rc v5.10.20-rc4 and v5.11.3-rc3
Test PASS on the v5.12-rc1 mainline and Linux next kernel.

Following two commits caused this test failure,

   Linus Torvalds <torvalds@linux-foundation.org>
       tty: implement read_iter

   Linus Torvalds <torvalds@linux-foundation.org>
       tty: convert tty_ldisc_ops 'read()' function to take a kernel pointe=
r

Test case failed link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.2-774-g6ca52dbc58df/testrun/4070143/suite/ltp-pty-tests/test/hangup01/log


--=20
Linaro LKFT
https://lkft.linaro.org
