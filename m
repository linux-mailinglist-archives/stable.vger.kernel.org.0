Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9263CE46A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348041AbhGSPnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348089AbhGSPjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 11:39:54 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5042BC0533B0
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:32:07 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso18615646oty.12
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xIwzU+Afe1M0wAfoYltQGIMtQgvGqIlYy99BYrSr2Zc=;
        b=HFRraTLnnT08snRhu4eIkJc1FsGkVqfFGCwoqAT7nsIJJSZOtj5YAbj2c+JSJ498pJ
         kjAzlMENbtMtUv4OgutDWs+1/RUSUrK5/jnq4cL/sMh0e9+1RzDwMtbKBPDZ/gKrjvjN
         ySYfO/VEf8Q1s+J8yh8XJ9rJtU4bL98CY4isOCHp+c6QnxdyBq8P9YHcDj67LHLNee4I
         NHjqb0ekWeG7YTkuJdczBpVb+giozE3AnI2dcC4Iwf0htpCcFFi5ACFpQM+0Jjz4FHRx
         fpCrhhdWE1DqZk+ImpC0WhBar6w8LBC45lH2H3oBR8HrcSl+WBuyWhI2My5FSmnJXHEH
         ZreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xIwzU+Afe1M0wAfoYltQGIMtQgvGqIlYy99BYrSr2Zc=;
        b=R0yAGUgmlk+FytChJROk/sq/30ChyHQwEFoAyfz+Hnz5e3s+aZOURWMT8JAi7PEirA
         QxSOPL/ROrK/TzQ4yPqZISC+XTc3Yk56Eo/1W5EmT6XFu1c7Fxiq652xsAXjjgQLJN46
         MUMVVIJH2avuLWG6jLXNv/fh34/XlXN5o7mWN9wYmYp5G3wj9V0tqBPy+9oVsb3gehil
         Idi6A/jwhp6D4bu4aAd4pYZisuWi0grB7riR7eLgCTaa9ANrQJRADNxaMDMPB983bDOe
         qiJ73vWd6czerlogk3JFajBSeje4qCMUjVjLQY6D+J2AgijBAXGeFTYe4jfSWRW9LheQ
         JT1A==
X-Gm-Message-State: AOAM533CsYboec9itDADnBh1eVywZXQKlgcjPJrAHLLb4Ztau06ND/PZ
        PBktlIrfnY3jLw7Bq+WHiqpTuhhmHhVeeXDqhy33Pw==
X-Google-Smtp-Source: ABdhPJwfWwmWGxabniI5FM6nXIIa0z9IUme9GHWpOXFC0+sp+Mu8KeFjTZ4K5AzKVZgI+DphK1QbLX8bP9p573dAML0=
X-Received: by 2002:a9d:32f:: with SMTP id 44mr19002565otv.266.1626710299343;
 Mon, 19 Jul 2021 08:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144942.861561397@linuxfoundation.org>
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 21:28:05 +0530
Message-ID: <CA+G9fYvCbZdAQbZw0+e-5ueyzRdsCog4JPQoHNK4TyxXLWpzqQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/315] 4.14.240-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021 at 20:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.240 release.
> There are 315 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.240-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following patch caused arm64 build errors on 4.19 and 4.14.

> Petr Vorel <petr.vorel@gmail.com>
>     arm64: dts: qcom: msm8994-angler: Fix gpio-reserved-ranges 85-88

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
Error: /builds/linux/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts:42.1-6
Label or path tlmm not found
FATAL ERROR: Syntax error parsing input tree
make[3]: *** [scripts/Makefile.lib:294:
arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dtb] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:544:
arch/arm64/boot/dts/qcom] Error 2

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
