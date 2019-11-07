Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7164FF27DA
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 08:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfKGHCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 02:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfKGHCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 02:02:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8520321D6C;
        Thu,  7 Nov 2019 07:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573110152;
        bh=C0qKGWBwYAN5IFKplG7JtqECFX8LEuxfkAJy6R2ZCbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6780Uw3vWRRG7whEOuSYGo7DmqTh9GbCycqZPK7pQFY5Vl0/e35MJH9vhkIRfVsc
         UVqDugjbZ/utvPVOxY+yxzU5+DwIjNwIV5lqy9Ov88+7MlpA+lS3aPQda94QjgSYc1
         ctWNtn+0RccVPhnF57CJUJAnIuYiSPKbEJPMHbUs=
Date:   Thu, 7 Nov 2019 08:02:29 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Peng Fan <peng.fan@nxp.com>
Cc:     "jslaby@suse.com" <jslaby@suse.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Duan <fugang.duan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] tty: serial: fsl_lpuart: use the sg count from
 dma_map_sg
Message-ID: <20191107070229.GA1114824@kroah.com>
References: <1573094911-448-1-git-send-email-peng.fan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573094911-448-1-git-send-email-peng.fan@nxp.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 02:50:11AM +0000, Peng Fan wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> The dmaengine_prep_slave_sg needs to use sg count returned
> by dma_map_sg, not use sport->dma_tx_nents, because the return
> value of dma_map_sg is not always same with "nents".
> 
> When enabling iommu for lpuart + edma, iommu framework may concatenate
> two sgs into one.
> 
> Fixes: 6250cc30c4c4e ("tty: serial: fsl_lpuart: Use scatter/gather DMA for Tx")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
> 
> V2:
>  Assign ret to sport->dma_tx_nents, then we no need to fix dma_unmap_sg
>  Hi Greg,
>   I saw v1 patch merged to tty-next, please help to replace with V2 if this
>   is ok for you, or you need I have a follow up fix for v1.

I can not "replace" anything, my tree does not rebase, sorry.  Please
send fix-up patches on top of it if there is any changes that need to
happen.

thanks,

greg k-h
