Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53961CB005
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgEHNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728692AbgEHNXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 09:23:09 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F50BC05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 06:23:09 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 188so1388058lfa.10
        for <stable@vger.kernel.org>; Fri, 08 May 2020 06:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VIU8yowc2+V8zkMLN+ep9zXZ58SIv77iw9jZ8rjfvrk=;
        b=x3ecS+EQSfs1Ivb0Effx7BC2qW6VK0RgGMyWkN1KysgXKJJbbnrP6SCO676GhKEZXO
         sQ2oKgxBAaIRXNXRQLhVMuIm29qEEWtreP+iEkGP2GeNXiUdIuvC+7uPZ85x30069/X2
         RYMzh8SJswH6UReBKcCMznaKe+WTJOTW5301kpAXHJY7WRTVzyPaBSAZddYyxfmJxIoH
         pXnDZnh/LYb6SI2Q58x2RR3wu/CW5o1owKOY90kIo0i1+pkidceCzyGJqy1XUGFFCm1I
         SL1mc4h1Wq++a4PyfFFyJx5RsB9dngGKjb9OCOKoF3wOsOQUugj7/nWq25pzW73UWCZb
         tfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VIU8yowc2+V8zkMLN+ep9zXZ58SIv77iw9jZ8rjfvrk=;
        b=jhDqfJtb+C+H9XGKOMhLPBhYoOU+rVrTOz3jRSeTbQnQ9ybYjRyKxj4UtG4Ts8Hirx
         dQ2Ug8VcndMdbqZ8P9pILHu+4N0YKhadjJLCVDcI4puoRg26vsB/EpYyCc+0RUy1cotw
         R2xEyeEbuKN0ady3PdseL4hyLJRzSNSshQvsf6vNi01kxISOZH4+qs0QNVMDYcc4qZUK
         cZwNQcxdFCsuxknB+jVNj7uu7msJQ8QFwOVYLdP1W8oNAl/W6w3fxMCg/xoLiHR5lZMG
         4VcZSMdmQNW5NpARQldX5LU0mFTAUjAhwmpHeqRDVl52++r8pFqwrJIRqnNw/Zjs3Fsq
         fIDQ==
X-Gm-Message-State: AOAM531zGXGz/fUEzSKDWJoP8nwZbJ3onPpjHJmKm+JqKQHsiwPWLvqJ
        uRo77x0cNarHmwZkpu9nBN+ZyCb9EVHxTzvlY3ILUg==
X-Google-Smtp-Source: ABdhPJzEJjpe16vQv80zYgMKsgsrfGZYRUbLuquVKFzrdtEbGoQTZmrtg7HMWaXV6M+SBfvOeIZlVvloc8btzEbocvY=
X-Received: by 2002:a19:3817:: with SMTP id f23mr1863933lfa.6.1588944187717;
 Fri, 08 May 2020 06:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200508123043.085296641@linuxfoundation.org>
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 May 2020 18:52:56 +0530
Message-ID: <CA+G9fYu6e9ytJejS=No4ytQT=U+YjqOPghVQXD=gAHB82L-WUw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/50] 5.4.40-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>
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

On Fri, 8 May 2020 at 18:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.40 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.40-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
<trim>
> Christoph Hellwig <hch@lst.de>
>     dma-direct: exclude dma_direct_map_resource from the min_low_pfn chec=
k
While building kernel Image for arm architecture the following error notice=
d
on stable-rc 5.4 kernel branch.
 # make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm
CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dgcc CC=3D"sccache
arm-linux-gnueabihf-gcc" O=3Dbuild zImage
 #
 ../kernel/dma/direct.c: In function =E2=80=98dma_direct_possible=E2=80=99:
 ../kernel/dma/direct.c:330:3: error: too many arguments to function
=E2=80=98dma_capable=E2=80=99
   330 |   dma_capable(dev, dma_addr, size, true);
       |   ^~~~~~~~~~~
 In file included from ../include/linux/dma-direct.h:12,
                  from ../kernel/dma/direct.c:10:
 ../arch/arm/include/asm/dma-direct.h:17:20: note: declared here
    17 | static inline bool dma_capable(struct device *dev, dma_addr_t
addr, size_t size)
       |                    ^~~~~~~~~~~
 In file included from ../include/linux/init.h:5,
                  from ../include/linux/memblock.h:12,
                  from ../kernel/dma/direct.c:7:
 ../kernel/dma/direct.c: In function =E2=80=98dma_direct_map_resource=E2=80=
=99:
 ../kernel/dma/direct.c:379:16: error: too many arguments to function
=E2=80=98dma_capable=E2=80=99
   379 |  if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
       |                ^~~~~~~~~~~
 ../include/linux/compiler.h:78:42: note: in definition of macro =E2=80=98u=
nlikely=E2=80=99
    78 | # define unlikely(x) __builtin_expect(!!(x), 0)
       |                                          ^
 In file included from ../include/linux/dma-direct.h:12,
                  from ../kernel/dma/direct.c:10:
 ../arch/arm/include/asm/dma-direct.h:17:20: note: declared here
    17 | static inline bool dma_capable(struct device *dev, dma_addr_t
addr, size_t size)
       |                    ^~~~~~~~~~~
 make[3]: *** [../scripts/Makefile.build:266: kernel/dma/direct.o] Error 1
 In file included from ../include/linux/string.h:6,
                  from ../include/linux/dma-mapping.h:6,
                  from ../include/linux/dma-direct.h:5,
                  from ../kernel/dma/swiotlb.c:24:
 ../kernel/dma/swiotlb.c: In function =E2=80=98swiotlb_map=E2=80=99:
 ../kernel/dma/swiotlb.c:681:16: error: too many arguments to function
=E2=80=98dma_capable=E2=80=99
   681 |  if (unlikely(!dma_capable(dev, *dma_addr, size, true))) {
       |                ^~~~~~~~~~~
 ../include/linux/compiler.h:78:42: note: in definition of macro =E2=80=98u=
nlikely=E2=80=99
    78 | # define unlikely(x) __builtin_expect(!!(x), 0)
       |                                          ^
 In file included from ../include/linux/dma-direct.h:12,
                  from ../kernel/dma/swiotlb.c:24:
 ../arch/arm/include/asm/dma-direct.h:17:20: note: declared here
    17 | static inline bool dma_capable(struct device *dev, dma_addr_t
addr, size_t size)
       |                    ^~~~~~~~~~~

Full build log,
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/544288767

--=20
Linaro LKFT
https://lkft.linaro.org
