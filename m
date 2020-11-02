Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF92A28EB
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 12:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgKBLSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 06:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgKBLSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 06:18:44 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1759CC061A04
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 03:18:44 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 79so4791835otc.7
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 03:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kXZChu7Wh7ILON/2gYLH4Pho4CrTf6ogIIqD17tHacw=;
        b=XUnOWCaJfUDDNS3cOqI8xlIpVY8dhXOnpx/GxA+bzrrMj4pqtfTy6G0TGcV6UUqnVN
         uBUJYiDPN2cU1ch1eqcgQec67EfZlp4DZn+gL1McyoCAAjgLw0UU3TZlto74e+nLal7F
         SxNXcEO/WWd9sDQrVph/8rzIO4nUcH4ND/6vw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kXZChu7Wh7ILON/2gYLH4Pho4CrTf6ogIIqD17tHacw=;
        b=rFcFbscI85d0MvZbyHARoqUgXtTQPA30Ur5hZJXpF3cbOa7sVN4vVe8LY0fDaX4b38
         VW2WDuGeVCdHuW0cH9U5fWc4IPL8uIRei1oX6vyYTh7D/fSi8vlZxRDLg9fQuj0hJn4y
         vD37xAD9V80IbYh6oGcVY93wHvLgz5hW4PmC94yvk3v9qJw3sPxc3Mv/e9sQte0N883S
         qBxBZe8LFBKPn3cw70YGGIywJ1zvDqWJtAAmMAiusgoW55DgcxaEcUCCExeE49cvJcKR
         c4zI6DqVaAiEVIMdYcQjtyqZa+v5yqJnB27Ljqh3b4z85RQ9NO20WYHvMYdT7Kht6Lgp
         uB3g==
X-Gm-Message-State: AOAM533ZbYZYv17dq5nfKatw/2Uq4qjt5Mf9zbItqnCQ8L+XpsB1T7da
        GDJhJgUDDTLLuPsPOQcxtusFR+AVXFh7kNQUYu6BKg==
X-Google-Smtp-Source: ABdhPJyQ0Lf5Md5khYUkk0S09uHR5oX+TS7s0b1ujSLfYLBp453dV5dDz9J5t5srPUamv+QLV9k/82ttq3sZ5XfNnSI=
X-Received: by 2002:a9d:6e81:: with SMTP id a1mr11108613otr.303.1604315923479;
 Mon, 02 Nov 2020 03:18:43 -0800 (PST)
MIME-Version: 1.0
References: <20201030181822.570402-1-lee.jones@linaro.org> <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell>
In-Reply-To: <20201102110916.GK4127@dell>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon, 2 Nov 2020 12:18:32 +0100
Message-ID: <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const qualifier
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 2, 2020 at 12:09 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Mon, 02 Nov 2020, Daniel Vetter wrote:
>
> > On Fri, Oct 30, 2020 at 7:18 PM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > > built-in fonts") introduced the following error when building
> > > rpc_defconfig (only this build appears to be affected):
> > >
> > >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compr=
essed/ll_char_wr.o:
> > >     defined in discarded section `.data' of arch/arm/boot/compressed/=
font.o
> > >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boo=
t/compressed/font.o:
> > >     defined in discarded section `.data' of arch/arm/boot/compressed/=
font.o
> > >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: =
arch/arm/boot/compressed/vmlinux] Error 1
> > >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boo=
t/compressed/vmlinux] Error 2
> > >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> > >
> > > The .data section is discarded at link time.  Reinstating
> > > acorndata_8x8 as const ensures it is still available after linking.
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Russell King <linux@armlinux.org.uk>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > Shouldn't we add the const to all of them, for consistency?
>
> The thought did cross my mind.  However, I do not see any further
> issues which need addressing.  Nor do I have any visibility into what
> issues may be caused by doing so.  The only thing I know for sure is
> that this patch fixes the compile error pertained to in the commit
> message, and I'd like for this fix to be as atomic as possible, as
> it's designed to be routed through the Stable/LTS trees.

The trouble is that if we only make one of them const, then it'll take
so much longer to hit any issues due to code not handling this
correctly. Being consistent with all fonts sounds like the best
approach.

And the original patch that lost the const for the additional data
also went through cc: stable for all fonts together. So that shouldn't
be the hold-up.
-Daniel

>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
