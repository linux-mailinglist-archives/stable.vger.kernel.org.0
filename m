Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70514360B1E
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 15:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhDONzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 09:55:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38609 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDONzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 09:55:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8EBA15C00E9;
        Thu, 15 Apr 2021 09:54:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 15 Apr 2021 09:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=P
        SbbnxKafh/POak88UobKK/g2kPDTLw7aUOdouRfrSA=; b=DuqglDF2rPxrSffr/
        4d1tmCHA8iZjRJzG//d9TzVCTZec8io52eWIakIGgMxWKeN6WrsLmzuFXPQ/CFRt
        ZDi6rEB7U70lzp3fi0hHkCJrnIZfhFa+Cgtk22mT3UO6KtcD+I3MtTUBlmePqphQ
        V4JS5IzAAuzn87vqRXRbCk+TVz5B36CT4xi6chT8vEXdwJDEf5mAibWLPR/ISevi
        lsH3YBIIUAxfWhSndEZsONLrHobIgksafcfbZjUY1074l8kpWWW8GArZxLE+4SGa
        ojbCX0aU+TK1oQVfk34CeLxVRKvYFrO/OuljPGIJWkGr8LRoS9qZTZAhfAeIo/gs
        yPLag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=PSbbnxKafh/POak88UobKK/g2kPDTLw7aUOdouRfr
        SA=; b=hwG6AVEx5DdnPGI8lnrVAcQ4gCwV6jbjIBQVFYxmAWoGacaaRNgC8qgep
        LA9BRG/TR3EB81yKdKNJ6nAc7BFxNw8lZUNitHI4BGo8Pqu+zgsieEszK9R4QTgJ
        XgAkFC/ntPKf9zIE35aQ74mwsU3/HhwDkRL/xYMgF8V4e5JB18L0zo+Hfr2qcaNY
        /pqFkM9VH66XRk1iBhWYcW3MwTek8Trhb4xv5VWeYd/S+DYiETMzjVw9QLIlCd+f
        x3WkFXMoC37crhuid5wq9ifmXMaLhpWlTAIgXepsnV+1vUYvikL5H68VV3frGUW0
        4TiufVwJYqM+2eIK8FLS4zmaB9smA==
X-ME-Sender: <xms:p0V4YEjmZI1OPmMQxIBAmt8Z-C8CMact9OqwmqRXnNiOuNPGh80C_Q>
    <xme:p0V4YHnKJAOrXeqWLSKFv2HmO4u8qTQsDSB-9Liqbk0bOZ4Br7z-i1nJgQsVwXp9_
    wlxfCD21MIZjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelfedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvdffgf
    euieeuhfehveehtefghedvfeegkeefveeujeeffedtteduteeihfehffdvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:p0V4YIr5PtMe-Wk9RroojkZ9rp3TIXrMWIiBpydRrGeR2f3Vsa7-ZA>
    <xmx:p0V4YIFxe-rDeqfmmTGg7PQnjCLuR24iSeUu-Uf-hWYo7ih-0Kw_MA>
    <xmx:p0V4YMyHC44_MIqNhAYIBLadXN-if9AIbm-RLGcKcedcV6AkM8BFMw>
    <xmx:qEV4YHd96brBtL-cJDtHqABgCslPAvr7eGNVPXAqIYzg3iu5G5uHnQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F0F324005D;
        Thu, 15 Apr 2021 09:54:47 -0400 (EDT)
Date:   Thu, 15 Apr 2021 15:54:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: sfp: cope with SFPs that set both LOS normal and
 LOS inverted
Message-ID: <YHhFpZZJLa23tlqW@kroah.com>
References: <20210412162833.17496-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210412162833.17496-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 06:28:33PM +0200, Pali Rohár wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> [ Upstream commit 624407d2cf14ff58e53bf4b2af9595c4f21d606e ]
> 
> The SFP MSA defines two option bits in byte 65 to indicate how the
> Rx_LOS signal on SFP pin 8 behaves:
> 
> bit 2 - Loss of Signal implemented, signal inverted from standard
>         definition in SFP MSA (often called "Signal Detect").
> bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
>         (often called "Rx_LOS").
> 
> Clearly, setting both bits results in a meaningless situation: it would
> mean that LOS is implemented in both the normal sense (1 = signal loss)
> and inverted sense (0 = signal loss).
> 
> Unfortunately, there are modules out there which set both bits, which
> will be initially interpret as "inverted" sense, and then, if the LOS
> signal changes state, we will toggle between LINK_UP and WAIT_LOS
> states.
> 
> Change our LOS handling to give well defined behaviour: only interpret
> these bits as meaningful if exactly one is set, otherwise treat it as
> if LOS is not implemented.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Link: https://lore.kernel.org/r/E1kyYQa-0004iR-CU@rmk-PC.armlinux.org.uk
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Please apply this commit to all stable releases where was already
> backported commit f0b4f847673299577c29b71d3f3acd3c313d81b7
> ("net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant")
> as it depends on this commit. The Ubiquiti U-Fiber Instant SFP GPON
> module has set both LOS_NORMAL and LOS_INVERTED bits so without this
> commit it does not work. If I checked it correctly patch should go
> into 5.10 and 5.11 releases.
> ---
>  drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)

Now queued up, thanks.

greg k-h
