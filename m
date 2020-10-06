Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864DB284F08
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgJFPcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 11:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJFPcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 11:32:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02EE3206D4;
        Tue,  6 Oct 2020 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601998335;
        bh=OD1ShKWKDH57lAR1RIhr8UFUdjhFDgj040obC8b1vbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pfw4pAbZMMatXod0HLkTpwx5cm9AK9iAcdCbDVaUg/4Mx1J9OZfLXjdMhyDuTGjkN
         q0Q+JvGLvtE0saNTSE8Uey6xBof+lrGgjsG3oZ4YUje/u49Osstgc/6CH5o92Xz/JV
         z/L7ReAEff1KYUiPY8o+/IuSl5/Cqoqm5gOYeO7g=
Date:   Tue, 6 Oct 2020 17:33:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bert Vermeulen <bert@biot.com>
Cc:     tudor.ambarus@microchip.com, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2] mtd: spi-nor: Fix address width on flash chips
 > 16MB
Message-ID: <20201006153301.GC23711@kroah.com>
References: <20201006132346.12652-1-bert@biot.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006132346.12652-1-bert@biot.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 03:23:46PM +0200, Bert Vermeulen wrote:
> If a flash chip has more than 16MB capacity but its BFPT reports
> BFPT_DWORD1_ADDRESS_BYTES_3_OR_4, the spi-nor framework defaults to 3.
> 
> The check in spi_nor_set_addr_width() doesn't catch it because addr_width
> did get set. This fixes that check.
> 
> Fixes: f9acd7fa80be ("mtd: spi-nor: sfdp: default to addr_width of 3 for configurable widths")
> Signed-off-by: Bert Vermeulen <bert@biot.com>
> Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/mtd/spi-nor/core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
