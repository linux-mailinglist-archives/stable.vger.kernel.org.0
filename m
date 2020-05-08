Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54FE1CAFCA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgEHNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728776AbgEHNUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 09:20:18 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52549C05BD09
        for <stable@vger.kernel.org>; Fri,  8 May 2020 06:20:17 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id b26so1392769lfa.5
        for <stable@vger.kernel.org>; Fri, 08 May 2020 06:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u8FtxFi4ImqEzH02SMGCC236F+wFyRG7A3MxBfNg3s0=;
        b=TDv0SpIue2QxC7unchMyXqFEK8r7oapDU9UBp2j4+t89IjjwDhQ9qDfD/biu9wffz/
         X/1a3inPWoDwY1clp/1T+oBVdWqJZ0vdETgFdpn9yzLujGSd/hFaxmxywBtPJaIC1v5h
         Etft4Tv4neM1WItafES7bps9WHiT650OzbBU7j4H3+TCbyj4IjYoS8y5JLI/BhQf/XuO
         XkvAYhEJevE1urfEdGghqrPEdsH5GkJfAWoQtq8WMY2XlM7opp/qOK6oJz/+HL8PIF/P
         jpXppeorxhB7qC1MUhdO0lhhW8e/V7oVkzwI2ZnOpQQeRdN3hrBtzxSfBGhL9aNpV+sR
         H79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u8FtxFi4ImqEzH02SMGCC236F+wFyRG7A3MxBfNg3s0=;
        b=I/n236W9ASqr4Zc01D/8cP7af/fdWPNLW+HaPOBATJZNcuKL+XgzVgzhkCG+wpbZBP
         LqDlpUYSZQjArHTTEqRGD6cGy/DV5Wf0u4R0Q3+gcYc6hVY+e7sHYB1Xf54UDlste+/6
         EnTutngKMoaqUIMkQvMNzsmff0G9HAeqCU09ZdasJv5c8zNwf67UbqlNQ8dIqqB3sykE
         Sjt8fhu1UV+Ca6O7V+YpG/ka9r6Ut1EAGQSt4ac4JAMoeOtQbMY5KqCcBAiCtQfjuT91
         RAdM4KI49AlRySAGW3hAcKlZqtpssnZ76Cx6FOm7O44xzIyUntfodkwMAr6sywok5Orf
         tqLQ==
X-Gm-Message-State: AOAM532pCmZACO9hdTwR7AmX+xEACPzfMfiCsdaI2cHL9VSndkBCGvs/
        96ANGUIpGF4Shk+gc7WNxCwxO+IUHIrLqcdaL0Dnjg==
X-Google-Smtp-Source: ABdhPJxVBwaJ7zK9WTEeKLTQ0XSgK/4I/baCCn4iGk3YjLC+G05WM2jnBd/mLDOXbcka8Elh8IXAtcRZnSPrfdy7ARI=
X-Received: by 2002:ac2:4436:: with SMTP id w22mr1844442lfl.55.1588944015621;
 Fri, 08 May 2020 06:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200508123043.085296641@linuxfoundation.org> <20200508123048.730720753@linuxfoundation.org>
In-Reply-To: <20200508123048.730720753@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 May 2020 18:50:02 +0530
Message-ID: <CA+G9fYvdD3dhMhGL5=nfT+7xTEdD36zUtceF2fROPF4OQQZbLQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 40/50] dma-direct: exclude dma_direct_map_resource
 from the min_low_pfn check
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, m.szyprowski@samsung.com
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 May 2020 at 18:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Christoph Hellwig <hch@lst.de>
>
> commit 68a33b1794665ba8a1d1ef1d3bfcc7c587d380a6 upstream.
>
> The valid memory address check in dma_capable only makes sense when mappi=
ng
> normal memory, not when using dma_map_resource to map a device resource.
> Add a new boolean argument to dma_capable to exclude that check for the
> dma_map_resource case.
>
> Fixes: b12d66278dd6 ("dma-direct: check for overflows on 32 bit DMA addre=
sses")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
<trim>
>
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -327,7 +327,7 @@ static inline bool dma_direct_possible(s
>                 size_t size)
>  {
>         return swiotlb_force !=3D SWIOTLB_FORCE &&
> -               dma_capable(dev, dma_addr, size);
> +               dma_capable(dev, dma_addr, size, true);

While building kernel Image for arm architecture the following error notice=
d
on stale-rc 5.4 kernel branch.

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
