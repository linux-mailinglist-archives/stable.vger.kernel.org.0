Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F563D56D7
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhGZJMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 05:12:36 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49393 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232861AbhGZJMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 05:12:31 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B6DA15C012E;
        Mon, 26 Jul 2021 05:52:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 26 Jul 2021 05:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=TjWWjtIOBpNtfDW2Mh1BVmSMBqU
        eTyEtVH2RUwg/IPo=; b=khICU63M95XeIkIjF8T/vC3BzhkskQKpxsEb1zAPHA2
        65qN7dsYVmS6xONYpFe3hxrN5NZVknhypxUJk7jTuUaEmYhtA0rYZ8X7bOCucoZq
        KiYw7w4DaW0BzMzRmRxUpN63+amUMscgz12C8+1+z6xV9Tse/DOs1HZpUZjAEKg5
        sojQKs0EnygUMrAxGancgY/laig1dctLF/ebGjqi25gHSxZmP1u6THwRYpvQ2A/h
        QTmIdbb+zFcvOR1Q4pw2IZy8tOht4y7vT/yYwKueWoP7y7V8b3puHKmKA7SvQHMr
        4aP5v6xZaCMm1Bzd9BeMkXYbQ4Y9LJ1RwaAC284zvzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TjWWjt
        IOBpNtfDW2Mh1BVmSMBqUeTyEtVH2RUwg/IPo=; b=dId8/CZ6OoHgVh6methh3R
        wDKvoleL9WuHgqNjOSjpMcKn2pmrhjt3yjndMMiulKQ84qaoZXWf9V7gnp4kL/kJ
        I8ViLwlVF+HxOtmYA7dNhJGMviL7Fsta5hBb4JH+fjjGfmhBBOzawfokc8i+yWd8
        Nj5BL500eniJPgi/c3NvHlXCQszvvgSffUtQltJz1dNzUAW3hm0TL9wnVIQDnDGc
        3oYCypoKFeO+QOd3Uciqnz7yBn+LnH8pk6jYLdHtm0F5YOb76BXBX5E6ivrYmmvB
        JEDXqbt4WsBTgY2YZv8NFtIcrccT0NqYOkFyVbck+bZ36CQrKPbKCS2DiGDkE27A
        ==
X-ME-Sender: <xms:-4X-YH3Izxz82Mn1YhxI6MG4MLi88QKoRaKAxWH6hh30-TsxZU0LNw>
    <xme:-4X-YGHHynNVv0s03vuVA8KhEePkbZf8iZgq75yJZWRyxGGlTT0Lcbjx9ogLFq-f-
    EZH1QnmiBKYpA>
X-ME-Received: <xmr:-4X-YH5iRF8CigUXfEPjsOUUc_MOytJxN2u6pwuELfG9tADouUe0wDizWxarUG3cvGuJQ8_90DkKnvGifi-YdXmUmpZGJFtW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrgeehgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-4X-YM2PplVyKY8yAZ7IRKt0H_c0glj2acg1UpMazqCbYjv_O1U7Kg>
    <xmx:-4X-YKEsXbAZw5lCksAA2_9nncTr7HKX1GTLvSz3xDPpfAcKtpf3MA>
    <xmx:-4X-YN9CFxHGTzEw-_nTywcvVUpWT67jnoa9gZyhyiBjlPgvVhgPvA>
    <xmx:-4X-YP5GZFQaGGUDs60h1AAHu43T3kjW3HYL9Ihg0L0CgpVS7pIiuw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Jul 2021 05:52:58 -0400 (EDT)
Date:   Mon, 26 Jul 2021 11:52:56 +0200
From:   Greg KH <greg@kroah.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
Subject: Re: Patch "spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG
 delay" has been added to the 5.4-stable tree
Message-ID: <YP6F+LlrpDqG3i2Z@kroah.com>
References: <20210726024900.3BE0C60F47@mail.kernel.org>
 <e8f0f5b3-c413-0f72-d94d-84833d7e771c@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f0f5b3-c413-0f72-d94d-84833d7e771c@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 11:45:20AM +0200, Marek Vasut wrote:
> On 7/26/21 4:48 AM, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >      spi: imx: mx51-ecspi: Reinstate low-speed CONFIGREG delay
> > 
> > to the 5.4-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       spi-imx-mx51-ecspi-reinstate-low-speed-configreg-del.patch
> > and it can be found in the queue-5.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> There is a subsequent fix for this patch posted to the SPI ML, so please
> drop this for now.

Now dropped, thanks.

greg k-h
