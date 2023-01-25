Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E267B9B0
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 19:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjAYSlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 13:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbjAYSku (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 13:40:50 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7EA51C49
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:40:44 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so3015247pjl.0
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aCu8FnWNXWV4RbQkbxOlEMF0nG9yZm5AzOji7i+P+HM=;
        b=RE0ChkX8D2HECzF3pbsI+R9nRWGXRK0dW9UH2ZH4mGGqwF3TOOM8zrtzCsqL/EzbQz
         u/PleP+OKLgSLjDtLIBrSY756U4+HK+kGcKfp3tVzK9wPXBCFz6jKPVZA1Bye3FXtDCW
         QxtNu9sqPRU/W/ZZqQMvOAI1ETjOSFAQ9suIBL2XzdvD0trWphj6ah+aCpQk/Gvfkr0j
         oH6M709nDAv2vSVLW3Ff0tBoWr3MTqsgP+8MWN55VGw39VttdHl5ti0bYNhJwbUfSbQU
         smxdOwqyn8zLXY/O0P1dj+YvrzZayC3KIN0EtUmhOQsTp6W8SDZ1FBaxD1Mbic4IZcoi
         idCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aCu8FnWNXWV4RbQkbxOlEMF0nG9yZm5AzOji7i+P+HM=;
        b=IXQdjpCfXjvH3tMn+G7pNwN+33SATKO8ci4EP6OMHW5qC8fYC3+kGpRQ2DmjWnL/7M
         wheyqzrk2JOPuwy7FUiI483Prd63+1LWNfRKMt73ssN3SfTAv6TlZcVXcoW7V/UksJY3
         LHzFhM4iiyLtxLhP37ixgcLyv6UZqTItJolxVhHROWoFt+KJdPCDCYaZ62bFV0hBmX4g
         yp7BlNr10LgDEjFjRKwvqqqWHijCYeAjL9aK+r7JpuvQmpHqLGdHFe08az+IywPOXR7W
         CkGlx8rp66rA44fVZS/w8sLeN17Kad83NNP7ibw3io+x9Ls7A5Q7ls25VIilCJg1BsMV
         q34w==
X-Gm-Message-State: AFqh2koH6kiCaV7hyjG00Utkh1INDt+l+6kYx8bOfLhbVuXEQQT5oUya
        aAx4qiTMdAf0e5BdNpPV2AA=
X-Google-Smtp-Source: AMrXdXui9SivYMz78h7nPDEJBWZ+o8+dCjlv4RtpMIS5cfdyH0FlRjhB8Lg5bepkYOKT6k9e0g/JIg==
X-Received: by 2002:a05:6a20:8e05:b0:af:ae14:9ecb with SMTP id y5-20020a056a208e0500b000afae149ecbmr51515309pzj.17.1674672043681;
        Wed, 25 Jan 2023 10:40:43 -0800 (PST)
Received: from [10.69.46.142] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w1-20020aa79541000000b00580fb018e4bsm3900129pfq.211.2023.01.25.10.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 10:40:43 -0800 (PST)
Message-ID: <c8275d9c-0490-d4eb-e20c-3faac5d74293@gmail.com>
Date:   Wed, 25 Jan 2023 10:40:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] nvme-fc: Fix initialization order
To:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        linux-nvme@lists.infradead.org
Cc:     James Smart <james.smart@broadcom.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org
References: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
Content-Language: en-US
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20230120174354.3437046-1-ross.lagerwall@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/20/2023 9:43 AM, Ross Lagerwall wrote:
> ctrl->ops is used by nvme_alloc_admin_tag_set() but set by
> nvme_init_ctrl() so reorder the calls to avoid a NULL pointer
> dereference.
> 
> Fixes: 6dfba1c09c10 ("nvme-fc: use the tagset alloc/free helpers")
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/nvme/host/fc.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 4564f16a0b20..456ee42a6133 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -3521,13 +3521,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
>   
>   	nvme_fc_init_queue(ctrl, 0);
>   
> -	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
> -			&nvme_fc_admin_mq_ops,
> -			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
> -				    ctrl->lport->ops->fcprqst_priv_sz));
> -	if (ret)
> -		goto out_free_queues;
> -
>   	/*
>   	 * Would have been nice to init io queues tag set as well.
>   	 * However, we require interaction from the controller
> @@ -3537,10 +3530,17 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
>   
>   	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_fc_ctrl_ops, 0);
>   	if (ret)
> -		goto out_cleanup_tagset;
> +		goto out_free_queues;
>   
>   	/* at this point, teardown path changes to ref counting on nvme ctrl */
>   
> +	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
> +			&nvme_fc_admin_mq_ops,
> +			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
> +				    ctrl->lport->ops->fcprqst_priv_sz));
> +	if (ret)
> +		goto fail_ctrl;
> +
>   	spin_lock_irqsave(&rport->lock, flags);
>   	list_add_tail(&ctrl->ctrl_list, &rport->ctrl_list);
>   	spin_unlock_irqrestore(&rport->lock, flags);
> @@ -3592,8 +3592,6 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
>   
>   	return ERR_PTR(-EIO);
>   
> -out_cleanup_tagset:
> -	nvme_remove_admin_tag_set(&ctrl->ctrl);
>   out_free_queues:
>   	kfree(ctrl->queues);
>   out_free_ida:

Yep. Thanks

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james


