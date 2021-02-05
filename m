Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC831053A
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 07:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhBEGzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 01:55:52 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41473 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230415AbhBEGzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 01:55:45 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 24A7F4E0;
        Fri,  5 Feb 2021 01:54:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 05 Feb 2021 01:54:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=cpdqHFAP/ZgCSsQGHyNAf+SemKK
        m+IyMVPQ2A6yHkbk=; b=EErDkAVCLuZqZ/qCluF3af0UxCkTF5hH+hMzODbPuQB
        qVsrcwJt6X3eUjezWZijSNUSGUfdSk/RHn8laCJDbO9gt48Z6IbLV7IzwH9W++wY
        K94YcTwhcobKjlYoG1OiWad9+ic+zmLKcrwIIcB0tiXz5lnmfCZXMAk6Yi8MKfWU
        6kI45VjScrKH+sVizKsVKLHereoOT1NcxnSqwLnCZyOe6uQ9JcZs1iU0EY1yuzQP
        POCBp4OcyETb9q/F34Wo8IygTylVdNjJDHeX48uVyBriv0nMV3zb1hxlcLOwFKj3
        FubdGFVj2B7q7vNP84UTtm1Qk13Ss4Z8n1+WHWyQmlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cpdqHF
        AP/ZgCSsQGHyNAf+SemKKm+IyMVPQ2A6yHkbk=; b=mEkbWSolboWDaYEf8UvyoN
        SU2BTWTCk0Pyx4KRgk2c6XIUCaOckqpWBp8e7/HjYjyOjT8RXK7nxU8HU+GtCikC
        QoainnswER4Zcp3R3QJznTGrnH8X0B6RP2WxhYY3qy6UFRiz7ahrOTyCLuz+15uC
        NOeB10YvrQzlVz6D8xe1meGxQMx6Cxjc9LetQgEnoogdPgSBU1bkz9EUVTaNAc/Y
        QNM8ZTcSn7L3WvnciY289fLWBa2ZZGlNNjHAD9qDlNwFMlUyDa0YDqGrNmOa63Q9
        K/c0XlM9Glne5ghau58hyC8sThw/Rd3WMQFxOr15s2sSEheQFfY/eU9XJNGPFQwg
        ==
X-ME-Sender: <xms:wuscYNUdgd92jxzpuGkourSla-HtqJ3Y24rDX4X5Sv9DyTPs71wxuQ>
    <xme:wuscYPl8Rd1vumbxgQwa-OpwIu040g48qMUs4eelKMRvsgOg2rHcr2R4v4_Ov_dL3
    LpFqnh2r5feXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeehgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wuscYCxt3zBPnVROctmjg8dhVwMk_iZg6iQz8z8HAtlXkecAcJqqdA>
    <xmx:wuscYCj56_jVpTt8mOfv_6QoT9wS5ifYLvPlX1FBtu5AwV-leCEc9A>
    <xmx:wuscYPXy3SAy7TOteqI1INxLTTkFlZG_USaNpjMQEftT81CPdMIBWA>
    <xmx:wuscYGwguyGrC-hV2o2V5DgohMAR4SHvyQylpSfK0rxDAHuKcruUJg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D852524005B;
        Fri,  5 Feb 2021 01:54:57 -0500 (EST)
Date:   Fri, 5 Feb 2021 07:54:55 +0100
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: Linux 5.11-rc5
Message-ID: <YBzrv1U2SjMZTwnB@kroah.com>
References: <CAHk-=wgmJ0q1URHrOb-2iCOdZ8gYybiH6LY2Gq7cosXu6kxAnA@mail.gmail.com>
 <161160687463.28991.354987542182281928@build.alporthouse.com>
 <CAHk-=wh23BXwBwBgPmt9h2EJztnzKKf=qr5r=B0Hr6BGgZ-QDA@mail.gmail.com>
 <20210204181925.GL299309@linux.ibm.com>
 <CAHk-=wg49zd_Z2V7+djV-sCVia0=Gv3GNWz6MYsa7vG16Ya5Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg49zd_Z2V7+djV-sCVia0=Gv3GNWz6MYsa7vG16Ya5Sg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 10:32:56AM -0800, Linus Torvalds wrote:
> On Thu, Feb 4, 2021 at 10:19 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
> >
> > On Mon, Jan 25, 2021 at 12:49:39PM -0800, Linus Torvalds wrote:
> > >
> > > Mike: should we perhaps revert the first patch too (commit
> > > bde9cfa3afe4: "x86/setup: don't remove E820_TYPE_RAM for pfn 0")?
> >
> > Unfortunately, I was too optimistic and didn't take into account that this
> > commit changes the way /dev/mem sees the first page of memory.
> >
> > There were reports of slackware users about issues with lilo after upgrade
> > from 5.10.11 to 5.10.12
> 
> Ok, applied to mainline.
> 
> Greg & stable people - this is now commit 5c279c4cf206 ("Revert
> "x86/setup: don't remove E820_TYPE_RAM for pfn 0"") in my tree.
> Although maybe you just want to revert the commit in stable, rather
> than take it from upstream? Same difference.

Taking it from upstream makes it easier to track over time what happend.
I've queued it up now, thanks!

greg k-h
