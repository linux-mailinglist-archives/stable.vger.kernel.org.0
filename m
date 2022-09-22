Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139A25E6E69
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 23:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiIVV2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 17:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiIVV2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 17:28:32 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2E2111DFF
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:28:27 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id m16so5592088iln.9
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 14:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=cxbQv9D2p8vN8THDF3AKAQRLlVYEVvb4qnk8cFoXNPs=;
        b=f2cVDIpVYXuoDIP3unMWkQNMOWeE7Xo0nLUDsGCy0Gmx1AWEdw1WZBQlqjd551VySs
         Zng1uF7z2o1k44Y3k7MnWH0L7/lT14/eFcee9EOBiYb6hsHWb2W/qOOuzgu500OfdWR+
         SEMxH6v8T+6OOwr7ufc/ftxs4W9xNxCf0brItbND+l5/BkNmwWJN2j/mObiDZFpm31Ge
         cgF+a00RGIdc7eDtI9JC9mfR/AUHXL4w/KAZSpBwlZ7wePJnP/Z1PO67bdMlGSQidB2h
         4SCYmdSxMPqils9q3+qY2uSfH5V9uob9QJ2kISuZNuVx2ZNbCQTG67p4hIAmQwBDfe/3
         PtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=cxbQv9D2p8vN8THDF3AKAQRLlVYEVvb4qnk8cFoXNPs=;
        b=uSMP8Fl5bacn/89gaXDfxuKLEX/x6HPc2w1fxWYOXq/mjIZa6yoClzcm3XwpBsFCRu
         /9+T8gPfgSrOOw2vAYjnVHWjRZWrW+XVNAyP8lzwMITl2+iWEnXB7LqcWhA+AZS5zdIN
         HeYAFeo/h4UUgbV6PuT5eJVgk+jz1qd7HeM6ej85ldPFLBuBFzy5OjiRIuakCchlKT90
         wGUe4mu20ZPNw4r9v/F8Ug+DJO1oAEk5M1QRTXxka8tv6sfTsJ23A+44hw/TsunKBxVL
         T3Ecp0HChh0+KOl6J9H8WzATjDkuVb+HTCJnb0zwbaC4G2tLLVHIYVYXpTq0mxFWFUhA
         AAng==
X-Gm-Message-State: ACrzQf1lSWRlBS7jP1K+2uG3qH4K0/KIdVlfDf3HiCCjKqwCChc1M9yh
        Y4b01yFqXuHx/ev+s9AH1VnSRw==
X-Google-Smtp-Source: AMsMyM5DHG8MWDXS3rBXWbxOKugTtaSJubwnzQTPKjdSUQBz07SX2LKtCDz+cQhertW7JKH7nsVMHQ==
X-Received: by 2002:a92:c545:0:b0:2f6:5ca9:8bc5 with SMTP id a5-20020a92c545000000b002f65ca98bc5mr2899934ilj.270.1663882106796;
        Thu, 22 Sep 2022 14:28:26 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id i7-20020a056638380700b00349d2d52f6asm2650812jav.37.2022.09.22.14.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 14:28:26 -0700 (PDT)
Message-ID: <00eb82ca-8bf6-c744-d04d-96b97ce06b17@linaro.org>
Date:   Thu, 22 Sep 2022 16:28:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [5.10 PATCH] interconnect: qcom: icc-rpmh: Add BCMs to commit
 list in pre_aggregate
