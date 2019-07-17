Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0C6B589
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 06:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfGQEZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 00:25:03 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:42199 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbfGQEZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 00:25:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F00AD3D5;
        Wed, 17 Jul 2019 00:25:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 17 Jul 2019 00:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=u
        /vTgkg4q1aOF98B1s0yLdLnNIc01pk6ZRJn0ycJ46E=; b=lh0JiCC6dIdY77pjT
        Q7LUIAUtvR+lkkTTzJ19gZSWdDuhvzrNdVDCqi0e80dcTc9Zq4liYSfhH7szgc1M
        jGUlHvARr4x9/Tc0eG0MrmBtBRKjse8BJ5scFe3YrDXyAOrPG91t4czDNcGmSzNR
        RuDipnIDmjcfvfToWbcXvYZIqpqrqhsWlSPEdZJd+B/MsIqr2RvQ9ZjroYekD6/l
        KkooUAy3ddmayfUI5pnjSIKQD+b8Wkwh7owDxCXLbMXkIbnf1EGwbmX7RZIy4pYz
        BN3C8s6Wky0KcwEU8oX4BU0SiJUY373YEY/Mf93ghKsCbV01yEzGd3RkRe42N5Z6
        Cxkhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=u/vTgkg4q1aOF98B1s0yLdLnNIc01pk6ZRJn0ycJ4
        6E=; b=hDhN6bcSObmcxY52Vi6ES3BBNKlHGSCYi+ns6jTWpLXI64ukqjROR2DAJ
        0PpfmJNaOLRzdtXAmbGrBzIqkr3Oi2pByq4BPoaHdqpp+4wE7wmB5+HWW27F3Y2a
        rSFNAXP+gVGZ7lBeD5VFH4b6onVZBHg56XynDUyyMxH+lwv3+VEK6/yCEWXEbeD/
        w/iiRwL+lzcqyeJJXuueXI2SfRu21y1nSeGZZ6sn39YyWdnTItvgNUEqQUVhM5LP
        QQw0r8LO0EDNj3NuaJO/dn38XjRM2Aa3bd1i4AH01Pre75FoSDWSnJlYSkk7edGG
        5iNMvz1eKsUCbDzY6lFV6NQJ8qWFw==
X-ME-Sender: <xms:HKMuXTyajO5qiesRmxaxvVt32tUPJNS2MaDsgwgf7ndRjkYk3FmxOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddriedugdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepvddutddrudegkedrgedvrdduudehnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:HKMuXXmAat3_nojmXuJUbhmAHs0CtOfEMN52PQQxsRc2AWh_oK9ZfQ>
    <xmx:HKMuXQFzUGL8N9le2Yu90IcIZIeuOQqCVwJwlyh05lehGezmfgsbBA>
    <xmx:HKMuXfV8E981fRj1U2BhNboWZS1HRVCCaEbwSSLx6DW_UfNC8oSFjQ>
    <xmx:HaMuXSBsbj9f4NAhStbtLsR8GH7pbb7ColuZdnnFO3Kb5MLxdImNAA>
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5099480059;
        Wed, 17 Jul 2019 00:25:00 -0400 (EDT)
Date:   Wed, 17 Jul 2019 13:24:52 +0900
From:   Greg KH <greg@kroah.com>
To:     Cyril Brulebois <cyril@debamax.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        charles.fendt@me.com
Subject: Re: [PATCH 1/3] ARM: dts: add Raspberry Pi Compute Module 3 and IO
 board
Message-ID: <20190717042452.GA11571@kroah.com>
References: <20190715140112.6180-1-cyril@debamax.com>
 <20190715140112.6180-2-cyril@debamax.com>
 <860468a1-df13-cb6a-6951-455cf72ad4a0@i2se.com>
 <20190716091122.GB11964@kroah.com>
 <20190717020459.g3qgvwpqxlym27aw@debamax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190717020459.g3qgvwpqxlym27aw@debamax.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 04:04:59AM +0200, Cyril Brulebois wrote:
> Hi Greg, Stefan,
> 
> Greg KH <greg@kroah.com> (2019-07-16):
> > On Mon, Jul 15, 2019 at 05:26:16PM +0200, Stefan Wahren wrote:
> > > Hi Cyril,
> > > 
> > > On 15.07.19 16:01, Cyril Brulebois wrote:
> > > > From: Stefan Wahren <stefan.wahren@i2se.com>
> > > >
> > > > commit a54fe8a6cf66828499b121c3c39c194b43b8ed94 upstream.
> > > >
> > > > The Raspberry Pi Compute Module 3 (CM3) and the Raspberry Pi
> > > > Compute Module 3 Lite (CM3L) are SoMs which contains a BCM2837 processor,
> > > > 1 GB RAM and a GPIO expander. The CM3 has a 4 GB eMMC, but on the CM3L
> > > > the eMMC is unpopulated and it's up to the user to connect their
> > > > own SD/MMC device. The dtsi file is designed to work for both modules.
> > > > There is also a matching carrier board which is called
> > > > Compute Module IO Board V3.
> > > 
> > > this patch series doesn't apply to the stable kernel rules.
> > 
> > I'm with Stefan.  Cyril, how do you think this matches up with what:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > says?
> 
> First off, I'm sorry to have wasted everyone's time with this attempt at
> getting the DTB addition upstream'd so that other distributions/users
> could benefit from it as well; it's now been included downstream
> instead.
> 
> 
> stable-kernel-rules has this entry that made me think this would be
> acceptable:
> 
>     - New device IDs and quirks are also accepted.
> 
> To my non-expert eyes, a DTB looked similar to a bunch of device IDs,
> mapping specific hardware to the right modules and parameters. I thought
> that allowing device IDs to be added, mapping new HW to existing and
> known-to-be-working modules, was similar to what's happening with a DTB.
> 
> 
> In hindsight, looking at say 4.9 or 4.19 (baselines for Debian kernels),
> I see that DTBs were fixed but never added. Maybe having an extra “(DTBs
> don't qualify)” in the documentation might prevent others from making
> the same mistake?

I don't think that anyone has made that same mistake in the past 5+
years that I can recall at the moment, so adding more text to the file
probably will not really save us many issues like this :)

thanks,

greg k-h
