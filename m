Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953983C23FF
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhGINLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:11:08 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44841 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhGINLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 09:11:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0CA31580370;
        Fri,  9 Jul 2021 09:08:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 09 Jul 2021 09:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JqsHIrzFyqFsXpqukbb6fnHV71l
        LicR7frv2ksoQz6s=; b=Ml8PAQBlhRItczTpS07ta+GO0TJ1x4l5hpnx4MoSnB2
        SA70l+1ZQQODEs/HuDADnD3+O2jqv8NZK0BcGAOGr16ITUCtgNdY4pm0OYxn/KHZ
        qfwuwAGpsIihv4joY3Lkgqe4kfLLB9reU5yy38sPHQHPlIQZ0TxZ8goC/8PHIf9X
        e6CVJRdQkgSNZthHNbQetQygGdL49heGGzY2K1Qr9GKOgqa5+VqeradeoAUMoBdL
        9Cv78zO7lbdvs2redPBzAWFvxnEJVkfs4B3eUfZB5rzmjLRxgwHnsG3NkieowclO
        qw4Pc3XMbOHTmqlv/qV+QQBDFRe/rR3DisrYxxwxzug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JqsHIr
        zFyqFsXpqukbb6fnHV71lLicR7frv2ksoQz6s=; b=GDeE7tatxjM4dJP+WlQadO
        EcYjsuNA3vWeaObPbHthaevM9memLtWGgZwSqXhJtqu3zN0izFp9DC56IXSX+0Ft
        9U4MRVdd82c2amujiVDpEYs3PDEYI1WVspYpj0DpUcxMJj6a9X+PpsUmY2YwXxbi
        7Tp48/Rf2I/+8FZo3aDCJSb+Zj0a5HkRRqNu9MnnVU/51k4UW2QfWFJNMFta2G3L
        g+2bQQ+PGF0xQl9LWWXa4Qlvv7YH5L4Yz7smXpjQnLeVxwBLPpBRLeBjFPoZqTbp
        FmLVo5d5kIn9AQxTUQ9d+QHUjEohqUai+bL7Wb0nnrLBfD3bnJ5e1ZRjOrc6wv2w
        ==
X-ME-Sender: <xms:RkroYJEKL_aKFQewa8wNFIVZVpuIhBFuRWdXsvAAn0CZQXtVYh-esQ>
    <xme:RkroYOXhJ9mwfQ_xMel0uuX6xsGIH2AIu9V_ol9ZLy1LXQvwW6Buv1G4032ha0vIc
    kPIAmPd3WXq7w>
X-ME-Received: <xmr:RkroYLJEaxdSlIlgV1c6YC8qDMXLfCNjcU4iz2w-VdLScMTtHuPqn_1AnjoMcftvwEJs1YH8lmydfp4kdWsDm9LLGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeigdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RkroYPGXX03oNednvqiq4BVHNNxBRflIA-rrEyvEAKAlbGunb8tWXg>
    <xmx:RkroYPX7pSAPWYI-sGzsufbeL82O6ZvJpFYtvTwwmGbWcM3sKeJTVA>
    <xmx:RkroYKMBzUNgYMNyM7HC1N9uri_22UtuptlGC04iLPDSCPsUcfugBw>
    <xmx:R0roYAsOUYCdY_8geHZUCQmwhE9_rgSRpostuVL6hoy98SE_hcD01w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Jul 2021 09:08:22 -0400 (EDT)
Date:   Fri, 9 Jul 2021 15:08:19 +0200
From:   Greg KH <greg@kroah.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keerthy <j-keerthy@ti.com>, Tero Kristo <kristo@kernel.org>
Subject: Re: [Backport for 4.19.y PATCH 1/4] ARM: OMAP: replace setup_irq()
 by request_irq()
Message-ID: <YOhKQ3khlGlf/5D6@kroah.com>
References: <20210709073745.13916-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709073745.13916-1-tony@atomide.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 10:37:42AM +0300, Tony Lindgren wrote:
> From: afzal mohammed <afzal.mohd.ma@gmail.com>
> 
> commit b75ca5217743e4d7076cf65e044e88389e44318d upstream.
> 
> request_irq() is preferred over setup_irq(). Invocations of setup_irq()
> occur after memory allocators are ready.
> 
> Per tglx[1], setup_irq() existed in olden days when allocators were not
> ready by the time early interrupts were initialized.
> 
> Hence replace setup_irq() by request_irq().
> 
> [1] https://lkml.kernel.org/r/alpine.DEB.2.20.1710191609480.1971@nanos
> 

ALl now queued up, thanks.

greg k-h
