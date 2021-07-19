Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8573CE55E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348100AbhGSPtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350239AbhGSPpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 11:45:45 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205E8C0ABC93
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 08:34:30 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id f93-20020a9d03e60000b02904b1f1d7c5f4so18639243otf.9
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 09:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UbfZ2fxZ551eOr1A/qga0gzaS5+WRQ4KJX74KhhPDFM=;
        b=aEJBXYEGXLQIMGfJtJjzxrxQy5KffM4hwJEbbAPWNkjyCyghqnicmRZqLSpaclQS2X
         U4zyRqO9iz304m6X2RZ+f3BAKQ32at+CME38elE8vRGCg+eSeWt4PlIypfzuF0oPjADx
         w2goxBQiF6uew6evCpUXKA/1c0JjtGWkGJERNp+T77kknUr7QUe78T3ixvc1bCXF2Iga
         EZA+ZrcZY/ROk5t4udwtWKjfytRCdBGgX/U5efVzG0SMGxgKwCGoR7igX+xMhaEIdT6D
         faoleBrQu57OaUsovtkJeeEt+QODrDMSFOJe+eVFxzO8aU4m15i5vee1W0IQKkVi3s8+
         6sdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UbfZ2fxZ551eOr1A/qga0gzaS5+WRQ4KJX74KhhPDFM=;
        b=W9MPVO52oJ6Lqv9Z7JE9MObAqn0VnxGfEbQhyBtKIMjvK1daugVrRB01TDfmNpTlhL
         XIwBzBGG84e3DirHX2wJLnQsQs4Fqu/GWiJMGpN+MSWYNsGTS+9L7nZWEksjHlATLdLZ
         q2RF+xBD3DggoKHnNyIJOISjV9fgJyLSjfuxMOBZc5Bt1dgC3Rhxu7g6zaA/3hRbwrZt
         y08YTev+f76/t/a/kqIURyqctoNz82a04MEylFSGxqAo5T3WXkemEqePpGCCDByk1ON9
         9KZZCyaXo2IiE+H0q+ofk+rd+jUc0tJGN3OEap7VzOb9z6VWZatH+2zvSNZtt0lx+e3W
         erZA==
X-Gm-Message-State: AOAM533czr+Ecl/Kzff0eAF6ozybVHWLvtvbpfkW2Cwh/Tutu68fKv7q
        2tJfqW9l4KDUMq/pIPB799OyzPEyTcFpsQarTUVsRA==
X-Google-Smtp-Source: ABdhPJwv9+IjPbCxEnJPxnBF1OwIRjiGsjXXPowfEMzPFtAAEYemEYMgOmkn/d2G4i0vSOA8Cr/faULWMBVQiGSFky0=
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr19709878ots.72.1626710431057;
 Mon, 19 Jul 2021 09:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210719144946.310399455@linuxfoundation.org>
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Jul 2021 21:30:17 +0530
Message-ID: <CA+G9fYsbeQCFhBv-TVxmD3Djp1BCXmVdPmJuopF82ghqMAG_3A@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/421] 4.19.198-rc1 review
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

On Mon, 19 Jul 2021 at 21:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.198 release.
> There are 421 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.198-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
