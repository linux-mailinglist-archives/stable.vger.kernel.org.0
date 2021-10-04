Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E394209C0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 13:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhJDLOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 07:14:17 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35503 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhJDLOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 07:14:16 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 56F755C00D4;
        Mon,  4 Oct 2021 07:12:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 04 Oct 2021 07:12:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=tmfBhLajCSYyPa1PuwIDiR6E6dV
        uCYY3+nyPglfVFMg=; b=iG5e9nizXr75BN3sYgRa1cknwEP9qeIwA74lj30Tmuq
        ZbWQDnRDjlgTfPF2VYHTYsYN8EealSykg1jy170ixFwAT38PuwtrOkeAkIl/3404
        2CTWCzqdOYu54FJ8Hg4Pe6tjfhDtb8fXQoTMOyJ9wudEAvkTXzTpdHDq6QZv088w
        ATa+oQlI1EyLOjILAnQrEWB2ldyi92dkt4wL8XbR0k7craIUbPEInm6AKbnc03ej
        OQablLFHil9miXItQSwsWj+oP+3uM20CxsaXSLZOD79rn2vcMuhyYs5xz/PDj4Cj
        KobqnprGFTpF0oLJc2pPd9kwzAz1vmliIlo9kRfZ20A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tmfBhL
        ajCSYyPa1PuwIDiR6E6dVuCYY3+nyPglfVFMg=; b=KVLoAkqYafh4p2kA1Rureh
        hvn2WEwmgxL7CTXgEQ4D69H1fSM7kmypBMIEQsC1F5+sjiewGdCELoC9uU9kjb56
        Y99jRupl0nJh5AGdu/uYQtmp6kaPzzUIxY8z+AUq2q4bjulQJHFaSEX7IsRrTWkd
        qAFahsTNdUKeNceeyuLUzOfS3Gwy127g5zs3nQSrVw8BgWSBQoU08Gjozex5vgIO
        pRqiBY2D5To+uV8anBbWTUq6rXPu/jsICNqd4xmdNjyaRlkJMdI47Sd5T9w3azUd
        KJrrUnrIQ4DVIJwWPk0HSCQykGlBhjKIhcznWYQTThUA9wxQvTg+TOUvBIdEVztg
        ==
X-ME-Sender: <xms:m-FaYQyuYktQVBcLWhj5FHGBBeHYsGF51W4sPTqJAKACHsDTOuo_Zg>
    <xme:m-FaYUT_aOTNDIAizn40jryI8icKNiVt2ot2kohfm0PK9xDZTBLB5zVExJKOIIk-_
    CtNncgv9XknWA>
X-ME-Received: <xmr:m-FaYSUgHNh7v3nk_U6BHykm70bKmbXdTJQRLMMb0OmxPdlia8VIfodXNNSZzndq0xI_sGk74qnKDkVWs1lS3aGWF22CMPBu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelvddgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:m-FaYehZ2kUcZ8mq5FF9oTVHpxJ7rEtZ6GY-kjNhsqa7cN-UKTTG-Q>
    <xmx:m-FaYSB84jgAE5x2zr4Tv_B14O2pf8_pYK4p_lhwF2iVaXgCAWCziA>
    <xmx:m-FaYfI1WmIYw66E36hXCwJdmovxNI7u0S0dw7ej8gUStkxdvuNjhg>
    <xmx:m-FaYV-mmi-Zsl2YYJcZNpjDJF-TUDkgaWx1_3bLuUBHqu4K0t5x5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Oct 2021 07:12:26 -0400 (EDT)
Date:   Mon, 4 Oct 2021 13:12:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, carnil@debian.org
Subject: Re: [PATCH 5.14 1/1] usb: hso: remove the bailout parameter
Message-ID: <YVrhmd26AXJ/kWSR@kroah.com>
References: <20210929075940.1961832-1-ovidiu.panait@windriver.com>
 <20210929075940.1961832-2-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929075940.1961832-2-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 29, 2021 at 10:59:40AM +0300, Ovidiu Panait wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> commit dcb713d53e2eadf42b878c12a471e74dc6ed3145 upstream.
> 
> There are two invocation sites of hso_free_net_device. After
> refactoring hso_create_net_device, this parameter is useless.
> Remove the bailout in the hso_free_net_device and change the invocation
> sites of this function.
> 
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> Backport this cleanup patch to 5.10 and 5.14 in order to keep the
> codebase consistent with the following 4.14/4.19/5.4 patchseries:
> [4.14] https://lore.kernel.org/stable/20210928151544.270412-1-ovidiu.panait@windriver.com/T/#m3212ee8701e6e6a532c681e26aa557a324628577
> [4.19] https://lore.kernel.org/stable/20210928143001.202223-1-ovidiu.panait@windriver.com/T/#mfc27ef6f6bb647d051f27ebc6ea19a423e8b67cc
> [5.4] https://lore.kernel.org/stable/YVNs%2FmLb9YXNz7G+@eldamar.lan/T/#m5a020c3314a5e1c686f923efdf6fdb6a6aa90652

Ick, but ok, now queued up....

greg k-h
