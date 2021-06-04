Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3954639BC21
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 17:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFDPnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 11:43:52 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45577 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229864AbhFDPnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 11:43:52 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 93A9B16A4;
        Fri,  4 Jun 2021 11:42:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 04 Jun 2021 11:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=c
        nEhANXPRZDZe5tabUinYP1OslNcvHT28YsdMUkGZUc=; b=bTN0i5c5tkRi82UzC
        tJ/WU6Q6XnQMCgYybXMF49mDCm4GnOMYtYA/G0W+IBuTH92xeSrVoyu7jHyI7/VK
        qDGeCS/mAr2GvmJjykTqU5zr0mJlD0sRQd6ArHwy8PanHcoTNjaGdbHm3w5/Ke81
        kC4PglCxWTAURs9HDL6IkmBxIqh5AWNO+XxaDBbymjmBURWnb2ZJVxOxJwrsfPHR
        TZJnboxTTslNyp745QtbONugA21XHodSu2gA6ZWoOeuI+aJKFfmyqUBBY2vhP4v7
        vB2C3PsGL+ZZSUd6u70f2IqF4+UhggS02BooJCFayHZVF5VGnRtuIB2OfrEAWiYg
        AKXyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=cnEhANXPRZDZe5tabUinYP1OslNcvHT28YsdMUkGZ
        Uc=; b=hUA+3k9nxdCBKmif2NrVJ3fwoTva9NbdmYnHDF7lPnlJ2AtUBa6o+xdc4
        2lM8tUaAB0qUI/x+Qmq8n4968luqMOIvssPAYX8TQj9VTrLvahA51uYAg5CcseqE
        NwUrXQmyr7fLL4U1QCB518toa+yMC830piO9mxiWHBOh+e/YNe9LX2t5Hg0RwO05
        htduI/nh0vvNQNyI5yzaFhbOJ9EKFG6zt1tBDQIxFpTt/vX9vPeLb0H5P6oV08+7
        OCXRsZ1EdgXYJKvR3lp9OsswIFsIxYqPY52t8kQFyBr9tgMimx3UV4Mvdy4Z32oY
        M9y8mEcnvrADv5rT4p+tttKFzblEw==
X-ME-Sender: <xms:zEm6YEbBh4mwqX85SWrLUdUsj8uG-pzH7UE4FdBdFEzFxGnjQGiMMw>
    <xme:zEm6YPZK8K6uTRA-tupCJL-qKTTcedMKQJ0bpbi4LzeZmGtC2munvpp7tuVUbnZi8
    kHC23224h6UFw>
X-ME-Received: <xmr:zEm6YO9G0cUpNbkrgXWad1uHQiZ_q8bOJt1tlU8XZAs4HlTZIP5lsgAKUZzLd7ob3iHB2ZB1Se6w6R4GFMCUFYIMWzRX1k5T>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtuddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeeije
    euvdffuedvffdtteefuefhkeehgfeuffejveettdelgfeuudffffetfedtnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zEm6YOpZDSu3OGQuWfnDx9LLI8y6AnFzUBFgCaumLtan90Utlmf_BQ>
    <xmx:zEm6YPpIc1-Pe-74Je12Wi7UVt69_A6oQzyN1ICFVmn5jGEVz9cAAg>
    <xmx:zEm6YMRKBcv83SZ9rvDiscASdJeFjzrWirJlKUVT5IprHYln-TW4pQ>
    <xmx:zUm6YAkz-4o07C9VyyZIN_hPie9Vall7vY8EaVovQqc8N6l4YPoERg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Jun 2021 11:42:04 -0400 (EDT)
Date:   Fri, 4 Jun 2021 17:42:02 +0200
From:   Greg KH <greg@kroah.com>
To:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Backporting fix for #199981 to 4.19.y?
Message-ID: <YLpJyhTNF+MLPHCi@kroah.com>
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com>
 <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com>
 <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 04:50:19PM +0200, Laurențiu Păncescu wrote:
> Hi Greg,
> 
> On 6/3/21 11:19 AM, Greg KH wrote:
> > That commit does not apply cleanly and I need a backported version.  Can
> > you do that and test it to verify it works and then send it to us to be
> > applied?
> 
> I now have a patch against linux-4.19.y, tested on my EeePC just now: the
> battery status and discharge rate are shown correctly.
> 
> I've never submitted a patch before, should I put "commit <short-hash>
> upstream." as the first line of my commit message, followed by another line
> stating which branch I would like this to be merged to? Should I also
> include the original commit message of the backported commit? And then use
> git format-patch? I just read through [1] and [2], but they don't say
> anything specific about commit messages for backported patches.

Yes, what you describe here should be great.  Look at the stable mailing
list archives on lore.kernel.org for other examples of this happening,
https://lore.kernel.org/r/20210603162852.1814513-1-zsm@chromium.org is
one example.

thanks,

greg k-h
