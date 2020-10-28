Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B93129DD0E
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgJ2Aes convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 28 Oct 2020 20:34:48 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:58270 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732017AbgJ1WTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:19:44 -0400
Received: from relay8-d.mail.gandi.net (unknown [217.70.183.201])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id A281A3B269D
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 10:03:42 +0000 (UTC)
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 0BC631BF21A;
        Wed, 28 Oct 2020 10:03:19 +0000 (UTC)
Date:   Wed, 28 Oct 2020 11:03:18 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     linux-mtd@lists.infradead.org, jianxin.pan@amlogic.com,
        liang.yang@amlogic.com, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: meson: fix meson_nfc_dma_buffer_release()
 arguments
Message-ID: <20201028110318.134be5f8@xps13>
In-Reply-To: <20201028094940.11765-1-saproj@gmail.com>
References: <20201028094940.11765-1-saproj@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sergei,

Sergei Antonov <saproj@gmail.com> wrote on Wed, 28 Oct 2020 12:49:40
+0300:

> Arguments 'infolen' and 'datalen' to meson_nfc_dma_buffer_release() were mixed up.
> 
> Fixes: 8fae856c53500 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sergei Antonov <saproj@gmail.com>

This patch looks good to me. Next time you send a new iteration of a
patch, please use [PATCH v2] in the subject prefix and also add a
changelog below the three dashes.

(your other patch to fix the style is still welcome)

> ---
>  drivers/mtd/nand/raw/meson_nand.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
> index 48e6dac96be6..a76afea6ea77 100644
> --- a/drivers/mtd/nand/raw/meson_nand.c
> +++ b/drivers/mtd/nand/raw/meson_nand.c
> @@ -510,7 +510,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
>  }
>  
>  static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
> -					 int infolen, int datalen,
> +					 int datalen, int infolen,
>  					 enum dma_data_direction dir)
>  {
>  	struct meson_nfc *nfc = nand_get_controller_data(nand);

Thanks,
Miquèl
