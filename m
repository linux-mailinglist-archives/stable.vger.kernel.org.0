Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7FE20B49F
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgFZPdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 11:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZPdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 11:33:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C87DC03E979
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 08:33:54 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l17so9239000wmj.0
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 08:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rpso9ySNKoLDGZyCP/hQvs97M6SXDiiUl7b7MavvpwM=;
        b=Im1TNyjYUqGtSxb3sVpOQyDfuWo+4jL/eqZNHs4NDDTYEFyid04tQdyu89ASBScZ4r
         wb24XBrOxce/WjPuyNXPXoUHQtfJiOu0kaAMJjR3M59cyn6Vkqe368y2feEo+qQEiBk1
         DGBfapEIfDFuUQ2BVVIu2qVIvQnFFinKhlLC/DFjzG2Vl42KM9ir4BThZQhjbOqbEaLn
         PIGe/3KXrsysRdikgnP8sEL3JiLrgrISIBIssg0wXfm9CiCOt594i2d+P+H+yy96DPWd
         chrGgttiyWu7uhIOKgZbaVf2bTgCFyCeXiE4mMc/P5bBOpgpq8XeNZk2VCtLj5y9RojH
         FdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rpso9ySNKoLDGZyCP/hQvs97M6SXDiiUl7b7MavvpwM=;
        b=NMVND3e6YgfF9+jSH8fwq66v7ui5aI7SBDva+taie8Hll+/ypB31VnUhWrV9r0H+VH
         VW1tTQ0BbOUXFqvwAaaXST50ZJF9599ZBzPTgk9CB6WDrNXqPUc+jXb0vtkFaiqFh9xz
         q5/oTxyzHenvTZjloTC3KlXZrVyXHM2HwdQwCp5NwmK2x4T24snBSZ9ack/UHyVLUneL
         LOpGp0DXnRV0DcWqsaYYvsapkRfTIjA315uCV4tGWO1CoNsKyeEwkS+uyVyxcgB9eqen
         UH47a14ozH7DujPqQ8udGWtUtt3FmJ+Zeipy3AEjCCywrb8bBRe/GtV3AWmGVNDOEtIL
         J6mQ==
X-Gm-Message-State: AOAM533JRgoQb67AABymerAxpoobE4+XQEKGCHsa/nV9ZqkSk6eQh/g/
        GPbloMzUPUOTyaw63ER1NIipjg==
X-Google-Smtp-Source: ABdhPJz9yrxY45T9SAy1cdsmEGjRTcOB+Cz9/AF+lu25KlsF3R66G6fdX+qT3KF8kVohKRgE/ySkTg==
X-Received: by 2002:a1c:32c4:: with SMTP id y187mr4112202wmy.79.1593185633299;
        Fri, 26 Jun 2020 08:33:53 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id f16sm18168315wmh.27.2020.06.26.08.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:33:52 -0700 (PDT)
Date:   Fri, 26 Jun 2020 16:33:51 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     jingoohan1@gmail.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Software Engineering <sbabic@denx.de>
Subject: Re: [PATCH 3/8] backlight: ili922x: Add missing kerneldoc
 descriptions for CHECK_FREQ_REG() args
Message-ID: <20200626153351.GD177734@dell>
References: <20200624145721.2590327-1-lee.jones@linaro.org>
 <20200624145721.2590327-4-lee.jones@linaro.org>
 <20200625094051.u4hanl3rycczlwiy@holly.lan>
 <20200625103334.GO954398@dell>
 <20200626095405.nzhqsfjegj6qg2ro@holly.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200626095405.nzhqsfjegj6qg2ro@holly.lan>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Jun 2020, Daniel Thompson wrote:

> On Thu, Jun 25, 2020 at 11:33:34AM +0100, Lee Jones wrote:
> > On Thu, 25 Jun 2020, Daniel Thompson wrote:
> > 
> > > On Wed, Jun 24, 2020 at 03:57:16PM +0100, Lee Jones wrote:
> > > > Kerneldoc syntax is used, but not complete.  Descriptions required.
> > > > 
> > > > Prevents warnings like:
> > > > 
> > > >  drivers/video/backlight/ili922x.c:116: warning: Function parameter or member 's' not described in 'CHECK_FREQ_REG'
> > > >  drivers/video/backlight/ili922x.c:116: warning: Function parameter or member 'x' not described in 'CHECK_FREQ_REG'
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > > Cc: Software Engineering <sbabic@denx.de>
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/video/backlight/ili922x.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> > > > index 9c5aa3fbb2842..8cb4b9d3c3bba 100644
> > > > --- a/drivers/video/backlight/ili922x.c
> > > > +++ b/drivers/video/backlight/ili922x.c
> > > > @@ -107,6 +107,8 @@
> > > >   *	lower frequency when the registers are read/written.
> > > >   *	The macro sets the frequency in the spi_transfer structure if
> > > >   *	the frequency exceeds the maximum value.
> > > > + * @s: pointer to controller side proxy for an SPI slave device
> > > 
> > > What's wrong with "a pointer to an SPI device"?
> > > 
> > > I am aware, having looked it up to find out what the above actually
> > > means, that this is how struct spi_device is described in its own kernel
> > > doc but quoting at that level of detail of both overkill and confusing.
> > 
> > I figured that using the official description would be better than
> > making something up.  However if you think it's better to KISS, then I
> > can change it.
> 
> Yes, I'd strongly prefer KISS here.
> 
> I know it is an "I am the world" argument[1] but I found using such a
> dogmatically accurate description out of context to be very confusing
> and therefore I don't think such a comment improves readability.
> 
> [1]: See #3 from http://www.leany.com/logic/Adams.html

It's fine, you are the world, I get it. ;)

Do you even like Country music?

Will fix!

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
