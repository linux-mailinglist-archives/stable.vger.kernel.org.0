Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274601FA29F
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgFOVQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 17:16:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38353 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbgFOVQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 17:16:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C0505C00CF;
        Mon, 15 Jun 2020 17:16:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 17:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=yDhzxQdrW72EMlzi/lWQrIa5fTs
        6huXl/qAj2WZomGY=; b=V8dzegYygnlsoQVGRGPfpfSGzIuvstWxtFKfo1j5J1c
        EReYrK18HFSSrHl13Ez6ZYJCyQAmJfu+BIoQtDSj0mFnu3F+Dgf5nXCx/sc5Hkjn
        sH2wPNTcNB0oQmvmpY8ZIBeqWLwsYR13zd00uOgY3IVMGJu/R3hnP49soAl83qAh
        GSr8Em43qej53X5wff+h0kdpDqb2yWNQrshoi9DkW2aGiXv/Cn49upSy4Jv6q0Hz
        PVldceGTRgY46MSBQO3vvN5ipJlvy8U5boZ+Ze4AEIHe2ZlIRB+FvmGhHUyVc66Y
        C6R7YFsqfnPTPYC5cscR2CySpcYVZu1j8iexDsD/P8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yDhzxQ
        drW72EMlzi/lWQrIa5fTs6huXl/qAj2WZomGY=; b=D7KfT+Ct0ClH2K+9oNlu0r
        Kr6L3kl/9krNOMBwa7sGwycN3dHdFlDHhzglXrBXPOuC8mCAtXApHAaey4n9+Mgo
        89KvGkB/aNbXtkHO1sy5QiepRv9MHsJa4q43LVJzxDs/SH/VPrxtqnFjOEfkPpdD
        fogVxOYV29CbyNhyy3TM1xhfeu6rPiN+ca42z73V+9+JWBFAdeAYFFL4QRJb+f0/
        K4UEAgDvOuEN5HxIOyVmgVcxzw/GVZKRqpJo3XfIjC2pM/o7Y291SCzXI1GHwRC7
        emQPDVWSnxDKdJzT6s8kQuI04IdHBclNiJBje26oofqz/VrVc+E++tyqAK0C0TPg
        ==
X-ME-Sender: <xms:QuXnXi6mz6JHh-93iEK_z4AYupX9SvMmNBBxBUzilEQLm0iZuk0URA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgudeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QuXnXr4xFUDNJCzEgkgkNSk43O694bEaVHeo3xtqz6ZXGCnE0s4UrA>
    <xmx:QuXnXhc6P-pbN7M2kWr-XQbzG26Z0fWJc_X1v7dSlvXVINeXnL0bSw>
    <xmx:QuXnXvLRM0_OSIwkPBsOSr_XKx-18Psf0xV492XsLYnzFgnQg3kqug>
    <xmx:Q-XnXohABxqtO7CLTnNGon45GwBt_iQj5KuqAhuDHJUyvWNEid9Mnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 410A4328005D;
        Mon, 15 Jun 2020 17:16:50 -0400 (EDT)
Date:   Mon, 15 Jun 2020 23:16:42 +0200
From:   Greg KH <greg@kroah.com>
To:     20181129133119.29387-1-linus.walleij@linaro.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] irq: Request and release resources for chained IRQs
Message-ID: <20200615211642.GD1019647@kroah.com>
References: <TZHZBQ.SOVDZ4DJB30O1@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TZHZBQ.SOVDZ4DJB30O1@ixit.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 10:23:53PM +0200, David Heidelberg wrote:
> Hello,
> 
> is there chance to get this patch included

What patch?

Included where?

> or could be this issue solved
> with different approach?

Such as what?

Totally confused,

greg k-h
