Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4A42AB413
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 10:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgKIJ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 04:56:18 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57651 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727906AbgKIJ4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 04:56:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A2CDC10FF;
        Mon,  9 Nov 2020 04:56:16 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 04:56:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=B2UCn0x7UuT7AMBhUk5kNhIGGoh
        Fv8RCc7A1xTXW5Jw=; b=4xzWhtN2Kig+AZgjcZpT6xY28nlF4GHLe8XET0HvCJ/
        CaU+r65MgvKZ9qWFHCDqUl8A8938rOpIZl/doCfkFmA5XBrF7/w++/5nB/DNtan6
        WeR32pmr/datB7TN17+o+6t81J6+nbnhCSk9ib0xA1LX4cRGecQlWZ8KZtRHE0d9
        4ZQ7B5bGr6Cxy7MdViJpHNr/jguokUXem9GB4lVuaQs4VvNqJqseQBIiHATOeRBO
        wCOdpEsu2yq5IXkBCCO7q7cgO1K5dILpfbztIBJvhMsh0Z5l0oeL+S/lPidE1jOD
        zGpb+02TBfP0g5se9DKlc4Y7unK4jRa4eyAEqyFWcAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B2UCn0
        x7UuT7AMBhUk5kNhIGGohFv8RCc7A1xTXW5Jw=; b=N/0d9pEt0rfdv4X5I//fsp
        Q2bamqLFUH4e+VDPB+EQAnCizDmqN1taHty+gwPQW+OkBH3NfNXQaok5n4+cX4qo
        88G0D3j8+BK3V2LKejdnzIPXTJ6YAE2ZRT2a/fr8596Brt1E4za82CaIxF/UwLhA
        E+f7WBadzz1Z/mv38vhvZP4/VkZIh/O/eDb4a5Ssl9ZBD7viiiSmhuWRkrAP52VF
        QKdhzTjWKQHnpYtwhk9EinBjG21yfcvrYfpliwWcCohxfR7GhNFPu1z9om8k5F7k
        U8ZeNzhczD+KM6mECJJe8FdoLexugz9Cp/iTZVJGcyz5JM+RbYl824J1ysbJMWmw
        ==
X-ME-Sender: <xms:PxKpX8fNZkvsNV9HOPJaYnHSAeTJKtGdTdU9tmaFZHAaYj6I8X_23A>
    <xme:PxKpX-ODEAVFNLJodj4mFRfH4xuJ9brc_5ZptOD15Ej1Fxh-h-hbCTZIrVdDZqKit
    ghB5Xr-FEkt0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PxKpX9hxKmVk7NwUIgzLd1VNsFfJvn6PXx8R8vRmjOheYIp8vMucdg>
    <xmx:PxKpXx_1Xb1ecscJLWOmdUth1ceH7mGm-XirGYHR46hDnIWWeHeF9g>
    <xmx:PxKpX4v8EiLdO9rY13CIsjUCyMrQNJSvNX5M3u0c5tYBrrM6AwmcCQ>
    <xmx:QBKpXyWMhPY7Jr7ZRcVlJyMy2Hx_cWAUUG7Yl0a1xnWp_zMyYYAcxA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B7DA3280059;
        Mon,  9 Nov 2020 04:56:14 -0500 (EST)
Date:   Mon, 9 Nov 2020 10:57:15 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Security Officers <security@kernel.org>,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH] vt: Disable KD_FONT_OP_COPY
Message-ID: <20201109095715.GA836082@kroah.com>
References: <20201107092857.3110264-1-daniel.vetter@ffwll.ch>
 <CAHk-=wjoTrpJcC+VKNwsOF+NFd+LANm_pydcFoaV9PscO0Ogaw@mail.gmail.com>
 <CAKMK7uFzGDe9vV8zef5kU6mS5W-0tTDw2KdUmMgbFJ=WT-F-RA@mail.gmail.com>
 <20201108161335.GB11931@kroah.com>
 <20201108183640.GA65130@kroah.com>
 <CAKMK7uHCSxAjcRR8oQRS5uL4i2-iLv38jiN8=7pntoNgQBu+bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHCSxAjcRR8oQRS5uL4i2-iLv38jiN8=7pntoNgQBu+bg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 08:57:38AM +0100, Daniel Vetter wrote:
> On Sun, Nov 8, 2020 at 7:35 PM Greg KH <greg@kroah.com> wrote:
> > On Sun, Nov 08, 2020 at 05:13:35PM +0100, Greg KH wrote:
> > > On Sun, Nov 08, 2020 at 04:41:35PM +0100, Daniel Vetter wrote:
> > > > On Sat, Nov 7, 2020 at 7:41 PM Linus Torvalds
> > > > <torvalds@linux-foundation.org> wrote:
> > > > >
> > > > > On Sat, Nov 7, 2020 at 1:29 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > > >
> > > > > > It's buggy:
> > > > >
> > > > > Ack. Who is taking this? Should I do it directly, or expect this
> > > > > through Greg's tty/char tree, or what?
> > > >
> > > > I've sent out v2 with more archive links, typo in commit message fixed
> > > > and ack from Peilin added. I'll leave merging up to you guys. Note
> > > > that cc: stable still needs to be added, I left that out to avoid an
> > > > accidental leak.
> > >
> > > Great, I'll grab this now and add it to my tty tree and send it to Linus
> > > later today.
> > >
> > > Unless I should be holding off somehow on this?  I didn't see anyone
> > > wanting to embargo this, or did I miss it?
> >
> > Given that Minh didn't ask for any embargo, and it's good to get this
> > fixed as soon as possible, I've queued this up and will send it to Linus
> > in a few minutes.
> >
> > Thanks all for the quick response,
> 
> cc: stable didn't get added I think.
> 
> Stable teams, please backport commit 3c4e0dff2095 ("vt: Disable
> KD_FONT_OP_COPY") to all supported kernels.

I was going to do that given that I am the same person :)

thanks,

greg k-h
