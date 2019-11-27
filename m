Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AE810ACF2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 10:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfK0Jy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 04:54:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40208 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfK0Jyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 04:54:55 -0500
Received: by mail-wm1-f66.google.com with SMTP id y5so6665226wmi.5
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 01:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=OhFYn38kxpOYTcrPm+Y/EegqNgkowYI0yN7z0gECY2U=;
        b=JsUhvvBump6XmCXgypDmK7of/3YvnLdCDtAAeiz7O3hLDFF8W7iGemUaE4GS+cv8D6
         T3v8eygIIxvP2wJzvFiQL42iEkWYIr/CeU1q93+wap8ifKqZsQKDaUq76OIe2So9fYgn
         pGoBDNTt01+8OiOuQVi0NMaoX6IIHU9qyxLvPG7M2doeX5XdG2buyL2MvnMget7lIaJf
         YFXZzdfYJAt2V2XsKndQH3dSyDIlRgJyCnQ6GrFa7bplwWTozfg/2Dg5xp7fwQNKrT+y
         lswhIUOoGvSv/Ww6TIiH15ctxbrx7r7H975WIF1yNVzkIMmcMVd3MWQM5W/ek87PgTJs
         htug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=OhFYn38kxpOYTcrPm+Y/EegqNgkowYI0yN7z0gECY2U=;
        b=L0ADiTsoxHhjWBlIiBllMqthnhDStC3lgF/dYhXqwfhBbT8mHovjsn36R7U0L3w7Fh
         /5Eo2nZ3+TOAAlPbq7Tfa/jV0AJ/+gVdjbql7LK+33/1a3kj79g6NyKIOdSuMsXsegsZ
         NJ2RYuqG64Gk1BTJ21I7ho5sk+LsM3ocxgIg7EZMOWaUtU6pz0kb+MHRrO95Uvvzg0cB
         uEO3bzenipfPGagDWn0ByFl01nEKjtmdzjwgtqpFANv80B2GjdFxt6pyPOPYZDiedDhm
         AtUAsDnXLLckpE2PNmLlliiAXu5bnSPvP2xfkmvYvSP49H1sezpwWy2wZm/waHgDtzPu
         AdeQ==
X-Gm-Message-State: APjAAAWMRDG4XtgUtN6+9KfNeB1hPdzkRBzvKmUssiH04KLOMDCZzATm
        QiD36ZeLyXl4ij2GiF0NHgaeSwNZu+s=
X-Google-Smtp-Source: APXvYqy2BUqfd0uLt8jDNsz8zuEtFbR/K1hU7H4CN17bdfp8S+/HIbet1s/Q/CdvEMVxzSgoSWSqhA==
X-Received: by 2002:a1c:a750:: with SMTP id q77mr3656975wme.76.1574848494085;
        Wed, 27 Nov 2019 01:54:54 -0800 (PST)
Received: from dell ([185.80.132.160])
        by smtp.gmail.com with ESMTPSA id m25sm5910937wmi.46.2019.11.27.01.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 01:54:53 -0800 (PST)
Date:   Wed, 27 Nov 2019 09:54:41 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.4 1/6] can: dev: can_dellink(): remove return at end of
 void function
Message-ID: <20191127095441.GM3296@dell>
References: <20191127072124.30445-1-lee.jones@linaro.org>
 <20191127075115.GB1821634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191127075115.GB1821634@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Nov 2019, Greg KH wrote:

> On Wed, Nov 27, 2019 at 07:21:19AM +0000, Lee Jones wrote:
> > From: Marc Kleine-Budde <mkl@pengutronix.de>
> > 
> > [ Upstream commit d36673f5918c8fd3533f7c0d4bac041baf39c7bb ]
> > 
> > This patch remove the return at the end of the void function
> > can_dellink().
> > 
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/net/can/dev.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> > index 9dd968ee792e..e0d067701edc 100644
> > --- a/drivers/net/can/dev.c
> > +++ b/drivers/net/can/dev.c
> > @@ -1041,7 +1041,6 @@ static int can_newlink(struct net *src_net, struct net_device *dev,
> >  
> >  static void can_dellink(struct net_device *dev, struct list_head *head)
> >  {
> > -	return;
> >  }
> >  
> >  static struct rtnl_link_ops can_link_ops __read_mostly = {
> 
> Also, this showed up in 5.4, so why did you not include it in all of
> your patch series that you sent?  I can't take patches for older kernels
> and skip newer ones for no good reason.

Right. I pulled it from the other branches as it wasn't suitable.

Looks like this was left behind.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
