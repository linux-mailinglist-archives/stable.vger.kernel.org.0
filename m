Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876AE18C2AC
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 23:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCSWAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 18:00:03 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41135 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgCSWAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 18:00:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id o10so4297483ljc.8
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 15:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bFyweR87uAdOCEm7xTt713Fc3fncIqKRE+WME6iIOUQ=;
        b=wNxfuBN+7i3FIFSSR1i3rpA6HWWmv8GltC1J1EWA+g3Mbs1rYEmbYjOh2ytAgr9MvE
         jBRbMwjZ53gpokr8kRh+j+52ZzA97tBAJGdkzOvUYLOSJ9rXlP9iU3q1VbgbKqjCmQkZ
         lt3Df891zgxMh58yZRq13rSLtD3p2EIFvuZdmkLwUmvl4cgJ5BjpT4M4fsEcMGQc0NRf
         Nv+hlYMAsCWQBbz28x54jeMUGktjTkHYBmALTfRyyMolY/UfHZCnGuV2lePrAIgCfUCD
         xem0d0w8KR5Q/9DRuz4Edu8Q8a4yaBBFtR4hjR2PPnpBcvkeZCieSoQ3PfxnHYxgzn9A
         V/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bFyweR87uAdOCEm7xTt713Fc3fncIqKRE+WME6iIOUQ=;
        b=lF/Qja5hZqLAz37Pq3JsgmjSw8HFYv/hzRK+A5W3hm5Pn+0hQCS38tIQt4oaQEbvC+
         UvQAta0S9kFK1kHiFrSe7N3KFDZsk7hAGQdGg0PIp95A9AyHGiKAQXI9oz5+RAXQ43zB
         bVktwDp4pZWVVcBo8u0LOFqmAaolLxsiOL+2T1BaXIkDyWI9q931hTNI+IkVwIuPtTFS
         bFdqa5wlpAlvWyMSx5VmyJeIwN7gxXRxu3p1s4H+oaK7IjG0eSox3F2uJONm7TCasT42
         v8gB2kb4yyXULFsRt46fakI3oA4t/tBeuCR1fWvWhzHDDR6bXr4G0Wu8jzLV9L/1rHJ/
         6s2Q==
X-Gm-Message-State: ANhLgQ1c87nkt1YJDnLsLjthsOUcaDel0AkAkFOh2ssMUBob/+f+0sDJ
        To/pYZTyvaCG24rJhwCudgbXQUmL+kwCspy/BVPrNQ==
X-Google-Smtp-Source: ADFU+vu2sZ8HBWaMW/pSwoQOgl3ony6LuKicMRC7Nv865ID8NDs7KA1Je3JT/K2aJsYsD49MnLSl0pe9P8Y3jyoY/7g=
X-Received: by 2002:a2e:990b:: with SMTP id v11mr3513597lji.243.1584655199510;
 Thu, 19 Mar 2020 14:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200319123919.441695203@linuxfoundation.org>
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 20 Mar 2020 03:29:47 +0530
Message-ID: <CA+G9fYvLC7xBuULxhG9yRi+EbUqmQjnS0X+0j-vGpX6XPVskOg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.27-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 19 Mar 2020 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.27 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.27-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
This regression is platform specific.

On arm64 dragonboard 410c-QC410E* the LT hugemmap05 and
hackbench test cases started failing on this build and easy to reproduce.
Where as on other arm64 platforms (juno-r2, nxp-ls2088) these test PASS.

These two test case scenario run on independent execution.

Steps to reproduce,
cd /opt/ltp
./runltp -s hugemmap05

cd /opt/ltp/testcases/bin
./hackbench 50 process 1000
./hackbench 20 thread 1000

Test output log:
--------------------
hugemmap05.c:89: BROK: mmap((nil),402653184,3,1,6,0) failed: ENOMEM (12)
tst_safe_sysv_ipc.c:99: BROK: hugemmap05.c:85: shmget(218431587,
402653184, b80) failed: ENOMEM (12)

Running with 50*40 (=3D=3D 2000) tasks.
fork() (error: Resource temporarily unavailable)
Running with 20*40 (=3D=3D 800) tasks.
pthread_create failed: Resource temporarily unavailable (11)


*
RAM: 1GB LPDDR3 SDRAM @ 533MHz
CPU: ARM Cortex-A53 Quad-core up to 1.2 GHz per core

https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-hugetlb=
-tests/hugemmap05
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-sched-t=
ests/hackbench01
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-sched-t=
ests/hackbench02


--
Linaro LKFT
https://lkft.linaro.org
