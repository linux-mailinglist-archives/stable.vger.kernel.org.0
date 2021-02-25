Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0BD325602
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhBYTCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbhBYTCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:02:44 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56331C061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 11:02:04 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r3so6295956wro.9
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 11:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R04SCbc3J2s6YGY6KTLqQ7dJLw7RfMlWnwJ0ZBxrr/A=;
        b=FcYamvVNhIttALmwinTG0BfvveZd/yBRYBN//4NW5hd8rU/hV1xxIHccU5RESjCeRb
         hZ2aLjMT4dMXcgqG9KW48eW5lRJqPnkGrhaGBrnBssj0U3M6Ls+csqDQAOucI4RCctWI
         sLdvKXnD097OdJpmfj9kiVrOIcnFNcRLJAYzoM/pFfhRU5WbczoyQp2PqHL6AKftUK7+
         p3EixcHJlmALpr1P5ZRMIjCpNZ4vf423GnpNd+iARqGOesx3ukvGe+985cGFhs2Airml
         vmw9QI90G12Q4DsVB1NSeVDeL/LgDXOB+75mojcl466eGOHJFlyZNDeyY1k+wmF4NQPM
         IKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R04SCbc3J2s6YGY6KTLqQ7dJLw7RfMlWnwJ0ZBxrr/A=;
        b=DC+1Jos6ijOpV0HZiQ3V6FI7giD+x7wlZZjvujKVaRzgRKI3R8+bvWfC3LLkvu0nxu
         fUZ7Tzpi2QHkibT3MOzRuRPkT3YslLyYkljAshSY1jRyXw1lRESBxN7rg4CJqAGHaqp8
         5DMnjrg4/pJghvZ1h/GeT6fmv2X75YAhPxYu/yC+VMAVdEGVZwAvxm8ZP/XjWy4Om6Dh
         soFleuLbQG0MPfhnBGo9jmls0oZ3PU4KFE+NhHxVIMmnvhdX1Pvrvu2yAm+ul7rrj5n+
         veKUd8W0oMG0B7k+qjS+EPWXQ3IsvDpeJqbxI2C7QKD+hbxweZVYU7X4wvE5IwkD4EsZ
         WOcg==
X-Gm-Message-State: AOAM533twOFiggQa50sZ571jWPoyx+uWljVOshFojRQm/HQi7hWqEDBm
        HpH770t9OmDLLZW2XUnkvhg=
X-Google-Smtp-Source: ABdhPJxk25RGRPLVZhS8dIoWYL89+5XVazQbdxVKKeCGmetyLUCZO5Oi36KP0AaM2heny3nLG3zS2Q==
X-Received: by 2002:a5d:4bc1:: with SMTP id l1mr5074737wrt.396.1614279723057;
        Thu, 25 Feb 2021 11:02:03 -0800 (PST)
Received: from debian ([2.98.59.96])
        by smtp.gmail.com with ESMTPSA id g17sm8289306wru.60.2021.02.25.11.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:02:02 -0800 (PST)
Date:   Thu, 25 Feb 2021 19:01:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Airlie <airlied@linux.ie>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Paul <sean@poorly.run>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH v3] drm: Use USB controller's DMA mask when importing
 dmabufs
Message-ID: <YDf0JdIUJU74J4PJ@debian>
References: <20210223105842.27011-1-tzimmermann@suse.de>
 <YDTk3L3gNxDE3YrC@kroah.com>
 <YDTrDAlcFH/7/7DD@phenom.ffwll.local>
 <YDTu4ugLo23APyaM@kroah.com>
 <CAKMK7uG67eHEFOCJBJCtwFbwoUWQsER4DNBKRp6e75uywvF1pw@mail.gmail.com>
 <YDT0GIJEhWRp0w5F@kroah.com>
 <9b1e0c9b-2337-d76b-4870-72fbe8495fd2@suse.de>
 <YDT+pusRy3/JpmRR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDT+pusRy3/JpmRR@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 02:09:58PM +0100, Greg KH wrote:
