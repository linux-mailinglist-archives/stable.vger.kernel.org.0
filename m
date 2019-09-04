Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDEAA8DAA
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbfIDRZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:25:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44435 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726589AbfIDRZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 13:25:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 92912221CF;
        Wed,  4 Sep 2019 13:25:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 04 Sep 2019 13:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=u9bMn1zukKv1Hh6yTnH9HI+sDfv
        YF98vUBzUJo2wB3U=; b=OgrPG8MDdFNrrodczUrZS8zdRqTMSRDXMA/LeV9IjsS
        vGLBbsQQHixUXCoH9o6dNnOconyEVqNWy3uYbMshtbUdNjHj5JDh8Yp+tWLWruDr
        kxdzoC2I/R/nGxpZLc8STD1cKOK1XaFwDXyslPLbopWmla56G0K7SMIkdFxprgyj
        9+CX0wurTn2Pb/Ys3CSZdoOVQL/3pjbL3Je9chtKwt/OYrsvs0XH62aOdj5j7btm
        QyFEvtYErJ8o62LOaVCYATcWBl2uFJ/Mv+XjTKLrTmeE6zg8iRc3v2L2YA3J9HMA
        aAOQ9wnsMW4NsRxF+UkcpUgL9qoErjJJVhGx3iV39Ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=u9bMn1
        zukKv1Hh6yTnH9HI+sDfvYF98vUBzUJo2wB3U=; b=XRl6AQgyIoguGW9YejvZ84
        4ofofym1GgUD5vuItjO3XO1uuRiJD0Gvyq4oNerr+XJRFsO/hbDC4E1dt0Pq/WsI
        ykAjpKths+74DadELoLM3gLd/YUo2ShgfPCexk+oVirhhD2vTyd8U6x9HsXvW33b
        XfVv7QHhQNlAwRtisMF5YW7kJndzd9XIEuoPJujGNPNZr1bYQ/KQWqdC6yCq5Yf/
        m9MGQtUDeMPS1NUcDABhznWZI/dCDmHiLAl6gcWWzCo0nk9/IDR/kNGmy+WTTUU3
        h9Rxb3ZHrVmntOGVscoihUJapZFEoEoe1RlXdsjHuV0PbRmNmzQRdJHsBIXYwS1g
        ==
X-ME-Sender: <xms:nvNvXVuX4lOaTn0ykdGjS5BNX_b3eAcilqGme9epzllWCdQQEo2KKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejhedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepfhhrvggvug
    gvshhkthhophdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiii
    gvpedt
X-ME-Proxy: <xmx:nvNvXY_bFWiVwWUbWOg9H7tGZvI05AgpFNIRd-TaW34fRAHPgnrYdw>
    <xmx:nvNvXVuTiqTH9CM2BVSWqklUfbR7R3Cg4IcbWdQjC5pe3C9O7Ga6Qw>
    <xmx:nvNvXe5GtWxvLqsk6iXj8X2QdeDvYLdo0RZmgb9MaZjvfgEMt-RC0Q>
    <xmx:n_NvXR5JnQ_I-InaallQbf1ILZOP-cYAduxbU3wtYs5_uUyBcjLPCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8743DD60062;
        Wed,  4 Sep 2019 13:25:50 -0400 (EDT)
Date:   Wed, 4 Sep 2019 19:25:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Baolin Wang <baolin.wang@linaro.org>
Cc:     stable@vger.kernel.org, chris@chris-wilson.co.uk, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        arnd@arndb.de, orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BACKPORT 4.14.y 1/8] drm/i915/fbdev: Actually configure untiled
 displays
Message-ID: <20190904172548.GA10973@kroah.com>
References: <cover.1567492316.git.baolin.wang@linaro.org>
 <5723d9006de706582fb46f9e1e3eb8ce168c2126.1567492316.git.baolin.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5723d9006de706582fb46f9e1e3eb8ce168c2126.1567492316.git.baolin.wang@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 02:55:26PM +0800, Baolin Wang wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> If we skipped all the connectors that were not part of a tile, we would
> leave conn_seq=0 and conn_configured=0, convincing ourselves that we
> had stagnated in our configuration attempts. Avoid this situation by
> starting conn_seq=ALL_CONNECTORS, and repeating until we find no more
> connectors to configure.
> 
> Fixes: 754a76591b12 ("drm/i915/fbdev: Stop repeating tile configuration on stagnation")
> Reported-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190215123019.32283-1-chris@chris-wilson.co.uk
> Cc: <stable@vger.kernel.org> # v3.19+
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> ---
>  drivers/gpu/drm/i915/intel_fbdev.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

What is the git commit id of this patch in Linus's tree?

Can you please add that as the first line of the changelog like is done
with all other stable patches?  That way I can verify that what you
posted here is the correct one.

Please fix the up for all of these and resend.

thanks,

greg k-h
