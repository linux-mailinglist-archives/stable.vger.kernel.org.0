Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5422A298C
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 12:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgKBLak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 06:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgKBLai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 06:30:38 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863F4C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 03:30:38 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h62so4321199wme.3
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 03:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=i8P+1ihFPTbcqcdmnuv8HM9WxJxCIqZJiXX7QB+7i7w=;
        b=m5bLNXPJlIXPe6vWNe3sFFSqDvuKpn8KQElblDrEAUjPPJ2eqIzNOrD3K/kopR8Ase
         RSAPoUZhcDDx3dQFrjjHC1QIKuuD6JSsE7It14yxKziSIBvaSZXu33sWRJ7uDViuTbvl
         9kL2L2H4wJNIMI/GCwrvWmmHkxvHRxlISY03JRMcZALik0l9m0WgQj/dslfRvAR1yxC+
         eAwXE3y4fJ/pPTlC7Ag+jgR1TRLjYFw4KpXIH93q62PTyU6cogjAnQzL15l4NPVyZ8iA
         nG47OUy2+XRjE47dt1+j+COQE96+FTrP+xnGYV6RMYjFEvlaVqGW2ZVkKtbaHZPn3xJz
         gzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=i8P+1ihFPTbcqcdmnuv8HM9WxJxCIqZJiXX7QB+7i7w=;
        b=UmDsPEb6qf/7DZ1F29cB2+1m11TBDBrP+tXrcpqJ/Jsm/3Q5NIHQA9Jf/Im29KoI29
         ilcIdxBPq4X2ryMaglMSgll1C+8MPSJRrvBdiq39YhKevwGv5xQ4zjoyIv6NQQE4GzVk
         Eau1KD/X8pMU28ApHiY4YarCTb3FwoZWbIyNnRVb3LWRX9RTuSdbHErZKz/Aaqbc16W3
         craQhEo1BGru7l7bkCI07MF+uqu8aL5LNdnQiNxykbvlqWYtsVm3r1WVi4DnClUBzyW0
         pXtJV9BNnMIRBlCKHN8cBDeUka9OIKDPsYzZ5eWM4pfQ0iSX1NTEmOk4JA1HsS+WEag/
         SfjQ==
X-Gm-Message-State: AOAM530oyt33y3uzlpDdDqIphrE909QEDUSf8wWKPvyhGOTIpoO+YCER
        d7ZtXoG15EntP5T9LJ+1ejIoJQ==
X-Google-Smtp-Source: ABdhPJyukRK6/lVQPZEtTsbbFN0/7S8cO1TDZDy93qCXars0Ldc0ODXaZPWGpf44BJ2D8ZiOzJUMJg==
X-Received: by 2002:a7b:ce85:: with SMTP id q5mr16890502wmj.35.1604316637217;
        Mon, 02 Nov 2020 03:30:37 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id b136sm14536930wmb.21.2020.11.02.03.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:30:36 -0800 (PST)
Date:   Mon, 2 Nov 2020 11:30:34 +0000
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
Message-ID: <20201102113034.GL4127@dell>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell>
 <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 02 Nov 2020, Daniel Vetter wrote:

> On Mon, Nov 2, 2020 at 12:09 PM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Mon, 02 Nov 2020, Daniel Vetter wrote:
> >
> > > On Fri, Oct 30, 2020 at 7:18 PM Lee Jones <lee.jones@linaro.org> wrote:
> > > >
> > > > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > > > built-in fonts") introduced the following error when building
> > > > rpc_defconfig (only this build appears to be affected):
> > > >
> > > >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
> > > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > > >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
> > > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > > >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
> > > >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
> > > >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> > > >
> > > > The .data section is discarded at link time.  Reinstating
> > > > acorndata_8x8 as const ensures it is still available after linking.
> > > >
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: Russell King <linux@armlinux.org.uk>
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > >
> > > Shouldn't we add the const to all of them, for consistency?
> >
> > The thought did cross my mind.  However, I do not see any further
> > issues which need addressing.  Nor do I have any visibility into what
> > issues may be caused by doing so.  The only thing I know for sure is
> > that this patch fixes the compile error pertained to in the commit
> > message, and I'd like for this fix to be as atomic as possible, as
> > it's designed to be routed through the Stable/LTS trees.
> 
> The trouble is that if we only make one of them const, then it'll take
> so much longer to hit any issues due to code not handling this
> correctly. Being consistent with all fonts sounds like the best
> approach.
> 
> And the original patch that lost the const for the additional data
> also went through cc: stable for all fonts together. So that shouldn't
> be the hold-up.

My plan was to keep the fix as simple as possible.

This is only an issue due to the odd handling of the compressed Arm
image which exclusively references 'acorndata_8x8' and discards it's
.data section.

I am happy to go with the majority on this though.

Does anyone else have an opinion?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
