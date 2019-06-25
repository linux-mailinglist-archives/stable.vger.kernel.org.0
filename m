Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4A652162
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 05:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfFYDxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 23:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfFYDxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 23:53:39 -0400
Received: from localhost (unknown [116.226.249.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 993EB20863;
        Tue, 25 Jun 2019 03:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561434818;
        bh=LiKh1y/cVsCqNr8ux7WO7aEmLV31ud+AQ1bb0n+nvNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zy0hx9p/4crxzYjV1lRLmNA6srJEKNhjem7iURpTiZ6qZyykyJc4xvBjgFbuwsPBI
         LqUfYd9yJiH2pbvvMsA9I0JwKIbT8dhPcmzYkOFmPoWMn7kF9t4f7XcbUxpiVYvfOZ
         70aqqAWKidJgfsmOQAnggYhLnpqxyh1bIcGdE/QQ=
Date:   Tue, 25 Jun 2019 11:08:07 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     liaoweixiong <liaoweixiong@allwinnertech.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Frieder Schrempf <frieder.schrempf@exceet.de>,
        Peter Pan <peterpandong@micron.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
Message-ID: <20190625030807.GA11074@kroah.com>
References: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561424549-784-1-git-send-email-liaoweixiong@allwinnertech.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 09:02:29AM +0800, liaoweixiong wrote:
> In case of the last page containing bitflips (ret > 0),
> spinand_mtd_read() will return that number of bitflips for the last
> page. But to me it looks like it should instead return max_bitflips like
> it does when the last page read returns with 0.
> 
> Signed-off-by: liaoweixiong <liaoweixiong@allwinnertech.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> ---
>  drivers/mtd/nand/spi/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
