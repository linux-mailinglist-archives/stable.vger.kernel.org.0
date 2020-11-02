Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32702A28C1
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 12:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgKBLJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 06:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgKBLJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 06:09:22 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D0FC061A04
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 03:09:20 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id w14so14060016wrs.9
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 03:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VNKBzuaah0h5Gb4hoIVZS3da51nQlrhYLCe3rboP11A=;
        b=SFTaJqUZtfkkrRI+Q9PY7VNO+a17R1kSjOtcGWcaK+CHErqUB/F2Sa3e/th8FMVcft
         TmgOCOTjq94XbgaUawLyPonyp5k6zXmfsTXV2c5U2H+oduVvMBHQfZoavcR4nCSVOAxY
         e9miCE9Iipq2MYWzeP+MDbIykjcYJY+WAAjOiKwHs2xr6UcrxbOO0I4ouSqA68j46mYC
         azb5mdF9wHULmZ2Cz6u54K2cSvx11STFdyPcDl9bInHXHq70Q98O+NKEk1Fq5YRZnsyK
         jacisaqaE9vTEUxs00HqwMo7MjuVoK8RkPC2yy5gcPU41D7lRiAA0z6d6utzoX9PXCjd
         w/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VNKBzuaah0h5Gb4hoIVZS3da51nQlrhYLCe3rboP11A=;
        b=sqn29mQGBLILjOPbdwdNMwBISdC553kzgb5SYW2Ca4pMeiC+BC9l+EVLGddgzQYowh
         uog4UBx6G+limBOPvab0IFvnSlXKXuL3IDgCvDQpzxijShdmjgOgWORIRER7cxy9evWh
         kDiCPceANqN8tjdCsfC8bKLi/9w2Ezb0BPuDBNpoDM/My5v6FZgVozImuBFONWk+tg+j
         Pn5SLi2/CV5n3rpXlcX93rTtI/c2Ql/kDK8DjvJdPcP476TmPk7KoLg9Cf95+6Xno2d3
         0ApIgeq40C/WD7Iw6eP658GTyL6kWhJWgDCMSwGgqMdoUsI+dOtiY3drrLSANj6fYc1l
         wRjw==
X-Gm-Message-State: AOAM532EgCn4WGP/ZPc4TEH7LwnLbP4K3yZwrVWxd2u2PiZ6db9W9Bz+
        SPI2Y/VqdaJL0HXVEzs0wr5Djw==
X-Google-Smtp-Source: ABdhPJxNCPU3ugtaw5SbDq9bRqIQsbfrQpZvvzXXHChVJFEpTyYgy/+pQ1unhh72pfJOI5cuZzTiTw==
X-Received: by 2002:adf:df91:: with SMTP id z17mr18923542wrl.379.1604315359142;
        Mon, 02 Nov 2020 03:09:19 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id y185sm14706772wmb.29.2020.11.02.03.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:09:18 -0800 (PST)
Date:   Mon, 2 Nov 2020 11:09:16 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102110916.GK4127@dell>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Nov 2020, Daniel Vetter wrote:

> On Fri, Oct 30, 2020 at 7:18 PM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > built-in fonts") introduced the following error when building
> > rpc_defconfig (only this build appears to be affected):
> >
> >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
> >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
> >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
> >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
> >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> >
> > The .data section is discarded at link time.  Reinstating
> > acorndata_8x8 as const ensures it is still available after linking.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Shouldn't we add the const to all of them, for consistency?

The thought did cross my mind.  However, I do not see any further
issues which need addressing.  Nor do I have any visibility into what
issues may be caused by doing so.  The only thing I know for sure is
that this patch fixes the compile error pertained to in the commit
message, and I'd like for this fix to be as atomic as possible, as
it's designed to be routed through the Stable/LTS trees.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