> On Tue, Feb 23, 2021 at 01:51:09PM +0100, Thomas Zimmermann wrote:
> > Hi
> > 
> > Am 23.02.21 um 13:24 schrieb Greg KH:
> > > On Tue, Feb 23, 2021 at 01:14:30PM +0100, Daniel Vetter wrote:
> > > > On Tue, Feb 23, 2021 at 1:02 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > 
> > > > > On Tue, Feb 23, 2021 at 12:46:20PM +0100, Daniel Vetter wrote:
> > > > > > On Tue, Feb 23, 2021 at 12:19:56PM +0100, Greg KH wrote:
> > > > > > > On Tue, Feb 23, 2021 at 11:58:42AM +0100, Thomas Zimmermann wrote:
> > > > > > > > USB devices cannot perform DMA and hence have no dma_mask set in their
> > > > > > > > device structure. Importing dmabuf into a USB-based driver fails, which
> > > > > > > > break joining and mirroring of display in X11.
> > > > > > > > 
> > > > > > > > For USB devices, pick the associated USB controller as attachment device,
> > > > > > > > so that it can perform DMA. If the DMa controller does not support DMA
> > > > > > > > transfers, we're aout of luck and cannot import.
> > > > > > > > 
> > > > > > > > Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> > > > > > > > instance of struct drm_driver.
> > > > > > > > 
> > > > > > > > Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
> > > > > > > > 
> > > > > > > > v3:
> > > > > > > >    * drop gem_create_object
> > > > > > > >    * use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> > > > > > > > v2:
> > > > > > > >    * move fix to importer side (Christian, Daniel)
> > > > > > > >    * update SHMEM and CMA helpers for new PRIME callbacks
> > > > > > > > 
> > > > > > > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > > > > > > Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> > > > > > > > Cc: Christoph Hellwig <hch@lst.de>
> > > > > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > > > > Cc: Johan Hovold <johan@kernel.org>
> > > > > > > > Cc: Alan Stern <stern@rowland.harvard.edu>
> > > > > > > > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > > > > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > > > > > > Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > > > > > > Cc: Oliver Neukum <oneukum@suse.com>
> > > > > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > > > > Cc: <stable@vger.kernel.org> # v5.10+
> > > > > > > > ---
<snip>
> > > > > > > 
> > > > > > > There shouldn't be anything "special" about a DRM driver that needs this
> > > > > > > vs. any other driver that might want to know about DMA things related to
> > > > > > > a specific USB device.  Why isn't this an issue with the existing
> > > > > > > storage or v4l USB devices?
> > > > > > 
> > > > > > The trouble is that this is a regression fix for 5.9, because the dma-api
> > > > > > got more opinionated about what it allows. The proper fix is a lot more
> > > > > > invasive (we essentially need to rework the drm_prime.c to allow dma-buf
> > > > > > importing for just cpu access), and that's a ton more invasive than just a
> > > > > > small patch with can stuff into stable kernels.
> > > > > > 
> > > > > > This here is ugly, but it should at least get rid of black screens again.
> > > > > > 
> > > > > > I think solid FIXME comment explaining the situation would be good.
> > > > > 
> > > > > Why can't I take a USB patch for a regression fix?  Is drm somehow
> > > > > stand-alone that you make changes here that should belong in other
> > > > > subsystems?
> > > > > 
> > > > > {hint, it shouldn't be}
> > > > > 
> > > > > When you start poking in the internals of usb controller structures,
> > > > > that logic belongs in the USB core for all drivers to use, not in a
> > > > > random tiny subsystem where no USB developer will ever notice it?  :)
> > > > 
> > > > Because the usb fix isn't the right fix here, it's just the duct-tape.
> > > > We don't want to dig around in these internals, it's just a convenient
> > > > way to shut up the dma-api until drm has sorted out its confusion.
> > > > 
> > > > We can polish the turd if you want, but the thing is, it's still a turd ...
> > > > 
> > > > The right fix is to change drm_prime.c code to not call dma_map_sg
> > > > when we don't need it. The problem is that roughly 3 layers of code
> > > > (drm_prime, dma-buf, gem shmem helpers) are involved. Plus, since
> > > > drm_prime is shared by all drm drivers, all other drm drivers are
> > > > impacted too. We're not going to be able to cc: stable that kind of
> > > > stuff. Thomas actually started with that series, until I pointed out
> > > > how bad things really are.
> > > > 
> > > > And before you ask: The dma-api change makes sense, and dma-api vs drm
> > > > relations are strained since years, so we're not going ask for some
> > > > hack there for our abuse to paper over the regression. I've been in
> > > > way too many of those threads, only result is shouting and failed
> > > > anger management.
> > > 
> > > Let's do it right.  If this is a regression from 5.9, it isn't a huge
> > > one as that kernel was released last October.  I don't like to see this
> > > messing around with USB internals in non-USB-core code please.
> > 
> > I get
> > 
> >  > git tag --contains 6eb0233ec2d0
> >  ...
> >  v5.10-rc1
> >  ...
> 
> Ah, I thought you said 5.9 was when the problem happened, ok, yes, 5.10
> is slow to get out to a lot of distros that do not update frequently :(

iiuc, Debian Bullseye release will be having v5.10.y.

Ben ?


--
Regards
Sudip
