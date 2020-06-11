Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07B31F6663
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFKLQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:16:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56609 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgFKLQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 07:16:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EA5D75C0136;
        Thu, 11 Jun 2020 07:16:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 11 Jun 2020 07:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=iJhioGXrX8dvOLTJotCpyNiRrpP
        3X0Ds+btZSqcR/Ig=; b=FbIcgR0uJDqr6uW6t1dpU7/dVthI/sZ6HXOnYUgMaSG
        V3DFuZ3VQaphY4Sbnp5LcXrRaeJMn1S3DTu+fMxFhs7OqOqsKpk6syLBSOiAmuHb
        XPQ0ngMNuqqIHwGCTxP9HipbMgiPrEzAsh9ZkFwG5nWHLzk5b/kRGacI1EUuAHDs
        uHRsouNA5Ki9L1uY6U9TUI+z9R35Bv+XewdkVJqpzcSI1/6/4DyEIiRY5N5JK/fI
        GSsHLHT8HrdP6t+iCLhh8Pp+lesTpbCTFkUcsRbHkzIgVhwEQwB8X1HpQSkcluur
        re4l2zg/r9HekusegVbyyiXvN0NKIxUNrdJ+KkEIFFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iJhioG
        XrX8dvOLTJotCpyNiRrpP3X0Ds+btZSqcR/Ig=; b=JiNoR0CeWooAEdLWPvPzwA
        XiMOzlpm7220wp1p0ApW1Zv2I2jWKL0JfNJrv/SicZdyAamo6FBAxrMe1wjm6gY8
        pG29aqeAjnUxfYZlq7wSEoq7VB65YicLIr+mFF3EAxZyM5WSG9FvACrjn+DxWNby
        IApB2758T2oYVpQmi0ol9qx7Jyonntto7GIQQYWjwj2M8HZCad+z7FCntTfz4GAA
        E1JloBq/BAST+9xvpLBSecokOyXmfhQibOT3GWNSujiBPTKvqPBA5rffekNJU4Cz
        ZwcbCHWfZmyAIKDJq0OmVm0v++6zKdunLibYAbpxihQsUuoEbdm9Fg4oipfIyQRw
        ==
X-ME-Sender: <xms:mRLiXuKqiRqLxtciOL5tb_0FvYtG5GMFH0_pddkm3gLus_IiQ81ntQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehledguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:mRLiXmLqcshEZGQr4-LuFjQvtYUUksRUbpwac3rOAOQ7x4JRRRxXdQ>
    <xmx:mRLiXusvOp1TdwyMuGCiAZ0eJy1kRPamNdj3IKOQ09bIu1tNDvhseQ>
    <xmx:mRLiXjb1WnRM1PURkv-dwALiObZNf_NdAr9pYNvNsAEdFRxrNfBB6w>
    <xmx:mRLiXkwxK5R2Bgz70puQZdqQU8V681kaGUOZH-oAe7JUOiTfUh8gfQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4DC373060F09;
        Thu, 11 Jun 2020 07:16:41 -0400 (EDT)
Date:   Thu, 11 Jun 2020 13:16:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Mark Brown <broonie@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH STABLE v4.4+] pwm: fsl-ftm: Use flat regmap cache
Message-ID: <20200611111630.GG3802953@kroah.com>
References: <20200609143517.31243-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609143517.31243-1-krzk@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 04:35:17PM +0200, Krzysztof Kozlowski wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> commit ad06fdeeef1cbadf86ebbe510e8079abada8b44e upstream.
> 
> Use flat regmap cache to avoid lockdep warning at probe:
> 
> [    0.697285] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2755 lockdep_trace_alloc+0x15c/0x160()
> [    0.697449] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> 
> The RB-tree regmap cache needs to allocate new space on first writes.
> However, allocations in an atomic context (e.g. when a spinlock is held)
> are not allowed. The function regmap_write calls map->lock, which
> acquires a spinlock in the fast_io case. Since the pwm-fsl-ftm driver
> uses MMIO, the regmap bus of type regmap_mmio is being used which has
> fast_io set to true.
> 
> The MMIO space of the pwm-fsl-ftm driver is reasonable condense, hence
> using the much faster flat regmap cache is anyway the better choice.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Fixes lockdep warning. Apply to v4.4 and newer.
> ---
>  drivers/pwm/pwm-fsl-ftm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
> index 7225ac6b3df5..fad968eb75f6 100644
> --- a/drivers/pwm/pwm-fsl-ftm.c
> +++ b/drivers/pwm/pwm-fsl-ftm.c
> @@ -392,7 +392,7 @@ static const struct regmap_config fsl_pwm_regmap_config = {
>  
>  	.max_register = FTM_PWMLOAD,
>  	.volatile_reg = fsl_pwm_volatile_reg,
> -	.cache_type = REGCACHE_RBTREE,
> +	.cache_type = REGCACHE_FLAT,
>  };
>  
>  static int fsl_pwm_probe(struct platform_device *pdev)
> -- 
> 2.17.1
> 

Now queued up, thanks.

greg k-h
