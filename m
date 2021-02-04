Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC630ED0A
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 08:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhBDHLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 02:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhBDHLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 02:11:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA13964DB2;
        Thu,  4 Feb 2021 07:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612422624;
        bh=msuW8Y8xyEBkeRokRLJJ7uu1QkVry74ufo9BerwRlsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j7sNO8ekouk32oT5BNxsectfclXc4pfudB7mzqMLAZx8B6y8XSPIyjwI1IcRO6lTe
         b6PYL/JjkhHt5ZdiwY2QmIr/haCjoUqXIM5491VO93S8K2dYBphPraEAKTO8wtulaw
         e7+aRMBtov1QkRZjPv+Ts/iibkRSX1z24tbobBk1kn45Ze1tgUR3o55yIaLHrrlSch
         i+aTBKpFfux09LidmwGGXS1QC0hfUhBjBEuQT3HpoPtWrkheHXGnMXsy3KmHph6jOK
         7LanHnTCw2PFngu1/9PP1Ilu95vWjrM+zHbJYX5Uf6cAl7jwLgGA2s07oUcQOr4ofX
         XP981ysKomUbg==
Date:   Thu, 4 Feb 2021 12:40:20 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     paul@crapouillou.net, kishon@ti.com, zhouyanjie@wanyeetech.com,
        aric.pzqi@ingenic.com, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3] PHY: Ingenic: Compile phy-ingenic-usb only if it was
 enabled
Message-ID: <20210204071020.GD3079@vkoul-mobl.Dlink>
References: <20210124103627.51801-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124103627.51801-1-hqjagain@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24-01-21, 18:36, Qiujun Huang wrote:
> We should compile this driver only if we enable PHY_INGENIC_USB.
> 
> Fixes: 31de313dfdcf ("PHY: Ingenic: Add USB PHY driver using generic PHY
> framework.")
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>

This was fixed by commit ef019c5daf032dce0b95ed4d45bfec93c4fbcb9f

> ---
> v3:
> There is no need to submit this patch to -stable tree, as the driver was
> not merged to 5.10.
> v2:
> Add a Fixes:tag and Cc linux-stable
> ---
>  drivers/phy/ingenic/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/phy/ingenic/Makefile b/drivers/phy/ingenic/Makefile
> index 65d5ea00fc9d..a00306651423 100644
> --- a/drivers/phy/ingenic/Makefile
> +++ b/drivers/phy/ingenic/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0
> -obj-y		+= phy-ingenic-usb.o
> +obj-$(PHY_INGENIC_USB)		+= phy-ingenic-usb.o
> -- 
> 2.25.1

-- 
~Vinod
