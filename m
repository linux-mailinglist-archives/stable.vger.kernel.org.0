Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3295252D362
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 15:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbiESNAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 09:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbiESNAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 09:00:49 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B87DE8D
        for <stable@vger.kernel.org>; Thu, 19 May 2022 06:00:47 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 067683200437;
        Thu, 19 May 2022 09:00:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 May 2022 09:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652965245; x=1653051645; bh=gGu548foHK
        QgaNAOtWGNui3je2KBG5Ulm6pbLTuBq4g=; b=XqHkfuEFpSmvGaz9nrlq9ZjUmJ
        Amvj94zdnRsGRdz5tcbE79CbcidcE3oSang2UAFg8PePyr9l7BQGc67kPjSyMj7W
        5CE4H/xMTkAhE4pyyuFeQTswWeFyJkqVmEnRQhs+8Stg1yt0qUxHVpR25Tdxaox0
        HclQb4gsdLmzN67sAMLsjAb0IW064Nu6kC4Gsofy6a2UlOln4f/eBBpFrUoAJkTb
        JqFSNwrtlPP0OUBB5d+mDhTAe7AjldREkrWKhZu8uOruPfYpLJWtlWzZfdMHvXAa
        u3jAK2zr08hE84IuXOXLT+TxHBpRdEvofc1MoKRkiDDFFcdICP3fPivOQuPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1652965245; x=1653051645; bh=gGu548foHKQgaNAOtWGNui3je2KB
        G5Ulm6pbLTuBq4g=; b=yxx5I3jJpzqnj7UZ0o075vMDOmk920+KfV1YNZ3Mhq4M
        9GN10PjU5khHDPbfxlS9RDt+PPSQsHIzVcq9PllSMoV2ljyGVFUjfhpWZFC3smN7
        x5y5K8vZR2lt9dWEIe+QQmWTiIo4q2XLQbGot9MvoDPThPPvt+Rx1jHr3/XClv7Z
        uvLKsvrJFYiMCroyYyFSrk56ACXjkpkuoY68SNLtnWOwMAbbq7ja5PlYRyT90xgW
        cvc6AvRukEuuzlUjyJJ9iErefQYaxwBaCJ4a20qFCegeQk7jnpve65Ve1jF4GajD
        A3qcOUYym6+2Qcf20DbrdJlG4/asydWfZAUw6EricA==
X-ME-Sender: <xms:fT-GYiwcmhBh2dg099tYcwAIBr-MDyG2I1B-oGC4Ben4O7wOHm0V8A>
    <xme:fT-GYuSic-_kTxOonnE2QuCsbArwSmmZRSC4wpnmv_LvBRVQbJDSpO8xfE9VK0xYR
    MkWIndcRJaDrA>
X-ME-Received: <xmr:fT-GYkWLJbKWBnvjz8nXWGdXJbglNjfb4Y-HNpAly8UnBbgk1dxxo82fAD28gMPA7GrCSkuTxNj1WG_C99aTm7oNgTf94Hvr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedriedugdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhfehke
    dvudduheehfeeugfetteefhffgfeeigfdvfeffheeugfeuieejveduheenucffohhmrghi
    nhepsggrshgvrdhiugenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fT-GYoi2mxOkEFY-SeCvQrqjPoEkpr37hBmNtUshdCbMWnJvc00xdQ>
    <xmx:fT-GYkCs7rDAo6Ibl11Yc958veROm3EjXRPZDl1wqfbIwJfjz0bHjw>
    <xmx:fT-GYpJzR5BVfdRDATwQnbqCEWms9bJO-pA9O12tZqK6mRSxPx628Q>
    <xmx:fT-GYn8ncgGz6s9wGx2yphUI8Qsps7g8AnOjJq-zzyYTuRMrjiwHaw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 May 2022 09:00:44 -0400 (EDT)
Date:   Thu, 19 May 2022 14:59:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Greg Thelen <gthelen@google.com>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 5.10] Revert "drm/i915/opregion: check port number bounds
 for SWSCI display power state"
Message-ID: <YoY/RWT3Gv0aeU1M@kroah.com>
References: <20220517000835.2450573-1-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517000835.2450573-1-gthelen@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 05:08:35PM -0700, Greg Thelen wrote:
> This reverts commit b84857c06ef9e72d09fadafdbb3ce9af64af954f.
> 
> 5.10 stable contains 2 identical commits:
> 1. commit eb7bf11e8ef1 ("drm/i915/opregion: check port number bounds for SWSCI display power state")
> 2. commit b84857c06ef9 ("drm/i915/opregion: check port number bounds for SWSCI display power state")
> 
> Both commits add separate checks for the same condition. Revert the 2nd
> redundant check to match upstream, which only has one check.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  drivers/gpu/drm/i915/display/intel_opregion.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_opregion.c b/drivers/gpu/drm/i915/display/intel_opregion.c
> index 6d083b98f6ae..abff2d6cedd1 100644
> --- a/drivers/gpu/drm/i915/display/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/display/intel_opregion.c
> @@ -376,21 +376,6 @@ int intel_opregion_notify_encoder(struct intel_encoder *intel_encoder,
>  		return -EINVAL;
>  	}
>  
> -	/*
> -	 * The port numbering and mapping here is bizarre. The now-obsolete
> -	 * swsci spec supports ports numbered [0..4]. Port E is handled as a
> -	 * special case, but port F and beyond are not. The functionality is
> -	 * supposed to be obsolete for new platforms. Just bail out if the port
> -	 * number is out of bounds after mapping.
> -	 */
> -	if (port > 4) {
> -		drm_dbg_kms(&dev_priv->drm,
> -			    "[ENCODER:%d:%s] port %c (index %u) out of bounds for display power state notification\n",
> -			    intel_encoder->base.base.id, intel_encoder->base.name,
> -			    port_name(intel_encoder->port), port);
> -		return -EINVAL;
> -	}
> -
>  	if (!enable)
>  		parm |= 4 << 8;
>  
> -- 
> 2.36.0.550.gb090851708-goog
> 

Now queued up, thanks.

greg k-h
