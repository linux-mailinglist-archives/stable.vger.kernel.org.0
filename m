Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F182A40B4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 10:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCJwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 04:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgKCJwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 04:52:44 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B65C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 01:52:43 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 33so6984084wrl.7
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 01:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=tZURvADMiFaiJPFlm7U63ViQDE3v0TWLHH+E89RNfTM=;
        b=JFvItVm0kvcse/IWL2EVvynsnyi3W9vwJPwpyUL/PNg0EQ+xrW0PyyNzU1ol/wNHEO
         KaTQ0NgjUNksEIYXCiwvrhpgL+3p4v0N9HRRwbJKbHy3ZzVI/cknLbneL1Cxn+hHuf48
         l1uke1kys9PZZ5UZYsV8oF8VXShVo0/kZGOIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=tZURvADMiFaiJPFlm7U63ViQDE3v0TWLHH+E89RNfTM=;
        b=Ps4N7/TECeEQoSyDvvrwv9oX/2w/KC5GZ3wodiZTAaUIAgL///F1uQDopLEYflkdJI
         zSFe7vT4MPn0G61rg7czT/vvMa5PO+v1qojYmRJzA4hPhojTMZ9KRcB9hlzXVuUz88zQ
         /KXn+q1QcvgzTDpIjAlIgHysLkq/7a0qwqKh4/aj1tqs5AcsvftSQFWwt23h2+5v6cbd
         dHBsNWzF9Tgqfj7IBEtG2uAcqDcOMO3LWP3EfOSFmbPfJdvlJS0dllC4QXBlPrHWhoRl
         jVha0hKVLRVdbROegMXI8jd1eFglfuJjStlLAtNw4S4QIEC+ZBkPdlzFtIytA9eD4NA6
         2smw==
X-Gm-Message-State: AOAM532AMuIFNI/jZP0pDXFtOj+zc4eVs+HaX+2yWZnlRswjbjlN6O3i
        dRjABtuZaCqIhcIrd7MgGVQudw==
X-Google-Smtp-Source: ABdhPJzusxtA0XkuTlkE8VCJBhBzvhLspVAmN9cw157VA0KKY9W4itB4ZEmLrfkkEt6x4UM89bMmbQ==
X-Received: by 2002:adf:9f49:: with SMTP id f9mr17860205wrg.122.1604397162504;
        Tue, 03 Nov 2020 01:52:42 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id w11sm2515722wmg.36.2020.11.03.01.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:52:41 -0800 (PST)
Date:   Tue, 3 Nov 2020 10:52:39 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lee Jones <lee.jones@linaro.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Message-ID: <20201103095239.GW401619@phenom.ffwll.local>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>, Peilin Ye <yepeilin.cs@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201102183242.2031659-1-yepeilin.cs@gmail.com>
 <20201103085324.GL4488@dell>
 <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
 <20201103091538.GA2663113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103091538.GA2663113@kroah.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 10:15:38AM +0100, Greg KH wrote:
> On Tue, Nov 03, 2020 at 09:58:18AM +0100, Daniel Vetter wrote:
> > On Tue, Nov 3, 2020 at 9:53 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Mon, 02 Nov 2020, Peilin Ye wrote:
> > >
> > > > From: Lee Jones <lee.jones@linaro.org>
> > > >
> > > > Commit 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in
> > > > fonts") introduced the following error when building rpc_defconfig (only
> > > > this build appears to be affected):
> > > >
> > > >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
> > > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > > >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
> > > >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> > > >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
> > > >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
> > > >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> > > >
> > > > The .data section is discarded at link time.  Reinstating acorndata_8x8 as
> > > > const ensures it is still available after linking.  Do the same for the
> > > > other 12 built-in fonts as well, for consistency purposes.
> > > >
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: Russell King <linux@armlinux.org.uk>
> > > > Fixes: 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts")
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > Co-developed-by: Peilin Ye <yepeilin.cs@gmail.com>
> > > > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > > > ---
> > > > Changes in v2:
> > > >   - Fix commit ID to 6735b4632def in commit message (Russell King
> > > >     <linux@armlinux.org.uk>)
> > > >   - Add `const` back for all 13 built-in fonts (Daniel Vetter
> > > >     <daniel.vetter@ffwll.ch>)
> > > >   - Add a Fixes: tag
> > > >
> > > >  lib/fonts/font_10x18.c     | 2 +-
> > > >  lib/fonts/font_6x10.c      | 2 +-
> > > >  lib/fonts/font_6x11.c      | 2 +-
> > > >  lib/fonts/font_6x8.c       | 2 +-
> > > >  lib/fonts/font_7x14.c      | 2 +-
> > > >  lib/fonts/font_8x16.c      | 2 +-
> > > >  lib/fonts/font_8x8.c       | 2 +-
> > > >  lib/fonts/font_acorn_8x8.c | 2 +-
> > > >  lib/fonts/font_mini_4x6.c  | 2 +-
> > > >  lib/fonts/font_pearl_8x8.c | 2 +-
> > > >  lib/fonts/font_sun12x22.c  | 2 +-
> > > >  lib/fonts/font_sun8x16.c   | 2 +-
> > > >  lib/fonts/font_ter16x32.c  | 2 +-
> > > >  13 files changed, 13 insertions(+), 13 deletions(-)
> > >
> > > LGTM.
> > >
> > > Thanks for keeping my authorship.  Much appreciated.
> > 
> > Should I stuff this into drm-misc-fixes? Or will someone else pick
> > this up? Greg?
> > 
> > I guess drm-misc-fixes might be easiest since there's a bunch of other
> > fbcon/font stuff in the queue in drm-misc from Peilin.
> 
> You can take it:
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to drm-misc-fixes, thanks everyone!

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
