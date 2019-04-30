Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AEDF1AB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 09:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfD3HyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 03:54:10 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:36971 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbfD3HyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 03:54:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 82A453E0;
        Tue, 30 Apr 2019 03:54:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 30 Apr 2019 03:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Onma7JcC5E2Rv2+YLAHhS5D4i6T
        7gl4TGbnq+RspTKY=; b=yc1yOsV3CFw+z6CV0kbmpwQZF4DDP9vZB1m6cpa0je7
        MF1UCLqNWx13yJ3+qlsHTwsBev8FceE3qK7i5x+JLbg+AhM9aGe2n9tdgYviWnWS
        xHRfU0NMWEidOwWtLWulp3xC8ebBExooev3AsKfbZipfa1AMNRCw2hf4m9md8QI/
        DmCApzN1nfw4qQJesvySZl96yJdv+kBgkUOa1tiiGl7dhyFm7auQTOncPlHXOsjE
        iAkG9Vp9KsWosWboAj64kIul0iht90Y23R1Gf+ReKgBW4UzVmKjYmsLzfIh6JQk+
        OHfUCew7dzot007qTWDGG2bmSX+PP0Qx8dPdU2wPRPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Onma7J
        cC5E2Rv2+YLAHhS5D4i6T7gl4TGbnq+RspTKY=; b=iwTUGsu60l0lgXlIsQft1E
        vZIfCME2T76kyr8mipY0x/jLYKCWa5pwcIeURfAjCn0I6FzRHqoMxMc2CSHx0gPU
        EjYleoRgFXO+5bGBqV8HdtQgeT3zaSIPqHL1XdvAErvFS7PCJ5RpRuhchj6XXCif
        TyX+hG70715qKliIE6wvQqJdlwSR3mdisIFmW/KRDmGLVCQ+gMkgbtaqM8WR8Vqy
        qO44/PB/ZI93aRbWGuQtkvdpYkDMqUgstgBlh4xskGZnTHfE+AX9eGgJ03XbbGGk
        JtI8g6nz4nm9TA6pK1RdNd9V1J+l2FBHwcOMUL0FXugqYua9HrbOA1RKt39L+BYw
        ==
X-ME-Sender: <xms:Hf_HXCrhb7fQH1FuseP6fOp-5gFHE8Z0zW4M0ccP3ZTYUy2HGRu4yg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Hf_HXDydynDRZ4N3Hlqe9HyGSE2UNbI-pGp2UcrpufAUsbuW3qOtRA>
    <xmx:Hf_HXEpsGS8GgtdMPfXLJYH43Jko-s2eeShQmkyPWC6P4Yu44jTWVw>
    <xmx:Hf_HXGcWePQdz9DInfCNqpqtEYRcPvEFGRJ7ZI9SuONd8peCidNEXQ>
    <xmx:Hv_HXBZuTMJsQDY5o8eupLBy3WIK6tBl1NedKl0Yr-ADdtvpJmRxXQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22A5D103C9;
        Tue, 30 Apr 2019 03:54:05 -0400 (EDT)
Date:   Tue, 30 Apr 2019 09:53:43 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190430075343.GA5383@kroah.com>
References: <20190429.220629.926084840433564745.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429.220629.926084840433564745.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 29, 2019 at 10:06:29PM -0400, David Miller wrote:
> 
> Please queue up the following neworking bug fixes for
> v4.19 and v5.0 -stable, respectively.

Thanks for these, all now queued up.

greg k-h
