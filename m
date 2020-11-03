Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969ED2A3F7C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 09:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgKCI6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 03:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgKCI6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 03:58:30 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AB1C0617A6
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 00:58:30 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id y22so4800042oti.10
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 00:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K+MACc07Pws5365l/xLxcP/2+AmzqU4XUQhOAyut96E=;
        b=STTpWyPq5ZxF9tVO8yTXEekYkaMc1WUut1WqgdmpKnGDVFgQfZxacNWbA0Cq9f670m
         k3owC92JGcElxZp6Nrwlk7KgXICcDXabPHuef6rUUyQhnKwg/Dg08+1FJernJwXLkBVf
         /75n4yFwei0v/zhtgjb2hCN2/zQxCLMS16vgA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K+MACc07Pws5365l/xLxcP/2+AmzqU4XUQhOAyut96E=;
        b=umUMqUMp/OY1a3pSZW7ZqLbLyrzs2x2l2W0wgl4cFTfmZslj7MxmojI0w+rYj2IjJz
         d5rVcn/U05NmYfLRbr1CbmPh4eYdFjhurRTP4FJtFZEq8EGWC3Qw799jTbymMd01ori1
         q/kZn79MvyzinYK3Kr8WCV9HQMoYkXRGM16Yx/D0jHgpf4aQw4qXGOY4+ZEDw8KiqdQb
         cBMsv5ZUNGkxuqkNGbSyV+S37N8PRo74g5quqJwTJ/e7/bpj+6vmv06dlReIdEUd7HS6
         3hzBCfjr8fncoiXDDiZ1AD7u9ZluUIYX1cbduHBOJnc/qFsITInaZmV6eaoFwAYipDk3
         wGYg==
X-Gm-Message-State: AOAM530BsezeQ4v0ESU4d1BqoKNGG9Ebf5Acmi1q2sAer4Njq9BdDq6C
        1j5N/MYUFC9CB18twltVXReHShyI3LQDjFKxEth1gBvj09LoAw==
X-Google-Smtp-Source: ABdhPJxOUQMQt3VYJItKDV/Lz5YeNzd3tJtHdejPHKPM2wx8pryoxeJVO79ab36z3kuxd2CEyKRMu7F0p9S4AIWqM10=
X-Received: by 2002:a9d:3b4:: with SMTP id f49mr14183517otf.188.1604393909620;
 Tue, 03 Nov 2020 00:58:29 -0800 (PST)
MIME-Version: 1.0
References: <20201030181822.570402-1-lee.jones@linaro.org> <20201102183242.2031659-1-yepeilin.cs@gmail.com>
 <20201103085324.GL4488@dell>
In-Reply-To: <20201103085324.GL4488@dell>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 3 Nov 2020 09:58:18 +0100
Message-ID: <CAKMK7uGV10+TEWWMJod1-MRD1jkLqvOGUu4Qk9S84WJAUaB7Mg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 3, 2020 at 9:53 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Mon, 02 Nov 2020, Peilin Ye wrote:
>
> > From: Lee Jones <lee.jones@linaro.org>
> >
> > Commit 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in
> > fonts") introduced the following error when building rpc_defconfig (only
> > this build appears to be affected):
> >
> >  `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
> >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> >  `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
> >     defined in discarded section `.data' of arch/arm/boot/compressed/font.o
> >  make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
> >  make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
> >  make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2
> >
> > The .data section is discarded at link time.  Reinstating acorndata_8x8 as
> > const ensures it is still available after linking.  Do the same for the
> > other 12 built-in fonts as well, for consistency purposes.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Fixes: 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts")
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Co-developed-by: Peilin Ye <yepeilin.cs@gmail.com>
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> > Changes in v2:
> >   - Fix commit ID to 6735b4632def in commit message (Russell King
> >     <linux@armlinux.org.uk>)
> >   - Add `const` back for all 13 built-in fonts (Daniel Vetter
> >     <daniel.vetter@ffwll.ch>)
> >   - Add a Fixes: tag
> >
> >  lib/fonts/font_10x18.c     | 2 +-
> >  lib/fonts/font_6x10.c      | 2 +-
> >  lib/fonts/font_6x11.c      | 2 +-
> >  lib/fonts/font_6x8.c       | 2 +-
> >  lib/fonts/font_7x14.c      | 2 +-
> >  lib/fonts/font_8x16.c      | 2 +-
> >  lib/fonts/font_8x8.c       | 2 +-
> >  lib/fonts/font_acorn_8x8.c | 2 +-
> >  lib/fonts/font_mini_4x6.c  | 2 +-
> >  lib/fonts/font_pearl_8x8.c | 2 +-
> >  lib/fonts/font_sun12x22.c  | 2 +-
> >  lib/fonts/font_sun8x16.c   | 2 +-
> >  lib/fonts/font_ter16x32.c  | 2 +-
> >  13 files changed, 13 insertions(+), 13 deletions(-)
>
> LGTM.
>
> Thanks for keeping my authorship.  Much appreciated.

Should I stuff this into drm-misc-fixes? Or will someone else pick
this up? Greg?

I guess drm-misc-fixes might be easiest since there's a bunch of other
fbcon/font stuff in the queue in drm-misc from Peilin.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