Content-Language: en-US
To:     Douglas Anderson <dianders@chromium.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc:     swboyd@chromium.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20220922141725.5.10.1.I791715539cae1355e21827ca738b0b523a4a0f53@changeid>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220922141725.5.10.1.I791715539cae1355e21827ca738b0b523a4a0f53@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/22 4:18 PM, Douglas Anderson wrote:
> From: Mike Tipton <mdtipton@codeaurora.org>
> 
> commit b95b668eaaa2574e8ee72f143c52075e9955177e upstream.
> 
> We're only adding BCMs to the commit list in aggregate(), but there are
> cases where pre_aggregate() is called without subsequently calling
> aggregate(). In particular, in icc_sync_state() when a node with initial
> BW has zero requests. Since BCMs aren't added to the commit list in
> these cases, we don't actually send the zero BW request to HW. So the
> resources remain on unnecessarily.
> 
> Add BCMs to the commit list in pre_aggregate() instead, which is always
> called even when there are no requests.
> 
> Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> [georgi: remove icc_sync_state for platforms with incomplete support]
> Link: https://lore.kernel.org/r/20211125174751.25317-1-djakov@kernel.org
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> [dianders: dropped sm8350.c which isn't present in 5.10]
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Whoops, sorry about that.

Acked-by: Alex Elder <elder@linaro.org>

> ---
> This should have been included in Alex Elder's request for patches
> picked to 5.10 [1] but it was missed. Let's finally pick it up.
> 
> [1] https://lore.kernel.org/r/20220608205415.185248-3-elder@linaro.org
> 
>   drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
>   drivers/interconnect/qcom/sm8150.c   |  1 -
>   drivers/interconnect/qcom/sm8250.c   |  1 -
>   3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
> index f6fae64861ce..27cc5f03611c 100644
> --- a/drivers/interconnect/qcom/icc-rpmh.c
> +++ b/drivers/interconnect/qcom/icc-rpmh.c
> @@ -20,13 +20,18 @@ void qcom_icc_pre_aggregate(struct icc_node *node)
>   {
>   	size_t i;
>   	struct qcom_icc_node *qn;
> +	struct qcom_icc_provider *qp;
>   
>   	qn = node->data;
> +	qp = to_qcom_provider(node->provider);
>   
>   	for (i = 0; i < QCOM_ICC_NUM_BUCKETS; i++) {
>   		qn->sum_avg[i] = 0;
>   		qn->max_peak[i] = 0;
>   	}
> +
> +	for (i = 0; i < qn->num_bcms; i++)
> +		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
>   }
>   EXPORT_SYMBOL_GPL(qcom_icc_pre_aggregate);
>   
> @@ -44,10 +49,8 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
>   {
>   	size_t i;
>   	struct qcom_icc_node *qn;
> -	struct qcom_icc_provider *qp;
>   
>   	qn = node->data;
> -	qp = to_qcom_provider(node->provider);
>   
>   	if (!tag)
>   		tag = QCOM_ICC_TAG_ALWAYS;
> @@ -67,9 +70,6 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
>   	*agg_avg += avg_bw;
>   	*agg_peak = max_t(u32, *agg_peak, peak_bw);
>   
> -	for (i = 0; i < qn->num_bcms; i++)
> -		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
> -
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
> diff --git a/drivers/interconnect/qcom/sm8150.c b/drivers/interconnect/qcom/sm8150.c
> index c76b2c7f9b10..b936196c229c 100644
> --- a/drivers/interconnect/qcom/sm8150.c
> +++ b/drivers/interconnect/qcom/sm8150.c
> @@ -627,7 +627,6 @@ static struct platform_driver qnoc_driver = {
>   	.driver = {
>   		.name = "qnoc-sm8150",
>   		.of_match_table = qnoc_of_match,
> -		.sync_state = icc_sync_state,
>   	},
>   };
>   module_platform_driver(qnoc_driver);
> diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
> index cc558fec74e3..40820043c8d3 100644
> --- a/drivers/interconnect/qcom/sm8250.c
> +++ b/drivers/interconnect/qcom/sm8250.c
> @@ -643,7 +643,6 @@ static struct platform_driver qnoc_driver = {
>   	.driver = {
>   		.name = "qnoc-sm8250",
>   		.of_match_table = qnoc_of_match,
> -		.sync_state = icc_sync_state,
>   	},
>   };
>   module_platform_driver(qnoc_driver);

