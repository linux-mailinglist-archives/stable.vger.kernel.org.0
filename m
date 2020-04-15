Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9911AAAB3
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 16:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636819AbgDOOqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 10:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636813AbgDOOp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 10:45:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF25C061A0C;
        Wed, 15 Apr 2020 07:45:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t40so6780657pjb.3;
        Wed, 15 Apr 2020 07:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jNALl1BuKD42Apo1o4CLRZrsNDZW3H4ERvTCwt+E5Sg=;
        b=swTfyokdNLkpNUivX5x2lAJJUr/Ds9rCHZHEFVUIxqvRE6Spu8dzgup7ff3HvB5+oJ
         NpTbSrNWZmWe5JwuA2bshJ75MVGM6VZHrVwq9+6OMb4dC1Z91GLiV4/156sCR+EJ/3Qm
         fAOs8XReIVVzuDWoDzlmYOwsR4ad/YEOu6bxe7CtNnAd3H/iuEX0p2KbSrAPAr16Xj4y
         fNHbIlhDhP+ogI6wU2tl76BtZWc2u5hiME2otSaHCS5BV2V9yIGMsgIBuooduDpcyEe2
         xaUPQp8iw+621uukl5hX5XBFCCwwUPa2nVBy6J7T87CwCWmDM0a8w/uBEVElDtS+OrMt
         /HBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=jNALl1BuKD42Apo1o4CLRZrsNDZW3H4ERvTCwt+E5Sg=;
        b=cK/X0q6OdpDVsgVbMAJY+jyVAkWNsQTpSVtMHNtgJk4A76r/IJNvcTYl8R/RzZuyHv
         N6h6QzH/XjSBrMogw3AZpSyF/grQ9S+ZTLf5xPXPtBOmOkBmJXuXCAQhZVkp77ijzLyA
         t9IwrCcMJsB/zxZPZbvScqRIUBPajCkQCDCXX8DE7wXHP7xz131Lh1EbwLeJcPRz7ZP/
         ag04cpX0jW7+DE6nBPL8V+mqnIEpOjIZKlPmVopWCALC6paGk5RApTJJQCILOW0XmYIV
         hXMgHVyvfvAO2un0LjLlLoZm01i5qdGKzpvQHxhUAVt5roT+sNh8mRW/Z/CiyFJWQZa0
         Dg2A==
X-Gm-Message-State: AGi0PuYt88nid6h7W6LeeFBJ+SYIQlUaoiJW7ZaFqYnX69E3dU02xuoy
        MF49fRrUQ/CSNmaTYG+0D/8=
X-Google-Smtp-Source: APiQypIPFYpY8g9SfD47Y7ZKroWOqDFZH6OMiZC0rwaXj1jrxCX8KwdhaKjd43X3cE7IGcpd7zMXuQ==
X-Received: by 2002:a17:90a:a40b:: with SMTP id y11mr6961734pjp.130.1586961957097;
        Wed, 15 Apr 2020 07:45:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h198sm14083554pfe.76.2020.04.15.07.45.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Apr 2020 07:45:56 -0700 (PDT)
Date:   Wed, 15 Apr 2020 07:45:54 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org, david@unsolicited.net,
        hans.verkuil@cisco.com, mchehab@osg.samsung.com,
        stable-commits@vger.kernel.org
Subject: Re: Patch "Revert "[media] videobuf2-v4l2: Verify planes array in
 buffer dequeueing"" has been added to the 4.4-stable tree
Message-ID: <20200415144554.GA113844@roeck-us.net>
References: <158694575418840@kroah.com>
 <20200415131412.GD27762@paasikivi.fi.intel.com>
 <20200415132742.GA3461248@kroah.com>
 <20200415134520.GE27762@paasikivi.fi.intel.com>
 <20200415135821.GA3640449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415135821.GA3640449@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 03:58:21PM +0200, Greg KH wrote:
> On Wed, Apr 15, 2020 at 04:45:20PM +0300, Sakari Ailus wrote:
> > On Wed, Apr 15, 2020 at 03:27:42PM +0200, Greg KH wrote:
> > > On Wed, Apr 15, 2020 at 04:14:12PM +0300, Sakari Ailus wrote:
> > > > Hi Greg,
> > > > 
> > > > On Wed, Apr 15, 2020 at 12:15:54PM +0200, gregkh@linuxfoundation.org wrote:
> > > > > 
> > > > > This is a note to let you know that I've just added the patch titled
> > > > > 
> > > > >     Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"
> > > > > 
> > > > > to the 4.4-stable tree which can be found at:
> > > > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > > > 
> > > > > The filename of the patch is:
> > > > >      revert-videobuf2-v4l2-verify-planes-array-in-buffer-dequeueing.patch
> > > > > and it can be found in the queue-4.4 subdirectory.
> > > > > 
> > > > > If you, or anyone else, feels it should not be added to the stable tree,
> > > > > please let <stable@vger.kernel.org> know about it.
> > > > > 
> > > > > 
> > > > > From 93f0750dcdaed083d6209b01e952e98ca730db66 Mon Sep 17 00:00:00 2001
> > > > > From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > > > Date: Wed, 11 May 2016 13:09:34 -0300
> > > > > Subject: Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"
> > > > > 
> > > > > From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > > > 
> > > > > commit 93f0750dcdaed083d6209b01e952e98ca730db66 upstream.
> > > > 
> > > > This patch has been already applied to the 4.4-stable tree --- and the
> > > > original has been re-applied as well, just as in upstream.
> > > > 
> > > > The original revert was done because another patch was missing the tree
> > > > (commit 93f0750dcdaed083d6209b01e952e98ca730db66 upstream), not because
> > > > there was a problem with the patch itself.
> > > > 
> > > > In other words, this patch must be dropped.
> > > 
> > > Really?
> > > 
> > > This is a mess.  I see the following commits in the stable 4.4 tree:
> > > 
> > > In the 4.4.9 release the following upstream commit was backported:
> > > 	2c1f6951a8a8 ("[media] videobuf2-v4l2: Verify planes array in buffer dequeueing")
> > > 
> > > then in 4.4.11 it was reverted by backporting:
> > > 	93f0750dcdae ("Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"")
> > > 
> > > Then finally, in 4.4.19 this commit gets added:
> > > 	83934b75c368 ("[media] videobuf2-v4l2: Verify planes array in buffer dequeueing")
> > > 
> > > So, is 83934b75c368 ok to backport, but 2c1f6951a8a8 was not?
> > 
> > Both are backports of separate patches in upstream, and should be in the
> > stable trees as they are at the moment (I checked 4.4). This all happened
> > back in 2016 but now this revert popped up four years later.
> > 
> > > 
> > > Because they look identical to me...
> > 
> > They are the same patch that got applied twice with a revert in between.
> > 
> > > 
> > > So, what am I missing here?
> > 
> > The fix was originally reverted due to an issue in the API usage in DVB,
> > and then re-applied with another fix in videobuf2 core. The discussion is
> > here, and all these patches ended up being applied:
> > 
> > <URL:https://www.spinics.net/lists/linux-media/msg99334.html>
> > <URL:https://www.spinics.net/lists/linux-media/msg100428.html>
> > <URL:https://www.spinics.net/lists/linux-media/msg100458.html>
> > 
> > Applying this revert re-introduces the original kernel memory overwriting
> > bug.
> 
> Ok, thanks, I'll drop this one.  Guenter, you should update your list so
> you don't try to add it again :)
> 

Done.

Thanks,
Guenter
