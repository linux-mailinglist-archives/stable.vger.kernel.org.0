Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C5285B1F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 08:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfHHG5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 02:57:13 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:44347 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbfHHG5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 02:57:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CCC5E50E;
        Thu,  8 Aug 2019 02:57:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 08 Aug 2019 02:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=xtN+oAbZghktZpqeYqR8OZXkXUf
        Qoe45rIBTtgudSDE=; b=TjNvsXVx0Bh7RdB1Ba0YLmIxyKinBmlWDvGePTJxsVE
        IHC0EER5K+p8oMoKB5fpceBzgioxm0p72f8Gz9A3ybGytUyV5fufUWWNmwP8r1KU
        xVI61D7bEGVyL+SG+O25T7uCvrFVpdx0HxAri/B51h0CCupTIAJ3ezDETMN12pvy
        GrRtIXxnzkFl2tWNhqixxCdE8glyJp1GhB5D8DfOqZJOJlELpdFpZ/o6KERUqV9X
        Cq0Ne1BPauioxXUVU8zYC8UbEdA2PviXeAAK9nnALloPXT2MWGqHEkXrVwBECUcl
        oLEkNf0hzYoiP74/7GuzesEO93zQVQnkPv523MtpH3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xtN+oA
        bZghktZpqeYqR8OZXkXUfQoe45rIBTtgudSDE=; b=aJU8tv/JrnrmzPg2Uc0/rt
        sRU+WzMQKYFygCySOoRA5VVwy6Cy89yMiEInzTJKIp4tTx7p4+Zh9RiXdKhNry1h
        HUNztNKQm+WKQYVZjuFzUQJI4E/0/dArttlLF9xa2gqdB1GOgjrXaD+wEp6cf/kw
        DmW7VjikITDcfddD3RrCYL/EQ5Z8FSh8yoNSAaM6DV1nd8fikOmpP7Nont6JdZtk
        HcGXPonAZYAOHjjVRq//aDaqAqzDQTWxonsU7LrPknpjSJWSq0Y8rwWKW9Vpovis
        KiikMcehJJPuUaJ+7TwJylfyu15LccnMo44WaKjJtHG+SlUYZQskovNb+uOT+0rQ
        ==
X-ME-Sender: <xms:x8dLXf8zbHPK50K89ASoR8T0YTwd6QtmyUoZTtUeEJOe5u8cipfaOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddugedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:x8dLXUHWIddimOryc--sCPu52Msd_sHOubH_ySbVnqGd1GZF2YKvmA>
    <xmx:x8dLXfP3lgxgje_CEHAX9ngghxSYK95RFLynuktgMya6DsImcWJeRw>
    <xmx:x8dLXTQWbj6WFDjsMn5echuR4kIMGIThDXUQNvJKtxGY-7w8HKNaJA>
    <xmx:x8dLXQIxfxy3wAhtB9qfcAIhkiH346PqrGx0CAvLp9wJ1cWQYV-fpQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FDF780064;
        Thu,  8 Aug 2019 02:57:10 -0400 (EDT)
Date:   Thu, 8 Aug 2019 08:57:08 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190808065708.GA15719@kroah.com>
References: <20190807.162757.1185445811628942430.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807.162757.1185445811628942430.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 04:27:57PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and v5.2
> -stable, respectively.
> 
> Thank you.


All now queued up, thanks!

greg k-h
