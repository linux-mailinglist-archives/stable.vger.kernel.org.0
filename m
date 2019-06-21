Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0624E4EB34
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 16:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfFUOxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 10:53:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55275 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfFUOxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 10:53:15 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EE916222C2;
        Fri, 21 Jun 2019 10:53:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 21 Jun 2019 10:53:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JCbEYoxmzy3ql8hBWp6kET6t/A+
        euvi2knEYE6fh5v4=; b=DHhdBTH+9Hji4Ox0n+JuF3cdqFyf2S/G9xhsYFJSUbE
        IV+gAQvp1ZZyxOhxELng7ccBcfJBf/ezjvIBIsApkkpYHZn23J6mLqcbdl0p9dpj
        zzI7sP2lvi+T6l0RJURXD4BpRrElL34hjos6QbQvbOL/pNnJWKKAVeNlrk4bsHU0
        9PR6fCtP9W7dm0g31+3rRzfjJA4jbtVxANcHqU6XUxeBKNqO7RpAW2BjzGjFyQwB
        kay72Uqvub0J68oBXhFa3RWqhDDWa7sEWfQBCO7NAKnP+qSPZzvtJ3Nq2A4OW9VX
        ffv1UmxHza8TOOeZ7VjCp1aj94teASPMwQtNs+abbkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JCbEYo
        xmzy3ql8hBWp6kET6t/A+euvi2knEYE6fh5v4=; b=qYfHNKCrqVEerzjmUWncTx
        KHdS/0h4qwWhhMR15OM7qm6Sx64VbFUBcL6WFUA63u9mDpkZT+pDYU445s5QfIBS
        HMpjnURZnaHxZHslhilHmrNNu9B3o6AJnVP4ZxSmXa7RMTnll9wq0szfaRR1sncP
        mejP0GL9Xe4A4F2nHtVfQKKA13P6oy8pjxxbQVH7POHNhPGpnb+wxfuhMZscwbWL
        bvqQUghOctsyiqvMozfSqpqwPLGoKwvSSiRhN+V4+puoF/TZclEOiUM9stiU6Yj0
        6DI2Z1iCG0/uTw2L2zhzu8aJbqYYbAGOA6scdK3NcK/PVTwLxiquZpoLvMmrokYQ
        ==
X-ME-Sender: <xms:WO8MXcYr1itAYpvrwcykV7S2iP77pX4ZLEfCANyiHuGuO4ad3f6c-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdeigdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WO8MXRWo2A3xOQNZumOn1N5pqM94LQCVxCs76kM8MTMyXWFQ0Icdyg>
    <xmx:WO8MXdSYyZMW7SoqbZkUGW2vQmvSTMKK-ckmbOr8ooCX_5CIcqWt_g>
    <xmx:WO8MXdIgt4Udh1z56peFriYkDN0ANFbht4X0HhxznfMAT8ltS0IH4A>
    <xmx:WO8MXeGQ9CbVfWj1GJTJLWHY1Jo-G2vVvSbOHgzegFPNrj3Gj1ex-g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9F7C380086;
        Fri, 21 Jun 2019 10:53:11 -0400 (EDT)
Date:   Fri, 21 Jun 2019 16:53:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: dapm: Adapt for debugfs API change
Message-ID: <20190621145309.GA6313@kroah.com>
References: <20190621113357.8264-1-broonie@kernel.org>
 <20190621113357.8264-2-broonie@kernel.org>
 <20190621132222.GB10459@kroah.com>
 <20190621143053.GH5316@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621143053.GH5316@sirena.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 03:30:53PM +0100, Mark Brown wrote:
> On Fri, Jun 21, 2019 at 03:22:22PM +0200, Greg KH wrote:
> > On Fri, Jun 21, 2019 at 12:33:57PM +0100, Mark Brown wrote:
> 
> > >  	struct dentry *d;
> > >  
> > > -	if (!parent)
> > > +	if (!parent || IS_ERR(parent))
> > >  		return;
> 
> > How can parent be NULL?
> 
> It was more effort than it was worth to check to see if it could
> actually be NULL through default initialization or something and fix it
> than just not delete the check so I just left it there.  I'll probably
> go back and clean it up more thorougly at some point.
> 
> > I am trying to make it so that debugfs doesn't return anything for when
> > a file is created.  Now if that will ever be possible or not, I don't
> > know, but I am pretty close in one of the branches in my driver-core
> > tree...
> 
> You mentioned this in a mail last week, I then replied pointing out that
> this is not helpful as it reduces the robustness and quality of our
> debugging tools and you then did not respond.

Sorry, had lots of other stuff to work on, it's in my queue to respond
to still...

> This is a view I still hold and in any case debugfs as it stands (and
> was in the kernel versions since this was broken) is still capable of
> reporting errors so we should fix that.

Sort story is, I am trying to change it so that it can not report errors :)

And even then, no kernel code should be doing anything different if
debugfs calls fail or not, that is why I am I making these changes.  No
"real" code should ever be affected, and right now, it is, if something
goes wrong with debugfs.

So removing those checks is the goal here.  Your driver code should not
care if debugfs is working at all or not.

thanks,

greg k-h
