Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75F929FB72
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 03:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgJ3Chi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 22:37:38 -0400
Received: from mail-sz.amlogic.com ([211.162.65.117]:9143 "EHLO
        mail-sz.amlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJ3Chi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 22:37:38 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2020 22:37:37 EDT
Received: from [10.28.39.46] (10.28.39.46) by mail-sz.amlogic.com (10.28.11.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 30 Oct
 2020 10:22:31 +0800
Subject: Re: [PATCH] mtd: meson: fix meson_nfc_dma_buffer_release() arguments
To:     Sergei Antonov <saproj@gmail.com>, <linux-mtd@lists.infradead.org>
CC:     <miquel.raynal@bootlin.com>, <jianxin.pan@amlogic.com>,
        <stable@vger.kernel.org>
References: <20201028094940.11765-1-saproj@gmail.com>
From:   Liang Yang <liang.yang@amlogic.com>
Message-ID: <a1dc1e51-d52e-a5de-6261-2a4740272cbb@amlogic.com>
Date:   Fri, 30 Oct 2020 10:22:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201028094940.11765-1-saproj@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.28.39.46]
X-ClientProxiedBy: mail-sz.amlogic.com (10.28.11.5) To mail-sz.amlogic.com
 (10.28.11.5)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sergei, miquel

On 2020/10/28 17:49, Sergei Antonov wrote:
> Arguments 'infolen' and 'datalen' to meson_nfc_dma_buffer_release() were mixed up.
>
> Fixes: 8fae856c53500 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> ---
>   drivers/mtd/nand/raw/meson_nand.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
> index 48e6dac96be6..a76afea6ea77 100644
> --- a/drivers/mtd/nand/raw/meson_nand.c
> +++ b/drivers/mtd/nand/raw/meson_nand.c
> @@ -510,7 +510,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
>   }
>   
>   static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
> -					 int infolen, int datalen,
> +					 int datalen, int infolen,
>   					 enum dma_data_direction dir)
>   {
>   	struct meson_nfc *nfc = nand_get_controller_data(nand);
It is good to me:

Acked-by: Liang Yang <liang.yang@amlogic.com>

and thanks.

