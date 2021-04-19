Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85A8364136
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbhDSMEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233519AbhDSMEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 08:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EEDB60FE8;
        Mon, 19 Apr 2021 12:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618833862;
        bh=JJzqqHbZqVlkT2kBS3P/HTmuc2pd9C539v+ZpQI79Y8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDCJP+v0ddQyW2ievNMk+Q1B4hR6tbH6D1E1uxeCJehXcOHL6MB6p3E19F3xhfYOg
         Vwm0R5G8TZzHMaiyum9HtrbwPz/V/JF+uWrfgfEI/XarIGaYHA1FT07jz3rp3nZDtK
         kHXUhBGFW80nO/JjF43uB0JGBcle9avYEPKOaawU=
Date:   Mon, 19 Apr 2021 14:04:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "net: Make tcp_allowed_congestion_control readonly in
 non-init netns" has been added to the 5.10-stable tree
Message-ID: <YH1xw5s0Uu5i/cRT@kroah.com>
References: <1618749928154136@kroah.com>
 <CAPFHKzdKcVDDERr8pmd=65Tf=tWNh_bKar9OLQd0oS2YBVu80Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPFHKzdKcVDDERr8pmd=65Tf=tWNh_bKar9OLQd0oS2YBVu80Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 18, 2021 at 10:47:04AM -0400, Jonathon Reinhart wrote:
> On Sun, Apr 18, 2021 at 8:46 AM <gregkh@linuxfoundation.org> wrote:
> >
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     net: Make tcp_allowed_congestion_control readonly in non-init netns
> >
> > to the 5.10-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      net-make-tcp_allowed_congestion_control-readonly-in-non-init-netns.patch
> > and it can be found in the queue-5.10 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> >
> >
> > From 97684f0970f6e112926de631fdd98d9693c7e5c1 Mon Sep 17 00:00:00 2001
> > From: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> > Date: Tue, 13 Apr 2021 03:08:48 -0400
> > Subject: net: Make tcp_allowed_congestion_control readonly in non-init netns
> >
> > From: Jonathon Reinhart <jonathon.reinhart@gmail.com>
> >
> > commit 97684f0970f6e112926de631fdd98d9693c7e5c1 upstream.
> 
> Hi Greg,
> 
> Thanks for picking this into the stable trees.
> 
> There's an earlier, somewhat related fix, which is only on net-next:
> 
> 2671fa4dc010 ("netfilter: conntrack: Make global sysctls readonly in
> non-init netns")
> 
> That probably could have been on "net", but it followed this other
> commit which was not strictly a bug-fix. It's additional logic to
> detect bugs like the former:
> 
> 31c4d2f160eb ("net: Ensure net namespace isolation of sysctls")
> 
> Here's the series on Patchwork:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210412042453.32168-1-Jonathon.Reinhart@gmail.com/
> 
> I'm not yet sure where the threshold is for inclusion into "net" or
> "stable". Could you please take a look and see if the first (or both)
> of these should be included into the stable trees? If so, please feel
> free to pick them yourself, or let me know which patches I should send
> to "stable".

I have to wait until a patch is in Linus's tree before we can add it to
the stable queue, unless there is some big reason why this is not the
case.

For something like this, how about just waiting until it hits Linus's
tree and then email stable@vger.kernel.org saying, "please apply git
commit <SHA1> to the stable trees." and we can do so then.

thanks,

greg k-h
