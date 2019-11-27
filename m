Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A5510AB50
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfK0HvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:51:18 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60249 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfK0HvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:51:18 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AFB4B2CC;
        Wed, 27 Nov 2019 02:51:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 02:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ESkPvoJrr1BrIHhtt/A9BEL+ip1
        4+yWEv92uomwfkyg=; b=pCHlU7MO4ME625BLGKXIx0xIYonao2j7rydOdAiFrXh
        dsJLkBtZmKYgKnoSlazjE2TV4j4Kged43qr++WDdwRE5o6TOWaxwSNBR8Dm49+MQ
        cAlsZDDoFgS5hsP5c4ddrf6cd7iN6pHx3sQJyPGLmFYvkxBeIYkoO6mMy5IfS/eO
        IqfPvrxNZF6nPIu9oFKjTvmTFwwDGtxXgcM8FzMjK/Z+dEqEl7LfSBO0HLi+a3+5
        aLjppPAFXJ6Qq8mwrUEdqTPuKjggxgGR6sClPZG+itbWvVO7I6aVDjblbfToP9wi
        qk2wWLZZFLjOBl/2TIZh6PwhHdTtXZ2iHKwqbTjEC1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ESkPvo
        Jrr1BrIHhtt/A9BEL+ip14+yWEv92uomwfkyg=; b=jHDAhDhtwy/ah8OQtLpWH9
        ildgRONA+zi0D8D3R3e7HGQG1Jmmlh46xCBTNCGg+jOTqU0TfygMs9mFcyKBF8xN
        vxoZa+T4k/ZXFsCB2YpCsMB/UVRDqF1PCMb6/EF6kUid9xO+jGbUlEku/8En4/ST
        NbnYRnVp7aDGIz+Evj9SCNnW84BkgLVcCVTbm6+XMu0fzBqkgfZTjvSLUcu/K6Ri
        uQTZbDBksLGeVd2XqfeXCPoegJb67M8r26tKyZkA3uX/6mgArCLML8QNtL52zDvX
        AZEVu3gLG20kV7Gv2QQLjbyTZRtUkSZMfmJNVPl742g/PY1pwNSBrDFQdG2Wxe0g
        ==
X-ME-Sender: <xms:9SreXcp7dlFT8-FgB2g2JlJ9PGuneU0UK2ZqPAnIjf_vxbe7Jr2VcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:9SreXQLhsZypYR6bnhNnhTdeE4cQRjqgPRsvzCEVc70yfzQzUnpTUA>
    <xmx:9SreXdSvMbybz31-IWhzg3Jn75OshllGopDla1-eQekRA049qJgE3w>
    <xmx:9SreXRI9AVP_W8fSqZTnEwU9JUg3Clh8HQOc2yBR3KTWss1O-rFaeA>
    <xmx:9SreXRWTW_2HYGxU8oNPxMX07Usq5lddlvIOp-uCG8CFFGMSj7OlEA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD09D8005B;
        Wed, 27 Nov 2019 02:51:16 -0500 (EST)
Date:   Wed, 27 Nov 2019 08:51:15 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.4 1/6] can: dev: can_dellink(): remove return at end of
 void function
Message-ID: <20191127075115.GB1821634@kroah.com>
References: <20191127072124.30445-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127072124.30445-1-lee.jones@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 07:21:19AM +0000, Lee Jones wrote:
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [ Upstream commit d36673f5918c8fd3533f7c0d4bac041baf39c7bb ]
> 
> This patch remove the return at the end of the void function
> can_dellink().
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/net/can/dev.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 9dd968ee792e..e0d067701edc 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -1041,7 +1041,6 @@ static int can_newlink(struct net *src_net, struct net_device *dev,
>  
>  static void can_dellink(struct net_device *dev, struct list_head *head)
>  {
> -	return;
>  }
>  
>  static struct rtnl_link_ops can_link_ops __read_mostly = {
> -- 
> 2.24.0
> 

Also, this showed up in 5.4, so why did you not include it in all of
your patch series that you sent?  I can't take patches for older kernels
and skip newer ones for no good reason.

thanks,

greg k-h
