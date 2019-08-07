Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809D68516C
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388801AbfHGQth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 12:49:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50667 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388783AbfHGQth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 12:49:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 529ED21B7C;
        Wed,  7 Aug 2019 12:49:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 07 Aug 2019 12:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=B
        fSCjn82aAb29n20rYVaN6jtI5PnXM2npbAFgVtJyqU=; b=h8+9YrFv5Dv3lgVSO
        4uXhIKCmIS6Yk0un1gAqjVcHnJiyQCNusEoj03KEjYaY+Ndy7rtMYwI3U4MRDDYd
        sC6jeXNn0Ymi4j84lnOChGvc8JMHLsN9B2iKug/c8LXS781p4xn2MA2IvG9lIRBW
        1gpt56VW+Rs0P3dv1jA7HUmxqElUUnB43yOIMxHuB9pUpg1vZTmxlHPGosFhmat9
        aJGcXRUiqB9VSMQi9BHPY3V8qKPbLmaCIuRfonEgOeoAKRhpGawXzW5Iu+OMMMrX
        TPHEKpCQXwa4+dMcm1TTlfoRLYXZ56p0sK/LcXTzLOzMwwVCyEvRtsWytzI3d4ae
        unwiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=BfSCjn82aAb29n20rYVaN6jtI5PnXM2npbAFgVtJy
        qU=; b=wTMim2E8A1So7qS7h4f/3LIfqowzgsjjOBhPDtEKcEAWr/8p5kpimjzET
        QJihE5igdeQAjKIWWxgp5edvGHrskE48qFVVIC1FAUiH/7u1cyziG3Gv01LrrKpI
        di7yGPgAgTJbOmfhVYJ1/33ajyXE8ep/8Z34kQCdpZF6WjdL27iLC+OFW/kceHQg
        QzJybFA8BiPGfr0jhcNkjmj9L0nlp6PKBOqHB2hcT3g7g28KweJV2VZmF0w89voO
        HQgFViuTZUneJNCbnQ4RNT1mSqpO2actuVvGWdgStd4dCFIxpxYzKatE/M2+Wz+6
        jetixAZ5btthLOm6uSRPEdL0ML1OA==
X-ME-Sender: <xms:HwFLXVFWDjpAHU4pBWzzWNPauH4Rf4dGqyUYHJzy3cVDX3QW-6B50w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:IAFLXR5W5cC95qAwkeipVvyUOoHX2TUqbrcoo4BussCGxfX_SxGCfw>
    <xmx:IAFLXWypV6-fV5XeswwokwuAUqGEnZYhUSlK0Q9ja9dTYFDxm7RmMw>
    <xmx:IAFLXX2KzfVlWJfI2xTBnlOdtSUYJVg_wqVZn-E1eISALzShgVzJAA>
    <xmx:IAFLXdXaLo4nmMMziZi7D8sT-mYonviBGKiwN1m_3xJAZOyTaJWUOQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 909E9380079;
        Wed,  7 Aug 2019 12:49:35 -0400 (EDT)
Date:   Wed, 7 Aug 2019 18:49:34 +0200
From:   Greg KH <greg@kroah.com>
To:     Major Hayden <major@redhat.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: Fwd: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue:
 queue-5.2
Message-ID: <20190807164934.GA31226@kroah.com>
References: <cki.81AEF59787.PJG8MSVVDT@redhat.com>
 <a3630be0-6df0-1421-2e30-39ee138cf9a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3630be0-6df0-1421-2e30-39ee138cf9a2@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 11:28:30AM -0500, Major Hayden wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> Hey there,
> 
> We are still working through some improvements on our platform and we haven't re-enabled automated emails to the list yet.
> 
> However, we did just stumble into this compile error for aarch64 with the latest patches in stable-queue:
> 
> > 00:03:02   CC [M]  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.o
> > 00:03:02 drivers/spi/spi-bcm2835.c: In function ‘bcm2835_spi_transfer_one’:
> > 00:03:02 drivers/spi/spi-bcm2835.c:768:21: error: ‘ctlr’ undeclared (first use in this function)
> > 00:03:02   768 |      tfr->rx_buf != ctlr->dummy_rx)
> > 00:03:02       |                     ^~~~
> > 00:03:02 drivers/spi/spi-bcm2835.c:768:21: note: each undeclared identifier is reported only once for each function it appears in
> > 00:03:02   CC [M]  drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.o
> > 00:03:02 make[4]: *** [scripts/Makefile.build:284: drivers/spi/spi-bcm2835.o] Error 1
> 
> Please let me know if anyone has more questions! The full build log is attached to this email.
> 

Welcome back!  Yes, this is a real error, your systems caught this at
the same exact time mine did :)

I'll go drop this patch from everywhere now.

thanks,

greg k-h
