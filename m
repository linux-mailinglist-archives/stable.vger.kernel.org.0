Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB27B604064
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJSJyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiJSJyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:54:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9183B2408B;
        Wed, 19 Oct 2022 02:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9QVTzazWDl7CzJj27vD1HI3Q5VZZTDlr+MDM1SbII88=; b=C8C6X1bxcCgc5Rb/GOC1LuXMlT
        BcHsdyxGZAPlU21pw/bgg+tO3EiqRSmP6NLu4FygRRXlzXVGYDIMxHb8mceFCzdF9SK/101bN4l/U
        4VtIwCAPl8mYIo7gehRXogbtNYFBFzt0B2Ssr9FoLX68HXeNXoqAhXXQMamS8sUq3o+L2HZ7UVKI4
        HjnNgYWgsSLK/TIp6z7wj7uH9wtk141xrjd3IuEBxwh8gGnf5rbSBzsy27Sroo+lnoliD8FvQxRlb
        LzohYJpD8DH4wlTHFb3lVcR6Gg9I1l9lAou0USwgUGGTo1loIDTP+dshvLHB6ay9emIg6HK1Ngygp
        zG/PrYPQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34790)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ol59Q-0005Q4-Cw; Wed, 19 Oct 2022 10:14:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ol59P-0001yh-6s; Wed, 19 Oct 2022 10:14:11 +0100
Date:   Wed, 19 Oct 2022 10:14:11 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 659/862] =?us-ascii?B?PT9V?=
 =?us-ascii?B?VEYtOD9xP0FSTS9kbWEtbWFwcD1EMT05Nm5nOj0yMGRvbnQ9MjBvdmVycmlk?=
 =?us-ascii?B?ZT0yMC0+ZG1hPTVGY29oZT89ID0/VVRGLTg/cT9yZW50PTIwd2hlbj0yMHNl?=
 =?us-ascii?Q?t=3D20from=3D20a=3D20bus=3D20notifier=3F=3D?=
Message-ID: <Y0+/41/qY8DjVn23@shell.armlinux.org.uk>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083319.087440003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221019083319.087440003@linuxfoundation.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I'm seeing:

Subject: [PATCH 6.0 659/862]
        =?UTF-8?q?ARM/dma-mapp=D1=96ng:=20dont=20override=20->dma=5Fcohe?=
        =?UTF-8?q?rent=20when=20set=20from=20a=20bus=20notifier?=

in mutt, and mutt seems to be unable to decode that. Either a mutt
bug or a bug in your scripts or git...

Russell.

On Wed, Oct 19, 2022 at 10:32:26AM +0200, Greg Kroah-Hartman wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 49bc8bebae79c8516cb12f91818f3a7907e3ebce ]
> 
> Commit ae626eb97376 ("ARM/dma-mapping: use dma-direct unconditionally")
> caused a regression on the mvebu platform, wherein devices that are
> dma-coherent are marked as dma-noncoherent, because although
> mvebu_hwcc_notifier() after that commit still marks then as coherent,
> the arm_coherent_dma_ops() function, which is called later, overwrites
> this setting, since it is being called from drivers/of/device.c with
> coherency parameter determined by of_dma_is_coherent(), and the
> device-trees do not declare the 'dma-coherent' property.
> 
> Fix this by defaulting never clearing the dma_coherent flag in
> arm_coherent_dma_ops().
> 
> Fixes: ae626eb97376 ("ARM/dma-mapping: use dma-direct unconditionally")
> Reported-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Tested-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/mm/dma-mapping.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 089c9c644cce..bfc7476f1411 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1769,8 +1769,16 @@ static void arm_teardown_iommu_dma_ops(struct device *dev) { }
>  void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
>  			const struct iommu_ops *iommu, bool coherent)
>  {
> -	dev->archdata.dma_coherent = coherent;
> -	dev->dma_coherent = coherent;
> +	/*
> +	 * Due to legacy code that sets the ->dma_coherent flag from a bus
> +	 * notifier we can't just assign coherent to the ->dma_coherent flag
> +	 * here, but instead have to make sure we only set but never clear it
> +	 * for now.
> +	 */
> +	if (coherent) {
> +		dev->archdata.dma_coherent = true;
> +		dev->dma_coherent = true;
> +	}
>  
>  	/*
>  	 * Don't override the dma_ops if they have already been set. Ideally
> -- 
> 2.35.1
> 
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
