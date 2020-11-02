Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA812A2D62
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 15:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgKBOvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 09:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgKBOvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 09:51:03 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD6EC0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 06:51:02 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id s21so14936629oij.0
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 06:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wZFcGmt2DZV2S1ETLPD5EyGoAl6DAcImG9s5mz7KKfo=;
        b=ccGygpiPnmvZMIboi3y07+KmnQkah7ON/Daac0w618bN4cW4vVuTgAcBQ9NY3EowVw
         nEsQTAAlQ79JcJ3qHgkvTP28qG7D0wcwgAMN/LKOzq8lo7ahPZtOQs2Lf3tg9h2cdBHj
         JxZeWSRiTiJlhDyLMAcAcsQwC7243TDVOikOc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wZFcGmt2DZV2S1ETLPD5EyGoAl6DAcImG9s5mz7KKfo=;
        b=iehC4jwYh388/uOLeA4Mf6cXV0D3gCMIH/WgVCcNiuWtNzpAzbYq+kfD2AV6+xSU0Z
         iywOB0amgsWyJNXCjdeyqN4sGnjYr724sqQ/ltxof+xeqnmzsN+nd807txV8Scl7Vnxb
         24+MCaGp31swgbMCxKPlgThWG0TO+nq6s8KYMcU0dht+r+h5uXgwH2TNqoZT4L425oc1
         ct2YgN4WlqH2yFfvjmqGQnFs105jlHBPVAMJH+IQQILuHHn8Z8ToJDC2pvbVzJJlqU56
         hwX/PyOy7wTOFgtZBy+gfmOhFpwm0osIxoEH+IShFB36zQtW4eUHmiEUHD2PmDn9M+Q5
         3cyA==
X-Gm-Message-State: AOAM531PMj/7QhSTYvq73L6rfF9ouX8IMkMAt9VHdjNfybbrBKjAjQhe
        0lkE0hcgPoS6a+6NGRl9c5x/I1D8uD0zgh1DiOpF2A==
X-Google-Smtp-Source: ABdhPJx+WNBcNZfK2XNCkFJ/n4r/3tlXepzMqj1UT19n16EAqTaPayKRlKJhUszNDgW4Jf7XHTHibvs59WYDzXaDaXc=
X-Received: by 2002:aca:cc01:: with SMTP id c1mr10429535oig.128.1604328661316;
 Mon, 02 Nov 2020 06:51:01 -0800 (PST)
MIME-Version: 1.0
References: <20201030181822.570402-1-lee.jones@linaro.org> <CAKMK7uFN31B0WNoY5P0hizLCVxVkaFkcYjhgYVo1c2W+1d7jxA@mail.gmail.com>
 <20201102110916.GK4127@dell> <CAKMK7uFhpt5J8TcN4MRMeERE9DtNar+pBAmE6QRvD0zkGR5iNQ@mail.gmail.com>
 <20201102113034.GL4127@dell>
In-Reply-To: <20201102113034.GL4127@dell>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon, 2 Nov 2020 15:50:49 +0100
Message-ID: <CAKMK7uHo2MMmBUic9EiFqcUh8mJeu1+=ZQfH7bWA=zdJTyRyvA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const qualifier
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 2, 2020 at 12:30 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Mon, 02 Nov 2020, Daniel Vetter wrote:
>
> > On Mon, Nov 2, 2020 at 12:09 PM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Mon, 02 Nov 2020, Daniel Vetter wrote:
> > >
> > > > On Fri, Oct 30, 2020 at 7:18 PM Lee Jones <lee.jones@linaro.org> wrote:
> > > > >
> > > > > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > > > > built-in fonts") introduced the following error when building
> > > > > rpc_defconfig (only this build appears to be affected):
> > > > >
> > > > >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
> > > > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > > > >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
> > > > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > > > >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
> > > > >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
> > > > >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> > > > >
> > > > > The .data section is discarded at link time.  Reinstating
> > > > > acorndata_8x8 as const ensures it is still available after linking.
> > > > >
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Cc: Russell King <linux@armlinux.org.uk>
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > >
> > > > Shouldn't we add the const to all of them, for consistency?
> > >
> > > The thought did cross my mind.  However, I do not see any further
> > > issues which need addressing.  Nor do I have any visibility into what
> > > issues may be caused by doing so.  The only thing I know for sure is
> > > that this patch fixes the compile error pertained to in the commit
> > > message, and I'd like for this fix to be as atomic as possible, as
> > > it's designed to be routed through the Stable/LTS trees.
> >
> > The trouble is that if we only make one of them const, then it'll take
> > so much longer to hit any issues due to code not handling this
> > correctly. Being consistent with all fonts sounds like the best
> > approach.
> >
> > And the original patch that lost the const for the additional data
> > also went through cc: stable for all fonts together. So that shouldn't
> > be the hold-up.
>
> My plan was to keep the fix as simple as possible.
>
> This is only an issue due to the odd handling of the compressed Arm
> image which exclusively references 'acorndata_8x8' and discards it's
> .data section.
>
> I am happy to go with the majority on this though.
>
> Does anyone else have an opinion?

Oh I don't want to hold up the fix, I'm just semi desperately looking
for people who care beyond "this is the most minimal thing for my use
case" since this entire area is orphaned. With the other things fixed
feel free to smash my ack onto this.

Maybe Peilin is going to include the full re-cosntification in a
cleanup series, dunno.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
