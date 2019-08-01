Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA5457E157
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 19:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbfHARs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 13:48:56 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:47131 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731061AbfHARs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 13:48:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E4FE6396;
        Thu,  1 Aug 2019 13:48:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 01 Aug 2019 13:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=bX/6GL3MmE3TsjC8DdRXIIaWGw8
        ZWwDpfqNZvIz+x50=; b=TLGPm6FpkwCkrXEnN681cRBxD8DR3f5HztHK941Hm3r
        E9U8tj0cdDagkr5YtVKH6XGnZ2RW/SIyOWA+RwASMrUYKt4OUNuChZLb2xFcrqeI
        YK/IeRzroBdwoKWgGMrSh72B4yseWbFgaRxscGkilfKeosG14yuLEPMH8DOzk4sX
        78LHupKp93FaM4g5c6xMUaSF5JCTsU7YEpKLrDxCmMunVEs23QRocSnc+SCg6slC
        M8+VAPGxPEPUXPzfCuSqIfKW+IvHSr+y9sFSLu6r2LRvByDpPEx2ftLDdf9ZMQEH
        hlMslx33R7nvkGR5NvtOvSuTJiOMOlTOXQMNrXq75Jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bX/6GL
        3MmE3TsjC8DdRXIIaWGw8ZWwDpfqNZvIz+x50=; b=hHM5nPFIKZmq4qZVxcGfms
        XPLYsf6+/obWeyhSAvkVBI9727Y6RY0LOQJvdS67/9zMJaRKF3L3FjPv4vDaI26p
        bEkVCovXdYlgX5MfGx/n85sY6r8A8ELd9NITXRypn7XToC8pne4o4Ya+DuXKKBno
        nHh8KMnpglXpL2cEo9eKh48EY5N2u8jHi+fZ75OqbWiMWD5JVFd6t76S70yxYcU8
        7EqbyLm96F85JDZoI7r/9Bqv863YvGDsvVsSDK0fKGp3RaWmygWzc7Ib2Hf0A2FY
        WdV1VuLnUGmdpG8mUPwNL2xJFySgTi4XE5ufmbaMEtPBw6nKDX4ny5HePv1hu+bg
        ==
X-ME-Sender: <xms:AyZDXUQDjzU8sPlkQd-yVXHNJqyvOLmheWCD9bR4TQGyA5qjSuplZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleejgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:AyZDXVe99Dz8clGzgoNYIUgtdBZBdBq06aW8M_pnVYe1Q2qMdIAsLQ>
    <xmx:AyZDXboiSB299FPC4RaicydBJnq7m3D2XLTEkKFq2mFd-5zkyvBRyw>
    <xmx:AyZDXe9UT3p3PDNwM7C3NaJ0qGG_zawz8mYPJe_u90nb675zVtoSaA>
    <xmx:BCZDXdEP4nZOVGZsRznaGeWIHIpAcgk6bGIwyNbYayLOV8WbPkjW4Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E01CB380084;
        Thu,  1 Aug 2019 13:48:50 -0400 (EDT)
Date:   Thu, 1 Aug 2019 19:48:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vladis Dronov <vdronov@redhat.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5.3-rc2] Bluetooth: hci_uart: check for missing tty
 operations
Message-ID: <20190801174849.GA5048@kroah.com>
References: <20190730093345.25573-1-marcel@holtmann.org>
 <20190801133132.6BF30206A3@mail.kernel.org>
 <20190801135044.GB24791@kroah.com>
 <20190801171639.GC17697@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801171639.GC17697@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 01:16:39PM -0400, Sasha Levin wrote:
> On Thu, Aug 01, 2019 at 03:50:44PM +0200, Greg KH wrote:
> > On Thu, Aug 01, 2019 at 01:31:31PM +0000, Sasha Levin wrote:
> > > Hi,
> > > 
> > > [This is an automated email]
> > > 
> > > This commit has been processed because it contains a "Fixes:" tag,
> > > fixing commit: .
> > > 
> > > The bot has tested the following trees: v5.2.4, v5.1.21, v4.19.62, v4.14.134, v4.9.186, v4.4.186.
> > > 
> > > v5.2.4: Build OK!
> > > v5.1.21: Build OK!
> > > v4.19.62: Build OK!
> > > v4.14.134: Failed to apply! Possible dependencies:
> > >     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
> > > 
> > > v4.9.186: Failed to apply! Possible dependencies:
> > >     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
> > > 
> > > v4.4.186: Failed to apply! Possible dependencies:
> > >     162f812f23ba ("Bluetooth: hci_uart: Add Marvell support")
> > >     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
> > >     395174bb07c1 ("Bluetooth: hci_uart: Add Intel/AG6xx support")
> > >     9e69130c4efc ("Bluetooth: hci_uart: Add Nokia Protocol identifier")
> > > 
> > > 
> > > NOTE: The patch will not be queued to stable trees until it is upstream.
> > > 
> > > How should we proceed with this patch?
> > 
> > Already fixed up by hand and queued up, your automated email is a bit
> > slow :)
> 
> /me scratches head
> 
> The patch went out two days ago:
> https://lore.kernel.org/lkml/20190730093345.25573-1-marcel@holtmann.org/
> 
> How did it make it upstream already?

It's in Linus's tree as b36a1552d731 ("Bluetooth: hci_uart: check for
missing tty operations") now.

thanks,

greg k-h
