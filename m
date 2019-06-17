Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D743C48192
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 14:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfFQML3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 08:11:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42387 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFQML2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 08:11:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CF00214DB;
        Mon, 17 Jun 2019 08:11:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Jun 2019 08:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=aXGkzSCZkb4oPoMyz+3wo1NF4tM
        qm2Uq4GOcYFwyqcw=; b=oiPwqllXZ/bEytOXqIGpL9CnIallBCTxUY1uGnnlFwa
        ogMmJefRJtI2WmDOptmSQap3lSev/XdAJLEEpy/SdWntG561GhS9W09aHcDBJzE5
        oHju90poC+kwAJTiBX+c/LfNUs5q9WiIlnUc7O/JDkwx9JCV0a6Z/1+xV6LBMvaE
        M/XFsxgzzXAP4P37niZI4nuDEcMriiT/H6l1ADLO+rC6QqoBxGqcW2OxCGMrsJSW
        vS4jeIzi2HVjSuu8LX8vQt9zovf/OcJMvCRpuoj4ptW61L0gWidJbzo6zyENcUgy
        f+uIYHZZRmyPAyTANHPeQXQGu/aV8plT6HH6JaznQJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aXGkzS
        CZkb4oPoMyz+3wo1NF4tMqm2Uq4GOcYFwyqcw=; b=q/RaJxqiBPHWmHika/G/qM
        PcJsqLeUfgp73SmBy+dh4lYz7wzqRwlacCCfQMwqRshk7IeSE8pe5IU+MIKLFZs7
        MyXMSk6EXp7MsBMzvboNK1AF64dpCpa2FH26OX6x6AaEiOWs6J9MvY0R0qwjD9xA
        WnjV4w/+26KbdHovZIQOPdIrd3fA4uYfag3Nqs0VUSKQ3SxVKmK93NMJtNF/zA9p
        hdwWY37mT0it45mY029ez+KnGwRvweCIz+CEvpjeK5PxIOjIufoRG+zNSKouYRgz
        atQeEW/OjOIXC1Y+8RdxhfZ+HgZRmKa9NNRF5huwgKhkXTtUgMMEW9XOGbjuxAOw
        ==
X-ME-Sender: <xms:boMHXSF6dNXFncDB20mkVOGsrVGvswliS-9aCIXac9QKfvBz67vyCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeijedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:boMHXU3ChH4NhnaWLpUcVKSw_Rws24Fs32mKrqbLGvCm-XW7PXKsfg>
    <xmx:boMHXUx3LL9cZUPJ0r-A8f7JyRO9Z5JQnk4o_y0SSXCeyofFM3-EmA>
    <xmx:boMHXeElhoABSxsn0K-bFTjSF8d-CeziOIwdpWewrNCsYqr4OHPn1w>
    <xmx:b4MHXdv3YeklGKjUpTss-XWJGRXN9fTTzIguTSt0-og9issI5nXzpg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF35738008B;
        Mon, 17 Jun 2019 08:11:25 -0400 (EDT)
Date:   Mon, 17 Jun 2019 14:11:24 +0200
From:   Greg KH <greg@kroah.com>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     stable@vger.kernel.org,
        Erik =?utf-8?Q?=C4=8Cuk?= <erik.cuk@domel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: rtc: pcf8523: don't return invalid date when battery is low
Message-ID: <20190617121124.GB1456@kroah.com>
References: <877e9qt8d1.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877e9qt8d1.fsf@tarshish>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 07:30:34AM +0300, Baruch Siach wrote:
> Hi stable kernel team,
> 
> Please consider upstream commit ecb4a353d3afd45 ("rtc: pcf8523: don't
> return invalid date when battery is low") for stable backport. As the
> commit log explains, this fixes bogus system date when RTC backup
> battery is low.  With this fix date is set to the well known 01-01-1970
> value instead.
> 
> This commit should be applicable to v4.9+.

Now queued up, thanks.

greg k-h
