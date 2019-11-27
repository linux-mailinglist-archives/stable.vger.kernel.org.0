Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEF010AB4F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfK0HuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:50:25 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50323 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726092AbfK0HuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:50:25 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3918A993;
        Wed, 27 Nov 2019 02:50:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 02:50:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=2SfCE91CPr2KLJgfyZexBHtnhDA
        APcWjiFSbvLAb1ts=; b=RhWdS1Zqyex17ifPVrh1DWW1A3f3iF0BkkYvL3U8CVV
        JdsoBaJi40ABIIawEKLJQwSBK4dj9eqoxGnPQkeyqROiwxIqT/AbNVi+TeGGVE+3
        52EPZQWttPquUZiIhLPDMnxoNkdzVqJjTSWhavZfjVO984DedcKksX+n7xTH9+nz
        QnvF/Tl2jWbwWlVFhuwyGVHYeDf9Ap3uBXOPvYumrCGc8gFdfwyYyPnXKAhB6b1a
        4EvX09ebj42eXvSrjA6xlVgoE6ocwL2/R8RHFxVS7vAEPWi4qAViLmtw8ifoCsnJ
        g4heMDDT2q2E6Ed4Gs6nUG43CM0CTUT25EeX1+9xpdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2SfCE9
        1CPr2KLJgfyZexBHtnhDAAPcWjiFSbvLAb1ts=; b=j28eobMq6AnaMpzNbLM5xA
        9wwUO1Aag0uFQrAgXUZxEB8PgDKL/uWPxqCC4sZyIE+e/BDpYjg1yMaFtmX4yc7/
        KwH/oZ/z09bo25CYw0ywBXRSJkJCZIXG6VSTyA3KOz/I9VQnGdR04WQ7Jy85Yc5W
        GT9ZJp1WKZdLb7JfHm7sU1mmusRRT8fsSz/vCWLkUQVB9ohTSb4n6CIbG3okJQBC
        VEYKpW0Rrwr8MYvM6YtumlYF1gJ133XdA9XmhvAenDBFVgXG/VVMdnglR5ZSWxLa
        DIABYFgTeV4bKzELcziUhtanzxVtN1glGpZbt3hsq9DqVSqsvkzcKmmhMqWyqLpQ
        ==
X-ME-Sender: <xms:vyreXd7MdW2ZFKR6Mg-zIle9yFBdgbZlHsunRzTcWTwhq1DetfHjEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vyreXXWTTQROFgS4974A66677S26L2W7v_ouTSAY6iwZOF1G1kDPeA>
    <xmx:vyreXTWsv9DS_91G_IBXjbCbogh81vkvmugUItsK5fGjPxwGUHVx_g>
    <xmx:vyreXcT8d7L0WGU3_AoKo5evtKikKLMlW5VujiGTMt9Y1x0Vit6xHw>
    <xmx:vyreXWKbDLTpTisDd7ODzYGAbNe5ImHPS1jSiOcOIAKYUmNUoQPKnQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53D7180062;
        Wed, 27 Nov 2019 02:50:23 -0500 (EST)
Date:   Wed, 27 Nov 2019 08:50:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.4 1/6] can: dev: can_dellink(): remove return at end of
 void function
Message-ID: <20191127075021.GA1821634@kroah.com>
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

How does this patch meet the stable kernel rules?

greg k-h
