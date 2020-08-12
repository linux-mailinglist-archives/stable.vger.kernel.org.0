Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777FC242B01
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 16:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHLOLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 10:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgHLOLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 10:11:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6464C061383
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 07:11:41 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so4329576wmc.0
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 07:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TydYFMefyVh1KPudA4+DQ2jk9sD/f15l4y32PkQDdqw=;
        b=ECQa6sfG5K1RafxYb3fRlxEIbM3fDTmoh0P3mx6tgqjlqlYt6ryPAc8EpogNnKf6TZ
         s531xeP8pYRCFxeB7If8Ddvnutxoq23HHvLZqfv4bzOXFJIAFIOj/k9L2FFomkjc5geH
         NqvG7vOK7oL8aOXMJ7Z8PB7/MZRKHDJ4JiUfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TydYFMefyVh1KPudA4+DQ2jk9sD/f15l4y32PkQDdqw=;
        b=H74ftbS72ADHoFe4LwAJNtlvFbD1BbNUYQ5r1R8hE+yh0vqpxFrkoBpwS06ha0PIIZ
         /PlBPKskju+1IBdqCIeQI9IKidwaWns3rzCDsMJ1tV4q39k4Cri0Du8Vqp3aKkHIMFLY
         ugAwzS6wsqu0G+Fn1xBxzqAVndfOkBBp3TmQhlznEjEZnbb9ezNLjU4xSET5aNTQ2cEp
         VtEYipqUfMYdj0/Xao96a/rP46HQiF0fY9LkuXaWvCoFudknLOyhyzyjuIrjR7XIh8eo
         8zww+pKz/+T8RLrtS+b19TXRtm36kMXF1hZCbD5XIMPzwvf56M17Xcyw65d9auG1Hh1R
         hO9g==
X-Gm-Message-State: AOAM531G8XtYtYxuVTGv9s4BFIThOrsElDNsRxh2jZljYnaKHi124D4V
        WBh73Kqtsg7P4BjTIp+nLjm7uw==
X-Google-Smtp-Source: ABdhPJw1jfxV4cQZuqQJzHbNQcYtLiTcsfM5U1rvdezxh0i/i0VwK/WdxIbGxBCgtu7GE+xHEtQEXw==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr9235847wml.106.1597241500333;
        Wed, 12 Aug 2020 07:11:40 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id s8sm3913149wmc.1.2020.08.12.07.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 07:11:39 -0700 (PDT)
Date:   Wed, 12 Aug 2020 16:11:37 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        daniel@ffwll.ch, andrzej.p@collabora.com, daniels@collabora.com
Subject: Re: [PATCH] drm/rockchip: Require the YTR modifier for AFBC
Message-ID: <20200812141137.GH2352366@phenom.ffwll.local>
References: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com>
 <20200812063154.GB1300894@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812063154.GB1300894@kroah.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 08:31:54AM +0200, Greg KH wrote:
> On Tue, Aug 11, 2020 at 04:26:31PM -0400, Alyssa Rosenzweig wrote:
> > The AFBC decoder used in the Rockchip VOP assumes the use of the
> > YUV-like colourspace transform (YTR). YTR is lossless for RGB(A)
> > buffers, which covers the RGBA8 and RGB565 formats supported in
> > vop_convert_afbc_format. Use of YTR is signaled with the
> > AFBC_FORMAT_MOD_YTR modifier, which prior to this commit was missing. As
> > such, a producer would have to generate buffers that do not use YTR,
> > which the VOP would erroneously decode as YTR, leading to severe visual
> > corruption.
> > 
> > The upstream AFBC support was developed against a captured frame, which
> > failed to exercise modifier support. Prior to bring-up of AFBC in Mesa
> > (in the Panfrost driver), no open userspace respected modifier
> > reporting. As such, this change is not expected to affect broken
> > userspaces.
> > 
> > Tested on RK3399 with Panfrost and Weston.
> > 
> > Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
> > ---
> >  drivers/gpu/drm/rockchip/rockchip_drm_vop.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> > index 4a2099cb5..857d97cdc 100644
> > --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> > +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> > @@ -17,9 +17,20 @@
> >  
> >  #define NUM_YUV2YUV_COEFFICIENTS 12
> >  
> > +/* AFBC supports a number of configurable modes. Relevant to us is block size
> > + * (16x16 or 32x8), storage modifiers (SPARSE, SPLIT), and the YUV-like
> > + * colourspace transform (YTR). 16x16 SPARSE mode is always used. SPLIT mode
> > + * could be enabled via the hreg_block_split register, but is not currently
> > + * handled. The colourspace transform is implicitly always assumed by the
> > + * decoder, so consumers must use this transform as well.
> > + *
> > + * Failure to match modifiers will cause errors displaying AFBC buffers
> > + * produced by conformant AFBC producers, including Mesa.
> > + */
> >  #define ROCKCHIP_AFBC_MOD \
> >  	DRM_FORMAT_MOD_ARM_AFBC( \
> >  		AFBC_FORMAT_MOD_BLOCK_SIZE_16x16 | AFBC_FORMAT_MOD_SPARSE \
> > +			| AFBC_FORMAT_MOD_YTR \
> >  	)
> >  
> >  enum vop_data_format {
> > -- 
> > 2.28.0
> > 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.

Greg's bot wants a cc: stable on the commit (i.e. in the commit message),
otherwise it's lost since it doesn't track what's all submitted to it
before it's merged.
-Daniel

> 
> </formletter>

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
