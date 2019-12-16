Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34118120725
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 14:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfLPN1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 08:27:54 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51695 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727601AbfLPN1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 08:27:54 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B2FC1727;
        Mon, 16 Dec 2019 08:27:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 16 Dec 2019 08:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=Y
        mViL70LTOh/d2HUWHm4SX1kRjzqtzPlz629CD92l7o=; b=g5559xHV/ZCMjWQRL
        UWI/pqUKEGOqkKg+bsWfTrrpEDpqnV3jhvtF0IUVbhi8Jlzm7+78bXTjiID/tqTt
        mY1CCAuOauItpHcX7/RUb2bYdoyBbCgLBdtXgUGXnSQ42XVouKfLdhRq5YQbKw9U
        03E5CNvw9hC5f72JXyjeM5MiCpurESr2T+lrtjinFGsZd/GKb+KJuSeyTC+LeoBE
        alfTXc/6OXr6p1edPOecWQp2Hz/XoJwQQdla9AR6mXlMI+niKkDf+abWMcN0Jg5L
        WhxiUrBRdCwCqfQdHzzxFDhGfzWt7nxS4kNmMOvkRcoLaXQd1wOHqa/GfS6BMaof
        SrTFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=YmViL70LTOh/d2HUWHm4SX1kRjzqtzPlz629CD92l
        7o=; b=cLhqAmDna7VjQ9383OzQsmzNRRFn+BLWtqAEe3oHZhAm9L4rIAEN8kAR/
        V3f2jyIByYkBIOxTQ+7UDKlFnBOrRZIxTWpFUkRtdOirLWraFVsAvdwpbjFKwyG3
        PB4qJN0Q7xdLVGwD0NLLD7a/eT8UJm6KQjcYyW5kutR1BZ2URimqpCicSiIJ/Fgh
        QvWUabgX39A3jr81lUc0JYDdg8LHA9RWhVGoyBxV22ah1PCLE9YTkN7NIJ+8CNwL
        4x5IITF/gmXt73slDHHqmKnBZ0SAdySnq9MUGVV0Kjkw7pdwQGjf/dWYfgjLbmec
        75XItDwCituwprizpkesg3eOYXnXw==
X-ME-Sender: <xms:V4b3XZf5TJsqQm6TdDA2OZMRNdtH63WcOi5z3ON7EyiBheZ7fFiNZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddthedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:WIb3XaOl1strmbI1xe_6r_gUUNxH1Vy7X7GsRXsF7EoLpm7LU7oFNQ>
    <xmx:WIb3XeL6fIs7EUe61HNSlxHyMDL1qg-m0lFucPi8_5Yzrbjpi-xJsg>
    <xmx:WIb3XRppvTTLMJArPhfvq6M9R9whCHoN3hQJZxFvDJCtoS-KHjQB1Q>
    <xmx:WIb3XSp1VyLOH-z42TfhxpbUlL-3Y-5ZSTjSsGTFvFz6JXnKAVGe8Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFAAF306010D;
        Mon, 16 Dec 2019 08:27:51 -0500 (EST)
Date:   Mon, 16 Dec 2019 14:27:50 +0100
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 133/350] Bluetooth: hci_bcm: Fix RTS handling
 during startup
Message-ID: <20191216132750.GA1646935@kroah.com>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-94-sashal@kernel.org>
 <20191216131512.c5x5ltndmdambdf4@core.my.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216131512.c5x5ltndmdambdf4@core.my.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:15:12PM +0100, Ondřej Jirman wrote:
> Hi,
> 
> On Tue, Dec 10, 2019 at 04:03:58PM -0500, Sasha Levin wrote:
> > From: Stefan Wahren <wahrenst@gmx.net>
> > 
> > [ Upstream commit 3347a80965b38f096b1d6f995c00c9c9e53d4b8b ]
> > 
> > The RPi 4 uses the hardware handshake lines for CYW43455, but the chip
> > doesn't react to HCI requests during DT probe. The reason is the inproper
> > handling of the RTS line during startup. According to the startup
> > signaling sequence in the CYW43455 datasheet, the hosts RTS line must
> > be driven after BT_REG_ON and BT_HOST_WAKE.
> > 
> > Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/bluetooth/hci_bcm.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
> > index 7646636f2d183..0f73f6a686cb7 100644
> > --- a/drivers/bluetooth/hci_bcm.c
> > +++ b/drivers/bluetooth/hci_bcm.c
> > @@ -445,9 +445,11 @@ static int bcm_open(struct hci_uart *hu)
> >  
> >  out:
> >  	if (bcm->dev) {
> > +		hci_uart_set_flow_control(hu, true);
> >  		hu->init_speed = bcm->dev->init_speed;
> >  		hu->oper_speed = bcm->dev->oper_speed;
> >  		err = bcm_gpio_set_power(bcm->dev, true);
> > +		hci_uart_set_flow_control(hu, false);
> >  		if (err)
> >  			goto err_unset_hu;
> >  	}
> 
> This causes bluetooth breakage (degraded bluetooth performance, due to failure to
> switch to higher baudrate) for Orange Pi 3 board:
> 
> [    3.839134] Bluetooth: hci0: command 0xfc18 tx timeout
> [   11.999136] Bluetooth: hci0: BCM: failed to write update baudrate (-110)
> [   12.004613] Bluetooth: hci0: Failed to set baudrate
> [   12.123187] Bluetooth: hci0: BCM: chip id 130
> [   12.128398] Bluetooth: hci0: BCM: features 0x0f
> [   12.154686] Bluetooth: hci0: BCM4345C5
> [   12.157165] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0000
> [   15.343684] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0038
> 
> I suggest not pushing this to stable.

Is it being fixed in Linus's tree?

thanks,

greg k-h
