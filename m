Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C440323E4E
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhBXNba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhBXNWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 08:22:44 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1B8C061786;
        Wed, 24 Feb 2021 05:22:03 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g5so3037578ejt.2;
        Wed, 24 Feb 2021 05:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CvhA11ta/4vzj4ouldymPVpRfP0/mY+iYxkvuMBKfpA=;
        b=SAP0fmmEpE/bH/Rd8n+r/YtTNkX8OTlKXzXL5CmoqwH/PItTK2GMJzbkRRS4P4WhpS
         Ozbwt7pnufBPBrS7OrgLyi6Hlzc13YkUHerWmK8n/bf00NB4me7hwGC6C0sp5CYSqtNP
         jQ4SktnNzBBRUuDJWVq2wr37d0KPEdMR9B4TYMLX53RoQTbTTJi5CcHg071rHq5hOLDd
         Yp4vTEFyyOGboGMeB4fmRwsyjG5MpI3HNoiXdB5je93btfZ93+Ry+bxNBSQ3L5oz3kUF
         DCx79iqs6DxLgpBKRqC+cNNDZjI7fObATj9uEHpTQT1zgL1H6kbEpbwsHRI7CrG4syl7
         e/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CvhA11ta/4vzj4ouldymPVpRfP0/mY+iYxkvuMBKfpA=;
        b=dUEJF1n5KYp5ovLh/YBPkcgsd7C/9GUucnqUoyu9I9gY0gqteXS3KOrYpMJzAb1BTo
         1x0yKHjkmLZDqSZIfrSInMtjliYcmAp9GQ09eYlWDgxnXW3/NlPgaXO84kPUWLIHHdJo
         T3HgMnH9cTArbJt4cWte63s7g3CPhj/LBrCvK3LnI2fuP//MlvNV3MHiZqup/dPri0qe
         JTutCcE98euLMUXZrHs5fFgD6jECHFMt0Ubi/1WmZMmAWGXO1Y9ojFQHBqLriUqkk3Rq
         4Tg+Ygs7agBmhJFG4PqwljN4yrbqgINwoHcxsq+SDb5P5IvB5zzZ6v9P0dka6XD1Jh6T
         yHMg==
X-Gm-Message-State: AOAM532AjsbnSlSrjhMp/G5t4mnsXG2eZTfWbJ4h9QTJs/gz2rZsnbd2
        AT4t5p7NYszVKgemopg1EDA=
X-Google-Smtp-Source: ABdhPJyG7sz265zT+79Ofx2whRj2nvW/2SeU/kXeevg9td41JL8swhnVwwK2+Z4NDjBgPE4Ho8d6Jg==
X-Received: by 2002:a17:906:4e57:: with SMTP id g23mr2457018ejw.47.1614172922578;
        Wed, 24 Feb 2021 05:22:02 -0800 (PST)
Received: from anparri (host-82-59-6-76.retail.telecomitalia.it. [82.59.6.76])
        by smtp.gmail.com with ESMTPSA id cb14sm1282414ejb.82.2021.02.24.05.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 05:22:02 -0800 (PST)
Date:   Wed, 24 Feb 2021 14:22:00 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Juan Vazquez <juvazq@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 15/16] Drivers: hv: vmbus: Resolve race
 condition in vmbus_onoffer_rescind()
Message-ID: <20210224132200.GB2031@anparri>
References: <20210224125514.483935-1-sashal@kernel.org>
 <20210224125514.483935-15-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125514.483935-15-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:55:12AM -0500, Sasha Levin wrote:
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
> index 5bf633c15cd4b..6ddda97030628 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -942,6 +942,18 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
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
> index 63cd81e5610d1..22e2c2d75361e 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -710,6 +710,7 @@ struct vmbus_channel {
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
