Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77EC1D74C2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgERKJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERKJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:09:01 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B199C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:08:59 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w7so11055813wre.13
        for <stable@vger.kernel.org>; Mon, 18 May 2020 03:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vFWtVAsm6Lg3H+QUocWsIA7k+r0dD6ZqmOUmyIkMUA0=;
        b=tsvbqaIcuhKVlJzuc2bIzPpcatFF9wAnXqjwL580g0P6xxH8tyvp7GXxlEkHI8EYPA
         3RxTjp12z0PtzqZbL8O9sRCImq4kALGZELl5bQqRlsvWHb5yHbXP95An2GNtGrbK7EHb
         obmjzvCOmbacCrRi1grMvbZcqe3HHl+b3zdObD2iBM04b03sbJfEturByySpP4OuGLtk
         9lot64bmeQQ3AJIjngoclJpBYd/dYdcmRHdV8+M0SR9JIrZ4k6VH14uWaRFzSqBqHvPa
         u+wKfzNo/Othd6/yx9oAjBG1cqwsFtyou5foaeW83/zeAiA1dFUcm5XhnJjg/LlSWHHI
         Ynfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vFWtVAsm6Lg3H+QUocWsIA7k+r0dD6ZqmOUmyIkMUA0=;
        b=OZhclbnfsAIyvQJZesgSqpwFrsKpm2xdcYvISUVoAPTQr57/WzEPqxgsFkbUIyd+gq
         LXMUJBNTycRM0E4KRhOJhcHRtS3/6xArhd5bWntoLWLN6yaio8kNhqx7Si6tlYlEUluG
         gekGtCENJqw6IZlqEDpxeSdlM9XrXQBjiVXxg6/fraYYGfl5SDCfmFXFhDPzWolnvJWW
         U5j3PgqbvVYB4Zawvg9vDz0ULL9whS6p2nUBfiePEondOpYZSEoy7CXhL8hoMO0p+/Qn
         ZKiWZxj4rIAglTloHK5SnO16po5S7MWg0xwOuLjamGmaJQXZsDiO6xirIQg3zraRUuuR
         MOAQ==
X-Gm-Message-State: AOAM530hY3ycNoTHzs8Mb2q+1nzglT/YxG3Zvoouk6DpQ07/8d/d44zT
        XBifX0WoBxvUvzM6zS3EpZSZ1WVYhIM=
X-Google-Smtp-Source: ABdhPJxCV95Nh2rSoNIp09+Lm+RNsUZ8YNuEtrnkyqYKdzFZQ/R0+n8yeg4xIkLPfrgYmvZmT0z5tg==
X-Received: by 2002:adf:f9c9:: with SMTP id w9mr18146111wrr.320.1589796538025;
        Mon, 18 May 2020 03:08:58 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id d13sm15451304wmb.39.2020.05.18.03.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 03:08:57 -0700 (PDT)
Date:   Mon, 18 May 2020 11:08:54 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 4.4 06/16] clk: Fix debugfs_create_*() usage
Message-ID: <20200518100854.GP271301@dell>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-7-lee.jones@linaro.org>
 <20200513093703.GE830571@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200513093703.GE830571@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 May 2020, Greg KH wrote:

> On Thu, Apr 23, 2020 at 09:40:04PM +0100, Lee Jones wrote:
> > From: Geert Uytterhoeven <geert+renesas@glider.be>
> > 
> > [ Upstream commit 4c8326d5ebb0de3191e98980c80ab644026728d0 ]
> > 
> > When exposing data access through debugfs, the correct
> > debugfs_create_*() functions must be used, matching the data
> > types.
> > 
> > Remove all casts from data pointers passed to debugfs_create_*()
> > functions, as such casts prevent the compiler from flagging bugs.
> > 
> > clk_core.rate and .accuracy are "unsigned long", hence casting
> > their addresses to "u32 *" exposed the wrong halves on big-endian
> > 64-bit systems. Fix this by using debugfs_create_ulong() instead.
> > 
> > Octal permissions are preferred, as they are easier to read than
> > symbolic permissions. Hence replace "S_IRUGO" by "0444"
> > throughout.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > [sboyd@codeaurora.org: Squash the octal change in too]
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/clk/clk.c | 30 ++++++++++++++----------------
> >  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> What about 4.9?

I sent this for v4.9 on the 22nd April.

https://www.spinics.net/lists/stable/msg382001.html

> I'm going to stop here and wait for a fixed up series of this, and any
> newer kernels that need the patches as well.
> 
> thanks,
> 
> greg k-h

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
