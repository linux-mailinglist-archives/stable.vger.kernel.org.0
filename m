Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECCD13F7B
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 14:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfEEMys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 08:54:48 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:53523 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbfEEMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 08:54:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B5D3C349;
        Sun,  5 May 2019 08:54:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 05 May 2019 08:54:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=RY3wovewi9AvozTWYkB4FWTt5Os
        MI612SS/7SLmA00I=; b=sKoHSDFC4U1j8E+IMSPFPx/unJ+RbHJ5gRKl8AXW6vk
        ZcGav9zLALkBl7Q4HzDEXe0vp5Bdb2GuEOUAPlzkA2DiuqsShcZw2DSj4vmBhbu3
        cmwqEPJlfMB079giOcAkRpNJ4pQtPhs+P9yORKyr3gEEjaJAwdOa75yG4Bzew8ik
        vyRa9A8oFVIb7wOFTHrWPjnW4XCsx73ZnF+OcUt3P2F0D5qqyvdVgNJlDcH220pZ
        MPmU+JbjpjnpUuu4L3p6wO+Uqx7eWc3HIZvFe8s5PJtAor0FPIIFdWCLac8OwfEt
        rwrB4tPM32JD30VC0RVUi0mvoH9dzYBjvxR/cI6Ageg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RY3wov
        ewi9AvozTWYkB4FWTt5OsMI612SS/7SLmA00I=; b=vQT+zCk4tWCTp4TM1joTIK
        ViCNfmr67XPydHBB+FvTHV/rzBPHBaVD2L3dn4Wz7TcneaVbE67keesPk9XgfSk/
        BmdH4ZsVeE30yb6hJCILzB+aRilV9PgyGeS90tJ5MxPz/VHXIWkFDgZGDY+nFs2e
        pBOtw6JoJ/Rz8W9rrXe1J3SbtMNX6IMnsdUbcFrRDeaAnNPoMrLFYJoROsgn8GaV
        hyagBlR0s9tYpdDTx0k3j75yiE50amEcOQRjVS8DFSgEGec7irekLDRiJEbnsZbT
        27CzDNDz18NhJSCS65LZwixbkpuaINXPXZYeEfMhoPhkJbWwSBpba0jarWWPY5Tw
        ==
X-ME-Sender: <xms:E93OXF05a0rjy0VguIUTnLiWOsI2x-iHavNLErtJB076f2rqWlmyCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeehgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:E93OXDEi3bPadcCxpiQ_LaVGq3lL3nM12txPocyldSs6KSnc1CXrGw>
    <xmx:E93OXCPSd2IjiznJIZfzig2THJs_8C1PMhGAHOFis-n1qgiA4qXk1Q>
    <xmx:E93OXJuBkYRI2hWTdWeTraInwz-67cCYhFvxDCbBMnxpXVMD_egeBw>
    <xmx:FN3OXEEohXIMIAxRrdlQIaK4K_QeI7S_EfX1GQIZs1IrBgCDcsntgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8EAEE4122;
        Sun,  5 May 2019 08:54:42 -0400 (EDT)
Date:   Sun, 5 May 2019 14:54:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: Prevent runtime suspend of adapter when Host Notify
 is required
Message-ID: <20190505125440.GA25640@kroah.com>
References: <20190430142322.15013-1-jarkko.nikula@linux.intel.com>
 <20190430155637.1B45E21743@mail.kernel.org>
 <7f989564-e994-5be6-02da-2838639efe59@linux.intel.com>
 <20190502153251.GG81578@ediswmail.ad.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502153251.GG81578@ediswmail.ad.cirrus.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 04:32:51PM +0100, Charles Keepax wrote:
> On Thu, May 02, 2019 at 03:32:24PM +0300, Jarkko Nikula wrote:
> > On 4/30/19 6:56 PM, Sasha Levin wrote:
> > >This commit has been processed because it contains a "Fixes:" tag,
> > >fixing commit: c5eb1190074c PCI / PM: Allow runtime PM without callback functions.
> > >
> > >The bot has tested the following trees: v5.0.10, v4.19.37.
> > >
> > >v5.0.10: Build OK!
> > >v4.19.37: Failed to apply! Possible dependencies:
> > >     6f108dd70d30 ("i2c: Clear client->irq in i2c_device_remove")
> > >     93b6604c5a66 ("i2c: Allow recovery of the initial IRQ by an I2C client device.")
> > >
> > >
> > >How should we proceed with this patch?
> > >
> > There's also dependency to commit
> > b9bb3fdf4e87 ("i2c: Remove unnecessary call to irq_find_mapping")
> > 
> > Without it 93b6604c5a66 doesn't apply.
> > 
> > Otherwise my patch don't have dependency into these so I can have
> > another version for 4.19 if needed.
> > 
> > I got impression from the mail thread for 6f108dd70d30 that it could
> > be also stable material but cannot really judge.
> > 
> > Charles: does your commits b9bb3fdf4e87 and 6f108dd70d30 with the
> > fix 93b6604c5a66 qualify for 4.19? (background: my fix doesn't apply
> > without them but doesn't depend on them).
> > 
> 
> b9bb3fdf4e87 ("i2c: Remove unnecessary call to irq_find_mapping")
> 
> I don't think this one would make sense to backport it's not
> fixing any issues it just removes a redundant call. The call just
> repeats work it does no harm.
> 
> 6f108dd70d30 ("i2c: Clear client->irq in i2c_device_remove")
> 93b6604c5a66 ("i2c: Allow recovery of the initial IRQ by an I2C client device.")
> 
> These two are much more of a grey area, they do fix an actual
> issue, although that issue only happens when you unbind and
> rebind both an I2C device and the device providing its IRQs. A
> couple of us have been trying to look for a better fix as well
> which further complicates matters.
> 
> I would suggest you just backport your patch and leave these
> ones. As evidenced by the fixup patch there is a slight chance
> of regressions from backporting this fix and the issue it
> fixes is clearly not something people are normally hitting.

I've queued all of these up now, as they make sense to have for 4.19.y.

thanks,

greg k-h
