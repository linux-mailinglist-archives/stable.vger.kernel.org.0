Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D164323E3C
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhBXN2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbhBXNVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:21:07 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76ED5C06178A;
        Wed, 24 Feb 2021 05:20:09 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lr13so2985544ejb.8;
        Wed, 24 Feb 2021 05:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pkahlOf/pP28CNyWC5Y+WgZbLG+WwMP1KrVJxBevxWc=;
        b=I7ajJMexZRa8jOCydZguMJEq2YMI4OqPY5TtjJjh5GFY+UEVQT39BflKJbyvZTUM7v
         y91W8wKb3LnQalPFGbnA0Noheo37CvNOu7Jmr3xgS9u4BZVn55iMRBl6UL2MU16tDOIF
         hv6VJdRM2bB+t2lQQOAEd0b/p2T1+tM9S1BTbM6UKW3ljqvdVjLvLaJoBBcc0D0K2SMI
         8BXWuP/4kaFAIf5rvmnq1CmUeNQ+O/bFv9tMYcuqDdIxwaY9ZincmguRz+4B0ym6yEzu
         mqzkdqJM01TZ93oUaCmNmAfFA90H+8LLOXAnm1pTQGaAo4+/BRN1ulsSOkGM/qKy7uQd
         LW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pkahlOf/pP28CNyWC5Y+WgZbLG+WwMP1KrVJxBevxWc=;
        b=RSr0vHnca4Of2PWVCdD7NKUP4ySu57p8g2HAmjJOmKStI1+sHIXV/kUgi1lV0J848q
         t0DvX4aABiZQtMkG6JA7dwjYoo66qpCIsgEtPL+eAYp9p8/46zkjDY/PNQECs7vztaq+
         IWFfdcalu/P1z+y9BjkqG+2Qec31R470qiCupY1yo9EldKm2f/f2s+ZTAJB/tTnRF9rL
         wLfs5HxKAdUTNb6h3N3cluB2etl46LZrQ3beK21fJWOcAQ+IQFdXK5+8gktuYNylG7XO
         0H0n5B566emFnc2YNgSUQhJGIx+KZisO7OVemF78jwuFprnJzGWllqeX9VpOredoj1oi
         6TdA==
X-Gm-Message-State: AOAM530pXtHFMMxuuURn7ZyCl/g4YZUNwSiMWVf0Qs9fwVVa2zU5Tyo7
        tgaxOg7kL7U3YmGE87uX4gXtoJYL1nM4vA==
X-Google-Smtp-Source: ABdhPJwhMgl88RINOG5oHJwFZKYnCbmcwIU7+WFcgyOHfPeQaqcMjUJjeYbn7pLle1DBCk0oByOp5Q==
X-Received: by 2002:a17:906:30da:: with SMTP id b26mr30614615ejb.376.1614172808077;
        Wed, 24 Feb 2021 05:20:08 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id br22sm1332637ejb.117.2021.02.24.05.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:20:07 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:20:05 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 41/56] Drivers: hv: vmbus: Resolve race
 condition in vmbus_onoffer_rescind()
Message-ID: <20210224132005.GD1920@anparri>
References: <20210224125212.482485-1-sashal@kernel.org>
 <20210224125212.482485-41-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125212.482485-41-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:51:57AM -0500, Sasha Levin wrote:
> From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
> 
> [ Upstream commit e4d221b42354b2e2ddb9187a806afb651eee2cda ]
> 
> An erroneous or malicious host could send multiple rescind messages for
> a same channel.  In vmbus_onoffer_rescind(), the guest maps the channel
> ID to obtain a pointer to the channel object and it eventually releases
> such object and associated data.  The host could time rescind messages
> and lead to an use-after-free.  Add a new flag to the channel structure
> to make sure that only one instance of vmbus_onoffer_rescind() can get
> the reference to the channel object.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/r/20201209070827.29335-6-parri.andrea@gmail.com
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Same here.

  Andrea


> ---
>  drivers/hv/channel_mgmt.c | 12 ++++++++++++
>  include/linux/hyperv.h    |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 1d44bb635bb84..a9f58840f85dc 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -1049,6 +1049,18 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
>  
>  	mutex_lock(&vmbus_connection.channel_mutex);
>  	channel = relid2channel(rescind->child_relid);
> +	if (channel != NULL) {
> +		/*
> +		 * Guarantee that no other instance of vmbus_onoffer_rescind()
> +		 * has got a reference to the channel object.  Synchronize on
> +		 * &vmbus_connection.channel_mutex.
> +		 */
> +		if (channel->rescind_ref) {
> +			mutex_unlock(&vmbus_connection.channel_mutex);
> +			return;
> +		}
> +		channel->rescind_ref = true;
> +	}
>  	mutex_unlock(&vmbus_connection.channel_mutex);
>  
>  	if (channel == NULL) {
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 1ce131f29f3b4..376f0f9e19650 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -786,6 +786,7 @@ struct vmbus_channel {
>  	u8 monitor_bit;
>  
>  	bool rescind; /* got rescind msg */
> +	bool rescind_ref; /* got rescind msg, got channel reference */
>  	struct completion rescind_event;
>  
>  	u32 ringbuffer_gpadlhandle;
> -- 
> 2.27.0
> 
