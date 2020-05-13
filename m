Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA01D0C5B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgEMJgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:36:09 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50739 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgEMJgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:36:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AD545C01A9;
        Wed, 13 May 2020 05:36:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 13 May 2020 05:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=cev3XGzTjz0cHESy5JKo/40s+we
        RRI4aQKYW75vQgno=; b=TR8dVorE9V8xQ2jQuf8vmvGnarNu5QXY6p+sXqyHn7z
        idRdm8XyHlScgCrK7dz5h60Dl2QFoFYq2fwY75ZOmcnnWHUPfG/GQ67zmGsHIeJj
        TAP7JGF6gACuCoJf7w3tJDTTMS708/sUCoOqke/H+W9lwvcsLfhMousIGu+1Fnbq
        130ZbLrjxY/Nrrw5y9LejsN5U9/Hq2u5Va41tEppcBTwwH2oL1/E4shuH/9sAnzo
        YEraWQNyKCtTNMYPIksy88BHhnbF6PlEZtbJqO66ZRdDqfZBmV5iiavyAoeM3R7D
        tmovPaGhG+xmvLtVjCK/oRr94b8jc89eJdzEeJYGeVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cev3XG
        zTjz0cHESy5JKo/40s+weRRI4aQKYW75vQgno=; b=QYkCJP3GfC+ORmZcjM6ZVS
        GFeSXWAviLsO3ABIsIFm94Aw5MHmrQx3nMnx/2dHIRg2icP7MfOhYIsHJdTHKCSJ
        jAUe/eenYyCJCyahXxXC+K43BRD/mVDWWe9v1oyAU/LifSVTF/co+FgdR8Yw7lj8
        ag7/MeC0VFP5rZ2oFhqQS/9aoAwE23uvOx/Wp5NFwW7JWoRIcVRjFIIYPSuhw7U8
        WO1EzrR2Tu65FJWC3UssIt7LdOKx0QF8/PkfaHiM33Ct8g9WRX35f9Y5tt/Lgwzc
        ev9ijvbW0zDNCbE+4n989qA/Nd2LWPthcJMJ8iiGqGdQp4KhdvhoSLZH3+DnVF2Q
        ==
X-ME-Sender: <xms:h7-7XtTHZQTf8B2jecIltF632gR8M2ZCI9noKjvONQjtF-op_eCfeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:h7-7XmypRKjm-_ptP7Gb1NWhfk2AY1X_N1eFrGB8VkZeylWCLMCNzQ>
    <xmx:h7-7Xi2DYyRY5t38wVvAyy5tSfNZIibtzgcgnaaKY5Xk9eGFEmHFfw>
    <xmx:h7-7XlC0mB5DB0NeL3jLl__aI8A-vy7Oqpr86oDzTU3dJGw0VknJ8g>
    <xmx:iL-7Xqb5k6QqgtuuV6-W4sIYvxwNtsXsf8IKCU1_M8IsQSlqhJa0PQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 55AC43280064;
        Wed, 13 May 2020 05:36:07 -0400 (EDT)
Date:   Wed, 13 May 2020 11:36:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org,
        Markus Elfring <elfring@users.sourceforge.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.4 04/16] crypto: talitos - Delete an error message for
 a failed memory allocation in talitos_edesc_alloc()
Message-ID: <20200513093603.GC830571@kroah.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-5-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-5-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 09:40:02PM +0100, Lee Jones wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> 
> [ Upstream commit 0108aab1161532c9b62a0d05b8115f4d0b529831 ]
> 
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/crypto/talitos.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 1c8857e7db894..f3d0a33f4ddb4 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -1287,7 +1287,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>  		if (iv_dma)
>  			dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
>  
> -		dev_err(dev, "could not allocate edescriptor\n");

Not really stable material, also missing from 4.9 and 4.14 trees.

