Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656C64FB5FF
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 10:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbiDKIdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 04:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245065AbiDKIdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 04:33:06 -0400
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAE532064
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 01:30:52 -0700 (PDT)
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23B8QgS8013469;
        Mon, 11 Apr 2022 10:30:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=iCEU0s5nP2G35mji7sCshckhwQm1NTUr12v6bAa/K9Y=;
 b=vMKyhp7RSJV//5q4cCdOQ7l/4HufLzleRzEqsMNwbNecFVL2qk8pHlrhgS2kyH5rpnIA
 QjYi9pRPpI8nXLtFrfgmlOAbF05veIX6OpiQ9nqSlqwhGlR74PXdItrAmigna/aXOjvv
 UaM+Toa5+2MBwBc60oJYaI1lASDi0iDeZE9lBk/xMao27T7rPmLtAQU4ArhjdjtUhmXf
 EnJIDTxvA0FwruDiNKRZnNuW8tEJpLof+FtCeDiigEC6s1F/a/+tzqhvRlc5WLsv3heF
 axkUvSYQPs3Y8b0GU4qg1HRU5wVLpqn48uZD4O0Gi/jtxSTq1nYbKmiujrWMramZzV1s Qw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3fb74pyk8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 10:30:49 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 841E8100034;
        Mon, 11 Apr 2022 10:30:48 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 77DCB2132E1;
        Mon, 11 Apr 2022 10:30:48 +0200 (CEST)
Received: from [10.201.21.172] (10.75.127.49) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Mon, 11 Apr
 2022 10:30:47 +0200
Message-ID: <284fae86-d1a2-d4d1-6662-b52cae8aeaf3@foss.st.com>
Date:   Mon, 11 Apr 2022 10:30:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: FAILED: patch "[PATCH] mmc: mmci: stm32: correctly check all
 elements of sg list" failed to apply to 5.4-stable tree
Content-Language: en-US
To:     <gregkh@linuxfoundation.org>, <ulf.hansson@linaro.org>
CC:     <stable@vger.kernel.org>
References: <164966239220895@kroah.com>
From:   Yann Gautier <yann.gautier@foss.st.com>
In-Reply-To: <164966239220895@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_03,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/11/22 09:33, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Hi Greg,

The patch doesn't apply because the following one is not there:
127e6e98ca9b mmc: mmci_sdmmc: Replace sg_dma_xxx macros

Maybe it should have been a fix patch too.

Ulf, what is your opinion on that?


Best regards,
Yann

> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 0d319dd5a27183b75d984e3dc495248e59f99334 Mon Sep 17 00:00:00 2001
> From: Yann Gautier <yann.gautier@foss.st.com>
> Date: Thu, 17 Mar 2022 12:19:43 +0100
> Subject: [PATCH] mmc: mmci: stm32: correctly check all elements of sg list
> 
> Use sg and not data->sg when checking sg list elements. Else only the
> first element alignment is checked.
> The last element should be checked the same way, for_each_sg already set
> sg to sg_next(sg).
> 
> Fixes: 46b723dd867d ("mmc: mmci: add stm32 sdmmc variant")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yann Gautier <yann.gautier@foss.st.com>
> Link: https://lore.kernel.org/r/20220317111944.116148-2-yann.gautier@foss.st.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> diff --git a/drivers/mmc/host/mmci_stm32_sdmmc.c b/drivers/mmc/host/mmci_stm32_sdmmc.c
> index 9c13f2c31365..4566d7fc9055 100644
> --- a/drivers/mmc/host/mmci_stm32_sdmmc.c
> +++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
> @@ -62,8 +62,8 @@ static int sdmmc_idma_validate_data(struct mmci_host *host,
>   	 * excepted the last element which has no constraint on idmasize
>   	 */
>   	for_each_sg(data->sg, sg, data->sg_len - 1, i) {
> -		if (!IS_ALIGNED(data->sg->offset, sizeof(u32)) ||
> -		    !IS_ALIGNED(data->sg->length, SDMMC_IDMA_BURST)) {
> +		if (!IS_ALIGNED(sg->offset, sizeof(u32)) ||
> +		    !IS_ALIGNED(sg->length, SDMMC_IDMA_BURST)) {
>   			dev_err(mmc_dev(host->mmc),
>   				"unaligned scatterlist: ofst:%x length:%d\n",
>   				data->sg->offset, data->sg->length);
> @@ -71,7 +71,7 @@ static int sdmmc_idma_validate_data(struct mmci_host *host,
>   		}
>   	}
>   
> -	if (!IS_ALIGNED(data->sg->offset, sizeof(u32))) {
> +	if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
>   		dev_err(mmc_dev(host->mmc),
>   			"unaligned last scatterlist: ofst:%x length:%d\n",
>   			data->sg->offset, data->sg->length);
> 

