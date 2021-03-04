Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734E932D454
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241385AbhCDNkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:40:03 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42667 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241264AbhCDNjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:39:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1F9DB1408;
        Thu,  4 Mar 2021 08:38:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 08:38:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=p
        xdxNshUnDFciKv9hucSlKKTBMVhzojqwaY6cFXIHBg=; b=sVui7dgTYACesSokc
        3IV8s64ZW7KBjFxTctjYbLREdz6WD6ajF6Equ15ZVUL9EtbXML81aUaqNjJgwJHj
        eHcBaXDiksTLMJJBwDa3qhTuJ42M+j5m161/j3/8hrKqZdFkY+5aG84PzjK49Q3o
        B+c613tosQdueMvwXHh6cV6FuOC84+LhWL0aRZhXvhheaOhiMvBfrTIjE69OdL61
        QKVTY2DVFJF0hJGx4c5Q3d9q5auaO5U5YqRiefdRJlBIO2GJN4TD8eeg4oC2EN9U
        ycNLiuZHAw5gbBOGmF9LlLvWjHpw9a9ETD9Ib/kZlBXQOM1JJN3L/q7RVSMaYEOg
        u5tGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=pxdxNshUnDFciKv9hucSlKKTBMVhzojqwaY6cFXIH
        Bg=; b=A26cLMQzvofs77HJ8OkvGHDxqxINyVTlVQTTnMQAbIQW3agVYzzkeJp4i
        IG1BzdxLNvFYtWSCrt+jKM/J/ZPv+cgq2WHsCZwhyLwV5e+jtLgMam77Y71R8far
        ZnrxxkNekH1dkREoIBJibYwPazSOEz1GMXhhX5Him8UsyPIdkPjfCTyUl5lqWVwG
        2SY4ghx6t7Zxh1FIig15otXlcoi2gKbOTNkO+GjKAj8a5c2WnOxX2B64YtBIbd4A
        +WBZ8wOKjEe+b0WSEZS69sdsX8s8wBA7gwJmht5mqO+QpdmGPcC6fXPdPmHrDZDD
        O8aVxliYHJKWB7sm1V4GFaTZzP0rQ==
X-ME-Sender: <xms:5OJAYJ23MVXPrFWe8LOcTp20Sb6gNMeFI2B8nKNwBtPfQTMJ4kF37Q>
    <xme:5OJAYAFY1KPBBcp0bZEJyqkwSPHIS85c6GzvTl_kjs-7-4YIYXew-hHWxmvYe61_o
    qfClJz0aAqwoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvdffgf
    euieeuhfehveehtefghedvfeegkeefveeujeeffedtteduteeihfehffdvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:5OJAYJ62xn7fIAEVCI24deWiwnQzlLgNvUfy2n54O1iKRTPtTEHuZg>
    <xmx:5OJAYG0hOSXfL8GOgF8DnfvUU5PE9MpahlGEcN2NZ2Sb3V5eWiwuCQ>
    <xmx:5OJAYMHtGsCePVBp78hCYZG6dPndN7Q6bfnK724-l0vFSytTy66waA>
    <xmx:5eJAYAA0wlGYCvpOjzdltstPZxoNM8zVeyIlw0jGx6ViVcRcsTWqfA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 409491080054;
        Thu,  4 Mar 2021 08:38:44 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:38:42 +0100
From:   Greg KH <greg@kroah.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     stable@vger.kernel.org, jingle <jingle.wu@emc.com.tw>,
        kernel@pengutronix.de, linux-input@vger.kernel.org,
        'Dmitry Torokhov' <dmitry.torokhov@gmail.com>
Subject: Re: elan_i2c: failed to read report data: -71
Message-ID: <YEDi4m04qYrPvkxp@kroah.com>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
 <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
 <YEA9oajb7qj6LGPD@google.com>
 <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210304065958.n3u5ewoby6rjsdvj@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 07:59:58AM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Mar 03, 2021 at 05:53:37PM -0800, 'Dmitry Torokhov' wrote:
> > On Wed, Mar 03, 2021 at 09:03:30PM +0100, Uwe Kleine-König wrote:
> > > On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-König wrote:
> > > > On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
> > > > > Please updates this patchs.
> > > > > 
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=056115daede8d01f71732bc7d778fb85acee8eb6
> > > > > 
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?h=next&id=e4c9062717feda88900b566463228d1c4910af6d
> > > > 
> > > > The first was one of the two patches I already tried, but the latter
> > > > indeed fixes my problem \o/.
> > > > 
> > > > @Dmitry: If you don't consider your tree stable, feel free to add a
> > > > 
> > > > 	Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > 
> > > > to e4c9062717feda88900b566463228d1c4910af6d.
> > > 
> > > Do you consider this patch for stable? I'd like to see it in Debian's
> > > 5.10 kernel and I guess I'm not the only one who would benefit from such
> > > a backport.
> > 
> > When I was applying the patches I did not realize that there was already
> > hardware in the wild that needed it. The patches are now in mainline, so
> > I can no longer adjust the tags, but I will not object if you propose
> > them for stable.
> 
> I want to propose to backport commit
> 
> e4c9062717fe ("Input: elantech - fix protocol errors for some trackpoints in SMBus mode")
> 
> to the active stable kernels. This commit repairs the track point and
> the touch pad buttons on a Lenovo Thinkpad E15 here. Without this change
> I don't get any events apart from an error message for each button press
> or move of the track point in the kernel log. (Also the error message is
> the same for all buttons and the track point, so I cannot create a new
> input event driver in userspace that emulates the right event depending
> on the error message :-)
> 
> At least to 5.10.x it applies cleanly, I didn't try the older stable
> branches.

Now queued up.

greg k-h
