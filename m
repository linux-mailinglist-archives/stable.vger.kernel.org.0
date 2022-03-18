Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36734DE002
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 18:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbiCRReL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 13:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239658AbiCRReL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 13:34:11 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2BA639F
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 10:32:52 -0700 (PDT)
Received: from [192.168.1.18] ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id VGT1nWtLcvjW4VGT2nSq1F; Fri, 18 Mar 2022 18:32:49 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 18 Mar 2022 18:32:49 +0100
X-ME-IP: 90.126.236.122
Message-ID: <d9bd48c4-f9e6-c2c4-210b-d87284ab86b1@wanadoo.fr>
Date:   Fri, 18 Mar 2022 18:32:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 42/43] bnx2: Fix an error message
Content-Language: fr
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20220317124527.672236844@linuxfoundation.org>
 <20220317124528.836870115@linuxfoundation.org>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220317124528.836870115@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

this one should be removed,
The message is correct in 5.4.


Le 17/03/2022 à 13:45, Greg Kroah-Hartman a écrit :
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> [ Upstream commit 8ccffe9ac3239e549beaa0a9d5e1a1eac94e866c ]
>
> Fix an error message and report the correct failing function.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/ethernet/broadcom/bnx2.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index c3f67d8e1093..f53292eab9da 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -8231,7 +8231,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
>   		rc = pci_set_consistent_dma_mask(pdev, persist_dma_mask);
>   		if (rc) {
>   			dev_err(&pdev->dev,
> -				"pci_set_consistent_dma_mask failed, aborting\n");
> +				"dma_set_coherent_mask failed, aborting\n");
>   			goto err_out_unmap;
>   		}
>   	} else if ((rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
