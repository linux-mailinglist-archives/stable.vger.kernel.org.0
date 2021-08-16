Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F303EDDB8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 21:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhHPTPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 15:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhHPTPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 15:15:22 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F6BC0613C1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 12:14:50 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id lo4so33590480ejb.7
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 12:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=0o5sAZp9YE4A/3Y6BSyPPjh5Xaj5fcrrsuEACZxp91I=;
        b=HeQ4TmYpfBzpluzlmeTNHhG1DjPxVGKXqgYWZBBAGJ2jX7q2WW1Ib8/54zlJ4GaRd5
         c7LPN2/YLDEShFJmT5aYusywOHqJ53gjiEt1UvL2nZcGjmRf5FTyqfkOf4W7DMarOO+e
         Ic6SXUaeN15/tR/K3Dw4LM4rNDHj6fbmBPyn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=0o5sAZp9YE4A/3Y6BSyPPjh5Xaj5fcrrsuEACZxp91I=;
        b=OAj6+iucDHjEgsPSgIUdk3VlZCDIZ9qglakBWy6cCYpF49frQcpGxnFK8qSwlv8kv1
         p8VYGoJgeF4CV8R6BiPJvomvTcG065GAuqNUCH2EOqxc4YzQozAyqrQYFSEFTG/hoREv
         dsR7+wBB2t6qqpI0CLfbwg+eXpO3u+kI8fsHlOpE9UzMmqppJ0549XQwpql188q4SoCI
         +iwLmKbgqXEzwDx+gLD94uUC8M/IboC2RBAG0KsDnF37dwTenmwhLmgTe6WYLstqmXon
         NKiQ99xC3W/MxD5uaD4upaktHH5ols1OobKUhcg6Wfa/vrXRcdIHn69xd33ARGe6ICKp
         TdkQ==
X-Gm-Message-State: AOAM532mUoOaLqCCjNfnIwywNI+a0Aqy2QI0Q4Euq6jVo3vvm0InGPXM
        Zmn0tg28kfGmGPUgSJiLKSSlVA==
X-Google-Smtp-Source: ABdhPJziMLxIL8mQJkTADzU0lrR8wgOKBkymDdB22OmEJ/6H6QFEMiLrk0t1HC+tZwgNBbo2NUBWyg==
X-Received: by 2002:a17:906:3782:: with SMTP id n2mr19972ejc.368.1629141288739;
        Mon, 16 Aug 2021 12:14:48 -0700 (PDT)
Received: from carbon (78-83-68-78.spectrumnet.bg. [78.83.68.78])
        by smtp.gmail.com with ESMTPSA id m6sm21360edq.22.2021.08.16.12.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 12:14:48 -0700 (PDT)
Date:   Mon, 16 Aug 2021 22:14:47 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
Message-ID: <YRq5JyLbkU8hN/fG@carbon>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        paskripkin@gmail.com, stable@vger.kernel.org, davem@davemloft.net
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
 <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRjWXzYrQsGZiISc@carbon>
 <20210816070640.2a7a6f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816070640.2a7a6f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-08-16 07:06:40, Jakub Kicinski wrote:
> On Sun, 15 Aug 2021 11:54:55 +0300 Petko Manolov wrote:
> > > > @@ -433,7 +433,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> > > >  	data[2] = loopback ? 0x09 : 0x01;
> > > >  
> > > >  	memcpy(pegasus->eth_regs, data, sizeof(data));
> > > > -	ret = set_registers(pegasus, EthCtrl0, 3, data);
> > > > +	set_registers(pegasus, EthCtrl0, 3, data);
> > > >  
> > > >  	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
> > > >  	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||  
> > > 
> > > This one is not added by the recent changes as I initially thought, 
> > > the driver has always checked this return value. The recent changes 
> > > did this:
> > > 
> > >         ret = set_registers(pegasus, EthCtrl0, 3, data);
> > >  
> > >         if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
> > >             usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
> > >             usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
> > >                 u16 auxmode;
> > > -               read_mii_word(pegasus, 0, 0x1b, &auxmode);
> > > +               ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
> > > +               if (ret < 0)
> > > +                       goto fail;
> > >                 auxmode |= 4;
> > >                 write_mii_word(pegasus, 0, 0x1b, &auxmode);
> > >         }
> > >  
> > > +       return 0;
> > > +fail:
> > > +       netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
> > >         return ret;
> > > }
> > > 
> > > now the return value of set_registeres() is ignored. 
> > > 
> > > Seems like  a better fix would be to bring back the error checking, 
> > > why not?  
> > 
> > Mostly because for this particular adapter checking the read failure makes much
> > more sense than write failure.
> 
> This is not an either-or choice.
> 
> > Checking the return value of set_register(s) is often usless because device's
> > default register values are sane enough to get a working ethernet adapter even
> > without much prodding.  There are exceptions, though, one of them being
> > set_ethernet_addr().
> > 
> > You could read the discussing in the netdev ML, but the essence of it is that
> > set_ethernet_addr() should not give up if set_register(s) fail.  Instead, the
> > driver should assign a valid, even if random, MAC address.
> > 
> > It is much the same situation with enable_net_traffic() - it should continue
> > regardless.  There are two options to resolve this: a) remove the error check
> > altogether; b) do the check and print a debug message.  I prefer a), but i am
> > also not strongly opposed to b).  Comments?
> 
> c) keep propagating the error like the driver used to.

If you carefully read the code, which dates back to at least 2005, you'll see
that on line 436 (v5.14-rc6) 'ret' is assigned with the return value of
set_registers(), but 'ret' is never evaluated and thus not acted upon.

> I don't understand why that's not the most obvious option.

Which part of "this is not a fatal error" you did not understand?

> The driver used to propagate the errors from the set_registers() call in
> enable_net_traffic() since the beginning of the git era. This is _not_ one of
> the error checking that you recently added.

The driver hasn't propagated an error at this particular location in the last 16
years.  So how exactly removing this assignment will make the driver worse than
it is now?

Anyway, i'll add a warn() and be done with it.


		Petko

