Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05760408817
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhIMJYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:24:32 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41321 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238504AbhIMJYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 05:24:30 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 61E83320046E;
        Mon, 13 Sep 2021 05:23:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 13 Sep 2021 05:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=5TcUJR/22vnEL/78nCSp+AG1lRP
        p+2UMV8HvdUGxiRM=; b=sxL+qAQtx4pqJCvpyIpliLSDD3XLQyH0KHtda120Bp3
        aKfQzPLhUbJ2u9o2KVHWwZfJX194zseBD3c3sFhFyK3vnuD2i0/u7x9F+L8PLe5H
        W4KiiCEEThciUwUok068Mrz4IzAkjhRHI5AcSoutD1gNT3wvK/7GtgtH1KZhIFFG
        XpAHKTwCSqTPgoZqp1fU4bcdWygEjPIs8x9NNO1DCre5Fdk0l9etMLi3vkqE8mFs
        hkcaG1PuV7hX+nfLxRpfrq3p6q52DBlVQZU62sgvOsA62w34sss0Y2m6FDljdYgU
        YUiOFdvkToJdDyAdWLDRSOHMfC28dVx/nHzfCaPeYUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5TcUJR
        /22vnEL/78nCSp+AG1lRPp+2UMV8HvdUGxiRM=; b=DsQcIDKY10vtvp1Fx1QRzk
        bXBnJHbjf8+nBW2SSaLcdgA4GCkbjMN03TH/9MbcYRTD/h/oO6RUd/AIkt8oFKP2
        1xXu5a2DjPBvcHbqQhreRff5PxTVFlx9ekAIH5us1+xH6e9I5BGi94I2X75OCz4C
        cKqlZLVS//p1cMdFrVNLcsG4eSFuiLRUm+caPpvoBKjuPdRh/n72tSY8gls1BVIG
        cyJLKWqIsiN1JZf4eHDCYR4uRNlD1fg4LtUQS+ynKYiKy2S27ifxMbaEwUBqAjy+
        Qrlp9MH5hehT8yGfab3zTw6M6vRWThgNikxUq9DSeqbHzXruqiPagttNoj4dIKaw
        ==
X-ME-Sender: <xms:gRg_YVcfmFyYqDSNp13ewL2OKPrax45WN2xouL-V-rwWZlZEWIdn9w>
    <xme:gRg_YTOeF7fzbPPHMwFuKEJwy1yrXUXHWl-G_bItfFW0IChJCEvMMbyLAMQ9GBY53
    JLI3Gg_pT12tg>
X-ME-Received: <xmr:gRg_YeiFlDXHyaL5w7h8wPaji9WxId1PR6rS5lHBFVVke4hSdvdz6qD5_WNBgCQdoT6eF_-zcfnWlAbo35tcj3_FeSu68Tf9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:gRg_Ye_fTifQ9m8cPdJtJshFnRh8MpyymUJrDCpVLa_F6zrGCtQVcw>
    <xmx:gRg_YRvXXYiN1UN4h-pgGVqqOzQIUpw1h4_cxnE2f9BIve57c7Ym1A>
    <xmx:gRg_YdF0AZdmwX9fUTF6I9A178YFIMLMrkj-TT6MegQMBI-2W1o27Q>
    <xmx:ghg_Ya6MZHWxO0XlYGUdcCjCk4JCIyn7aS2Cz5jXx8RJAT3zSO1YSg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 05:23:13 -0400 (EDT)
Date:   Mon, 13 Sep 2021 11:23:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
Message-ID: <YT8YftsQxd0KPUpI@kroah.com>
References: <CAFxkdAqoFriQQ-9udv4aXWh=FfbKhaWfULFOQmHzyYETr_jYtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdAqoFriQQ-9udv4aXWh=FfbKhaWfULFOQmHzyYETr_jYtw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 11, 2021 at 10:53:12AM -0500, Justin Forbes wrote:
> commit 2f32c147a3816d789722c0bd242a9431332ec3ed upstream.
> 
> This patch adds a missing pci-id to support the wireless device in the
> Galaxy Book Flex2 Alpha which is shipping and in the wild. It has been
> tested to work on 5.13+. While it has been shipping in Fedora kernels,
> Samsung and a couple of users requested it be added to stable.

Now queued up, thanks.

greg k-h
